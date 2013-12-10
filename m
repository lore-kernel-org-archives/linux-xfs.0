Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B4647F59
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 10:18:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBD9F304066
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 08:18:28 -0800 (PST)
Date: Tue, 10 Dec 2013 08:18:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/10] xfs: remove duplicate code in
	xlog_cil_insert_format_items
Message-ID: <20131210161827.GA32474@infradead.org>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084000.123386171@bombadil.infradead.org>
	<20131209194548.GX1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209194548.GX1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 09, 2013 at 01:45:48PM -0600, Ben Myers wrote:
> > +			if (ordered) {
> > +				/* track as an ordered logvec */
> > +				ASSERT(lip->li_lv == NULL);
> > +				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
> > +				goto insert;
> 
> It looks like lv->lv_niovecs is no longer being set in this case.  Was that intentional?

Yes, ordered log vecs don't have iovecs attached, so the implicit zero
from the kmem_zalloc is the right value.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
