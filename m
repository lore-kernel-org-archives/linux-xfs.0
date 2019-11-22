Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D2DC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 15:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 235682071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 15:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="In4UQkiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKVPnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:43:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfKVPnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 10:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574437399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gCOkzMQBCndWiBceq+qHqW5tjY7w7QwZ7hMW1iarnZ0=;
        b=In4UQkiQ6PwpvzKPb+P3k1uotJ8qqkRsLkKN67YGTp3YpjDKyOwm9o++VKJpOPNzyZLvXM
        5zYGZlmtJBHyJolDZDI2f9/g969hR3ErnOtkrvL9rpzZApqtvZTe3+QPum3Q+ssiNhmSmp
        nSSBd3/Z/jpPJKtWWFjC1XNmKsuU3yo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-sgnz8uBUPImXF1SOD0y1ww-1; Fri, 22 Nov 2019 10:43:15 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 960471883545;
        Fri, 22 Nov 2019 15:43:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38BBF63772;
        Fri, 22 Nov 2019 15:43:14 +0000 (UTC)
Date:   Fri, 22 Nov 2019 10:43:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191122154314.GA31076@bfoster>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
MIME-Version: 1.0
In-Reply-To: <1574359699-10191-1-git-send-email-alex@zadara.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: sgnz8uBUPImXF1SOD0y1ww-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> We are hitting the following issue: if XFS is mounted with sunit/swidth d=
ifferent from those
> specified during mkfs, then xfs_repair reports false corruption and event=
ually segfaults.
>=20
> Example:
>=20
> # mkfs
> mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=3D64,swidth=3D64 -l =
sunit=3D32 /dev/vda
>=20
> #mount with a different sunit/swidth:
> mount -onoatime,sync,nouuid,sunit=3D32,swidth=3D32 /dev/vda /mnt/xfs
>=20

FYI, I couldn't reproduce this at first because sparse inodes is enabled
by default and that introduces more strict inode alignment requirements.
I'm assuming that sparse inodes is disabled in your example, but it
would be more helpful if you included the exact configuration and mkfs
output in such reports.

> #umount
> umount /mnt/xfs
>=20
...
>=20
> Looking at the kernel code of XFS, there seems to be no need to update th=
e superblock sunit/swidth if the mount-provided sunit/swidth are different.
> The superblock values are not used during runtime.
>=20

I'm not really sure what the right answer is here. On one hand, this
patch seems fundamentally reasonable to me. I find it kind of odd for
mount options to override and persist configuration set in the
superblock like this. OTOH, this changes a historical behavior which may
(or may not) cause disruption for users. I also think it's somewhat
unfortunate to change kernel mount option behavior to accommodate
repair, but I think the mount option behavior being odd argument stands
on its own regardless.

What is your actual use case for changing the stripe unit/width at mount
time like this?

> With the suggested patch, xfs repair is working properly also when mount-=
provided sunit/swidth are different.
>=20
> However, I am not sure whether this is the proper approach. Otherwise, sh=
ould we not allow specifying different sunit/swidth during mount?
>=20
...
>=20
> Signed-off-by: Alex Lyakas <alex@zadara.com>
> ---
>  fs/xfs/xfs_mount.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ba5b6f3..e8263b4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -399,19 +399,13 @@
>  =09=09}
> =20
>  =09=09/*
> -=09=09 * Update superblock with new values
> -=09=09 * and log changes
> +=09=09 * If sunit/swidth specified during mount do not match
> +=09=09 * those in the superblock, use the mount-specified values,
> +=09=09 * but do not update the superblock.
> +=09=09 * Otherwise, xfs_repair reports false corruption.
> +=09=09 * Here, only verify that superblock supports data alignment.
>  =09=09 */
> -=09=09if (xfs_sb_version_hasdalign(sbp)) {
> -=09=09=09if (sbp->sb_unit !=3D mp->m_dalign) {
> -=09=09=09=09sbp->sb_unit =3D mp->m_dalign;
> -=09=09=09=09mp->m_update_sb =3D true;
> -=09=09=09}
> -=09=09=09if (sbp->sb_width !=3D mp->m_swidth) {
> -=09=09=09=09sbp->sb_width =3D mp->m_swidth;
> -=09=09=09=09mp->m_update_sb =3D true;
> -=09=09=09}
> -=09=09} else {
> +=09=09if (!xfs_sb_version_hasdalign(sbp)) {

Would this change xfs_info behavior on a filesystem mounted with
different runtime fields from the superblock? I haven't tested it, but
it looks like we pull the fields from the superblock.

Brian

>  =09=09=09xfs_warn(mp,
>  =09"cannot change alignment: superblock does not support data alignment"=
);
>  =09=09=09return -EINVAL;
> --=20
> 1.9.1
>=20

