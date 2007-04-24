Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 23:18:09 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3O6I4fB025882
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 23:18:06 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3O6I0nL029873
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 15:18:02 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3O6AGlG002306
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 15:10:16 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3O6AGM11436 for xfs@oss.sgi.com; Tue, 24 Apr 2007 15:10:16 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l3O6AFO04731 for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 15:10:15 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070424.151015.85902548 for <xfs@oss.sgi.com>
	; Tue, 24 Apr 2007 15:10:15 +0900
Message-Id: <200704240610.AA05249@TNESG9305.tnes.nec.co.jp>
From: Utako Kusaka <utako@tnes.nec.co.jp>
Date: Tue, 24 Apr 2007 15:10:21 +0900
Subject: Re: [PATCH] Fix "quota -n" command in xfs_quota.
In-Reply-To: <20070423212606.GE13572@infradead.org>
References: <20070423212606.GE13572@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi,

Thanks for your comment.
I have updated my patch as below.

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- quota.orig	2007-04-18 10:36:38.000000000 +0900
+++ quota.c	2007-04-24 11:42:18.000000000 +0900
@@ -202,10 +202,12 @@ getusername(
 	int		numeric)
 {
 	static char	buffer[32];
-	struct passwd	*u;
 
-	if (!numeric && (u = getpwuid(uid)))
-		return u->pw_name;
+	if (!numeric) {
+		struct passwd *u = getpwuid(uid);
+		if (u)
+			return u->pw_name;
+	}
 	snprintf(buffer, sizeof(buffer), "#%u", uid);
 	return &buffer[0];
 }
@@ -247,10 +249,12 @@ getgroupname(
 	int		numeric)
 {
 	static char	buffer[32];
-	struct group	*g;
 
-	if (!numeric && (g = getgrgid(gid)))
-		return g->gr_name;
+	if (!numeric) {
+		struct group *g = getgrgid(gid);
+		if (g)
+			return g->gr_name;
+	}
 	snprintf(buffer, sizeof(buffer), "#%u", gid);
 	return &buffer[0];
 }
@@ -310,10 +314,12 @@ getprojectname(
 	int		numeric)
 {
 	static char	buffer[32];
-	fs_project_t	*p;
 
-	if ((p = getprprid(prid)))
-		return p->pr_name;
+	if (!numeric) {
+		fs_project_t *p = getprprid(prid);
+		if (p)
+			return p->pr_name;
+	}
 	snprintf(buffer, sizeof(buffer), "#%u", (unsigned int)prid);
 	return &buffer[0];
 }



Mon, 23 Apr 2007 22:26:06 +0100 Christoph Hellwig wrote：
>
>Looks good to me, but the even the original code could be a little bit cleaner:
>
>> --- xfsprogs-2.8.20/quota/quota.orig	2007-04-18 10:36:38.000000000 +0900
>> +++ xfsprogs-2.8.20/quota/quota.c	2007-04-18 11:09:10.000000000 +0900
>> @@ -312,7 +312,7 @@ getprojectname(
>>  	static char	buffer[32];
>>  	fs_project_t	*p;
>>  
>> -	if ((p = getprprid(prid)))
>> +	if (!numeric && (p = getprprid(prid)))
>>  		return p->pr_name;
>>  	snprintf(buffer, sizeof(buffer), "#%u", (unsigned int)prid);
>>  	return &buffer[0];
>
>	if (!numeric) {
>		fs_project_t *p = getprprid(prid);
>		if (p)
>			return p->pr_name;
>	}
>
>	snprintf(buffer, sizeof(buffer), "#%u", (unsigned int)prid);
>	return &buffer[0];
>
>		
