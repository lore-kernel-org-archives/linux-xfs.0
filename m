Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5401AEB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 10:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbjGNKxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 06:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbjGNKxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 06:53:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B85D30FD
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 03:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187DF61CDA
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 10:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D5AC433C7;
        Fri, 14 Jul 2023 10:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689332027;
        bh=zGFb5bDROxRUE94cKReA01aihAo75+lqELxmBIhltcQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SWs3hToiXE19VH44qS57BvAdwiUFi/75kDHE8AMIKvoGTbqXs0zj2iBolkByJ3H0Y
         d/co/zkeoLk+Y/MEyXFFeLZCvZjJMv4NkOniFB/7Ccg1lBVSx7jARqKii9yhkJYusU
         T570x4IbKkJ8ztQ5xXZIKuu7F2gJEC8SvRRkFfQj87ZT+t7c/N00PKtJdGV0Lwv2Hz
         D5bqvT2kcaPTeUAVVfxC37aGBmf7lZG5pCRiRhFRl9twi93XW3sUWIWbJ4hZtpILL4
         a1pko4F2jqvRLBpiaBupJL00xS9JEJ41E8lpaX9fSZK93gSMf7MHQU+pnyCfjveFmV
         YQ76sQtU9VYyg==
Message-ID: <6a2e25d21dde5e376af85ed5b691a0ddbb9cd478.camel@kernel.org>
Subject: Re: [PATCH v5 5/8] xfs: XFS_ICHGTIME_CREATE is unused
From:   Jeff Layton <jlayton@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Date:   Fri, 14 Jul 2023 06:53:45 -0400
In-Reply-To: <20230714063502.GS108251@frogsfrogsfrogs>
References: <20230713-mgctime-v5-0-9eb795d2ae37@kernel.org>
         <20230713-mgctime-v5-5-9eb795d2ae37@kernel.org> <ZLCOaj3Xo0CWL3t2@technoir>
         <2b782aa87e50d6ee9195a9725fef2d56d52d8afe.camel@kernel.org>
         <20230714063502.GS108251@frogsfrogsfrogs>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2023-07-13 at 23:35 -0700, Darrick J. Wong wrote:
> On Thu, Jul 13, 2023 at 08:15:21PM -0400, Jeff Layton wrote:
> > On Fri, 2023-07-14 at 01:53 +0200, Anthony Iliopoulos wrote:
> > > On Thu, Jul 13, 2023 at 07:00:54PM -0400, Jeff Layton wrote:
> > > > Nothing ever sets this flag, which makes sense since the create tim=
e is
> > > > set at inode instantiation and is never changed. Remove it and the
> > > > handling of it in xfs_trans_ichgtime.
> > >=20
> > > It is currently used by xfs_repair during recreating the root inode a=
nd
> > > the internal realtime inodes when needed (libxfs is exported to xfspr=
ogs
> > > so there are userspace consumers of this code).
> > >=20
> >=20
> > Ahh thanks. I didn't think to look at userland for this. We can drop
> > this patch, and I'll respin #6.
> >=20
> > Looking briefly at xfsprogs, it looks like XFS_ICHGTIME_CREATE is never
> > set without also setting XFS_ICHGTIME_CHG. Is that safe assumption?
>=20
> There are four timestamps in an xfs inode and an ICHGTIME flag for each:
> MOD is mtime, CHG is ctime, CREATE is crtime/btime, and ACCESS is atime.
> I'd rather leave it that way than tie flags together.
>=20
>=20

I wasn't suggesting to tie any flags together. I just don't see any
scenario where it's OK to call xfs_trans_ichgtime() without
XFS_ICHGTIME_CHG set. It has to change if either of the other times
change.

> >=20
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_shared.h      | 2 --
> > > >  fs/xfs/libxfs/xfs_trans_inode.c | 2 --
> > > >  2 files changed, 4 deletions(-)
> > > >=20
> > > > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.=
h
> > > > index c4381388c0c1..8989fff21723 100644
> > > > --- a/fs/xfs/libxfs/xfs_shared.h
> > > > +++ b/fs/xfs/libxfs/xfs_shared.h
> > > > @@ -126,8 +126,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount=
 *mp,
> > > >   */
> > > >  #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp *=
/
> > > >  #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
> > > > -#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
> > > > -
> > > > =20
> > > >  /*
> > > >   * Symlink decoding/encoding functions
> > > > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_tr=
ans_inode.c
> > > > index 6b2296ff248a..0c9df8df6d4a 100644
> > > > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > > > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > > > @@ -68,8 +68,6 @@ xfs_trans_ichgtime(
> > > >  		inode->i_mtime =3D tv;
> > > >  	if (flags & XFS_ICHGTIME_CHG)
> > > >  		inode_set_ctime_to_ts(inode, tv);
> > > > -	if (flags & XFS_ICHGTIME_CREATE)
> > > > -		ip->i_crtime =3D tv;
> > > >  }
> > > > =20
> > > >  /*
> > > >=20
> > > > --=20
> > > > 2.41.0
> > > >=20
> > > >=20
> >=20
> >=20
> > --=20
> > Jeff Layton <jlayton@kernel.org>

--=20
Jeff Layton <jlayton@kernel.org>
