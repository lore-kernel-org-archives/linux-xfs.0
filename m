Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6F6C48BE5
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 20:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79AFC61182
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 20:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhFLUVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Jun 2021 16:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLUVk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Jun 2021 16:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C38861107;
        Sat, 12 Jun 2021 20:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623529180;
        bh=ez5wamjDqI9ymYM367JuxRRPRCMTRuVX80rURrDznZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuBLpn5dYWugbaDhOSyhBYSUrUk36CPrUbvf7mJKqKaHMgezkMUkUV32SzVKACMoI
         0XEk3yIdXfTcdE11WFwb6YJsUWD08f2Q1V1QxifqpuE3jJEtciR1fFZ18Pa6WX9Z+1
         uTNJtUCChHGHoyPxPCqbFiSrLi/KRUzQ6OeGFlTiVPOzhMAcgP2X3eS2wxYbZEsstf
         bb1EAf7c78weZqMaq9AqQ35KETABrhEBWPd2hCkmpL8ySDCO+Ky3peTbbmyNI/xw9o
         DyLqZ42p+UbTY3w2u76gX+32KHL1bZbq+AF2mpGQJKV0e8NX4CQnPbPOk9NbRCO3vW
         ef2r8jJsODc3Q==
Date:   Sat, 12 Jun 2021 13:19:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yizhuo Zhai <yzhai003@ucr.edu>
Cc:     dchinner@redhat.com, bfoster@redhat.com,
        allison.henderson@oracle.com, chandanrlinux@gmail.com,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: A Potential Bug in fs/xfs/libxfs/xfs_bmap.c
Message-ID: <20210612201939.GE2945763@locust>
References: <CABvMjLSDhy8witCZCm3ZHaWZ+E7S8NeQm8oc+sP6HSObZeUUqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABvMjLSDhy8witCZCm3ZHaWZ+E7S8NeQm8oc+sP6HSObZeUUqw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc list]

On Fri, Jun 11, 2021 at 11:12:18PM -0700, Yizhuo Zhai wrote:
> Hi All:
> I just found a bug in the cramfs using the static analysis tool, but not

cramfs?  I thought we were in xfs.  Well, I get turned around easily.

> sure if this could happen in reality, could you please advise here? Thanks
> for your attention : )
> 
> In function xfs_bmap_del_extent_real
> <https://elixir.bootlin.com/linux/v5.12/source/fs/xfs/libxfs/v5.12/C/ident/xfs_bmap_del_extent_real>()
> , the structure "got" could be uninitialized if function "
> xfs_iext_get_extent
> <https://elixir.bootlin.com/linux/v5.12/source/fs/xfs/libxfs/v5.12/C/ident/xfs_iext_get_extent>()"
> returns false. However, there's no check for the return value but it is
> still used in the later code.

What's the state of the iext cursor?  Has it moved since the last time
anyone validated it?

--D

> 
> Here's the related code:
> 
> STATIC int xfs_bmap_del_extent_real ()
> {
>         struct xfs_bmbt_irec	got; //"got" declared here but not initialized
>         xfs_iext_get_extent(ifp, icur, &got); //"got" could be
> uninitialized if xfs_iext_get_extent() return false.
> 
> 
>         ASSERT(got.br_startoff <= del->br_startoff); //"got" is used
> here and later code
> }bool
> xfs_iext_get_extent(
> 	struct xfs_ifork	*ifp,
> 	struct xfs_iext_cursor	*cur,
> 	struct xfs_bmbt_irec	*gotp)
> {
> 	if (!xfs_iext_valid(ifp, cur))
> 		return false;
>         ...
> }
> 
> 
> 
> -- 
> Kind Regards,
> 
> *Yizhuo Zhai*
> 
> *Computer Science, Graduate Student*
> *University of California, Riverside *
