Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N6khC4161865 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 01:46:43 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92CD617522EE
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 23:46:42 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	ZsTch3d55P4n9PW5 for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 23:46:42 -0700 (PDT)
Received: by vxa40 with SMTP id 40so1229971vxa.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 23:46:40 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jun 2011 12:16:40 +0530
Message-ID: <BANLkTi=0Xk6XnU8nrCuKhMyiz-fRggnbrw@mail.gmail.com>
Subject: xfstests 228 output log differ
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear all,
I have attached the log of xfstests 228, the test case seems to PASS
on my target (MIPS 2.6.35.13) but log differ because of additional
information.
Can anyone tell how to fix it

 QA output created by 228
 File size limit is now set to 100 MB.
 Let us try to preallocate 101 MB. This should fail.
-File size limit exceeded
+./228: line 78:  1674 File size limit exceeded$XFS_IO_PROG -F -f -c
'falloc 0 101m' $TEST_DIR/ouch
 Let us now try to preallocate 50 MB. This should succeed.
 Test over.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
