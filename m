Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 03:02:23 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MA2Kcu007261
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 03:02:20 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29BA21A2CEEC
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 03:03:41 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174]) by cuda.sgi.com with ESMTP id 6fHuzWFH9CffDC9O for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 03:03:41 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so369020wfd.32
        for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 03:03:40 -0700 (PDT)
Message-ID: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:03:40 +0200
From: "=?ISO-8859-2?Q?S=B3awomir_Nowakowski?=" <nailman23@gmail.com>
Subject: XFS issue under 2.6.25.13 kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dear All,

We have a problem with implementing xfs file system for Linux. The problem
appears after mounting xfs file system on 2.6.25.13 kernel that is created on
2.6.17.13 kernel.

File system is created on logical volume in the following way:

lvcreate -L 4G volume1 -n test
mkfs.xfs /dev/volume1/test
mount /dev/volume1/test /mnt/x

After mounting it on 2.6.17.13 kernel "df -B 1" output looks like this:

/dev/volume1/test    4284481536    147456 4284334080   1% /mnt/x

but in case of 2.6.25.13 kernel:

/dev/volume1/test    4284481536   4489216 4279992320   1% /mnt/x

The same happens in case of 2.6.26.3 kernel.

As it is shown after mounting the volume in newer kernel size of file system
is visible smaller. The problem appears when on this volume exists one big
file, occupying all available space. After trying to mount it under newer
kernel, the file is cut because available free space is smaller.

Is it known issue and/or does solution or workaround exists?

Thank you in advance for your help.

Best Regards
Roland
