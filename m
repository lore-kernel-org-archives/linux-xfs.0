Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DB3C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 07:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjFEHQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjFEHQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 03:16:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E486E9;
        Mon,  5 Jun 2023 00:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iTJR9D5E2cnws34QU+a3OUx5W0ge8s4NxROKcEdnvWk=; b=F02Y+fPhJlp8SBsoIiHOXXIYEb
        A+fdr0Jp+3G0virT4QaMeT+rrTulzXmuhONsLySVcxivP1Mdp1WAJIMcsXQIOnMTzV7I3yhMEH2hq
        3XPV3zkC4fgASpMILzixBq0i5zFTcz8TYgH8GVBb2eCEhfPW4+mtmHVwZcSRcq/sOGWL2gYN4SaKG
        TOfgLYJTep9oXLLxronXn8qvcKRupAzBOYcFTeMoOJXV9YNaO/ePit8eqLNkrquhRJzTHqCPJj+Cl
        7mLdNpr2BCD/rVDsZ71lV3h/be5Rbm5yU8lD5NDq8ZyNZfIwG0w2TGsE94kxQnliEsgD/8LXMUYtS
        uIl1e6YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q64S1-00EWVo-1R;
        Mon, 05 Jun 2023 07:16:25 +0000
Date:   Mon, 5 Jun 2023 00:16:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2 5/7] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <ZH2LyR4iJj/QfIlr@infradead.org>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602222445.2284892-6-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Still not a huge fan of the dense encoding in the flags, but technically
this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
