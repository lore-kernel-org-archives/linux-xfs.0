Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A4CFC7CF4
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:08:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45316304039
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:08:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Y0rgxtCN9e4qNAcq for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:08:19 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id F1259545
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:08:18 -0500 (CDT)
Subject: Re: [PATCH 08/19] mkfs: getbool is redundant
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-9-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c2bb26bc-dbbb-4068-cdbf-4d7543d22408@sandeen.net>
Date: Mon, 2 May 2016 18:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-9-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove manpage changes, tidy others

Tidy up the grammar a little in the boolean args description.

Remove extra text around the noalign option.

It's fine that the noalign option now takes an optional
boolean 0/1 argument, but I don't think we need to document
it in the manpage.  If someone happens to add "=1" and it works,
they'll just be pleasantly surprised.


Eric Sandeen <sandeen@redhat.com>: manpage tidiness
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index be3d1a0..980b0e1 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -119,7 +119,7 @@ option first needs to be added to the command line.
 Failure to specify the size of the units will result in illegal value errors
 when parameters are quantified in those units.
 .PP
-Many options allows for optional argument of value 0 or 1, to explicitly
+Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
 .SH OPTIONS
 .TP
@@ -315,12 +315,10 @@ and
 .B swidth
 values.
 .TP
-.BI noalign[= value ]
-If the
-.I value
-is 1, this option disables automatic geometry detection and creates the filesystem
+.BI noalign
+This option disables automatic geometry detection and creates the filesystem
 without stripe geometry alignment even if the underlying storage device provides
-this information. 0 disables this option, that is, enables automatic detection.
+this information.
 .RE
 .TP
 .B \-f
@@ -810,11 +808,9 @@ This suboption is only needed if the real-time section of the
 filesystem should occupy less space than the size of the partition
 or logical volume containing the section.
 .TP
-.BI noalign[= value ]
-If the
-.I value
-is 1, then the option disables stripe size detection, enforcing a realtime
-device with no stripe geometry. 0 will enable stripe size detection.
+.BI noalign
+This option disables stripe size detection, enforcing a realtime device with no
+stripe geometry.
 .RE
 .TP
 .BI \-s " sector_size"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
