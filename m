Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3808C7EE2F
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 14:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240259AbjFGObH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbjFGObG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 10:31:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388D41FCE
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 07:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b/UxW/mEVip1NCNPCXrG7UAmmzZo9Aa9Lg9A8pwBfno=; b=kVwgpW2p+UOWmSXrmB8DrBnHl1
        lJzQgw5G2kvP5dHHOxqfv/3Idzigbh7a0wxeELkM9wzm6eboYbN9X2PJh1MdlndONxMrjPEQZ+kFq
        ED2j/LdYhQ+GDcwbh/nBoSL56FF9d3/XwCejl6Du8CnEyofOrYhNW9FpgZaqBOwXD9UWGT65vsWIK
        /jg+IbSXrtygBlkXdMQt2AcSdI0576BP6t7JrRwaRDzsBY4PdCZV3PA0LL0M54YrHx9R0rJAm2ZDa
        lAKLwBqx3HIspBxcEYLu/VM8EU1XGkySyNk+PpZe6mQzXYFQnm1Vv4bdIR66IBBxZgotTgP5HbvX1
        AB6pq2oA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q6uBb-006GCK-0G;
        Wed, 07 Jun 2023 14:30:55 +0000
Date:   Wed, 7 Jun 2023 07:30:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <ZICUn0Na/mqWEKkw@infradead.org>
References: <20230606151122.853315-1-cem@kernel.org>
 <i5VjxsfPIrRyvOoqV6BqW6qno66Gxsc-zGbsc1RZ60MawgxcwuoRtOODkv1SKvanvnXaNriVpBuIGtR99YA_Vw==@protonmail.internalid>
 <ZIAmCHghf8Acr26I@infradead.org>
 <20230607073757.zwfhie3qbn7mox5i@andromeda>
 <k8Kj2sTeNZWAzveaTqq0fnhlyrNj59s_SwIZn82YJTtQHnnXOS7GM08VCbW5V8M4uXSjuMxVJ3umucWeAYqxLQ==@protonmail.internalid>
 <ZIA2NLCSw7nVMh6w@infradead.org>
 <20230607084804.vh3dz6qvgbkotjav@andromeda>
 <20230607142812.GR1325469@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607142812.GR1325469@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 07:28:12AM -0700, Darrick J. Wong wrote:
> *Someone* please just review the fixes for fscounters.c that I put on
> the list two weeks ago.  The first two patches of the patchset are
> sufficient to fix this problem.
> 
> https://lore.kernel.org/linux-xfs/168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs/

That sounds like a way better idea indeed.  I'll get to it after my
meetings.
