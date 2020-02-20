Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9345C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84F00206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rn93hmgz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgBTPko (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:40:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54252 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgBTPko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gcxt3+q3ssS0s8xuV8PzdJFrlcRsKvwiDR6hEXKilqA=; b=rn93hmgzbGyPuFhHjzreeynYqx
        0LMx6AfMgoJZ4dcTZM53VYWFht2zf94tEETYl1TcOqP8Deg1MmMQDW0PcBVNlRDptf9K5QFwA6yLo
        YXD4nVoUvNJRc7LjzrNwYaWBv6VA/JenrFnTZ6Eg5Xo08ndmy4+ZjoENPwtTOuO2Hn513teMr0ovr
        G+JbgjwOSE2qGhoB6QKdqzeoQ312Q5Us8tHXvwgQWLkNPHcYyiSCK1T3t6fJiGnaDD611YDJDfFjP
        mbNfmZPNDf8NnrA52Ilo4pqPAALunU9Q5i3zVgsB55BXcwK2I2GtPVh0izmK9GfCBTrXTX40vkHtY
        fW6EW1gg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4nwI-00036h-Mr; Thu, 20 Feb 2020 15:40:34 +0000
Date:   Thu, 20 Feb 2020 07:40:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, dchinner@redhat.com,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        renxudong1@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH v2] xfs: add agf freeblocks verify in xfs_agf_verify
Message-ID: <20200220154034.GA6870@infradead.org>
References: <1582197182-142137-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582197182-142137-1-git-send-email-zhengbin13@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:13:02PM +0800, Zheng Bin wrote:
> +	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks ||
> +	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length) ||
> +	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length) ||
> +	    be32_to_cpu(agf->agf_refcount_blocks) > be32_to_cpu(agf->agf_length) ||

This adds a > 80 char line, please properly format it.

> +	    be32_to_cpu(agf->agf_spare2) != 0)
> +		return __this_address;

There is no need to byte swap fields if you just check if they are
non-zero.

> +
> +	for (i = 0; i < ARRAY_SIZE(agf->agf_spare64); i++)
> +		if (be64_to_cpu(agf->agf_spare64[i]) != 0)
> +			return __this_address;

Same here.
