Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 00:56:26 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6K7u6DW017449
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 00:56:12 -0700
Received: from localhost (dslb-084-056-078-084.pools.arcor-ip.net [84.56.78.84])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id D040CFA8A6
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 09:53:05 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs FAQ update for write cache
Date: Thu, 20 Jul 2006 09:55:35 +0200
References: <200607200602.k6K62Lsp32974694@snort.melbourne.sgi.com>
In-Reply-To: <200607200602.k6K62Lsp32974694@snort.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607200955.36136.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 20 Juli 2006 08:02 schrieb Timothy Shimmin:
> Modid:  current:xfs-website:212892a
> faq.html - 1.88 - changed
> 	- Update info about write cache.
> 	  Mention persistent write cache, external logs,
> 	  checking it was actually enabled in xfs msgs.

Hello Thimothy,

thanks a lot... thats awesome... I have that directory corruption problem 
also mentioned in the FAQ on a workstation at work. When you have a new 
xfs_check available I can test it. (I know how to compile it under 
Knoppix 5 ;-).

A little feedback: lines are not wrapped in either Firefox or Konqueror 
(http://oss.sgi.com/projects/xfs/faq.html). This is for the complete FAQ. 
It makes reading it difficult.

It might make sense to include the log messages when barriers are disabled 
at the approbiate places of the FAQ:

root@deepdance:/usr/src/linux/fs/xfs -> grep -ir "barrier" *
linux-2.6/xfs_super.c:xfs_mountfs_check_barriers(xfs_mount_t *mp)
linux-2.6/xfs_super.c:            "Disabling barriers, not supported with 
external log device");
linux-2.6/xfs_super.c:          mp->m_flags &= ~XFS_MOUNT_BARRIER;
linux-2.6/xfs_super.c:            "Disabling barriers, not supported by 
the underlying device");
linux-2.6/xfs_super.c:          mp->m_flags &= ~XFS_MOUNT_BARRIER;
linux-2.6/xfs_super.c:  error = xfs_barrier_test(mp);
linux-2.6/xfs_super.c:            "Disabling barriers, trial barrier write 
failed");
linux-2.6/xfs_super.c:          mp->m_flags &= ~XFS_MOUNT_BARRIER;

While they are quite self-explanatory it might still help to make it 
absolutely clear what each log message mean.

Is the last one  "Disabling barriers, trial barrier write failed" issued 
when the underlying device does not support write barriers?

It would be good to know which drivers do and which don't but thats more 
of a kernel FAQ regarding write barrier support. Its probably best to 
test for oneself and use the logs ;-)

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
