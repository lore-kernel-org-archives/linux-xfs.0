Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC46C7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 15:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbjFAP62 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 11:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbjFAP61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 11:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEA9F2;
        Thu,  1 Jun 2023 08:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBC77646FD;
        Thu,  1 Jun 2023 15:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D793BC433EF;
        Thu,  1 Jun 2023 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685635104;
        bh=rZsvgn1Qz1sIejmC3hSShN/kjvw/1Nvi8CJxyMdm+rU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKFjPM3GRqsFoMtAphV5b3w+6Ukw1CPPdPjxWeAQrNM0Xq0CFz80Gk0mTIojcvU5T
         bRazzIM7imebgUXIhGIrlDyzOHUShEW5oCorlhef21BB1TtVF+BaWr0Yd2hXtIVGRD
         9e/k7dBLuSenTg9JueHbx5yD6eF7eYuos18oOcTkWydmA56+1yrhfbIMS86N7pEnCc
         v13XFx70ScOnsBiRZW6jzxB407Qxz0M4D5b6ouBX5cNfpc4iR1b7/+P66GBwKMZylQ
         h1ZaKLV5ecKChVtkTwtJ7snZygngGuSjuygt0v1L8wTuaHCDBUvhw/dNfPP2xhxSgY
         wSVfI4xxC3a2g==
Date:   Thu, 1 Jun 2023 17:58:19 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ext4: Remove ext4 locking of moved directory
Message-ID: <20230601-vierhundert-fuhrpark-1d29c6cc1ed7@brauner>
References: <20230601104525.27897-1-jack@suse.cz>
 <20230601105830.13168-1-jack@suse.cz>
 <20230601145222.GB1069561@mit.edu>
 <20230601152746.kqykcztndxvxbbf7@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230601152746.kqykcztndxvxbbf7@quack3>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 01, 2023 at 05:27:46PM +0200, Jan Kara wrote:
> On Thu 01-06-23 10:52:22, Theodore Ts'o wrote:
> > On Thu, Jun 01, 2023 at 12:58:21PM +0200, Jan Kara wrote:
> > > Remove locking of moved directory in ext4_rename2(). We will take care
> > > of it in VFS instead. This effectively reverts commit 0813299c586b
> > > ("ext4: Fix possible corruption when moving a directory") and followup
> > > fixes.
> > 
> > Remind me --- commit 0813299c586b is not actually causing any
> > problems; it's just not fully effective at solving the problem.  Is
> > that correct?
> 
> Yes, correct.
> 
> > In other words, is there a rush in trying to get this revert to Linus
> > during this cycle as a regression fix?
> > 
> > I think the answer is no, and we can just let this full patch series
> > go in via the vfs branch during the next merge window, but I just
> > wanted to make sure.
> 
> Exactly, that's my plan as well.

Yeah, we'll have time and ideally this should soak in -next for a good
while also gives others time to take a look.
