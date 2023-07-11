Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7EDEB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 00:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjGKAUT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 20:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGKAUR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 20:20:17 -0400
X-Greylist: delayed 382 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Jul 2023 17:20:16 PDT
Received: from out-63.mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20DCFB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 17:20:16 -0700 (PDT)
Date:   Mon, 10 Jul 2023 20:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689034430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnNFGZHfV5N5ZNTEHBuqL1ViZwIfvECr+nHwgjFpWZ4=;
        b=ljOCg06rtqxxmv9ANo8RSvG3XkmzKHDB1c11HOlO0KxzxItkQHFOie2+h5Q+zOfgq2EyqD
        gCTIfnrV1sxsx9Z/1ytY1TGismJEmWuHjZmyTZEYSq+OJvTq+TO861+L8ys0o/LCkgtZnw
        dXZQnYdMwWFcuokDCXG38Il9iulKbJE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 7/9] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <20230711001346.nupvyrb3hbrpmjww@moria.home.lan>
References: <20230710130253.3484695-1-willy@infradead.org>
 <20230710130253.3484695-8-willy@infradead.org>
 <ZKybP22DRs1w4G3a@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKybP22DRs1w4G3a@bombadil.infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 04:58:55PM -0700, Luis Chamberlain wrote:
> Curious how this ended up being the heuristic used to shoot for the
> MAX_PAGECACHE_ORDER sky first, and then go down 1/2 each time. I don't
> see it explained on the commit log but I'm sure there's has to be
> some reasonable rationale. From the cover letter, I could guess that
> it means the gains of always using the largest folio possible means
> an implied latency savings through other means, so the small latencies
> spent looking seem to no where compare to the saving in using. But
> I rather understand a bit more for the rationale.
> 
> Are there situations where perhaps limitting this initial max preferred
> high order folio might be smaller than MAX_PAGECACHE_ORDER? How if not,
> how do we know?

It's the exact same situation as when filesystems all switched from
blocks to extents 10-20 years ago. We _always_ want our allocations to
be as big as possible - it reduces metadata overhead, preserves
locality, reduces fragmentation - IOW, this is clearly the right thing
to do.
