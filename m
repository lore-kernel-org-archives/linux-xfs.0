Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RK6NvK208460 for <xfs@oss.sgi.com>; Wed, 27 May 2009 15:06:23 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0786C14868E1
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:12:33 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id PxBtNK67neKwGEyg for <xfs@oss.sgi.com>;
	Wed, 27 May 2009 13:12:33 -0700 (PDT)
Message-ID: <4A1D9D41.7040107@sandeen.net>
Date: Wed, 27 May 2009 15:06:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: kill xfs_qmops
References: <20090224143736.GA16616@infradead.org>	<4A1C2839.3010005@sandeen.net>
	<20090527095616.GA19069@infradead.org>
In-Reply-To: <20090527095616.GA19069@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
...

> never, but that's a bug because the loop should now start at 0.  Looks
> like out quota testing in xfsqa still isn't that good or the first
> inode is always already attached in normal operation (probably the latter).
> 
> Updated patch below:
> 
> 
> Subject: xfs: kill xfs_qmops
> From: Christoph Hellwig <hch@lst.de>
> 
> Kill the quota ops function vector and replace it with direct calls or
> stubs in the CONFIG_XFS_QUOTA=n case.
> 
> Make sure we check XFS_IS_QUOTA_RUNNING in the right spots.  We can remove
> the number of those checks because the XFS_TRANS_DQ_DIRTY flag can't be set
> otherwise.
> 
> This brings us back closer to the way this code worked in IRIX and earlier
> Linux versions, but we keep a lot of the more useful factoring of common
> code.
> 
> Eventually we should also kill xfs_qm_bhv.c, but that's left for a later
> patch.
> 
> Reduces the size of the source code by about 250 lines and the size of
> XFS module by about 1.5 kilobytes with quotas enabled:
> 
>    text	   data	    bss	    dec	    hex	filename
>  615957	   2960	   3848	 622765	  980ad	fs/xfs/xfs.o
>  617231	   3152	   3848	 624231	  98667	fs/xfs/xfs.o.old
> 
> 
> Fallout:
> 
>  - xfs_qm_dqattach is split into xfs_qm_dqattach_locked which expects
>    the inode locked and xfs_qm_dqattach which does the locking around it,
>    thus removing XFS_QMOPT_ILOCKED.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Looks better to me now, thanks.  Though worrisome that quota doesn't
seem well-tested in xfsqa, as you said... but as far as I can tell seems
ok now.  Have arekm test it a bit too ;)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
