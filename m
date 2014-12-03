Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 746127F54
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 04:51:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 636F28F8037
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 02:51:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id am3iba7kaBVXywLK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 02:51:23 -0800 (PST)
Date: Wed, 3 Dec 2014 02:51:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: lobotomise xfs_trans_read_buf_map()
Message-ID: <20141203105122.GA3727@infradead.org>
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
	<20141202165930.GA28571@infradead.org>
	<20141202224518.GG18131@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202224518.GG18131@dastard>
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

On Wed, Dec 03, 2014 at 09:45:18AM +1100, Dave Chinner wrote:
> > Can you fix the inconsistent return for the trylock case in a follow on
> > patch?  This difference doesn't look intentional to me, and I would
> > be surprised if it's correctly handled in the callers.
> 
> Ok, I'll do an audit and make this common in a follow up patch. Just
> to confirm:
> 
> 		if (!(flags & XBF_TRYLOCK))
> 			return -ENOMEM;
> 		return -EAGAIN;
> 
> is what you want to see, right?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
