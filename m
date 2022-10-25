Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CC3ECDFA1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 22:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJYWFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 18:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJYWFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 18:05:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FA6481D0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AAFDB81F1E
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 22:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1FFC433D6;
        Tue, 25 Oct 2022 22:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666735521;
        bh=G9VHg05Oj02c2GlqKqBqFpGw10GH7k96EzNdA7CYh2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxfQY7suxXz+sVExM6dEmnc1Xdk99Qan6lzQJ9HV42MpBkCwMbM96Infh+B30jy8J
         ipGhWKhLOUc87Y9BJ9HGp6Xw8ZXnFqKSAaFs62ryCFotSV6mRm/fHHWEQPQ35Eo1GR
         HD9g48y/VoRpSglFLlvtKzPV4vpHtOzJGlYoSacFYN9jOzwNbyfKOc2A2IPwIyW6ZI
         YnoDbIN/Rj2IPFrvhCUfeNPkMA692LJWJ46JEqEES0geq5J0xSZGsRw9UctzdvE4zA
         vNoWh6iILwWmKb7o7BOHACIkMu1p6AbaeilhLZP+LOpWN2STjOFsUOAWlWyRnPblQB
         Zh/SsPhj9ZYVQ==
Date:   Tue, 25 Oct 2022 15:05:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix validation in attr log item recovery
Message-ID: <Y1hdoXzYppP6bG58@magnolia>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664715731.2688790.9836328662603103847.stgit@magnolia>
 <20221025211927.GB3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025211927.GB3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 08:19:27AM +1100, Dave Chinner wrote:
> On Mon, Oct 24, 2022 at 02:32:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Before we start fixing all the complaints about memcpy'ing log items
> > around, let's fix some inadequate validation in the xattr log item
> > recovery code and get rid of the (now trivial) copy_format function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_attr_item.c |   54 ++++++++++++++++++++----------------------------
> >  1 file changed, 23 insertions(+), 31 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index cf5ce607dc05..ee8f678a10a1 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -245,28 +245,6 @@ xfs_attri_init(
> >  	return attrip;
> >  }
> >  
> > -/*
> > - * Copy an attr format buffer from the given buf, and into the destination attr
> > - * format structure.
> > - */
> > -STATIC int
> > -xfs_attri_copy_format(
> > -	struct xfs_log_iovec		*buf,
> > -	struct xfs_attri_log_format	*dst_attr_fmt)
> > -{
> > -	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
> > -	size_t				len;
> > -
> > -	len = sizeof(struct xfs_attri_log_format);
> > -	if (buf->i_len != len) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> > -		return -EFSCORRUPTED;
> > -	}
> > -
> > -	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
> > -	return 0;
> > -}
> > -
> >  static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
> >  {
> >  	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
> > @@ -731,24 +709,44 @@ xlog_recover_attri_commit_pass2(
> >  	struct xfs_attri_log_nameval	*nv;
> >  	const void			*attr_value = NULL;
> >  	const void			*attr_name;
> > -	int                             error;
> > +	size_t				len;
> >  
> >  	attri_formatp = item->ri_buf[0].i_addr;
> >  	attr_name = item->ri_buf[1].i_addr;
> >  
> >  	/* Validate xfs_attri_log_format before the large memory allocation */
> > +	len = sizeof(struct xfs_attri_log_format);
> > +	if (item->ri_buf[0].i_len != len) {
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> > +		return -EFSCORRUPTED;
> > +	}
> 
> I can't help but think these should use XFS_CORRPUPTION_ERROR() so
> that we get a dump of the corrupt log format structure along with
> error message.

That is a good idea.  I will tack a new patch on the end to make that
conversion.

--D

> Regardless, the change looks good - validating the name/value region
> sizes before we allocate and copy them is a good idea. :)
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
