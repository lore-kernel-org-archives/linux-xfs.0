Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD89C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiF2H1P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiF2H1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:27:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B37835876
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NxAsogeejhqs0jmP/1137/pjrW
        9peCtHKr6na9TwV4HrQPReBkx44Z0B9doRWuiT9XFMXl/uahLwE5VzBsNOksZj8pHOY+jAyZOIaIE
        +DBtzEaWh8/5iWEMcBuRccgDJlHE0BdKJXdXcoPu+sMu8P5KwHBwQXWInOqtjbMbW87LMxUAZsPjJ
        yk4LKWDxyWqQAfl66jFs69gKxCon+G7cpy+tRk1Vhulire/j8k7NCs606qtUEwftzwtL2xxuHNhjI
        SEComLp1lSdTUBRGrt2dh7kVd7bGORfkqI2EMSGhwmrRQi1n/sHHvGwV2W77Sw3kGsxnePIe9o4fM
        887ljVcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6S6Q-00A5pz-Qn; Wed, 29 Jun 2022 07:27:10 +0000
Date:   Wed, 29 Jun 2022 00:27:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     hexiaole <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1] xfs: correct nlink printf specifier from hd to PRIu32
Message-ID: <Yrv+zu5l+eIrqwTp@infradead.org>
References: <20220628144542.33704-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628144542.33704-1-hexiaole1994@126.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
