Return-Path: <SRS0=G8Dq=WV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82F8C3A59E
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Aug 2019 03:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8A5214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Aug 2019 03:13:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="Cbi6lx0+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UHXVHona"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfHYDNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Aug 2019 23:13:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43047 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727941AbfHYDNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Aug 2019 23:13:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ED07C20EB0;
        Sat, 24 Aug 2019 23:13:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 24 Aug 2019 23:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=dknbcyoZeFLLBhXxWIjkGwOLVSf
        M1TAYdlB/lnK7ZMU=; b=Cbi6lx0+Js3KXLTawxk9BlaBSzHk4XPte/36i5R1SnQ
        pn8fwFES463HHkAb6eGge/XtXhZ7mhSmhNCfQa9lgM1rpyyuOxrsvKiAEQ2/tAzA
        d3AQUxza7mGFG03Bys64fzm1ou8pf/Kgz06U6KfvEAemqPrZSuSSjIhDtnQVz9J6
        p5bn0rApGJVjZ/0oLv8AzVhkGKF+7wwNRwZrqNMjGLrJL/5a5QvVpHza0YPNLgaD
        7fQWX/WnwLebODsCEezwTwsWTjFrzwypuQYafHkezWEV0n1qQGJafJKycSjTsEuI
        wZbPqZx74dxqzwdhUpGMfh7WItDU9W35v6oLT1CEreg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dknbcy
        oZeFLLBhXxWIjkGwOLVSfM1TAYdlB/lnK7ZMU=; b=UHXVHonarZRnRYKgZUyhrP
        bB2iN+ooSqPzW3HLtHlcx/tGh/VsPG/Tfy+gTX6ELi+r7EdYPevv7l4kfTKF50wm
        Bzr8jtNpkd1qfnjwMi0Tgo9hrMC/DxHdwKhWjtyIlalYtgGn8KywycCcbm2tWAoz
        NOHfmyY7vdf8/tys6Ak/X4/33zxuNQns9YDuNhNNvuqqZKlEfaTda1xcbiHiOpvt
        oYuR8X4i79IovUNCPMtFhRtpcLuwBCGOIa+uwtXzqly1aduvw9qB6RP14+erkIJS
        ILsjipMEPj1/bxPBTUtzU1JYFL+mnzYkPQeDiOLh0S5i88eKCWYJOY6Zk1US5CmA
        ==
X-ME-Sender: <xms:0PxhXfBbPjTltJEeMLZl4Hqx4FhjnXcSNJWBqnEmPRn-8VAqk93Kbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehuddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:0PxhXZN_Bb0y84XuoERlR3lIitQd6Y_tTkpSk4y6ZzYKACXBuewh-g>
    <xmx:0PxhXVpxy3dth6kdluhmstqjNNQkA3Ri9Ri4MrfTyHpIewlesNXBmw>
    <xmx:0PxhXfP-5g9Kwy_s9V4h5JSpwYZsrNRnYM2by_G3SqReGT2pNU2QFQ>
    <xmx:0PxhXSXS9snK7hRE76GvIhi_FW89mizO6WrM0yMLzgx9QKM42eIurw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F854D6005B;
        Sat, 24 Aug 2019 23:13:20 -0400 (EDT)
Date:   Sun, 25 Aug 2019 05:13:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
Message-ID: <20190825031318.GB2590@kroah.com>
References: <20190823035528.GH1037422@magnolia>
 <20190823192433.GA8736@eldamar.local>
 <CAHk-=wj2hX9Qohd8OFxjsOZEzhp4WwjDvvh3_jRw600xf=KhVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj2hX9Qohd8OFxjsOZEzhp4WwjDvvh3_jRw600xf=KhVw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 24, 2019 at 11:44:44AM -0700, Linus Torvalds wrote:
> On Fri, Aug 23, 2019 at 12:24 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> >
> > Confirmed the fix work.
> >
> > Feel free to add a Tested-by if wanted.
> >
> > Can this be backported to the relevant stable versions as well?
> 
> It's out there in my tree now. It's not explicitly marked for stable
> per se, but it does have the "Fixes:" tag which should mean that Greg
> and Sasha will pick it up automatically.
> 
> But just to make it explicit, since Greg is on the security list,
> Darrick's fix is commit 1fb254aa983b ("xfs: fix missing ILOCK unlock
> when xfs_setattr_nonsize fails due to EDQUOT").

Thanks, I'll pick this up.

Note, "Fixes:" will never guarantee that a patch ends up in a stable
release.  Sasha's scripts usually do a good job of catching a lot of
them a week or so after-the-fact, but they are not guaranteed to do so.
A CC: stable@ will always be caught by me, and I try to ensure that
anything goes across the security@k.o list also gets picked up.

thanks,

greg k-h
