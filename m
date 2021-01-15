Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBD0C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 04:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E091120731
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 04:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbhAOEP1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbhAOEP1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 23:15:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7469B23B03;
        Fri, 15 Jan 2021 04:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610684086;
        bh=frPjDg5ezqI1H9FNhbdG/myp9DYV/nhKpD/79ISMAHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XE23MjUfQAwYvR0b9ZgrWOvMhymE7/iSIhLFKnfomoDLn8rNSd6jxTqDUW7GRX3a2
         a4wL1nBGLc01EPdIDh18JeQeP2TGuunk1R09Mh349SmGsB6P/qxl6ckvvG5MULakX1
         gw3aXiQVMEstEnq/+NdJKl7JYAY/ABHhHOdS5m7+XJ1cU+r3jb2DfJm+BFwZvDRiHV
         Gi1BIoS5Nbh3x0wEu/3QqtR2u7KMsK6aDI7XS3ZcF+1kf/mWOXuy4HD59/EQiZnUvD
         BWsPAKdIp/d3TzHGc1w9vg5JKNHdpN2AT21Tg8jwzaIE91goSqixBLkViPj3CPdqJc
         D1pPE71Nf5eHg==
Date:   Thu, 14 Jan 2021 20:14:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Nathan Scott <nathans@redhat.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Bastian Germann <bastiangermann@fishpost.de>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
Message-ID: <20210115041445.GI1164248@magnolia>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 15, 2021 at 02:40:39PM +1100, Nathan Scott wrote:
> Heya,
> 
> On Fri, Jan 15, 2021 at 5:39 AM Bastian Germann
> <bastiangermann@fishpost.de> wrote:
> >
> > Apply some minor changes to the xfsprogs debian packages, including
> > missing copyright notices that are required by Debian Policy.
> >
> > Bastian Germann (6):
> >   debian: cryptographically verify upstream tarball
> >   debian: remove dependency on essential util-linux
> >   debian: remove "Priority: extra"
> >   debian: use Package-Type over its predecessor
> >   debian: add missing copyright info
> >   debian: new changelog entry
> 
> Having reviewed each of these, please add for each:
> 
> Signed-off-by: Nathan Scott <nathans@debian.org>

Assuming that SOB also applies to the patch below, someone please add a
commit message, and:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> 
> 
> Also, please add Bastion to the list of deb uploaders - thanks!
> 
> diff --git a/debian/control b/debian/control
> index 49ffd340..06b92400 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -2,7 +2,7 @@ Source: xfsprogs
>  Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
> -Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar
> <anibal@debian.org>
> +Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar
> <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
>  Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>=
> 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17),
> linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python,
> pkg-config
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
> 
