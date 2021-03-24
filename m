Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26FBC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C4961A25
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbhCXSMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbhCXSMd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 14:12:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7308C061763;
        Wed, 24 Mar 2021 11:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qz136NLar8MaLNakgb8B8hXZ8Dw3KPCZdV6e5jyV8nY=; b=GK4ee1CF6ZLqq28ESWA/QZIU6n
        mXOdS5ji/jgLvtSudySbmNdO2HNO7Q94yVYtkospFzSf7QCz8e3qdKD2mV1tlBKoy+WCrEnOcH3HP
        zNPuVsOrqT0MwXd4ADPrgbmqQclCc66gq3/2ISkhMnpN56Jt2dTRXlWLJEsN4XiFumm6W5VkDsu+l
        PS3+FHuj+oHXVvrUWv8t3cfnDaGYDVZ25ZWyTvkZLERhhs47YxA6CJHxoV04okj9VfufU4sbt4iPD
        WkeJvEUoDxqWib5KxbjuwX3xNt0tey/YzogrJfIt96bEZ2YoGjCty8odOn+GUBg+19/mvw45RC1OR
        3G7i5BLQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lP7z3-00Bg5H-H7; Wed, 24 Mar 2021 18:12:02 +0000
Date:   Wed, 24 Mar 2021 18:11:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] common/populate: change how we describe cached
 populated images
Message-ID: <20210324181157.GC2779737@infradead.org>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
 <161647319905.3429609.14862078528489327236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647319905.3429609.14862078528489327236.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:19:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The device name of a secondary storage device isn't all that important,
> but the size is.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index c01b7e0e..94bf5ce9 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -808,13 +808,23 @@ _fill_fs()
>  _scratch_populate_cache_tag() {
>  	local extra_descr=""
>  	local size="$(blockdev --getsz "${SCRATCH_DEV}")"
> +	local logdev="none"
> +	local rtdev="none"
> +
> +	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_LOGDEV}" ]; then
> +		logdev="$(blockdev --getsz "${SCRATCH_LOGDEV}")"
> +	fi
> +
> +	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
> +		rtdev="$(blockdev --getsz "${SCRATCH_RTDEV}")"

Shouldn't these variables be called LOGDEV_SIZE and RTDEV_SIZE?
