Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4BDC61DA4
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 09:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCRJEf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Mar 2023 05:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCRJEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2023 05:04:34 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F025B50985
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 02:04:14 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id x33so4809724uaf.12
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 02:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679130253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46YE2zZsbRZvVS3GTHikh2mmcF7QF9nXPt3CyA6L148=;
        b=ckR7wcDwdnsH+rFWuwbFeaRq2PbsXtyhOISjRziF/Xz22DtLB6s0vPeB/iEn4an2tD
         wXFVjseiPFXvraXx9VGA9LUkLv9Qngf9h7dZCD54+21amVL8REswdJeZBuyr0Kl5iqFe
         Be2syiqwFFcIqRaUPCa9sYDdAxxqdTD5lGiGAZ095GLBjWz6Heeky2c+3zc5BTq7q4V6
         b1Rt6UudisxSZcoXw14QYoh9bhIgm4KoFzvvwoR1hMPiK1gi70Mhzc54q9U+Epnd1abE
         A/a8bXsTWO2dtLlM1GK1ABalYi0UFa6Zdv3Wkz0enRlKWscIyxQjJtxJumbxCbIjH6Rb
         GiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679130253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46YE2zZsbRZvVS3GTHikh2mmcF7QF9nXPt3CyA6L148=;
        b=IA1bRH7UnaynrfA7Zt3zXJhOu8N4doLomqzMqg8fWquYoRuucNA2gK0Upb/XVVgi+v
         COyBFo+rsub3p8mWqjVeBFspAYw8dp3GxtO4oTF2RUs/QaAuAWh7vO5PfEOYwxtlrPVn
         nBnZexQyc/y6Ajm1OAdVk8BSp26/HUxSaFU6e3aI0OsusZWdkBWqUjHmc+vyH+QN7pHg
         DHSGImdNyPV9r/+BwjUlllLGrwSBpuSsfI7YeteSGTQqD6HQQ/Ko7aURSpJVykuooZKe
         Hwdqq0O00jxVMcGpmHeKhfxpEbR0VebeTFQ/VlhVDkflU4UQubJLh5iW6kEAuWtY481m
         pDvg==
X-Gm-Message-State: AO0yUKVhZYwKa7NjxIce1HJebFNyz9WdHWLgPwo4KDsGdSaj/pSRx5Ul
        0oBYIbseJ8x+x8nwfJ3jd2SvDODpDpV4BYf9No0=
X-Google-Smtp-Source: AK7set8Wbz0M+Z84K54uYMK5BLxVGQczveY06Sz2cgTDfY8AaCP7sMdMEw4DNxUcqGt3pRl5RDNDK5Bp+BBxbGffZjA=
X-Received: by 2002:a05:6130:42c:b0:68a:a9d:13f5 with SMTP id
 ba44-20020a056130042c00b0068a0a9d13f5mr713180uab.1.1679130253202; Sat, 18 Mar
 2023 02:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314062847.GQ360264@dread.disaster.area> <20230318001143.GS11376@frogsfrogsfrogs>
In-Reply-To: <20230318001143.GS11376@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 18 Mar 2023 11:04:02 +0200
Message-ID: <CAOQ4uxjQZQMW1ovEf_KjMS-uEfX90Q+PYyCvwP5_=X9OnG_FZw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] setting uuid of online filesystems
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 18, 2023 at 2:24=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Tue, Mar 14, 2023 at 05:28:47PM +1100, Dave Chinner wrote:
> > On Mon, Mar 13, 2023 at 09:21:05PM -0700, Catherine Hoang wrote:
> > > Hi all,
> > >
> > > This series of patches implements a new ioctl to set the uuid of moun=
ted
> > > filesystems. Eventually this will be used by the 'xfs_io fsuuid' comm=
and
> > > to allow userspace to update the uuid.
> > >
> > > Comments and feedback appreciated!
> >
> > What's the use case for this?
> >
> > What are the pro's and cons of the implementation?
> >
> > Some problems I see:
> >
> > * How does this interact with pNFS exports (i.e.
> > CONFIG_EXPORTFS_BLOCK_OPS). XFS hands the sb_uuid directly to pNFS
> > server (and remote clients, I think) so that incoming mapping
> > requests can be directed to the correct block device hosting the XFS
> > filesystem the mapping information is for. IIRC, the pNFS data path
> > is just given a byte offset into the device where the UUID in the
> > superblock lives, and if it matches it allows the remote IO to go
> > ahead - it doesn't actually know that there is a filesystem on that
> > device at all...
>
> I think we're going to have to detect the presence of pNFS exports and
> EAGAIN if there are any active.  That probably involves incrementing a
> counter during ->map_blocks and decreasing it during ->commit blocks.
>
> That might still invite races between someone setting the fsuuid and
> exporting via NFS.
>
> > * IIRC, the nfsd export table can also use the filesystem uuid to
> > identify the filesystem being exported, and IIRC that gets encoded
> > in the filehandle. Does changing the filesystem UUID then cause
> > problems with export indentification and/or file handle
> > creation/resolution?
>
> I thought NFS (when not being used for block layouts and pnfs stuff)
> still used the fsid that's also in the superblock?  Presumably we'd
> leave the old m_fixedfsid unchanged while the fs is still mounted, and
> document the caveat that handles will not work after a remount.
>
> On some level, we might simply have to document that changing the
> user-visible uuid will break file handles and pnfs exports, so sysadmins
> had better get that done early.
>
> OTOH that is an argument for leaving the xfs_db-based version that we
> have now.
>
> > * Is the VFS prepared for sb->s_uuid changing underneath running
> > operations on mounted filesystems? I can see that this might cause
> > problems with any sort of fscrypt implementation as it may encode
> > the s_uuid into encryption keys held in xattrs, similarly IMA and
> > EVM integrity protection keys.
>
> I would hope it's not so hard to detect that EVM/fscrypt are active on a
> given xfs mount.  EVM seems pretty hard to detect since it operates
> above the fs.
>
> fscrypt might not be so difficult, since we likely need to add support
> in the ondisk metadata, which means xfs will know.
>
> IMA seems to be using it for rule matching, so I'd say that if the
> sysadmin changes the fsuuid, they had better update the IMA rulebook
> too.
>
> Come to think of it, perhaps reading a filesystem's uuid (whether via
> handle export, direct read of s_uuid, nfs, evm, ima, or fscrypt) should
> set a superblock flag that someone has accessed it; and only if nobody's
> yet accessed it do we allow the fsuuid update?
>
> > * Should the VFS superblock sb->s_uuid use the XFS
> > sb->sb_meta_uuid value and never change because we can encode it
> > into other objects stored in the active filesystem? What does that
> > mean for tools that identify block devices or filesystems by the VFS
> > uuid rather than the filesystem uuid?
>
> I don't know of any other than the ones you found.

FWIW, overlayfs also uses s_uuid in a similar manner to nfsd
as a persistent reference to the origin lower file after copy up.

Like nfsd, the overlayfs persistent origin handle (fsuuid+filehandle) will =
break
when changing lower fs uuid offline, but I don't see much difference from
changing s_uuid online - worse case that I can think of is that an overlayf=
s
inode will change its st_ino after evict/lookup on a mounted overlayfs.

Thanks,
Amir.
