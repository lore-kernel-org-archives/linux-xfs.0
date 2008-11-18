Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAIL1Xdu001454 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 15:01:35 -0600
Received: from smtp5.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06B951B8549C
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 13:01:23 -0800 (PST)
Received: from smtp5.poczta.onet.pl (smtp5.poczta.onet.pl [213.180.130.32]) by
	cuda.sgi.com with ESMTP id AP3rVCdCBq48VdR1 for
	<xfs@oss.sgi.com>; Tue, 18 Nov 2008 13:01:23 -0800 (PST)
Received: from ip-213-17-136-130.netia.com.pl ([213.17.136.130]:49677 "EHLO
	[192.168.0.101]" rhost-flags-OK-FAIL-OK-FAIL) by ps5.test.onet.pl
	with ESMTPSA id S251767032AbYKRVBQGIIXP (ORCPT
	<rfc822;xfs@oss.sgi.com>); Tue, 18 Nov 2008 22:01:16 +0100
Message-ID: <49232C66.2000504@poczta.onet.pl>
Date: Tue, 18 Nov 2008 21:58:14 +0100
From: aluno3 <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: Re: [xfs] Calltrace in 2.6.27 kernel]
References: <491C9687.6040305@poczta.onet.pl> <491D3BAB.2090207@poczta.onet.pl>
	<20081114163056.GA22691@infradead.org>
In-Reply-To: <20081114163056.GA22691@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi

I tested this patch through a few days and I did not get call trace from
kernel.Will this patch be included to official kernel? Thanks and best


Christoph Hellwig wrote:
> On Fri, Nov 14, 2008 at 09:49:47AM +0100, aluno3@poczta.onet.pl wrote:
>   
>> Hi
>>
>> I ran addr2line for both vmlinux and for first call trace (2.6.27)
>> add2line returned:
>>
>> addr2line -e ./vmlinux c029553d
>> fs/xfs/xfs_log.c:3528
>>
>> in source:
>>
>>         /*
>>          * If this happens during log recovery, don't worry about
>>          * locking; the log isn't open for business yet.
>>          */
>>         if (!log ||
>>             log->l_flags & XLOG_ACTIVE_RECOVERY) {
>>                 mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
>>                 XFS_BUF_DONE(mp->m_sb_bp);                            
>> //3528 line
>>     
>
> Thanks a lot.  I think I figured out what happens:
>
>  - we fail the buffer read in xlog_recover_do_inode_trans, and thus
>    abort the mount.
>  - but before that log recovery has started delayed writeback of inode
>    buffers
>  - during the mount error handling we call xfs_freesb, which NULLs
>    mp->m_sb_bp after the inode has been unmounted
>  - but the device close tries to flush all delayed buffers after that,
>    and the inode buffer triggers the filesystem shutdown case because
>    it also had an I/O error.
>  - Now we try to mark the superblock buffer done, but it's not there
>    anymore.
>
> The easy fix is to just check for a NULL mp->m_sb_bp before marking it
> done.  Note that this will only fix the XFS oops, but not the underling
> DM issue, for which I'd ask on the device mapper list.
>
>
> Index: xfs-2.6/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_log.c	2008-11-14 17:28:55.000000000 +0100
> +++ xfs-2.6/fs/xfs/xfs_log.c	2008-11-14 17:29:20.000000000 +0100
> @@ -3525,7 +3525,8 @@ xfs_log_force_umount(
>  	if (!log ||
>  	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
>  		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> -		XFS_BUF_DONE(mp->m_sb_bp);
> +		if (mp->m_sb_bp)
> +			XFS_BUF_DONE(mp->m_sb_bp);
>  		return 0;
>  	}
>  
> @@ -3546,7 +3547,8 @@ xfs_log_force_umount(
>  	spin_lock(&log->l_icloglock);
>  	spin_lock(&log->l_grant_lock);
>  	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> -	XFS_BUF_DONE(mp->m_sb_bp);
> +	if (mp->m_sb_bp)
> +		XFS_BUF_DONE(mp->m_sb_bp);
>  	/*
>  	 * This flag is sort of redundant because of the mount flag, but
>  	 * it's good to maintain the separation between the log and the rest
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
