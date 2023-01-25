Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E992C54E94
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 17:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbjAYRV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 12:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjAYRV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 12:21:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CB1B469
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 09:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4344B81ACC
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 17:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E6CC433EF;
        Wed, 25 Jan 2023 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674667282;
        bh=Y32W2zDSnm82udCQNjocqvWbPZIIJBje7FcjkE2Fcuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3z0IgwK5B9HTvjX83d9sI5F84q/OCGqOqG0fSbcAB40ZvUj2YWU7iByb7H6YiZfu
         ChL4s2B04Ws0UE7pLdlfhUc0LWM+opJq3+AHNmCj92eUBwvv92G8Fc3b5XH+Z4GEcv
         cQXxcMC+WqC8Lnoyef3SqA4Rh8EAc9E82FfDn/YN73HFcCEYqTSQRHGOFeLQG/lnV0
         MwcCiq7GSrUIvO4rggCO4LwGsR6oJbUbRzCN7gVpSGlO8AC2+67JFUYYwWc4DpT4gj
         60DLiAuE21dziRAvAY1fxbwKl4at2Vb93HNImtryrRcRISC+AU1xG/kP3wL+9SLbMY
         gbT2gIub5GT7g==
Date:   Wed, 25 Jan 2023 18:21:17 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Message-ID: <20230125172117.dvzqkkjp6arfabqf@andromeda>
References: <20230120154512.7przrtsqqyavxuw7@andromeda>
 <YCpxV7N7zijCqzEgnJXPpWgGYUrNV687hdQtYZPyEcYqGI5zrws-hZ6Znw9fOdkrEsLUfLyrBZsxXcb1iJaeYw==@protonmail.internalid>
 <323afbd0338c40d691d79138c1ab93d00074f27c.camel@oracle.com>
 <20230123131050.qsizlly5prd5tydz@andromeda>
 <XkX9I2PpZ5FbFZgqb7FaPbIqm7mCm3Coq1ALGbJhH37ergFaPpYkKXXgr8xbSAQmsRLMbG1Q0BxK0vKByvE58Q==@protonmail.internalid>
 <d1ca3632aa9996c63df72f28228bb97065be09e4.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1ca3632aa9996c63df72f28228bb97065be09e4.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 23, 2023 at 05:49:46PM +0000, Allison Henderson wrote:
> On Mon, 2023-01-23 at 14:10 +0100, Carlos Maiolino wrote:
> > On Fri, Jan 20, 2023 at 11:35:12PM +0000, Allison Henderson wrote:
> > > On Fri, 2023-01-20 at 16:45 +0100, Carlos Maiolino wrote:
> > > > Hello.
> > > >
> > > > The xfsprogs for-next branch, located at:
> > > >
> > > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next__;!!ACWV5N9M2RV99hQ!PiPt2DJxvbDLwRJAXsg5bus3suustYPKHJFnIY8Uu7h8QyFJpDo8rVAjr0A-dpGMPv70rmx06boX5hIO$
> > > >  
> > > >
> > > > Has just been updated.
> > > >
> > > > Patches often get missed, so if your outstanding patches are
> > > > properly
> > > > reviewed on
> > > > the list and not included in this update, please let me know.
> > > >
> > > > The new head of the for-next branch is commit:
> > > >
> > > > d8eab7600f470fbd09013eb90cbc7c5e271da4e5
> > > >
> > > > 4 new commits:
> > > >
> > > > Catherine Hoang (2):
> > > >       [d9151538d] xfs_io: add fsuuid command
> > > Oops, Catherine and I noticed a bug in this patch yesterday.  Do
> > > you
> > > want an updated patch, or a separate fix patch?
> >
> > I suppose you're not talking about:
> > [PATCH v1] xfs_admin: get/set label of mounted filesystem
> > ?
> That patch had exposed it, so I had advised to update "xfs_io: add
> fsuuid command" since it didn't look like it had merged yet
> 
> >
> > Anyway, feel free to send a new patch with a 'Fixes:' tag. It's gonna
> > be better
> > than rebasing for-next.
> 
> Alrighty, thanks Carlos!
> 
> Allison

You're welcome!

> 
> >
> > Thanks for the heads up.
> >
> 

-- 
Carlos Maiolino
