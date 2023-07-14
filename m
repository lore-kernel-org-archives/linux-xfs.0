Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA7CC001B0
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 00:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjGNAQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 20:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjGNAQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 20:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1253E30D8
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 17:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03ECC61AD2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 00:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A736C433C7;
        Fri, 14 Jul 2023 00:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689293723;
        bh=ZenSUeumfTWPgVa5YbCd0t017oTrYJ9hydO1k1I0Rjo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TKbW6vdTrCS+O2mDy52SHW+Sock2fcjf4ztWmQKyQAWrVVOPsvMxJp0gjMG+LfCOX
         Ro3TOzWT0q0EjO0+Kz1Zu7Cj3zmPXi9PBAN1ZVo75clGYBIiGOL9yBJ/+AYU5Eofzx
         EzBJ3r80oJuPsJ75mV9xugo6pEyOusb4y+uf0l62rIjhb4cTF2tjMuAySsr9A7tJDx
         tjsWr3bzwyUlcgn9/Wpkz8AK0RcT86BzHsw+Fyx0lAg/IrhmD+WwP8sQZXLyel5Uu8
         e9xk5woJmUW06iT/ckQRYUne9WptQRC0PtXvpgNpmwuYm5Ey3l54xLF2ddJb3EGJlL
         w+eO59cUhhAFQ==
Message-ID: <2b782aa87e50d6ee9195a9725fef2d56d52d8afe.camel@kernel.org>
Subject: Re: [PATCH v5 5/8] xfs: XFS_ICHGTIME_CREATE is unused
From:   Jeff Layton <jlayton@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 13 Jul 2023 20:15:21 -0400
In-Reply-To: <ZLCOaj3Xo0CWL3t2@technoir>
References: <20230713-mgctime-v5-0-9eb795d2ae37@kernel.org>
         <20230713-mgctime-v5-5-9eb795d2ae37@kernel.org> <ZLCOaj3Xo0CWL3t2@technoir>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2023-07-14 at 01:53 +0200, Anthony Iliopoulos wrote:
> On Thu, Jul 13, 2023 at 07:00:54PM -0400, Jeff Layton wrote:
> > Nothing ever sets this flag, which makes sense since the create time is
> > set at inode instantiation and is never changed. Remove it and the
> > handling of it in xfs_trans_ichgtime.
>=20
> It is currently used by xfs_repair during recreating the root inode and
> the internal realtime inodes when needed (libxfs is exported to xfsprogs
> so there are userspace consumers of this code).
>=20

Ahh thanks. I didn't think to look at userland for this. We can drop
this patch, and I'll respin #6.

Looking briefly at xfsprogs, it looks like XFS_ICHGTIME_CREATE is never
set without also setting XFS_ICHGTIME_CHG. Is that safe assumption?


> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_shared.h      | 2 --
> >  fs/xfs/libxfs/xfs_trans_inode.c | 2 --
> >  2 files changed, 4 deletions(-)
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index c4381388c0c1..8989fff21723 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -126,8 +126,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp=
,
> >   */
> >  #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
> >  #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
> > -#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
> > -
> > =20
> >  /*
> >   * Symlink decoding/encoding functions
> > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_=
inode.c
> > index 6b2296ff248a..0c9df8df6d4a 100644
> > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > @@ -68,8 +68,6 @@ xfs_trans_ichgtime(
> >  		inode->i_mtime =3D tv;
> >  	if (flags & XFS_ICHGTIME_CHG)
> >  		inode_set_ctime_to_ts(inode, tv);
> > -	if (flags & XFS_ICHGTIME_CREATE)
> > -		ip->i_crtime =3D tv;
> >  }
> > =20
> >  /*
> >=20
> > --=20
> > 2.41.0
> >=20
> >=20


--=20
Jeff Layton <jlayton@kernel.org>
