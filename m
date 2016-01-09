Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 988797F37
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 07:39:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 242EBAC002
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 05:39:30 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lqnHYmh9yCSnE1HQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 05:39:28 -0800 (PST)
Date: Sat, 9 Jan 2016 05:39:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/35] block: set op to REQ_OP
Message-ID: <20160109133918.GC26660@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-27-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452027218-32303-27-git-send-email-mchristi@redhat.com>
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
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

> @@ -1149,10 +1151,12 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
>  
>  	blk_rq_init(q, rq);
>  	blk_rq_set_rl(rq, rl);
> -	rq->cmd_flags = rw_flags | REQ_ALLOCED;
> +	/* tmp compat - allow users to check either one for the op */
> +	rq->cmd_flags = op | op_flags | REQ_ALLOCED;

This one is still left after the whole series is applied, seems like
the hunk to remove it again got lost somewhere.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
