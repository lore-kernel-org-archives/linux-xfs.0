Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB6CC38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 01:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiJYBKt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 21:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiJYBJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 21:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2449D2CDB
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 17:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E227261052
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 00:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF8EC433C1;
        Tue, 25 Oct 2022 00:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666657114;
        bh=AYNdIGacxRsDkqocIdm5GNxDukzwT3N86R37lmpGthw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OxqbxjdKpmB3+CnDOp3iJ8sY6QEbf1qioxINM48yPl/uWugtareVrEJRYbz5C97QR
         9gP53yqhwnT86+tbO0pgLXO0Pgi9CuqybZhi8BAlWwhpaDFn7LDerwJ1nLMBnw+zXM
         AT1eH7Z75b7XscisWDWQ7GD/AovVDsTUX17wWsw//vXAOWBYMiDRpvoOtGbYcr4mcK
         oaQBY/VA15XfiP3eXgQv8hEnaqjxVU3SN1I2tmIJmGn5A4IjmC6gZWbUVpXPtEsnD5
         hFeW3PymY4RSQvOLgxoH1FVEKKe9yQ5nwfIGOsuy07/WNQmF3mldkqAbBZaS2r7jz8
         7nXeUFgMLiIDw==
Date:   Mon, 24 Oct 2022 17:18:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1crWdYUGatxJn+T@magnolia>
References: <Y1cEYs4TK/kED/52@magnolia>
 <Y1cKIEmT2R9INlDT@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1cKIEmT2R9INlDT@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 10:56:48PM +0100, Matthew Wilcox wrote:
> On Mon, Oct 24, 2022 at 02:32:18PM -0700, Darrick J. Wong wrote:
> > Fix the incorrect return type for these two functions, and make the
> > !fsdax version return SIGBUS since there is no vm_fault_t that maps to
> > zero.
> 
> Hmm?  You should be able to return 0 without sparse complaining.

Yes I know, but is that the correct return value for "someone is calling
the wrong function, everything is fubar, please stop the world now"?

--D
