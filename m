Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1688BCDB474
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 22:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443015AbjJLWV5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 18:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442949AbjJLWV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 18:21:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E0B8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 15:21:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45B1C433C9;
        Thu, 12 Oct 2023 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697149314;
        bh=zZfuzTRKUWnT2RyNNPD1ccPtHiXn6cpVkofj+vDDha0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J07Nr+vr6254F39yN3XwzV0MZ29Rq/NE+A6nzbxAwH9qDKYsWmy6kjCibKN8uRymg
         ZfP7I9DlmcDbTFCRoTGY/WiHlRgEDfEmD4iITpAd3csEHzYBPsaTz6M67j4nMAqfyA
         zTyLUOeq+TprSe+yytdsTp44XEX5FfzcliaszMK55aIUeQu5uD2vbr7nOElEN+JnAR
         A+d7c7Y9+FV1hDiIyyU1Mo1AZ54U0KCT/SHIsXWTQtfRg4uoW97vrqBs+pQDcT5wGz
         aVNo1zMxcSuGpVhI6T9S8Z/U1x7CGLt2SVZyp4yT7I3tNspFT4Aclv56zWHoJMNeHo
         E1DmH4jHID29w==
Date:   Thu, 12 Oct 2023 15:21:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 8/8] xfs: use accessor functions for summary info words
Message-ID: <20231012222154.GQ21298@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721750.1773834.4264847386675407220.stgit@frogsfrogsfrogs>
 <20231012062619.GC3667@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012062619.GC3667@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:26:19AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:08:19AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create get and set functions for rtsummary words so that we can redefine
> > the ondisk format with a specific endianness.  Note that this requires
> > the definition of a distinct type for ondisk summary info words so that
> > the compiler can perform proper typechecking.
> 
> Same comment as for the bitmap access, including the same offer.

<nod> I'll take you up on that, if you think the tradeoffs is worth it.
:)

--D
