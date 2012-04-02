Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32ES39k186612 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 09:28:03 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id SjiihV4Fj3iBwsPH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Apr 2012 07:28:01 -0700 (PDT)
Received: by pbcuo1 with SMTP id uo1so5263114pbc.26
	for <xfs@oss.sgi.com>; Mon, 02 Apr 2012 07:28:01 -0700 (PDT)
From: CHEN Baozi <baozich@gmail.com>
Subject: [RFC] Add XFS support in SYSLINUX
Date: Mon, 2 Apr 2012 22:27:53 +0800
Message-Id: <D9839BD8-29F4-4472-A5B5-7974497B14DD@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
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

Hi all,

I'm a student applying for this year's GSoC and planning to add XFS support to the syslinux bootloader. I did some research on the syslinux's implementation, and have a rough idea. 

XFS starts its superblock from the first bytes of partition, where syslinux would install its boot codes(in the first 512 bytes). Currently, we have two approach to handle that. One is to follow the GRUB that put its codes in the first few bytes immediately following the MBR and before the first partition's first sector. However, this approach breaks some designing rules of syslinux, so it won't be accepted. The other one that we are now considering is to use the remaining 2048 bytes left in XFS's first block. But I'm not sure that this area is reserved for some new features in the future. 

Any comment?

Regards,
Chen Baozi
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
