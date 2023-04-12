Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4B2C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 12:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDLMNn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDLMNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:13:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E8B35B5
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Il5CkqhHdfwtQPAD50OQs7PJhLehbo96tng/XtfizpE=; b=tappdGBLitGnPy8l214zWkR/b5
        8bxJj126jbcO4peme+FBVfQy35RuvzVvfHc+IxA9MYZ5vzS/INDWQYJjxA3j/JdqUFizUazyNlbQT
        u+R2o4zCXnBRbT/bLRcnXDiyQixQXlOg+DZ+f2t1nzGX+DOCq51e0jK41qaajBSkL/eAKWIN4fx54
        0x3Ef8SLTlXaLskDmhtqLR2tGsLyRN+HbDtJP2YRFNaPMkMPp3rEj5xw+1sZ7BR/FiQnqwlxDf81Y
        EgWaPUyWs/Mqala2TutmbWZQqUo0M/CWRqSgfhOj/NPre7YuLiALQXWNomawfi6LSqr5EMU7UkaZK
        /Q2B1u3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZM5-00336L-1p;
        Wed, 12 Apr 2023 12:13:41 +0000
Date:   Wed, 12 Apr 2023 05:13:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't consider future format versions valid
Message-ID: <ZDagdV4uGpRyogxj@infradead.org>
References: <20230411232342.233433-1-david@fromorbit.com>
 <20230411232342.233433-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411232342.233433-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -86,16 +87,16 @@ xfs_sb_good_version(
>  	if (xfs_sb_is_v5(sbp))
>  		return xfs_sb_validate_v5_features(sbp);
>  
> +	/* versions prior to v4 are not supported */
> +	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_4)
> +		return false;

The comment is a bit confusing now.  But maybe the v4 checks should
move into a xfs_sb_validate_v4_features helper anyway, which
would lead to a quite nice flow here:

	if (xfs_sb_is_v5(sbp))
	 	return xfs_sb_validate_v5_features(sbp);
	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
	 	return xfs_sb_validate_v4_features(sbp);
	return false;
