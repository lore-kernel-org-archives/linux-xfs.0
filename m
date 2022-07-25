Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29873C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jul 2022 07:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiGYH7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 03:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiGYH7s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 03:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FAD13D3F
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 00:59:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87A816119A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 07:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4528C341CE;
        Mon, 25 Jul 2022 07:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658735986;
        bh=BMHyrdiWt4HfJKXhDfcUp1HGIR9kkqu9QeZ5qyVri1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MzMjj8dFlUyngPXFRIwku/AHkWJ2V46abwkd6Y+eNbhrkErnC/NEm7DXxvQSOIjcr
         lA2V3m9wTzCooVJOlLCkElS62dnpwY5eyhaTsJL98vFCieCmvRGnIHOexsMYvE/DXQ
         2897pXxKfSTV+oHpfS9RVxBVvHU8NTwct6EN9BJi8nLu3unN9/HgLyVPPmBgZZkfWk
         EOrZKt4Zp2jy1lM/pLlEzuFDDvGtUxeFqe7kLDk40cOB7lWPnlEBY97UTZPpswEJIC
         hyCOWFPauFcPFjj9l/WnuOoqjolBBRNKwfStddtLTPH0nliTmfFTk28JBAKTF7vkcV
         GytSDYg6IEyvA==
Date:   Mon, 25 Jul 2022 09:59:42 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v3 0/2] mkfs: stop allowing tiny filesystems
Message-ID: <20220725075942.erejjxcyjkyhopa3@orion>
References: <jClQwnsHFSREVSitFnWiO2spgHLt1kaTBHjtDn1V9WeXRB1qq0BOBhwGw25IoTL-aMmeeElWwy2pVsHv9ywuMA==@protonmail.internalid>
 <165826709801.3268874.7256134380224140720.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165826709801.3268874.7256134380224140720.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 02:44:58PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> The maintainers have been besieged by a /lot/ of complaints recently
> from people who format tiny filesystems and growfs them into huge ones,
> and others who format small filesystems.  We don't really want people to
> have filesystems with no backup superblocks, and there are myriad
> performance problems on modern-day filesystems when the log gets too
> small.
> 
> Empirical evidence shows that increasing the minimum log size to 64MB
> eliminates most of the stalling problems and other unwanted behaviors,
> so this series makes that change and then disables creation of small
> filesystems, which are defined as single-AGs fses, fses with a log size
> smaller than 64MB, and fses smaller than 300MB.
> 
> v2: rebase to 5.19
> v3: disable automatic detection of raid stripes when the device is less
>     than 1G to avoid formatting failures
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 

Both changes looks good to me, but IMHO we really require it to be documented in
manpages otherwise we'll get (even more) questions about "why can't I create
small FS'es anymore?".
But anyway, I can help with the manpages once these patches hit for-next if you
are ok with it.

-- 
Carlos Maiolino
