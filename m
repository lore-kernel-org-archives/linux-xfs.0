Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C35C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 15:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244160AbiFGPZo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243190AbiFGPZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 11:25:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C66EB0D0F
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 08:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1319061716
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 15:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6366EC385A5;
        Tue,  7 Jun 2022 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654615542;
        bh=I229DA3HcVvtjD4UYyKRC0of7fMFYc/Te3H0dC1MQuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jKKqtdvjRCxwW1gzzpSJ2deNfyptapUfLg8+dU2jnIRZdg8jepceN3QzA2b94TYSg
         fQpOBbhkxBbF3/KYX222f0xhbFsTfuDKX5T3Y5EW1VcVUFLOCy92il31KXEsd7juXN
         KNPBZ+mufShag5+KI/80MgzNMoakfY/ggV2iSt53kxNQzHUNkatGyVczGGIiuQ/ZRO
         jR88+dkBzxTeA3zN+MszRS/pPMNMHlU7WlE+G8mEElHtBl9bGFDSlna7E1dnQbtS27
         kMwKhTrBVCMNlmq4gEzkaqNMDHYupCiiCLkkq1XNtRz7OHwDkeh+xpLpfdH7sAMFs0
         7f4Lw+/5nEDJA==
Date:   Tue, 7 Jun 2022 08:25:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Marco Berizzi <pupilla@libero.it>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: lilo booting problem
Message-ID: <Yp9t9rVXfFNEl/YH@magnolia>
References: <1234293069.1387822.1654601480847@mail1.libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234293069.1387822.1654601480847@mail1.libero.it>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 07, 2022 at 01:31:20PM +0200, Marco Berizzi wrote:
> Hello everyone,
> 
> I have recently installed Slackware Linux 15 distribution
> with xfs file system. I noticed that the system could not
> start booting. The loader is Lilo and is installed on the
> MBR: I am aware that this software is no longer maintained.
> 
> I tested vanilla kernels 5.17.13 and 5.18.1 (64 bit).
> 
> I re-created the filesystem with the reflink=0 option and
> now, the system performs the boot successfully.
> 
> I kindly wanted to know if this behavior is the expected
> one.

Yes.  lilo isn't supported on reflink filesystems.

--D

> Thanks,
> Marco
