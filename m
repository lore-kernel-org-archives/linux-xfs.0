Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 49AAB7F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 15:31:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A417304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 13:31:05 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Q4QSwc3BbGlokUrC for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 13:31:02 -0800 (PST)
Date: Mon, 4 Jan 2016 08:30:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 35/76] libxfs: refactor short btree block verification
Message-ID: <20160103213038.GZ19802@dastard>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090014.12713.75657.stgit@birch.djwong.org>
	<20160103121832.GD28429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160103121832.GD28429@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, Jan 03, 2016 at 04:18:32AM -0800, Christoph Hellwig wrote:
> > +/**
> > + * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
> > + *				      btree block
> > + *
> > + * @bp: buffer containing the btree block
> > + * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
> > + * @pag_max_level: pointer to the per-ag max level field
> > + */
> 
> We're so far avoided using kerneldoc comments and they silly super
> verbosity in XFS.  It might be good to tone this down to the normal
> XFS level (same for some other patches).

I'll do that before I commit it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
