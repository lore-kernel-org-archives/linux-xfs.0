Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5M7T56t217631 for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 02:29:06 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C12396394D
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 00:37:46 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id 2DLFK3u4sRGCUaht for
	<xfs@oss.sgi.com>; Mon, 22 Jun 2009 00:37:46 -0700 (PDT)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e7.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5M7H4Ah003723
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 03:17:04 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id
	n5M7TViR238240 for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 03:29:31 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n5M7TVtQ032264 for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 03:29:31 -0400
Message-ID: <4A3F3304.1080901@linux.vnet.ibm.com>
Date: Mon, 22 Jun 2009 13:00:12 +0530
From: Anoop Vijayan <acv@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: getfacl gives octal output for Hebrew user/group names
References: <4A38F04C.9090909@linux.vnet.ibm.com>
	<200906191917.45817.agruen@suse.de>
In-Reply-To: <200906191917.45817.agruen@suse.de>
Content-Type: multipart/mixed; boundary="------------030007090302060906090308"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: acl-devel@nongnu.org
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------030007090302060906090308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andreas,
>> Removing the checks isprint(*s) and *s == '\\' resolves the issue.
>> AD shares are associated with a doamin name and AD users/groups will be in
>> the format Dom\user. Can someone explain why these checks are required?
> 
> The '\\' check is required so that backslashes will go through 
> unquote(quote(string)) will come out correctly.
> 
> The isprint() check is a misguided attempt to do something reasonable with 
> unprintable characters, but it leads to lots of problems with different 
> encodings, so it should probably be removed. I'll fix that.
> 
> There also is a check for '=' in quote(). This is from the attr package which 
> separates names and values with '=', but unnecessary in acl. quote() should 
> probably be passed in a string of additional characters that need to be quoted 
> so that it does the right thing in both packages.

The do_print() in getfacl/getfacl.c calls

printf("# owner: %s\n", xquote(user_name(st->st_uid, opt_numeric)));
printf("# group: %s\n", xquote(group_name(st->st_gid, opt_numeric)));

and xquote simply calls quote().

Also, acl_entry_to_any_str() in libacl/__acl_to_any_text.c calls quote.
I could not find the corresponding unquote calls for these.

If I wrap the above quote() calls with unquote(), the problem seems to be resolved.
Attaching a patch for the same.

Cheers!
Anoop

--------------030007090302060906090308
Content-Type: application/x-troff-man;
 name="getfacl-2.2.47.patch.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="getfacl-2.2.47.patch.2"

diff -Naurp acl-2.2.47.orig/getfacl/getfacl.c acl-2.2.47/getfacl/getfacl.c
--- acl-2.2.47.orig/getfacl/getfacl.c	2009-06-17 14:44:57.000000000 +0300
+++ acl-2.2.47/getfacl/getfacl.c	2009-06-22 10:17:57.000000000 +0300
@@ -495,16 +495,16 @@ int do_print(const char *path_p, const s
 		if (opt_comments) {
 			printf("# file: %s\n", xquote(path_p));
 			printf("# owner: %s\n",
-			       xquote(user_name(st->st_uid, opt_numeric)));
+			       unquote(xquote(user_name(st->st_uid, opt_numeric))));
 			printf("# group: %s\n",
-			       xquote(group_name(st->st_gid, opt_numeric)));
+			       unquote(xquote(group_name(st->st_gid, opt_numeric))));
 		}
 		if (acl != NULL) {
 			char *acl_text = acl_to_any_text(acl, NULL, '\n',
 							 print_options);
 			if (!acl_text)
 				goto fail;
-			if (puts(acl_text) < 0) {
+			if (puts(unquote(acl_text)) < 0) {
 				acl_free(acl_text);
 				goto fail;
 			}
@@ -516,7 +516,7 @@ int do_print(const char *path_p, const s
 							 print_options);
 			if (!acl_text)
 				goto fail;
-			if (puts(acl_text) < 0) {
+			if (puts(unquote(acl_text)) < 0) {
 				acl_free(acl_text);
 				goto fail;
 			}

--------------030007090302060906090308
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------030007090302060906090308--
