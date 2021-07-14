Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5342C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B476D6100C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhGNHBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbhGNHBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 03:01:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9926EC061574
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uSaElolBUp06yjiZG+x89c/LB2TP4WWRfx0ZwTcu32A=; b=OOrHBEIESb7Gk4Tz0hCt1ODxnc
        eHWbWP3Rc7H6c55HfW3BLUaaBOLpEszp9frN+dCviJlOB7AMddYpsLxNedMmWD7FhAzOru4KmMYC7
        tLv9hDvzjN7tquYz+9dsVlQTo4WQkxRFSVui4I9ytG8CRkDX4tduG3zVhTxx2UpGETaQS5O+D42wd
        3MXV+Jngj9wVlysK4mqmJ0UCKmrzd9K+kOKpPIFatcZEI7P27nuRsY4UnCv5OIpQlIlz7uHpNHXVB
        Om/Sy9joq67vnrWizctSg8hemGBrnfejoicn/IY2Bl3k/4kmrsiWgPivgVONOttfuj+RiSlKbmqZz
        73EJeLIw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YqX-001wRX-DW; Wed, 14 Jul 2021 06:58:25 +0000
Date:   Wed, 14 Jul 2021 07:58:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <YO6LCbZWRz3q4JRg@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * Now that we've recovered any pending superblock feature bit
> +	 * additions, we can finish setting up the attr2 behaviour for the
> +	 * mount. If no attr2 mount options were specified, the we use the
> +	 * behaviour specified by the superblock feature bit.
> +	 */
> +	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&

Missing spaces around the |.

> +	if ((mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) ==
> +			  (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) {
> +		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> +		return -EINVAL;
> +	}

Same here.

> +
> +
>  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&

Double empty line.


More importantly I wonder if we can simplify this further:

 - completely ignore the attr2 option (we already warn about it being
   deprecated) and remove XFS_MOUNT_ATTR2
 - just check for XFS_MOUNT_NOATTR2 do disable automatically switching
   to v2 attrs

And maybe as a service to the user warn when the noattr2 option is
specified on a file system that already has v2 attrs.
