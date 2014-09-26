Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CAADA29E02
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 07:01:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58EC7AC003
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:01:06 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7pL9FBMYUrcBTapf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 05:01:05 -0700 (PDT)
Date: Fri, 26 Sep 2014 05:01:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
Message-ID: <20140926120104.GA10574@infradead.org>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
	<1411697952-24741-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411697952-24741-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 26, 2014 at 12:19:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The XLOG_UNMOUNT_TRANS case skips the transaction, despite the fact
> an unmount record is always in a standalone transaction. Hence
> whenever we come across one of these we need to free the transaction
> structure associated with it as there is no commit record that
> follows it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> @@ -3600,8 +3605,10 @@ xlog_recover_ophdr_to_trans(
>  	 * on this opheader is allocate a new recovery container to hold
>  	 * the recovery ops that will follow.
>  	 */
> -	if (ohead->oh_flags & XLOG_START_TRANS)
> +	if (ohead->oh_flags & XLOG_START_TRANS) {
> +		ASSERT(be32_to_cpu(ohead->oh_len) == 0);
>  		xlog_recover_new_tid(rhp, tid, be64_to_cpu(rhead->h_lsn));
> +	}
>  	return NULL;

.. but I suspect this hunk fits better into the previous patch.
Also shouldn't we handle any sort of on disk corruption more gracefully?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
