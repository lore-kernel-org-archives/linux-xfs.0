Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C8F427CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 11:44:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 359AEAC001
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 09:44:10 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bSWfJUwBv8WJffmd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 09:44:08 -0700 (PDT)
Date: Tue, 6 Sep 2016 09:43:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/71] xfs: create refcount update intent log items
Message-ID: <20160906164341.GD16696@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216801436.867.13017543869659604138.stgit@birch.djwong.org>
	<20160906151603.GI24287@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906151603.GI24287@infradead.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 08:16:03AM -0700, Christoph Hellwig wrote:
> > +/*
> > + * This is the structure used to lay out a cui log item in the
> > + * log.  The cui_extents field is a variable size array whose
> > + * size is given by cui_nextents.
> > + */
> > +struct xfs_cui_log_format {
> > +	__uint16_t		cui_type;	/* cui log item type */
> > +	__uint16_t		cui_size;	/* size of this item */
> > +	__uint32_t		cui_nextents;	/* # extents to free */
> > +	__uint64_t		cui_id;		/* cui identifier */
> > +	struct xfs_phys_extent	cui_extents[1];	/* array of extents */
> 
> Please define this as a proper variable length extent, e.g.
> 
> 	struct xfs_phys_extent	cui_extents[];
> 
> and get rid of the one-off arithmentics in xfs_cui_copy_format and
> xfs_cui_init.

Ok.

> > +int
> > +xfs_cui_copy_format(
> > +	struct xfs_log_iovec		*buf,
> > +	struct xfs_cui_log_format	*dst_cui_fmt)
> > +{
> > +	struct xfs_cui_log_format	*src_cui_fmt;
> > +	uint				len;
> > +
> > +	src_cui_fmt = buf->i_addr;
> > +	len = sizeof(struct xfs_cui_log_format) +
> > +			(src_cui_fmt->cui_nextents - 1) *
> > +			sizeof(struct xfs_phys_extent);
> > +
> > +	if (buf->i_len == len) {
> > +		memcpy((char *)dst_cui_fmt, (char *)src_cui_fmt, len);
> > +		return 0;
> > +	}
> > +	return -EFSCORRUPTED;
> 
> 
> Wouldn't life be a simpler if we simply opencoded this in
> xlog_recover_cui_pass2?  Also no need for the casts in the memcpy
> arguments.

<shrug> I'm relatively indifferent either way, though I noticed that
EFIs have a separate copy_format function in xfs_extfree_item.c which
reduces the amount of clutter in xfs_log_recover.c.  It seemed more
neat to keep all the log item functions corralled within a separate
file rather than putting them in xfs_log_recover.c, so I maintained
that pattern for the rui/cui/bui items.

In a semi-related side note I've been toying with turning on LTO in
xfsprogs to see how much it shrinks all the XFS code.  Code size goes
down considerably (repair shrinks by nearly 1MB!) but wow the
resulting tangle can be a PITA to debug.  :(

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
