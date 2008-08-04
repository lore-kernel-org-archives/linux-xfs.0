Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 14:54:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77LrsYw028297
	for <linux-xfs@oss.sgi.com>; Thu, 7 Aug 2008 14:53:55 -0700
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 185CA374C72
	for <linux-xfs@oss.sgi.com>; Thu,  7 Aug 2008 14:55:08 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com with ESMTP id 1wnCkpXmMwgxSXjP for <linux-xfs@oss.sgi.com>; Thu, 07 Aug 2008 14:55:08 -0700 (PDT)
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KRDRm-0001Jj-Te
	for linux-xfs@oss.sgi.com; Thu, 07 Aug 2008 21:55:03 +0000
Received: from 155.91.45.232 ([155.91.45.232])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Thu, 07 Aug 2008 21:55:02 +0000
Received: from freemanrich by 155.91.45.232 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Thu, 07 Aug 2008 21:55:02 +0000
From: Richard Freeman <freemanrich@gmail.com>
Subject: Re: =?utf-8?b?eGZzX2ZvcmNlX3NodXRkb3du?= called from file =?utf-8?b?ZnMveGZzL3hmc190cmFuc19idWYuYw==?=
Date: Mon, 4 Aug 2008 16:55:41 +0000 (UTC)
Message-ID: <loom.20080804T165100-165@post.gmane.org>
References: <B3EDBE0F860AF74BAA82EF17A7CDEDC660BE05A3@svits26.main.ad.rit.edu> <C8CBE79A-8D1D-4151-ADFD-2C9400FAF356@rit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Jay Sullivan <jpspgd <at> rit.edu> writes:
> 
> Today I upgraded to the latest stable kernel in Gentoo (2.6.23-r3) and  
> I'm still on xfsprogs 2.9.4, also the latest stable release.  A few  
> hours after rebooting to load the new kernel, I saw the following in  
> dmesg:
> 
> ####################
> attempt to access beyond end of device
> dm-0: rw=0, want=68609558288793608, limit=8178892800

I just started getting these on an ext3 filesystem also on gentoo, with the 
latest stable kernel.  I suspect there is an lvm bug of some kind that is 
responsible.  I ran an e2fsck on the filesystem and managed to corrupt not 
only that filesystem, but also several others on the same RAID.  I'm probably 
going to have to try to salvage what I can from the no-longer-booting system 
and rebuild from scatch/backups.

Either lvm has some major bug, or somehow e2fsck is bypassing the lvm layer 
and writing directly to the drives.  It shouldn't be possible to write to one 
logical volume and modify data stored in a different logical volume on the 
same md raid-5 device.  A check of the underlying RAID turns up no issues - I 
suspect the problem is in the lvm layer.

Googling around for "access beyond end of device" turns up other reports of 
similar issues.  Obviously the problem is rare.
