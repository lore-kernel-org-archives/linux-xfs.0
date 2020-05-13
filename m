Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2932ACA90AF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBB8C20750
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FGVloXyl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgEMNOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 09:14:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733297AbgEMNOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 09:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589375660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Srd2/2KU57FehrojignuJqqXrUW/BBSkycuY0Il9yEY=;
        b=FGVloXyl3s+CSUx33KHSfxYZ0h5mOXViZXK31SGKfceCnrQH7VaS71ipfwyPJjGKbnx7xu
        LTKGUJY6l892MZMhNeycGURN2jN7PIMRj6IKbsFBDeNnzTZKwDyK9+8okNVBfvveMZkLuH
        1jnlYMxNZWg7QMJT86w+tjSlgobjtSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-xXq1LhSqNCy_ayNKX4SIbw-1; Wed, 13 May 2020 09:14:18 -0400
X-MC-Unique: xXq1LhSqNCy_ayNKX4SIbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D282318FE861;
        Wed, 13 May 2020 13:14:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 785C75D9E8;
        Wed, 13 May 2020 13:14:17 +0000 (UTC)
Date:   Wed, 13 May 2020 09:14:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200513131415.GC44225@bfoster>
References: <20200512210033.GL6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512210033.GL6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 02:00:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While QAing the new xfs_repair quotacheck code, I uncovered a quota
> corruption bug resulting from a bad interaction between dquot buffer
> initialization and quotacheck.  The bug can be reproduced with the
> following sequence:
> 
> # mkfs.xfs -f /dev/sdf
> # mount /dev/sdf /opt -o usrquota
> # su nobody -s /bin/bash -c 'touch /opt/barf'
> # sync
> # xfs_quota -x -c 'report -ahi' /opt
> User quota on /opt (/dev/sdf)
>                         Inodes
> User ID      Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> root            3      0      0  00 [------]
> nobody          1      0      0  00 [------]
> 
> # xfs_io -x -c 'shutdown' /opt
> # umount /opt
> # mount /dev/sdf /opt -o usrquota
> # touch /opt/man2
> # xfs_quota -x -c 'report -ahi' /opt
> User quota on /opt (/dev/sdf)
>                         Inodes
> User ID      Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> root            1      0      0  00 [------]
> nobody          1      0      0  00 [------]
> 
> # umount /opt
> 
> Notice how the initial quotacheck set the root dquot icount to 3
> (rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
> xfs_quota reports that the root dquot has only 1 icount.  We haven't
> deleted anything from the filesystem, which means that quota is now
> under-counting.  This behavior is not limited to icount or the root
> dquot, but this is the shortest reproducer.
> 
> I traced the cause of this discrepancy to the way that we handle ondisk
> dquot updates during quotacheck vs. regular fs activity.  Normally, when
> we allocate a disk block for a dquot, we log the buffer as a regular
> (dquot) buffer.  Subsequent updates to the dquots backed by that block
> are done via separate dquot log item updates, which means that they
> depend on the logged buffer update being written to disk before the
> dquot items.  Because individual dquots have their own LSN fields, that
> initial dquot buffer must always be recovered.
> 
> However, the story changes for quotacheck, which can cause dquot block
> allocations but persists the final dquot counter values via a delwri
> list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
> means that the initial dquot buffer can be replayed over the (newer)
> contents that were delwritten at the end of quotacheck.  In effect, this
> re-initializes the dquot counters after they've been updated.  If the
> log does not contain any other dquot items to recover, the obsolete
> dquot contents will not be corrected by log recovery.
> 
> Because quotacheck uses a transaction to log the setting of the CHKD
> flags in the superblock, we skip quotacheck during the second mount
> call, which allows the incorrect icount to remain.
> 
> Fix this by changing the ondisk dquot initialization function to use
> ordered buffers to write out fresh dquot blocks if it detects that we're
> running quotacheck.  If the system goes down before quotacheck can
> complete, the CHKD flags will not be set in the superblock and the next
> mount will run quotacheck again, which can fix uninitialized dquot
> buffers.  This requires amending the defer code to maintaine ordered
> buffer state across defer rolls for the sake of the dquot allocation
> code.
> 
> For regular operations we preserve the current behavior since the dquot
> items require properly initialized ondisk dquot records.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   10 ++++++++-
>  fs/xfs/xfs_dquot.c        |   51 ++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 47 insertions(+), 14 deletions(-)
> 
...  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7f39dd24d475..cf8b2f4de587 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
...
> @@ -277,11 +279,34 @@ xfs_qm_init_dquot_blk(
>  		}
>  	}
>  
> -	xfs_trans_dquot_buf(tp, bp,
> -			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
> -			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
> -			     XFS_BLF_GDQUOT_BUF)));
> -	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> +	if (type & XFS_DQ_USER) {
> +		qflag = XFS_UQUOTA_CHKD;
> +		blftype = XFS_BLF_UDQUOT_BUF;
> +	} else if (type & XFS_DQ_PROJ) {
> +		qflag = XFS_PQUOTA_CHKD;
> +		blftype = XFS_BLF_PDQUOT_BUF;
> +	} else {
> +		qflag = XFS_GQUOTA_CHKD;
> +		blftype = XFS_BLF_GDQUOT_BUF;
> +	}
> +
> +	xfs_trans_dquot_buf(tp, bp, blftype);
> +
> +	/*
> +	 * If the CHKD flag isn't set, we're running quotacheck and need to use
> +	 * ordered buffers so that the logged initialization buffer does not
> +	 * get replayed over the delwritten quotacheck buffer.  If we crash
> +	 * before the end of quotacheck, the CHKD flags will not be set in the
> +	 * superblock and we'll re-run quotacheck at next mount.
> +	 *
> +	 * Outside of quotacheck, dquot updates are logged via dquot items and
> +	 * we must use the regular buffer logging mechanisms to ensure that the
> +	 * initial buffer state is recovered before dquot items.
> +	 */
> +	if (mp->m_qflags & qflag)
> +		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> +	else
> +		xfs_trans_ordered_buf(tp, bp);

Ok, I think I follow what's going on here. quotacheck runs and allocates
a dquot block and inits it in a transaction. Some time later quotacheck
updates dquots in said block and queues the buffer in its own delwri
list. Quotacheck completes, the buffer is written back and then the
filesystem immediately crashes. We replay the content of the alloc/init
transaction over the updated content in the block on disk. This isn't a
problem outside of quotacheck because a subsequent dquot update would
have also been logged instead of directly written back.

Therefore, the purpose of the change above is primarily to avoid logging
the init of the dquot buffer during quotacheck. That makes sense, but
what about the integrity of this particular transaction? For example,
what happens if this transaction commits to the on-disk log and we crash
before quotacheck completes and the buffer is written back? I'm assuming
recovery would replay the dquot allocation but not the initialization,
then quotacheck would run again and find the buffer in an unknown state
(perhaps failing a read verifier?). Hm?

Brian

>  }
>  
>  /*
> 

