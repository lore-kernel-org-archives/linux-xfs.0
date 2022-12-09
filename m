Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A8AC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 09:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiLIJwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 04:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIJvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 04:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61004186D2
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 01:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04E5762134
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 09:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93112C433D2;
        Fri,  9 Dec 2022 09:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670579511;
        bh=0PaXvTizXQHDj0N9RuBc7JOWVXFhaNWoKwDCSsB6LDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAQ0h1VrIS/HwOGUKfthb0BRXXaRqG8l/LhkQENiqTiTwk7o2+Fd0C1Fgxx2SzkFk
         fX57ukL+IB5oMS/Id4mGGx+YwE71sH8JNqaRT/+yf0xaqy4bD7PtVWnq2YQhmaOAmU
         4OwpOVKvGREusdttrkIo7VEmn+JSGj3Yd0W2Gge+2pmjyJDcMtxXlIbW4BUUR+mOQm
         yFTtoE3NTWCrWv4wKdnY7EHWgLHE5JnLkKZiuSugRmaZ1JBt2nwvOi3vadZA24bCqv
         nLjFt1q3dCmJaKEC6N6KBZVWGT62yzjPtO2dzZKusjbHfxkFcI/CzGca2Fu/eafcqP
         ODG9XWNKrZPEA==
Date:   Fri, 9 Dec 2022 10:51:46 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Darrick Wong <darrick.wong@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Message-ID: <20221209095146.72urohonkttuzkui@andromeda>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
 <20221123083636.el5fivqey5qmx6ie@andromeda>
 <c-vuqhpmmrL6JSN0ZRnqX7c1BUcXw5gJ9L2UZ2lG3H8hCJRNIn_uan2rVHLDUPwgY24Nv3WZpiBt2nflhVadtA==@protonmail.internalid>
 <CY4PR10MB1479D19A047EAB8558445EC7A30C9@CY4PR10MB1479.namprd10.prod.outlook.com>
 <20221123122305.oht2bspxqb6ndnlm@andromeda>
 <MWHPR10MB148619277A997E1D8A715257A30E9@MWHPR10MB1486.namprd10.prod.outlook.com>
 <Y4U+dDlv2ylHApxo@magnolia>
 <WuljuDxGZprSR8FYvaB5tfuqKWsgyktc0am1Ct-Gz40iCCgoCCcSXx01oWWSajgXIzkzla5RIDUsyFYxloZksA==@protonmail.internalid>
 <MWHPR10MB1486C55C14A9D4F8CA32D33DA31B9@MWHPR10MB1486.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR10MB1486C55C14A9D4F8CA32D33DA31B9@MWHPR10MB1486.namprd10.prod.outlook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > > So I am still wondering on how to proceed with this patch. Any
> > > comments would be helpful.
> >
> @Carlos Maiolino, Any comments or thoughts on this patch?

Sorry, didn't have time to look into it yet.


-- 
Carlos Maiolino
