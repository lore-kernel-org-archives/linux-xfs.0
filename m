Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17703 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752642AbcJZRcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 13:32:01 -0400
Date: Wed, 26 Oct 2016 10:31:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/39] xfs_logprint: support refcount redo items
Message-ID: <20161026173119.GE26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743676212.11035.6341580285293427233.stgit@birch.djwong.org>
 <20161026103750.GQ29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026103750.GQ29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:37:50AM -0700, Christoph Hellwig wrote:
> > +static int
> > +xfs_cui_copy_format(
> > +	char			  *buf,
> > +	uint			  len,
> > +	struct xfs_cui_log_format *dst_fmt,
> > +	int			  continued)
> > +{
> > +	uint nextents = ((struct xfs_cui_log_format *)buf)->cui_nextents;
> 
> nit: may have a local variable of type struct xfs_cui_log_format *
> to clean this up a bit?
> 
> > +	uint dst_len = xfs_cui_log_format_sizeof(nextents);
> > +
> > +	if (len == dst_len || continued) {
> > +		memcpy((char *)dst_fmt, buf, len);
> 
> no need to cast here.
> 
> > +int
> > +xlog_print_trans_cui(
> > +	char			**ptr,
> > +	uint			src_len,
> > +	int			continued)
> > +{
> > +	struct xfs_cui_log_format	*src_f, *f = NULL;
> > +	uint			dst_len;
> > +	uint			nextents;
> > +	struct xfs_phys_extent	*ex;
> > +	int			i;
> > +	int			error = 0;
> > +	int			core_size;
> > +
> > +	core_size = offsetof(struct xfs_cui_log_format, cui_extents);
> > +
> > +	/*
> > +	 * memmove to ensure 8-byte alignment for the long longs in
> > +	 * struct xfs_cui_log_format structure
> > +	 */
> > +	src_f = malloc(src_len);
> > +	if (src_f == NULL) {
> > +		fprintf(stderr, _("%s: %s: malloc failed\n"),
> > +			progname, __func__);
> > +		exit(1);
> > +	}
> > +	memmove((char*)src_f, *ptr, src_len);
> 
> No need to use memmove on a freshly allocated buffer ever, memcpy
> is enough.  Also no need to cast here.
> 
> > +int
> > +xlog_print_trans_cud(
> > +	char				**ptr,
> > +	uint				len)
> > +{
> > +	struct xfs_cud_log_format	*f;
> > +	struct xfs_cud_log_format	lbuf;
> > +
> > +	/* size without extents at end */
> > +	uint core_size = sizeof(struct xfs_cud_log_format);
> > +
> > +	/*
> > +	 * memmove to ensure 8-byte alignment for the long longs in
> > +	 * xfs_efd_log_format_t structure
> > +	 */
> > +	memmove(&lbuf, *ptr, MIN(core_size, len));
> 
> Can be a memcpy again.
> 

Yeah, cut & paste, sorry.

The copy function can be passed a struct xfs_cui_log_format * as the
first parameter instead of char *, which cleans out a lot of the
cruftiness.  Will fix this all up.

--D
