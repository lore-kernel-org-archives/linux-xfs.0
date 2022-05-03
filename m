Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D51C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 23:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiECXLh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 19:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbiECXLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 19:11:35 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 984AD42ECD
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 16:08:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AC70F534628;
        Wed,  4 May 2022 09:08:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm1cc-007hDf-Kp; Wed, 04 May 2022 09:07:58 +1000
Date:   Wed, 4 May 2022 09:07:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: hide log iovec alignment constraints
Message-ID: <20220503230758.GC1098723@dread.disaster.area>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-4-david@fromorbit.com>
 <20220503224529.GD8265@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503224529.GD8265@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6271b5d0
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=Mn_ZLakLt8jX-304B0YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 03:45:29PM -0700, Darrick J. Wong wrote:
> On Wed, May 04, 2022 at 08:17:21AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Callers currently have to round out the size of buffers to match the
> > aligment constraints of log iovecs and xlog_write(). They should not
> > need to know this detail, so introduce a new function to calculate
> > the iovec length (for use in ->iop_size implementations). Also
> > modify xlog_finish_iovec() to round up the length to the correct
> > alignment so the callers don't need to do this, either.
> > 
> > Convert the only user - inode forks - of this alignment rounding to
> > use the new interface.
....
> >  static inline void
> > -xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
> > +xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
> > +		int data_len)
> >  {
> >  	struct xlog_op_header	*oph = vec->i_addr;
> > -
> > -	/* opheader tracks payload length, logvec tracks region length */
> > +	int			len;
> > +
> > +	/*
> > +	 * Always round up the length to the correct alignment so callers don't
> > +	 * need to know anything about this log vec layout requirement. This
> > +	 * means we have to zero the area the data to be written does not cover.
> > +	 * This is complicated by fact the payload region is offset into the
> > +	 * logvec region by the opheader that tracks the payload.
> > +	 */
> > +	len = xlog_calc_iovec_len(data_len);
> > +	if (len - data_len != 0) {
> > +		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
> > +
> > +		memset(buf + data_len, 0, len - data_len);
> 
> Assuming this is the replacement for the kzalloc/kzrealloc calls above
> so that we don't write junk to disk,

Yes, exactly that.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
