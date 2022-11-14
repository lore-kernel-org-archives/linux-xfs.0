Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF56AC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 16:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbiKNQjd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 11:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbiKNQjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 11:39:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B1B30547
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 08:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B0BB8104F
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 16:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6706C433D6;
        Mon, 14 Nov 2022 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668443710;
        bh=hrfiU2OPmmGVbddp3xdj+au7ypjDvnXODDMUxWr0M94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q789GGB4oAfvErAlJfXBmlzygsqUh+QOY8neGp2HFb8hIdzzUNHf8dOOZL21hYaNk
         Y6gm0rKE+UI2hVklEo64dlCtBtNJjLzqScXA5LB+QXThE/fMgp2NVUrDoz4VR9jOE2
         aUM8oFstsenjbVS3tPkg/NOq7Cl+BC5GdYYK3+FfGPp+ONn+rmgHxezDN97gWOKUOu
         L6wnP3t7lObOdY7Imj0qsKtFHhm15t+g0cJOaWCj8bcR3sPZ28Y1ckCQsesOLyNC+i
         TbGsd5C/KivOa9LECj2CdRE/ZTyKUIruGKScpVepMY4MLTOuMuTaN8+OYW7jpwn7Cb
         cytfXRQU2AlAA==
Date:   Mon, 14 Nov 2022 17:35:06 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs-6.0.0 released
Message-ID: <20221114163506.vvebiubf5e5b5obx@andromeda>
References: <20221114113639.mxgewf2zjgokr6cb@andromeda>
 <miYA_Urvct9JMgOavaZZdbE-7h_9GxwEaB2XWlWYI2kmcv6FqdqVRmSAhAqDrd9_iopj1BubWnUntC7eGk2H_Q==@protonmail.internalid>
 <08c365c6-09f4-5af4-b242-7189d9f79921@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08c365c6-09f4-5af4-b242-7189d9f79921@applied-asynchrony.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2022 at 12:51:41PM +0100, Holger Hoffstätte wrote:
> On 2022-11-14 12:36, Carlos Maiolino wrote:
> > Hi folks,
> >
> > The xfsprogs repository at:
> >
> >          git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> >
> > has just been updated and tagged for a v6.0.0 release. The condensed changelog
> > since v6.0.0-rc0 is below.
> >
> > Tarballs are available at:
> >
> > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.gz
> > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.xz
> > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.sign
> >
> > Patches often get missed, so please check if your outstanding
> > patches were in this update. If they have not been in this update,
> > please resubmit them to linux-xfs@vger.kernel.org so they can be
> > picked up in the next update.
> 
> It looks like my compilation fix for clang-16 (and maybe gcc-13?) is missing:
> 
> https://lore.kernel.org/linux-xfs/865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com/
> 

This should go into 6.1, I expect to push this and some more stuff into for-next
around this week, depending on how much time libxfs sync will consume.


> thanks
> Holger

-- 
Carlos Maiolino
