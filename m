Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NDYEQ0128011 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 08:34:14 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2C32E48151
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 06:47:40 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id tPHOpZFTdkxf3PWi for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 06:47:40 -0700 (PDT)
Message-ID: <4C9B5786.4010205@open-e.com>
Date: Thu, 23 Sep 2010 15:35:02 +0200
From: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
MIME-Version: 1.0
Subject: Problem with file system on iSCSI FileIO
Reply-To: slawomir.nowakowski@open-e.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: =?UTF-8?B?xYF1aw==?=@oss.sgi.com, 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, Artur Piechocki <artur.piechocki@open-e.com>, =?UTF-8?B?YXN6IFdpdHRpZw==?= <lukasz.wittig@open-e.com>

Dear Sir,

We are using iSCSI FileIO on the LVM. The file (called lun) has been 
initialized with:
dd if=/dev/zero of=/dev/vg+vg00/lv+i+lv0000 bs=1M conv=notrunc

on the XFS formatted logical volume.

Additionally, we use 2.6.27-39 kernel  and xfs-tools 2.10.1

After some time, without any additional errors, we are not able mount 
the volume. After mount command we get:


"mount: Structure needs cleaning"

in dmesg we can see:

"XFS: failed to read root inode"

If we run the xfs_repair, the lun file will be removed and all data on 
the iSCSI FileIO volume is lost.

I have found in the FAQ that this can be everything:

http://xfs.org/index.php/XFS_FAQ#Q:_I_see_applications_returning_error_990_or_.22Structure_needs_cleaning.22.2C_what_is_wrong.3F

But do you know if it is possible to recover the data somehow?

Thanks in advance for response

-- 

If you have any more questions, please do not hesitate to contact me.

Best Regards

Slawomir Nowakowski
Technical Support Engineer
-------------------------------------------------------
Open-E GmbH
e-mail: slawomir.nowakowski@open-e.com
http://www.open-e.com/
-------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
