Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AB3C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 15:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiEXPUK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 11:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiEXPUK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 11:20:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772845003B;
        Tue, 24 May 2022 08:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13016616EF;
        Tue, 24 May 2022 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E6EC34113;
        Tue, 24 May 2022 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653405608;
        bh=IW3RND1D6FLNAz8IY81qq+Ng2PVrV4Y+5Y+V1m1ThxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ux22iTMayVuaz9NVAe02w7VtIXotOlPsjqbvrADuy8iUaURlY69yKXwTUc+fp+Oth
         WFIqvhQMCa1ithe+Nev2NIxnutxuP7ECqooUgFHrnS7zCWDx6ME59VkKbSGAJsskbI
         lcKoBOb+rtqF8UATejhz6YG1gzLi5tJ00511fgdLUIIVWxWRzu5aVSSDUoMLSRoLUa
         m5UakIt7GhReQ2v+G6WPt2ygiTqST5l79kLt973xfbmenlMpcizB99UlrGcsfdO3Lg
         vOq3JbiMM1hS2GjtXayUMFx+qjQz4qrX9Dv5vq6RPSjWvN5IXNbCkdK6TZ6DRZr623
         nKC8A5jYQqu+A==
Date:   Tue, 24 May 2022 09:20:04 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <Yoz3pG97VmdT4bmE@kbusch-mbp.dhcp.thefacebook.com>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
 <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
 <YowpjtLfZPld1H6T@T590>
 <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
 <YoxgU5/P460FZ3rl@kbusch-mbp.dhcp.thefacebook.com>
 <Yox7Kp2N1NzSes0C@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yox7Kp2N1NzSes0C@T590>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 02:28:58PM +0800, Ming Lei wrote:
> On Mon, May 23, 2022 at 10:34:27PM -0600, Keith Busch wrote:
> > On Mon, May 23, 2022 at 09:02:39PM -0600, Keith Busch wrote:
> > > Here's a bandaid, though I assume it'll break something...
> > 
> > On second thought, maybe this is okay! The encoded hctx doesn't change after
> > this call, which is the only thing polling cares about. The tag portion doesn't
> > matter.
> 
> I guess it still may change in case that nvme mpath bio is requeued.

A path failover requeue strips the REQ_POLL flag out of the bio, so it would be
interrupt driven at that point.
