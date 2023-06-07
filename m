Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC80C7EE23
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 07:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbjFGHkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 03:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbjFGHkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 03:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EAC35AA
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 00:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C0F614A7
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 07:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B04C433EF;
        Wed,  7 Jun 2023 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686123482;
        bh=GhFTsBlf5dOMyd/G/uJb8PgRzuWnVgzxboFdwk4yqXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XYgEQtIXH0y/M8iLfUAL//vtYKMp8Bu3YM/fscdEttxAAL44905utnYTO/mJJx004
         FIsD/uT2y8MnJnUIgCBVSftuSeQMsyFfOhQ8DZl66cx80Qe8QfA1I3a2KEZA7RMLXN
         idNZtBTDDfGRB7f7hynle0WspC1pBk7D8SoZ4rDYZRXfpYEzLqi6qtlhxKY/+FNp9E
         ay6XRTthvZcULCOU5tk68BfOu8NUPsVK7k3buKv5BoO9lIOMseGWAXkzEBTq+hMVKt
         CJuYwGTWF48x6r+ph7Y4O6V8fkn4GqDdqWDc+t0lQwJ3WPHQci0HTsq+0TyuqktPnQ
         ktdEr4Yf90q5w==
Date:   Wed, 7 Jun 2023 09:37:57 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <20230607073757.zwfhie3qbn7mox5i@andromeda>
References: <20230606151122.853315-1-cem@kernel.org>
 <i5VjxsfPIrRyvOoqV6BqW6qno66Gxsc-zGbsc1RZ60MawgxcwuoRtOODkv1SKvanvnXaNriVpBuIGtR99YA_Vw==@protonmail.internalid>
 <ZIAmCHghf8Acr26I@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIAmCHghf8Acr26I@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 11:39:04PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 06, 2023 at 05:11:22PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Comment the code out so kernel test robot stop complaining about it
> > every single test build.
> 
> Err, what?  #if 0ing commit coe is a complete no-go.  If this code
> is dead it should be removed.

The code isn't dead, it's temporarily broken. I spoke with Darrick about
removing it, but by doing that, later, 'reverting' the patch that removed the
broken code, will break the git history (specifically for git blame), and I
didn't want to give Darrick extra work by needing to re-add back all this code
later when he come back to work on this.
Anyway, just an attempt to quiet built test warning alerts :)
I'm totally fine ^R'ing these emails :)

-- 
Carlos
