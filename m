Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D3BC00140
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Aug 2022 17:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiHHRgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 13:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiHHRgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Aug 2022 13:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7103213E8A
        for <linux-xfs@vger.kernel.org>; Mon,  8 Aug 2022 10:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA322B80EBB
        for <linux-xfs@vger.kernel.org>; Mon,  8 Aug 2022 17:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB7EC433D6;
        Mon,  8 Aug 2022 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659980197;
        bh=MWPjn4dmpLmFiGb+0GzQmgPnM7CnVjogQmqnxnlUC8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dpthOK66/+MI1lj2Yn5/Kl2FmxaUim6koVEOw3kCVF3I2Uacvf1UKBmWO53PMSqi8
         xj1gB6ESH/at8GSFK5TyHfvPwlEKMVs0FN7Z+biYMJYwQP+VzymcWZV2R6/dcs2jEI
         Hm73QEP47SuEjGdmjGQ6YUPnjMKjLYdBq4IopkzrCqEuDk/zYb7G6zCphHK1L2sACG
         m2j+JbATEdb9TK7KzF+DVzCY9B/zSaOcMSYhQl25exYEBOC3nbhptHx8Q7FJCKGC7y
         6xY3VDitHTEp4ej9Ua4DfdaPcuZlD2xLakzb2KJn5OkT3X6C217jqXjFu3buvHTVC2
         +L9OGPvdrBEfg==
Date:   Mon, 8 Aug 2022 10:36:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: Re: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly
 exported header files
Message-ID: <YvFJpctzK/9/LsV6@magnolia>
References: <WVSe_1J22WBxe1bXs0u1-LcME14brH0fGDu5RCt5eBvqFJCSvxxAEPHIObGT4iqkEoCCZv4vpOzGZSrLjg8gcQ==@protonmail.internalid>
 <YtiPgDT3imEyU2aF@magnolia>
 <20220721121128.yyxnvkn4opjdgcln@orion>
 <e6ee2759-8b55-61a9-ff6c-6410d185d35e@gmail.com>
 <YuQBarhgxff8Hih6@magnolia>
 <86691238-3de4-418d-5e94-981de043173e@sandeen.net>
 <14b36a0e-b567-e854-8791-0aed7af0567a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14b36a0e-b567-e854-8791-0aed7af0567a@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 08, 2022 at 10:13:06AM -0700, Florian Fainelli wrote:
> On 8/4/22 19:11, Eric Sandeen wrote:
> > 
> > 
> > On 7/29/22 10:48 AM, Darrick J. Wong wrote:
> > > > Darrick, do you need to re-post, or can the maintainers pick up the patch directly?
> > > I already did:
> > > https://lore.kernel.org/linux-xfs/YtmB005kkkErb5uw@magnolia/
> > > 
> > > (It's August, so I think the xfsprogs maintainer might be on vacation?
> > > Either way, I'll make sure he's aware of it before the next release.)
> > > 
> > > --D
> > > 
> > 
> > Yep I was, picking it up now. Thanks for the pointer Darrick.
> > 
> > -Eric
> 
> Eric, any chance this could be pushed to xfsprogs-dev.git so we can take the
> patch and submit it to buildroot, OpenWrt and other projects that depend
> upon that build fix?

It's queued in for-next, so the git commit ids should be stable if you
want to get that started now.

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?h=for-next&id=28965957f4ea5c79fc0b91b997168c656a4426c5

--D

> Thanks!
> -- 
> Florian
