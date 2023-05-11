Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647D3C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 16:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbjEKQue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbjEKQuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 12:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB40A6
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 09:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 188AC64FD0
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 16:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FFDC433D2;
        Thu, 11 May 2023 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683823830;
        bh=2naPD0erLNUmJ640UORUBdMHYzTFvlEuGWq16u8Fimw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5iHwjTR6GckOqmufiveRdL39duggwtXVikwJXkznzEtlJ7+kUNFDG3R/PE4mjaFA
         KP4cHZMolwwP1LWXXYY7MOIVT6xtwm4FEYGbzhsdhGi/a05wY99SlbJMRosvLB5Qk3
         pJaxc6FSZNKz4PJrPpAOp7AddJQOJADMD9djCFt45WsPJnDcd1vjkmiR4u7TpxMmBm
         XU2MCVQI4riZuWdeHBh5Em11nfceCuQ8mDVdPjEB2SBPziEsSTbcxfpBpuYd+ZZisR
         nCr4pBYeLefsofS/v/j0aeIKSFAelUZ3dG+v7dfWpQ4K4/3qJKS+KR2YVElRfDFRZH
         /TeVcuQ7WwEFw==
Date:   Thu, 11 May 2023 09:50:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
Message-ID: <20230511165029.GE858799@frogsfrogsfrogs>
References: <20230511015846.GH2651828@dread.disaster.area>
 <20230511020107.GI2651828@dread.disaster.area>
 <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 09:49:25PM -0500, Linus Torvalds wrote:
> On Wed, May 10, 2023 at 9:01 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > [ and now with the correct cc's. DOH! ]
> 
> [ Bah. And now with the correct cc's on the reply too. ]
> 
> We do not consider build warnings even remotely "harmless".
> 
> That sounds like you will fail all build farms that happen to have
> this compiler version.

...and which version is that?  The build robot report just says ia64
without specifying any details about what compiler was running, etc:

https://lore.kernel.org/linux-xfs/20230510165934.5Zgh4%25lkp@intel.com/T/#u

I'll see if I can fix it, but there's not enough information to
reproduce the exact circumstances of the warning.  I've been building
this branch with gcc 11.3 on x86_64, aarch64, ppc64le, s390x, and
riscv64, and none of them complained.  I normally build the fs/xfs code
with most of the W=12e options enabled, though I confess to turning off
the warnings that trigger on random bits of source code outside xfs.

I don't have access to any ia64 environment, let alone whatever build
farm Intel has.

> Which in turn just means that I'd have to revert the commit.

The PR message didn't specify what warning was being ignored.  Assuming
it's the one the build robot found, would you actually revert a commit
over a build warning about unreachable code *only* on ia64?

> The fact that you seem to think that build warnings don't matter and
> are harmless AND you imply that you can just leave some compiler
> warning to the next release just makes me go "No, I don't want to pull
> this".
>
> So I pulled this. It built fine for me. But then I went "Dave says he
> isn't even bothering to fix some build warning he seems to know about,
> and isn't even planning on fixing it until 6.5, so no, I think I'll
> unpull again".

The real fixes for the code that I turned off are sufficiently involved
that we had to have a session about it at LSFMM.  There's no way to
merge it now; the window is closed.

--D

> When you decide that compiler warnings matter, please re-send.
> 
>                     Linus
