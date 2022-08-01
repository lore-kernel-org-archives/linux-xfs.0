Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647AAC00144
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 17:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiHARnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiHARnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 13:43:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511FE1AF01;
        Mon,  1 Aug 2022 10:43:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E274461086;
        Mon,  1 Aug 2022 17:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270FC433C1;
        Mon,  1 Aug 2022 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659375790;
        bh=v6aSxWl0Cm6Ct3Ek7FJTvKUZgh2DkyjHOZEfxCUoP5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BgvBDKS6vMNUCRyajb1xxjx7TH4ybmCKRy2MlvY1kYFyvYODCVBAmUwxiBsMossM7
         Sewp9IIf9X1voqxz498vSoUchYNtmpXYPp9nNd2WPPeAkpl5fWQ8iocsCRdodynD4s
         nOgOe7lyvDu9UXE8oSu/qQ3wJW9zilZiNABOTCuJXx3pEqGmHJK06BZDVYsiBbvat7
         h+czJrcgp0zhZaIz7QugfSGBenBx27pknorkLUeKdVSiJreyXt/wi+igaRA1BqDdlh
         49n6WUyzp09N119GdRTQ6CwNE526UWJAafnSPr4KM9rhlORjTaUhdLmhAe+/ucaKi7
         eKIGun6I2GA2g==
Date:   Mon, 1 Aug 2022 10:43:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/432: fix this test when external devices are in
 use
Message-ID: <YugQrTnxXHfxpWzE@magnolia>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
 <165903223512.2338516.9583051314883581667.stgit@magnolia>
 <YuLunHKTHbw1wcvZ@infradead.org>
 <20220731052912.u3mcvvhl2dintaqq@zlang-mailbox>
 <Yua0vwCQFsayKH1x@magnolia>
 <YugJ41IWh4m5Tbgp@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YugJ41IWh4m5Tbgp@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 01, 2022 at 10:14:11AM -0700, Christoph Hellwig wrote:
> On Sun, Jul 31, 2022 at 09:58:39AM -0700, Darrick J. Wong wrote:
> > *OR* we could just override the variable definition for the one line
> > since (for once) bash makes this easy and the syntax communicates very
> > loudly "HI USE THIS ALT SCRATCH_DEV PLZ".  And test authors already do
> > this.
> 
> Ok, let's stick to that and I'll take my suggestion back.

Ok, thank you! :)

--D
