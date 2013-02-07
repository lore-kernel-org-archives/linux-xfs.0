Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B4F37F3F
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2013 09:42:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8AF7C304032
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2013 07:42:32 -0800 (PST)
Received: from smtpbg56.qq.com (smtpbg56.qq.com [64.71.138.45]) by
	cuda.sgi.com with SMTP id U4rS1sDJFuAVOvHa for
	<xfs@oss.sgi.com>; Thu, 07 Feb 2013 07:42:31 -0800 (PST)
Received: from [192.168.1.2] (unknown [60.30.217.59])
	by esmtp4.qq.com (ESMTP) with SMTP id 0
	for <xfs@oss.sgi.com>; Thu, 07 Feb 2013 23:42:26 +0800 (CST)
Message-ID: <5113CB5D.40007@Tydus.org>
Date: Thu, 07 Feb 2013 23:42:21 +0800
From: Tydus Ken <Tydus@Tydus.org>
MIME-Version: 1.0
Subject: XFS on RAID5+LVM with scheduled capacity grow
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

Hi list,
   I'm new here, and also new to RAID.
   I just bought a LSI RAID card and 3 new 2TB HDDs (together with 2 old
ones), and trying to build a RAID5 volume.
   Because I don't have spare drives, I'm doing like this: use the 3 new
ones to build RAID5, then create a LVM VG on it as partition table, make
an XFS (as well as a BTRFS for profile and personal data) on it. Then
grow it to 5 drives use MegaCLi, do a vgextend, then xfs_growfs.
   Now the question is, I cannot deside sw of XFS
(https://raid.wiki.kernel.org/index.php/RAID_setup#XFS). I think I
should use 4(5-1), but it has poor performance (~140MB/s while raw disk
write is ~250M). Is this all right? Or should I specify sunit and swidth
in the mount options? I don't really know the mechanic of XFS on this,
does this have effect on read?
   Additionally, I want to know if this is the optimal method for me or
just use GPT? Maybe I will grow the array to more disks later.

   Any help is appreciated.

Tydus Ken

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
