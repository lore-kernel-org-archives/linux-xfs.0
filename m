Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9B2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 14:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbiECO5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 10:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiECO5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 10:57:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864B321E39
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 07:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ps4V8Amp/10tPjsfOfOrFmauhBeOYWfQbc0TM9NVQZg=; b=asOo/1OLPys+YRP538+AoE9gzZ
        UOruXtLF4yXfg9Dmu1x/WZ7e/+R96SCbB1hNDQDP7Eb7fSLkexu+C8DiO0DIsoHUAdbujYloeMncl
        IsF+C0mFPhCP4gr/GgjottVxfN5i3w77/h8CEGgGGBEqCQsUpp8aUXFHOxrn8RQp29sqjIWWgF8az
        G7NACAK0QrzVk28wIiQK4edULf6lf3rddouCBzkdv8GK3lyFWRG9vwc4ZbBw+8yx5A0d9kOVq5bRB
        EPWUg6idfjZ17WDMY7kmebXImUL69qhLJH5FrfNPI8cQOmJ3wMINCjk3l4YaEuYXO5lzMQqQ27ZZf
        eN/MLzjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nltuL-006M1Y-16; Tue, 03 May 2022 14:53:45 +0000
Date:   Tue, 3 May 2022 07:53:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: detect self referencing btree sibling pointers
Message-ID: <YnFB+Ff+gRh0vQbb@infradead.org>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

One nit (with a few instances):

> +	if (level >= 0) {
> +		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
> +			return __this_address;
> +	} else if (!xfs_verify_fsbno(mp, sibling)) {
> +		return __this_address;
> +	}

Maybe it's just me, but I would find the non-condensed version a little
easier to read for these kinds of checks:

	if (level >= 0) {
		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
			return __this_address;
	} else {
		if (!xfs_verify_fsbno(mp, sibling))
			return __this_address;
	}
