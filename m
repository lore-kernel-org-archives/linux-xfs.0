Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1002DC001DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbjGNOav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbjGNOau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:30:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05761BFB
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF6261D1A
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7534C433C9;
        Fri, 14 Jul 2023 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345007;
        bh=OBfJCS92UzmsLadHmYPGtlTmmiWzY0ooE0gwKVu0LDk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RyYsF45hKkn2Y7NdN/Oc6NC0mhrD/MKM+C0Lm+7AqC7TxahYt1lnmKIaDCioB1HT8
         gSlLz5/clvYGb9s5bxIXrdJ5wVrvRYTcHsBSfjDmquHoA5vMZJ6ulXO5t1Y7UTVDcU
         SouOIh7Wyoj/RJN/DqkZzLyKPwGCily96IGFVq8746JYbnWWokcHJCc1opRg48Aw98
         BYrl5m8zM7RSCVY90Iu/Q66XzK1+F2bEOy27xN3iV4oEEle7AmkmUI306TX1+MIwA6
         VcDWspZgvdKOYQwyaxSG6ua4ayigUBJoDoJbMxV8vAugK414BwVDdVJaOdEJJg19q4
         6C6X5VWlpnq5w==
Message-ID: <872eb33d7a7c58f7223faa79f2bda7677b8ee264.camel@kernel.org>
Subject: Re: [PATCH v5 5/8] xfs: XFS_ICHGTIME_CREATE is unused
From:   Jeff Layton <jlayton@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Date:   Fri, 14 Jul 2023 10:30:05 -0400
In-Reply-To: <20230714141632.GU108251@frogsfrogsfrogs>
References: <20230713-mgctime-v5-0-9eb795d2ae37@kernel.org>
         <20230713-mgctime-v5-5-9eb795d2ae37@kernel.org> <ZLCOaj3Xo0CWL3t2@technoir>
         <2b782aa87e50d6ee9195a9725fef2d56d52d8afe.camel@kernel.org>
         <20230714063502.GS108251@frogsfrogsfrogs>
         <6a2e25d21dde5e376af85ed5b691a0ddbb9cd478.camel@kernel.org>
         <20230714141632.GU108251@frogsfrogsfrogs>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2023-07-14 at 07:16 -0700, Darrick J. Wong wrote:
> On Fri, Jul 14, 2023 at 06:53:45AM -0400, Jeff Layton wrote:
> > On Thu, 2023-07-13 at 23:35 -0700, Darrick J. Wong wrote:
> > > On Thu, Jul 13, 2023 at 08:15:21PM -0400, Jeff Layton wrote:
> > > > On Fri, 2023-07-14 at 01:53 +0200, Anthony Iliopoulos wrote:
> > > > > On Thu, Jul 13, 2023 at 07:00:54PM -0400, Jeff Layton wrote:
> > > > > > Nothing ever sets this flag, which makes sense since the create=
 time is
> > > > > > set at inode instantiation and is never changed. Remove it and =
the
> > > > > > handling of it in xfs_trans_ichgtime.
> > > > >=20
> > > > > It is currently used by xfs_repair during recreating the root ino=
de and
> > > > > the internal realtime inodes when needed (libxfs is exported to x=
fsprogs
> > > > > so there are userspace consumers of this code).
> > > > >=20
> > > >=20
> > > > Ahh thanks. I didn't think to look at userland for this. We can dro=
p
> > > > this patch, and I'll respin #6.
> > > >=20
> > > > Looking briefly at xfsprogs, it looks like XFS_ICHGTIME_CREATE is n=
ever
> > > > set without also setting XFS_ICHGTIME_CHG. Is that safe assumption?
> > >=20
> > > There are four timestamps in an xfs inode and an ICHGTIME flag for ea=
ch:
> > > MOD is mtime, CHG is ctime, CREATE is crtime/btime, and ACCESS is ati=
me.
> > > I'd rather leave it that way than tie flags together.
> > >=20
> > >=20
> >=20
> > I wasn't suggesting to tie any flags together. I just don't see any
> > scenario where it's OK to call xfs_trans_ichgtime() without
> > XFS_ICHGTIME_CHG set. It has to change if either of the other times
> > change.
>=20
> Oh!  That's correct, I don't know of any place where the [bam]time get
> updated without also bumping ctime.
>=20

Great! Thanks for confirming. With that, patch #6 has this delta in it
instead:

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inod=
e.c
index 6b2296ff248a..3ac1fcca7c52 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -62,12 +62,12 @@ xfs_trans_ichgtime(
        ASSERT(tp);
        ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
=20
-       tv =3D current_time(inode);
+       /* If the mtime or btime change, then ctime must also change */
+       WARN_ON_ONCE(!(flags & XFS_ICHGTIME_CHG));
=20
+       tv =3D inode_set_ctime_current(inode);
        if (flags & XFS_ICHGTIME_MOD)
                inode->i_mtime =3D tv;
-       if (flags & XFS_ICHGTIME_CHG)
-               inode_set_ctime_to_ts(inode, tv);
        if (flags & XFS_ICHGTIME_CREATE)
                ip->i_crtime =3D tv;
 }

