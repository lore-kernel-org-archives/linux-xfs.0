Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EDBC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CA120825
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J9aOrUEH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgHVHd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgHVHd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:33:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E18C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=439O+/fjeg7TIgFsMrc8VC7GVXcwqPcRZExXZ0nFgOI=; b=J9aOrUEHSpB5XpMf6xxc6hCpaB
        dM8rzYZ3TGcPmm2oWffCL2Vrb1yfnVjRHF64sFByujGh5PLI2z4915SYSnpyhY+85WinAVVdclLVo
        WkqgNI8kSijOEQM9ACytZjh6cnPxN1S03Sk+yt6OkbCOkBOcjeyhpo6vhQAGTaKYML3tB/wMDuMTW
        QZV7/+0mGcFPQqk1XSWyRaZ2vBkMvcS9OXluuNdgJK5wzDWkCmZE64VWx13s7n+aMS2WHuQxDFPrR
        PfZ5ukmxXTTMD8+2L07cBsR7qP0+Mlh+07IqvNf45evr9I5YGJ8I6x3nxEWR2ikDUz1Rx/t3WWVVj
        Via5Hxmg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9O2G-00026B-BT; Sat, 22 Aug 2020 07:33:56 +0000
Date:   Sat, 22 Aug 2020 08:33:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 09/11] xfs: refactor quota timestamp coding
Message-ID: <20200822073356.GI1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594823.965217.2346364691307432620.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797594823.965217.2346364691307432620.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* Convert an on-disk timer value into an incore timer value. */
> +void
> +xfs_dquot_from_disk_timestamp(
> +	struct xfs_disk_dquot	*ddq,
> +	time64_t		*timer,
> +	__be32			dtimer)
> +{
> +	*timer = be32_to_cpu(dtimer);
> +}
> +
> +/* Convert an incore timer value into an on-disk timer value. */
> +void
> +xfs_dquot_to_disk_timestamp(
> +	struct xfs_dquot	*dqp,
> +	__be32			*dtimer,
> +	time64_t		timer)
> +{
> +	*dtimer = cpu_to_be32(timer);

Why not return the values?
