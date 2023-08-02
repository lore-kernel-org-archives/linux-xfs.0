Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9904AC00528
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 07:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjHBH1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 03:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjHBH1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 03:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE2C19A0;
        Wed,  2 Aug 2023 00:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D85861839;
        Wed,  2 Aug 2023 07:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED4DC433C7;
        Wed,  2 Aug 2023 07:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690961251;
        bh=WnX9+MWsNIclhTn4dVIbgl3+beSPxZ0kKR++0Zojcag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HBW9ZyJtu1x5mbClMS23cXv0njVgI/aMR5RZkLzGcn8zb5nU3dJL5cwVbnQ845ZTg
         1KniwmhR/yc6QR2XxUOEFGY0awtNA7t26rFkXMGiiP7/bhuYgSYGkMaYOpxu9QMVh3
         ibWbkhMra1IVg6LOu44CPtVyQqH8/Ko5Ju88FNngXZUoJdAwWat/SRmbWHCofq3frZ
         jdHNilB6EJudLDBdiE0leP4l/KJVwFPJRtuPb9ARljzauzvxFKvoTDzCAEA/JblyFG
         N1EK1BSId49f3OrEg8tYWbySs4Xx2u70TMpaL5cjrb321129LvCjQUsnTAF6pCem5c
         J+2crCiChSiAQ==
Date:   Wed, 2 Aug 2023 09:27:25 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian@brauner.io>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <p.raghav@samsung.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] block: use iomap for writes to block devices
Message-ID: <20230802-kramen-modular-294d89af3574@brauner>
References: <20230801172201.1923299-1-hch@lst.de>
 <20230801172201.1923299-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230801172201.1923299-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 07:22:00PM +0200, Christoph Hellwig wrote:
> Use iomap in buffer_head compat mode to write to block devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>
