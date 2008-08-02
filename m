Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 18:19:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m721JVdF023234
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 18:19:32 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C81F6352B29
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 18:20:45 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id GDD0G901SnYBkZkT for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 18:20:45 -0700 (PDT)
Date: Sat, 2 Aug 2008 11:20:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/21] implement generic xfs_btree_rshift
Message-ID: <20080802012042.GN6201@disturbed>
References: <20080729193125.GP19104@lst.de> <20080730060808.GP13395@disturbed> <20080801194914.GI1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080801194914.GI1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:49:14PM +0200, Christoph Hellwig wrote:
> > > +				  XFS_BB_NUM_BITS, &first, &last);
> > > +		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
> > > +	} else {
> > > +		/* XXX(hch): maybe factor out into a method? */
> > > +		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
> > > +			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
> > 
> > I don't think it is necessary at this point.
> 
> It's the only leakage of the detailed inode root implementation into
> the generic code, so I'm still wondering whether a method would be
> better.

Ah, right. yes, it probably would be cleaner to do it as a
separate method, but Ǐ don't think it's that important right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
