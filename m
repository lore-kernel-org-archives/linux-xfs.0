Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AEFC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 09:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLIJo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 04:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIJo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 04:44:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BE65F6E7
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 01:44:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70AB1621E3
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 09:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E68C433D2;
        Fri,  9 Dec 2022 09:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670579064;
        bh=HSejx1t790YeTMcj2OZujlW2T1F+aUSmpLCOWgkpyNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVKOCgir03fPjHeTOgXvM0gaHIk1gqMIj1wb6/zlrDRaAQwNL9YUO2xDzwqHbaNvd
         nN1D3/F7OrH2Fr/fEDsyzeQYqC2G/QzEhwLNGCxUhxx4PBKcTaqjpJ9WyjOhE5JX+z
         ZkdWpZvf3sbiIjuhtsUtTL5/iiAvBU2JEZNR4RhasmaTg57Uohvx9SylUEekvIcfcp
         IrT/ywbfL7v83hjE6NLKjoPzH3qLmoVatszu7hyEDd39usMNI8PkwypXIyp2DOIImw
         S9SqB5HP9hhLTQcOZKEmT+95hSEZtDFJeydC6b8rRzmbVyGdjJvkAOyh87o5wBMrek
         7+j4jXLBAfIpg==
Date:   Fri, 9 Dec 2022 10:44:20 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Chris Boot <lists@bootc.boo.tc>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: XFS corruption help; xfs_repair isn't working
Message-ID: <20221209094420.npdlf36p4eydnwlr@andromeda>
References: <c3fc1808-dbbf-b1c0-36de-1e55be1942e8@bootc.boo.tc>
 <20221129220646.GI3600936@dread.disaster.area>
 <Y4gNntJTb1dZLejo@magnolia>
 <a019db45-2f05-e2ec-5953-26e20aa9484b@bootc.boo.tc>
 <ATlUYJ1o-KWXzdv2pkYVYcZ5oplRX3e-9flZ5uIzHo54ND075lzD_m41vdZUX60h2vWA-mup705INyHy6cQgDw==@protonmail.internalid>
 <3f7796b5-478a-2660-86a8-caeb2c58851a@bootc.boo.tc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f7796b5-478a-2660-86a8-caeb2c58851a@bootc.boo.tc>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2022 at 02:43:32PM +0000, Chris Boot wrote:
> On 01/12/2022 13:00, Chris Boot wrote:
> >> I kinda want to see the metadump of this (possibly enormous) filesystem.
> >
> > I've asked whether I can share this with you. The filesystem is indeed
> > huge (35TiB) and I wouldn't be surprised if the metadata alone was
> > rather large. What would be the most efficient way of sharing that with
> > you?
> 
> I've got approval to send a metadata dump to you. What's the best way of
> getting it over? It's 31GiB uncompressed, 6.5GiB with zstd compression.

Place it somewhere we can easily download, and if you feel uncomfortable sharing
the link publicly to the list, you can send it directly to those who asked for
it, off-list, but please keep the remaining discussion within the list.

-- 
Carlos Maiolino
