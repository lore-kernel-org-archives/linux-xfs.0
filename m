Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A475C77B7F
	for <linux-xfs@archiver.kernel.org>; Tue, 16 May 2023 16:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjEPQac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 12:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjEPQaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 12:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4618689;
        Tue, 16 May 2023 09:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B4D961A4E;
        Tue, 16 May 2023 16:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF8AC433EF;
        Tue, 16 May 2023 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684254602;
        bh=UYNL3wcrKY5KPE1Xdxr8uZb47SyVGSjDsdj+pPjtPdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2R7n6qqJjRH1B+87xpWAMusjg0ZpmgRFSJKgNdHm73nGPejTuVuP0MYyb52g2CMk
         BCjrTuJsjkAYudV6oVwhDGajqgsPXW9XBa7W19q+6qa3ovCHX5BK5S+VtCcujr7q1v
         TuHuFVBnKV76nzEueJRt8st+cUKV8ro2I1UkZSFpIZ7wJ6/beRD3ZNFT3hWS0BuzIv
         PP5TvKaImaxH+kbdTQqopgGfNwsRDM1BFMJmWUP8pJXccBZZ9LjdsDst23wcE669mu
         zAQ+3Y9pE68HrdUCjPWY5CE2ysRot9L7ZDbRPiYEojF+zFDp3Bt9O7cBYfCcFtDory
         qTHuvPUcBIFEA==
Date:   Tue, 16 May 2023 18:29:57 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] block: avoid repeated work in blk_mark_disk_dead
Message-ID: <20230516-unfair-unbeirrbar-8dcf64fd5959@brauner>
References: <20230505175132.2236632-1-hch@lst.de>
 <20230505175132.2236632-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230505175132.2236632-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 05, 2023 at 01:51:25PM -0400, Christoph Hellwig wrote:
> Check if GD_DEAD is already set in blk_mark_disk_dead, and don't
> duplicate the work already done.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Acked-by: Christian Brauner <brauner@kernel.org>
