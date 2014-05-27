Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 279267F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:38:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E18C304043
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 03:38:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id JjGOdxcObLloUU61 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 03:38:30 -0700 (PDT)
Date: Tue, 27 May 2014 03:38:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: block allocation work needs to be kswapd aware
Message-ID: <20140527103829.GA1440@infradead.org>
References: <1401143214-9181-1-git-send-email-david@fromorbit.com>
	<1401143214-9181-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401143214-9181-2-git-send-email-david@fromorbit.com>
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

On Tue, May 27, 2014 at 08:26:53AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Upon memory pressure, kswapd calls xfs_vm_writepage() from
> shrink_page_list(). This can result in delayed allocation occurring
> and that gets deferred to the the allocation workqueue.
> 
> The allocation then runs outside kswapd context, which means if it
> needs memory (and it does to demand page metadata from disk) it can
> block in shrink_inactive_list() waiting for IO congestion. These
> blocking waits are normally avoiding in kswapd context, so under
> memory pressure writeback from kswapd can be arbitrarily delayed by
> memory reclaim.
> 
> To avoid this, pass the kswapd context to the allocation being done
> by the workqueue, so that memory reclaim understands correctly that
> the work is being done for kswapd and therefore it is not blocked
> and does not delay memory reclaim.
> 
> To avoid issues with int->char conversion of flag fields (as noticed
> in v1 of this patch) convert the flag fields in the struct
> xfs_bmalloca to bool types. pahole indicates these variables are
> still single byte variables, so no extra space is consumed by this
> change.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
