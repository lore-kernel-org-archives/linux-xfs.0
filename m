Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5425AC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20BBF208DB
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QfZ8Fi7j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgHVHdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgHVHdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:33:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA532C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2V3wgjCUWg+Vid44r49aMMZ5owNIE9rTDwHOJPA2tuk=; b=QfZ8Fi7jrtkAXV4T9HdxABrX0g
        MqFgObGdXVObHld7aI0JfOFG9gxftGVZLJtP+N0uJnC5gTHmsG/cFErheCARIRK7dfIDXfPKktqjo
        UfqIJz5RHwWXA0/3A2Zk2BZ8CEMVlky6qms14NVIp5zNVLhggeYkm2ohycwZw35CZwgosJlZKcDix
        nFigHo/HsmbZFnb7cwkNHJ0dDRyFALfpp333M/Ft7zlsE9HdXcUp5wZ7o6xjJBy8xzsNM4wFN+uWF
        hqsQvs7RHDC0zFdnUQ9lOURiQQuL2XRg3AbkYOQisSdiRSCHk7PVvS8Tfqq2FSC8o00DRfMc0MFYB
        pLMCLfww==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9O1f-00024a-EX; Sat, 22 Aug 2020 07:33:19 +0000
Date:   Sat, 22 Aug 2020 08:33:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200822073319.GH1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594159.965217.2504039364311840477.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797594159.965217.2504039364311840477.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>   * in the AGI header so that we can skip the finobt walk at mount time when
> @@ -855,12 +862,18 @@ struct xfs_agfl {
>   *
>   * Inode timestamps consist of signed 32-bit counters for seconds and
>   * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
> + *
> + * When bigtime is enabled, timestamps become an unsigned 64-bit nanoseconds
> + * counter.  Time zero is the start of the classic timestamp range.
>   */
>  union xfs_timestamp {
>  	struct {
>  		__be32		t_sec;		/* timestamp seconds */
>  		__be32		t_nsec;		/* timestamp nanoseconds */
>  	};
> +
> +	/* Nanoseconds since the bigtime epoch. */
> +	__be64			t_bigtime;
>  };

So do we really need the union here?  What about:

 (1) keep the typedef instead of removing it
 (2) switch the typedef to be just a __be64, and use trivial helpers
     to extract the two separate legacy sec/nsec field
 (3) PROFIT!!!

> +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
>  void
>  xfs_inode_from_disk_timestamp(
> +	struct xfs_dinode		*dip,
>  	struct timespec64		*tv,
>  	const union xfs_timestamp	*ts)

I think passing ts by value might lead to somewhat better code
generation on modern ABIs (and older ABIs just fall back to pass
by reference transparently).

>  {
> +	if (dip->di_version >= 3 &&
> +	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {

Do we want a helper for this condition?

> +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> +		uint64_t		s;
> +		uint32_t		n;
> +
> +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> +		tv->tv_nsec = n;
> +		return;
> +	}
> +
>  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
>  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);

Nit: for these kinds of symmetric conditions and if/else feels a little
more natural.

> +		xfs_log_dinode_to_disk_ts(from, &to->di_crtime, &from->di_crtime);

This adds a > 80 char line.

> +	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {
> +		uint64_t		t;
> +
> +		t = (uint64_t)(ts->tv_sec + XFS_INO_BIGTIME_EPOCH);
> +		t *= NSEC_PER_SEC;
> +		its->t_bigtime = t + ts->tv_nsec;

This calculation is dupliated in two places, might be worth
adding a little helper (which will need to get the sec/nsec values
passed separately due to the different structures).

> +		xfs_inode_to_log_dinode_ts(from, &to->di_crtime, &from->di_crtime);

Another line over 8 characters here.

> +	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
> +		sb->s_time_min = XFS_INO_BIGTIME_MIN;
> +		sb->s_time_max = XFS_INO_BIGTIME_MAX;
> +	} else {
> +		sb->s_time_min = XFS_INO_TIME_MIN;
> +		sb->s_time_max = XFS_INO_TIME_MAX;
> +	}

This is really a comment on the earlier patch, but maybe we should
name the old constants with "OLD" or "LEGACY" or "SMALL" in the name?

> @@ -1494,6 +1499,10 @@ xfs_fc_fill_super(
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
>  		sb->s_flags |= SB_I_VERSION;
>  
> +	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> +		xfs_warn(mp,
> + "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
> +

Is there any good reason to mark this experimental?
