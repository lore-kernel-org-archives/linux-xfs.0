Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D27C197A0
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Nov 2023 05:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjKQFYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Nov 2023 00:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjKQFYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2023 00:24:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB853D4A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 21:24:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3119AC433C8;
        Fri, 17 Nov 2023 05:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700198672;
        bh=otj+kKHBEQFfwTQUWipbjkRUInhszzJFCznCNIx193U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATxyc/DiM7VHfiLYTA23c9NFxUjE/ye5SZWOACsFqwqLDoJfCwyMf6txGbV0btsIc
         Ltm/frn2KzuykZVEoHi67LzTIcBMieWLcwIVhQhwyCd1irla21ej95bzhOJZFoodpP
         0+ZYE9k39OCD7kgA89asiIzkd9laHyynXbZ68k3DHt3r1iBCZO1Cif/XB7kdfHncHX
         3K3H967cvNF1eXZdWnYlQNRoMqBgz96C2LfOwbRhZ3VW0myEG8X5q67ldeAdMYG9Fm
         do35gzwSW/PGN5JVAnDUiP3YhxnlOoyXB8oxQlI2z4STuMAyElDnS5idvTqB2TNwHN
         PPh0Gv6+Dm9ig==
Date:   Thu, 16 Nov 2023 21:24:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [xfsprogs PATCH] xfs_io/encrypt: support specifying crypto data
 unit size
Message-ID: <20231117052430.GB972@sol.localdomain>
References: <20231013062639.141468-1-ebiggers@kernel.org>
 <KMvmogj9a91wwFViEyqlFQPlIuusUrW4mllNMHHZWBgZzBLAzrSJ2c93ZZyLh7bh4tkBI-JTjQZ6LJrGHubXcQ==@protonmail.internalid>
 <20231116035846.GA1583@sol.localdomain>
 <h7e7q6g7ti4mbre55ap6x5o6suzdiiyykxtn5pgfsf2w6y7esx@tg2qxsplx2zb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h7e7q6g7ti4mbre55ap6x5o6suzdiiyykxtn5pgfsf2w6y7esx@tg2qxsplx2zb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 16, 2023 at 11:04:16AM +0100, Carlos Maiolino wrote:
> On Wed, Nov 15, 2023 at 07:58:46PM -0800, Eric Biggers wrote:
> > On Thu, Oct 12, 2023 at 11:26:39PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Add an '-s' option to the 'set_encpolicy' command of xfs_io to allow
> > > exercising the log2_data_unit_size field that is being added to struct
> > > fscrypt_policy_v2 (kernel patch:
> > > https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).
> > >
> > > The xfs_io support is needed for xfstests
> > > (https://lore.kernel.org/fstests/20231013061403.138425-1-ebiggers@kernel.org),
> > > which currently relies on xfs_io to access the encryption ioctls.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  configure.ac          |  1 +
> > >  include/builddefs.in  |  4 +++
> > >  io/encrypt.c          | 72 ++++++++++++++++++++++++++++++++-----------
> > >  m4/package_libcdev.m4 | 21 +++++++++++++
> > >  man/man8/xfs_io.8     |  5 ++-
> > >  5 files changed, 84 insertions(+), 19 deletions(-)
> > 
> > Hi!  Any feedback on this patch?
> 
> I've got a limited bandwidth these days, I'll try to review this sometime
> around next week.
> 

Thanks Carlos.

BTW, this is really just for xfstests.  To be honest, it might be a good idea to
remove the encryption commands from xfs_io, and make the encryption tests just
use an xfstests helper program, potentially in combination with fscryptctl
(https://github.com/google/fscryptctl) which now contains most of this
functionality too.  Then the XFS folks would have less to worry about.  Maybe
xfs_io has a backwards compatibility guarantee that makes this impossible, but
if not then it may be worth thinking about if the XFS folks don't want to have
to keep reviewing patches to the encryption commands like this.  The xfs_io
commands were what Dave had requested when I added the first encryption tests
back in 2016, so I did it that way, but maybe preferences have changed.

Anyway, review and/or thoughts are appreciated.

- Eric
