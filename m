Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7811129DFB
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 16:02:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47C2330404E
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 14:02:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lhFTGiCBke5nZ3TG for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 14:02:25 -0700 (PDT)
Date: Thu, 29 Aug 2013 07:02:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: check LSN ordering for v5 superblocks during
	recovery
Message-ID: <20130828210223.GO12779@dastard>
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
	<1377688967-6480-3-git-send-email-david@fromorbit.com>
	<521E625A.2070109@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <521E625A.2070109@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 28, 2013 at 03:49:30PM -0500, Mark Tinguely wrote:
> On 08/28/13 06:22, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Log recovery has some strict ordering requirements which unordered
> >or reordered metadata writeback can defeat. This can occur when an
> >item is logged in a transaction, written back to disk, and then
> >logged in a new transaction before the tail of the log is moved past
> >the original modification.
> >
> >The result of this is that when we read an object off disk for
> >recovery purposes, the buffer that we read may not contain the
> >object type that recovery is expecting and hence at the end of the
> >checkpoint being recovered we have an invalid object in memory.
> >
> >This isn't usually a problem, as recovery will then replay all the
> >other checkpoints and that brings the object back to a valid and
> >correct state, but the issue is that while the object is in the
> >invalid state it can be flushed to disk. This results in the object
> >verifier failing and triggering a corruption shutdown of log
> >recover. This is correct behaviour for the verifiers - the problem
> >is that we are not detecting that the object we've read off disk is
> >newer than the transaction we are replaying.
> >
> >All metadata in v5 filesystems has the LSN of it's last modification
> >stamped in it. This enabled log recover to read that field and
> >determine the age of the object on disk correctly. If the LSN of the
> >object on disk is older than the transaction being replayed, then we
> >replay the modification. If the LSN of the object matches or is more
> >recent than the transaction's LSN, then we should avoid overwriting
> >the object as that is what leads to the transient corrupt state.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> 
> >@@ -2488,7 +2595,7 @@ xlog_recover_buffer_pass2(
> >  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
> >  	}
> >  	if (error)
> >-		return XFS_ERROR(error);
> >+		goto out_release;
> >
> 
> This adds a xfs_buf_relse() on the buffer in the error path. The
> reference was taken in this routine. The callers do not know of the
> buffer and can't release it. convinced me.
> 
> 
> >  	/*
> >  	 * Perform delayed write on the buffer.  Asynchronous writes will be
> >@@ -2517,6 +2624,7 @@ xlog_recover_buffer_pass2(
> >  		xfs_buf_delwri_queue(bp, buffer_list);
> >  	}
> >
> >+out_release:
> >  	xfs_buf_relse(bp);
> >  	return error;
> 
> Looks good. Nice to get into Linux 3.12 and possibly back to stable.

Why stable? It's v5 only code, and everyon knows that is still in
the experimental stage....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
