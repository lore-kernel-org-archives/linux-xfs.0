Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01427C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbjEZIN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjEZINZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:13:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F90C125;
        Fri, 26 May 2023 01:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DgTgBMZWINXOuoCZBI2L8FK+k2n3IGa7ukNMwg/DhYc=; b=L1M/wOjEJS+hbGb0Ek6blzw3yA
        nabgFkkkKy+DTSss8/1GulWyfdXqHHVYNAzFWT5mbVwZAjUGHZXHuEQfl0e+6/OtF12MpNy4YLP80
        VEIFzvlb4aVe0P7pRCuYc3yIdqxzO6y1Zsavs8rcRkdM9/4mz4siRmfuqn+sIDoKXdA46+bkVCwm5
        aiixFMuyKgI/5ocaWt6B9ZqX+HUkoXOZlXs8Z6gefmi2wlMxbafMZW818soeWjD1oBROq9uXous9u
        y1HEaBkTCpK3nsAM9uz9T5N1fw3+CMx5JirbVy1uboijoXvhGmyTqNkB3f7GvUjESGORDZCBAgPdX
        NkZvUbmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q2SZW-001Z7f-3C;
        Fri, 26 May 2023 08:13:14 +0000
Date:   Fri, 26 May 2023 01:13:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, hch@infradead.org,
        djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org,
        patches@lists.linux.dev, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, hare@suse.de, p.raghav@samsung.com,
        da.gomez@samsung.com, rohan.puri@samsung.com,
        rpuri.linux@gmail.com, kbusch@kernel.org
Subject: Re: [PATCH v2 1/5] block: annotate bdev_disk_changed() deprecation
 with a symbol namespace
Message-ID: <ZHBqGosY0tWkNdIR@infradead.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526073336.344543-2-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 26, 2023 at 12:33:32AM -0700, Luis Chamberlain wrote:
> This ensures no other users pop up by mistake easily and provides
> us a with an easy vehicle to do the same with other routines should
> we need it later.

I don't see how this is related to the rest of the seris.  I also don't
think it's a good idea.  The APIs isn't deprecated per se.  It just
should not be called by drivers.  The right thing would be an interface
like

EXPORT_SYMBOL_GPL_FOR(bdev_disk_changed, loop.ko, CONFIG_BLK_DEV_LOOP);
EXPORT_SYMBOL_GPL_FOR(bdev_disk_changed, dasd_mod.ko, CONFIG_DASD);

with the modulo code enforcing that no one but the module this is
explicitly exorted for can use the symbol.
