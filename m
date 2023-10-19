Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED83CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjJSQOA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346343AbjJSQN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:13:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824C291
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:13:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC21C433C8;
        Thu, 19 Oct 2023 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732034;
        bh=40iBxGXJc6v5RZZw9V4i61J2csD433VDkcWKuRCIAec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDX/mSeRyhI7qrtKhoQtmu25V3iHhSaqvTMmIgdtl/cEz5gAiojH3LKl2u0eeRRbq
         Q0Bt0w/3wh74tt2OQudQpowlj4sIeLP945yJUMIkw84uagrmHiN3w5SfYxEI75Wjsi
         ePEdvdE3dDtpxxnmx2FUjxE3C94DljBDZcGnk6m4De7M9+apNowtuC214QFn1+jrTe
         U2/rBopzFdy5kDDummn+rmIVdoknxQZRtAk3DbWbX4fhr/txdLYLAt2yP1N8pOyVxw
         6kZebqFwkMX8J7AmeYPZsd+F7XN+lrOAcmRHaqUmPy6tYl6N4k3AkRMoZ+u3fF+z1c
         cUmllRWX6RWUA==
Date:   Thu, 19 Oct 2023 09:13:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 4/9] xfs: simplify rt bitmap/summary block accessor
 functions
Message-ID: <20231019161353.GM3195650@frogsfrogsfrogs>
References: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs>
 <169767367256.4127997.17671935176137544426.stgit@frogsfrogsfrogs>
 <20231019051316.GC14079@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019051316.GC14079@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 07:13:16AM +0200, Christoph Hellwig wrote:
> If you for some reason need to respin the series again it would be nice
> to just add the strut xfs_rtalloc_args definition at the top of the header
> from the beginning.

Will do!

Thank you for reviewing all my cleanups and Omar's rtalloc fixes.  I
very much enjoyed the quick feedback, which made iterating the patchset
so much easier.

Looking forward to the next time we get to do this,

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
