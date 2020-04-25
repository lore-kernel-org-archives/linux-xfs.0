Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A9CC55191
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DF0E20704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V/88nMtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDYRid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:38:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518BDC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C8ysXq++6mfmT39gc/W38n39Vor3h4zlfHu4GSklQFA=; b=V/88nMtFyBVkRnHhuNBUBHB4sD
        wmuDxckVYyofT8pwd6XEnHtFr/MnseXr9zRjehoOzJST/yuJXLKw5TJs7VO9X98ZYD18n7C43nEsm
        tOhjkzoAAC1UK9pmCiXq/RBp01ChBhbWCimgEgi9dY40eFSE5LGOTfNYpPB0OHLc861zZgRjRxZm7
        Fmsc6B30byaOJpp91L7Pg0Q2J3fzMVHo7Dkc+KmqnzXCvUYh+NUU8sn8xb5h9TiWeQPuS1zrcAFFT
        HADfSPfwIhBZ6QcdRXMmz06twIhryI4LKHm1oYQ/ut+kkcXtmSq2nvutLZmJpJmn7QbEa+gGnJgNP
        V7unCYXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOl7-0004BE-75; Sat, 25 Apr 2020 17:38:33 +0000
Date:   Sat, 25 Apr 2020 10:38:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 12/13] xfs: random buffer write failure errortag
Message-ID: <20200425173833.GI30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-13-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:28PM -0400, Brian Foster wrote:
> @@ -1289,6 +1289,12 @@ xfs_buf_bio_end_io(
>  	struct bio		*bio)
>  {
>  	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
> +	struct xfs_mount	*mp = bp->b_mount;
> +
> +	if (!bio->bi_status &&
> +	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> +	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
> +		bio->bi_status = errno_to_blk_status(-EIO);

Please just use BLK_STS_IOERR directly here.
