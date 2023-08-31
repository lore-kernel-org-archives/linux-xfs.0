Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA53C83F01
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 12:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346295AbjHaMjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 08:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346301AbjHaMjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 08:39:09 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060601A4
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 05:39:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-68a6f6a66e1so574605b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 05:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693485545; x=1694090345; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L3VP6rA968fYh9bg1M3TzY+bczzreDTM/rS3B0EnsMU=;
        b=peAHqTDA3i/8G21yZRgv8aRpqwQpUwKGrZ+An/zTIYoXUTiy9/mLzgHO1upwgMBAM1
         A+dg7tiYFZZxpL2csMfB+ANXdFA1jXzueQCnXOebEv7sFwFNbod4prenjsSqsjA4Cjfm
         QV+LHKX99J81r9bkuuWZJ/bRoJ29VPykVwPonZLYjPoyZguJ4yRJX8D/hfbGHG6mUxJK
         njwBHGW39lUvTj9Y/1kWH7m3LXTmiykwDq0MhQEgn5VA8xlecKrXcoqSFEu2UllkCIi7
         EdOReSf6B5cVyPEq333sNVBrFeV4+EpnDrI+7PPTmFQDJ7zswE4tj8GwX+sNmehuzSfs
         eP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693485545; x=1694090345;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L3VP6rA968fYh9bg1M3TzY+bczzreDTM/rS3B0EnsMU=;
        b=DnpwoQ2IHC1AtFbtCp+oZxff/RQCyYLnaIf1GZU27G9WVmm1zgU7bYxgfIPrq/1BBz
         CvS9Pi1xJLvDIYh05y6Q6JI3C/FCrgahzNh7QiNwQSMCNXwd9FInyqIDdTTPILSbGGWt
         se4dM00mP9HO63EcPX+dlAtiY8c4ZX23ARS2O/fqkNK2Koan5Mx8gwSc+3Er1PyFNo1P
         a/hXEUaDlzU4coCu3fIU7r1qW3tZqFWL9T2aeaobHaHEz4z4MGo46faSebvwLTf5k3yW
         FD+KwJt6gkstH94QyUxVgX0x4PmwG5nvFm3UrgO49JeX+FaYu04cltj9quBtzk9Q85fc
         fzJg==
X-Gm-Message-State: AOJu0YzlFXnonS6GcrNHaw4quOqnUBhCLErZLDCrjLGLz84iefSigCrF
        /y7wdMAyiFruM4vhTVrxtRU=
X-Google-Smtp-Source: AGHT+IHPU3MNs24C6mBHy3oASxsO4ZlrCil27Wjml6Fi19KwOkvd20d3OCFII3NUe6TlZLmsu1uVJw==
X-Received: by 2002:a05:6a00:238c:b0:68b:5b5d:ccd5 with SMTP id f12-20020a056a00238c00b0068b5b5dccd5mr5551253pfc.6.1693485544712;
        Thu, 31 Aug 2023 05:39:04 -0700 (PDT)
Received: from dw-tp ([49.207.223.191])
        by smtp.gmail.com with ESMTPSA id u17-20020aa78391000000b0068a3f861b24sm1244932pfm.195.2023.08.31.05.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 05:39:04 -0700 (PDT)
Date:   Thu, 31 Aug 2023 18:09:00 +0530
Message-Id: <87pm338jyz.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] xfs: load uncached unlinked inodes into memory on demand
In-Reply-To: <20230830152659.GJ28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:

> From: Darrick J. Wong <djwong@kernel.org>
>
> shrikanth hegde reports that filesystems fail shortly after mount with
> the following failure:
>
> 	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
>
> This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:
>
> 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> 	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }
>
> From diagnostic data collected by the bug reporters, it would appear
> that we cleanly mounted a filesystem that contained unlinked inodes.
> Unlinked inodes are only processed as a final step of log recovery,
> which means that clean mounts do not process the unlinked list at all.
>
> Prior to the introduction of the incore unlinked lists, this wasn't a
> problem because the unlink code would (very expensively) traverse the
> entire ondisk metadata iunlink chain to keep things up to date.
> However, the incore unlinked list code complains when it realizes that
> it is out of sync with the ondisk metadata and shuts down the fs, which
> is bad.
>
> Ritesh proposed to solve this problem by unconditionally parsing the
> unlinked lists at mount time, but this imposes a mount time cost for
> every filesystem to catch something that should be very infrequent.
> Instead, let's target the places where we can encounter a next_unlinked
> pointer that refers to an inode that is not in cache, and load it into
> cache.
>
> Note: This patch does not address the problem of iget loading an inode
> from the middle of the iunlink list and needing to set i_prev_unlinked
> correctly.
>
> Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
> Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: log that we're doing runtime recovery, dont mess with DONTCACHE,
>     and actually return ENOLINK
> ---
>  fs/xfs/xfs_inode.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_trace.h |   25 +++++++++++++++++
>  2 files changed, 96 insertions(+), 4 deletions(-)

Hi Darrick,

Thanks for taking a look at this. I tested this patch on the setup where
Shrikanth earlier saw the crash. I still can see a problem. I saw it is
taking the branch from 

+	/* If this is not an unlinked inode, something is very wrong. */
+	if (VFS_I(next_ip)->i_nlink != 0) {
+		error = -EFSCORRUPTED;
+		goto rele;
+	}

Here are the logs of reference - 

[   21.399573] XFS (dm-0): Found unrecovered unlinked inode 0x2ec44d in AG 0x0.  Initiating recovery.
[   21.400150] XFS (dm-0): Internal error xfs_trans_cancel at line 1104 of file fs/xfs/xfs_trans.c.  Caller xfs_remove+0x1a0/0x310 [xfs]
[   21.400222] CPU: 0 PID: 1629 Comm: systemd-tmpfile Not tainted 6.5.0+ #2
[   21.400226] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
[   21.400230] Call Trace:
[   21.400231] [c000000014cdbb70] [c000000000f377b8] dump_stack_lvl+0x6c/0x9c (unreliable)
[   21.400239] [c000000014cdbba0] [c008000000f7c204] xfs_error_report+0x5c/0x80 [xfs]
[   21.400303] [c000000014cdbc00] [c008000000fab320] xfs_trans_cancel+0x178/0x1b0 [xfs]
[   21.400371] [c000000014cdbc50] [c008000000f999d8] xfs_remove+0x1a0/0x310 [xfs]
[   21.400432] [c000000014cdbcc0] [c008000000f93eb0] xfs_vn_unlink+0x68/0xf0 [xfs]
[   21.400493] [c000000014cdbd20] [c0000000005b8038] vfs_rmdir+0x178/0x300
[   21.400498] [c000000014cdbd60] [c0000000005be444] do_rmdir+0x124/0x240
[   21.400502] [c000000014cdbdf0] [c0000000005be594] sys_rmdir+0x34/0x50
[   21.400506] [c000000014cdbe10] [c000000000033c38] system_call_exception+0x148/0x3a0
[   21.400511] [c000000014cdbe50] [c00000000000c6d4] system_call_common+0xf4/0x258
[   21.400515] --- interrupt: c00 at 0x7fff9ad230d4
[   21.400518] NIP:  00007fff9ad230d4 LR: 00007fff9b12ff74 CTR: 0000000000000000
[   21.400521] REGS: c000000014cdbe80 TRAP: 0c00   Not tainted  (6.5.0+)
[   21.400524] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 28004204  XER: 00000000
[   21.400534] IRQMASK: 0
[   21.400534] GPR00: 0000000000000028 00007fffc57f9aa0 00007fff9ae07300 000000014e651df0
[   21.400534] GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   21.400534] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   21.400534] GPR12: 0000000000000000 00007fff9b4f5e60 000000013ebbee38 000000013ebc05d8
[   21.400534] GPR16: 000000013ebbee60 000000013ebc0818 000000013ebbee70 000000013ebbfe68
[   21.400534] GPR20: 000000013ebe003b 000000013ebe0051 000000013ebe003c 0000000000000000
[   21.400534] GPR24: 000000013ebc07d8 000000014e6496c0 000000013ebe0078 00007fffc57f9c80
[   21.400534] GPR28: 0000000000000000 000000014e651df0 0000000000000000 000000000000000e
[   21.400569] NIP [00007fff9ad230d4] 0x7fff9ad230d4
[   21.400571] LR [00007fff9b12ff74] 0x7fff9b12ff74
[   21.400573] --- interrupt: c00
[   21.402551] XFS (dm-0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x190/0x1b0 [xfs] (fs/xfs/xfs_trans.c:1105).  Shutting down filesystem.
[   21.402615] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)

Do you know any possible reason/explaination on what could be going wrong?

>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6ee266be45d4..2942002560b5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
>  
>  	rcu_read_lock();
>  	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +	if (!ip) {
> +		/* Caller can handle inode not being in memory. */
> +		rcu_read_unlock();
> +		return NULL;
> +	}
>  
>  	/*
> -	 * Inode not in memory or in RCU freeing limbo should not happen.
> -	 * Warn about this and let the caller handle the failure.
> +	 * Inode in RCU freeing limbo should not happen.  Warn about this and
> +	 * let the caller handle the failure.
>  	 */
> -	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
> +	if (WARN_ON_ONCE(!ip->i_ino)) {
>  		rcu_read_unlock();
>  		return NULL;
>  	}
> @@ -1858,7 +1863,8 @@ xfs_iunlink_update_backref(
>  
>  	ip = xfs_iunlink_lookup(pag, next_agino);
>  	if (!ip)
> -		return -EFSCORRUPTED;
> +		return -ENOLINK;
> +
>  	ip->i_prev_unlinked = prev_agino;
>  	return 0;
>  }
> @@ -1902,6 +1908,62 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> +/*
> + * Load the inode @next_agino into the cache and set its prev_unlinked pointer
> + * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
> + * to the unlinked list.
> + */
> +STATIC int
> +xfs_iunlink_reload_next(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
> +	xfs_agino_t		prev_agino,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_perag	*pag = agibp->b_pag;
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*next_ip = NULL;
> +	xfs_ino_t		ino;
> +	int			error;
> +
> +	ASSERT(next_agino != NULLAGINO);
> +
> +#ifdef DEBUG
> +	rcu_read_lock();
> +	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
> +	ASSERT(next_ip == NULL);
> +	rcu_read_unlock();
> +#endif
> +
> +	xfs_info_ratelimited(mp,
> + "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating recovery.",
> +			next_agino, pag->pag_agno);
> +
> +	/*
> +	 * Use an untrusted lookup to be cautious in case the AGI has been
> +	 * corrupted and now points at a free inode.  That shouldn't happen,
> +	 * but we'd rather shut down now since we're already running in a weird
> +	 * situation.
> +	 */
> +	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
> +	if (error)
> +		return error;
> +
> +	/* If this is not an unlinked inode, something is very wrong. */
> +	if (VFS_I(next_ip)->i_nlink != 0) {
> +		error = -EFSCORRUPTED;
> +		goto rele;
> +	}
> +
> +	next_ip->i_prev_unlinked = prev_agino;
> +	trace_xfs_iunlink_reload_next(next_ip);
> +rele:
> +	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
> +	xfs_irele(next_ip);
> +	return error;
> +}
> +
>  static int
>  xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> @@ -1933,6 +1995,8 @@ xfs_iunlink_insert_inode(
>  	 * inode.
>  	 */
>  	error = xfs_iunlink_update_backref(pag, agino, next_agino);
> +	if (error == -ENOLINK)
> +		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
>  	if (error)
>  		return error;
>  
> @@ -2027,6 +2091,9 @@ xfs_iunlink_remove_inode(
>  	 */
>  	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
>  			ip->i_next_unlinked);
> +	if (error == -ENOLINK)
> +		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
> +				ip->i_next_unlinked);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 36bd42ed9ec8..f4e46bac9b91 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3832,6 +3832,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
>  		  __entry->new_ptr)
>  );
>  
> +TRACE_EVENT(xfs_iunlink_reload_next,
> +	TP_PROTO(struct xfs_inode *ip),
> +	TP_ARGS(ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, agino)
> +		__field(xfs_agino_t, prev_agino)
> +		__field(xfs_agino_t, next_agino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = ip->i_mount->m_super->s_dev;
> +		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->prev_agino = ip->i_prev_unlinked;
> +		__entry->next_agino = ip->i_next_unlinked;
> +	),
> +	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_unlinked 0x%x next_unlinked 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->agino,
> +		  __entry->prev_agino,
> +		  __entry->next_agino)
> +);
> +
>  DECLARE_EVENT_CLASS(xfs_ag_inode_class,
>  	TP_PROTO(struct xfs_inode *ip),
>  	TP_ARGS(ip),

-ritesh
