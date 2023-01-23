Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E64C38142
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Jan 2023 13:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjAWNK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 08:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjAWNK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 08:10:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252792412D
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 05:10:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9022E60F08
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 13:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DBDC433D2;
        Mon, 23 Jan 2023 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674479455;
        bh=UQN3mTk58m412Wg9UNJx9Chprh3xewtJH5jjmIZaiCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oa7gUQNLesDvD4fC/7/I1rgzuzsc6Y1KodhUOrlsTN9Rc1CLok/eZTkPV3LJ8MQIR
         s6NOev/o/OKej2HBzZNWmkdUmmR2mXPU6l2aEPmoDk8fKDbQq7FV67teizbtcFnERX
         8z3oKJeUwtQ+hL9NwoK6OM9Sk+t9TWCAc5lWlXqu1ny24r4aP1T+EZ7r3ZeUi1OHFw
         fh4+FZs20b/HijB18wrQVeM5Wu+xwCrksdjSDC4FWFVlm1SgcVtyk8rtxmX8peBCGD
         dG4DOWfk6ms7KIdhQnLpoVdwMQuzb7yPUiU1WtDzv9uYBfyV0YoExivisCA0ezmov1
         Dx6L6jmBkb32Q==
Date:   Mon, 23 Jan 2023 14:10:50 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Message-ID: <20230123131050.qsizlly5prd5tydz@andromeda>
References: <20230120154512.7przrtsqqyavxuw7@andromeda>
 <YCpxV7N7zijCqzEgnJXPpWgGYUrNV687hdQtYZPyEcYqGI5zrws-hZ6Znw9fOdkrEsLUfLyrBZsxXcb1iJaeYw==@protonmail.internalid>
 <323afbd0338c40d691d79138c1ab93d00074f27c.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <323afbd0338c40d691d79138c1ab93d00074f27c.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 20, 2023 at 11:35:12PM +0000, Allison Henderson wrote:
> On Fri, 2023-01-20 at 16:45 +0100, Carlos Maiolino wrote:
> > Hello.
> >
> > The xfsprogs for-next branch, located at:
> >
> > https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next
> >
> > Has just been updated.
> >
> > Patches often get missed, so if your outstanding patches are properly
> > reviewed on
> > the list and not included in this update, please let me know.
> >
> > The new head of the for-next branch is commit:
> >
> > d8eab7600f470fbd09013eb90cbc7c5e271da4e5
> >
> > 4 new commits:
> >
> > Catherine Hoang (2):
> >       [d9151538d] xfs_io: add fsuuid command
> Oops, Catherine and I noticed a bug in this patch yesterday.  Do you
> want an updated patch, or a separate fix patch?

I suppose you're not talking about:
[PATCH v1] xfs_admin: get/set label of mounted filesystem
?

Anyway, feel free to send a new patch with a 'Fixes:' tag. It's gonna be better
than rebasing for-next.

Thanks for the heads up.

-- 
Carlos Maiolino
