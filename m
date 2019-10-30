Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46BFCA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 12:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 847E92087F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 12:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMOJ76/i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfJ3Mqz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:46:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55839 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726088AbfJ3Mqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 08:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572439614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GLjwuaIUQUu2xWN1yG21bQtUdaP3MVFXCRzeL8VBThc=;
        b=TMOJ76/iWq8zTx9vvBkOezBf/1opKt9KbS8dy0WFX4Iyj7PutMf/VbjpmzQNjQicQptuLg
        GvAcL7SOtwrsMaAvQNZnBFylu74Ti3aJNloQ/JwyjIqpyWkekaGkZq9cb55UNRAf2snh5I
        wN//Hm3f/x1S4P/Gp2OQlG0tyudjIq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-nxwVNeh1MbCi4mDVaruCQw-1; Wed, 30 Oct 2019 08:46:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A127800C61;
        Wed, 30 Oct 2019 12:46:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5BB360C81;
        Wed, 30 Oct 2019 12:46:48 +0000 (UTC)
Date:   Wed, 30 Oct 2019 08:46:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191030124647.GB46856@bfoster>
References: <20191029223752.28562-1-david@fromorbit.com>
MIME-Version: 1.0
In-Reply-To: <20191029223752.28562-1-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: nxwVNeh1MbCi4mDVaruCQw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 09:37:52AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>=20
> AIO+DIO can extend the file size on IO completion, and it holds
> no inode locks while the IO is in flight. Therefore, a race
> condition exists in file size updates if we do something like this:
>=20
> aio-thread=09=09=09fallocate-thread
>=20
> lock inode
> submit IO beyond inode->i_size
> unlock inode
> .....
> =09=09=09=09lock inode
> =09=09=09=09break layouts
> =09=09=09=09if (off + len > inode->i_size)
> =09=09=09=09=09new_size =3D off + len
> =09=09=09=09.....
> =09=09=09=09inode_dio_wait()
> =09=09=09=09<blocks>
> .....
> completes
> inode->i_size updated
> inode_dio_done()
> ....
> =09=09=09=09<wakes>
> =09=09=09=09<does stuff no long beyond EOF>
> =09=09=09=09if (new_size)
> =09=09=09=09=09xfs_vn_setattr(inode, new_size)
>=20
>=20
> Yup, that attempt to extend the file size in the fallocate code
> turns into a truncate - it removes the whatever the aio write
> allocated and put to disk, and reduced the inode size back down to
> where the fallocate operation ends.
>=20
> Fundamentally, xfs_file_fallocate()  not compatible with racing
> AIO+DIO completions, so we need to move the inode_dio_wait() call
> up to where the lock the inode and break the layouts.
>=20
> Secondly, storing the inode size and then using it unchecked without
> holding the ILOCK is not safe; we can only do such a thing if we've
> locked out and drained all IO and other modification operations,
> which we don't do initially in xfs_file_fallocate.
>=20
> It should be noted that some of the fallocate operations are
> compound operations - they are made up of multiple manipulations
> that may zero data, and so we may need to flush and invalidate the
> file multiple times during an operation. However, we only need to
> lock out IO and other space manipulation operations once, as that
> lockout is maintained until the entire fallocate operation has been
> completed.
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c |  8 +-------
>  fs/xfs/xfs_file.c      | 23 +++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c     |  1 +
>  3 files changed, 25 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fb31d7d6701e..dea68308fb64 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1040,6 +1040,7 @@ xfs_unmap_extent(
>  =09goto out_unlock;
>  }
> =20
> +/* Caller must first wait for the completion of any pending DIOs if requ=
ired. */
>  int
>  xfs_flush_unmap_range(
>  =09struct xfs_inode=09*ip,
> @@ -1051,9 +1052,6 @@ xfs_flush_unmap_range(
>  =09xfs_off_t=09=09rounding, start, end;
>  =09int=09=09=09error;
> =20
> -=09/* wait for the completion of any pending DIOs */
> -=09inode_dio_wait(inode);
> -
>  =09rounding =3D max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
>  =09start =3D round_down(offset, rounding);
>  =09end =3D round_up(offset + len, rounding) - 1;
> @@ -1085,10 +1083,6 @@ xfs_free_file_space(
>  =09if (len <=3D 0)=09/* if nothing being freed */
>  =09=09return 0;
> =20
> -=09error =3D xfs_flush_unmap_range(ip, offset, len);
> -=09if (error)
> -=09=09return error;
> -
>  =09startoffset_fsb =3D XFS_B_TO_FSB(mp, offset);
>  =09endoffset_fsb =3D XFS_B_TO_FSBT(mp, offset + len);
> =20
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 525b29b99116..46fc5629369b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -817,6 +817,29 @@ xfs_file_fallocate(
>  =09if (error)
>  =09=09goto out_unlock;
> =20
> +=09/*
> +=09 * Must wait for all AIO to complete before we continue as AIO can
> +=09 * change the file size on completion without holding any locks we
> +=09 * currently hold. We must do this first because AIO can update both
> +=09 * the on disk and in memory inode sizes, and the operations that fol=
low
> +=09 * require the in-memory size to be fully up-to-date.
> +=09 */
> +=09inode_dio_wait(inode);
> +
> +=09/*
> +=09 * Now that AIO and DIO has drained we can flush and (if necessary)
> +=09 * invalidate the cached range over the first operation we are about =
to
> +=09 * run. We include zero and collapse here because they both start wit=
h a
> +=09 * hole punch over the target range. Insert and collapse both invalid=
ate
> +=09 * the broader range affected by the shift in xfs_prepare_shift().
> +=09 */
> +=09if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> +=09=09    FALLOC_FL_COLLAPSE_RANGE)) {
> +=09=09error =3D xfs_flush_unmap_range(ip, offset, len);
> +=09=09if (error)
> +=09=09=09goto out_unlock;
> +=09}
> +
>  =09if (mode & FALLOC_FL_PUNCH_HOLE) {
>  =09=09error =3D xfs_free_file_space(ip, offset, len);
>  =09=09if (error)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 287f83eb791f..800f07044636 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -623,6 +623,7 @@ xfs_ioc_space(
>  =09error =3D xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
>  =09if (error)
>  =09=09goto out_unlock;
> +=09inode_dio_wait(inode);
> =20
>  =09switch (bf->l_whence) {
>  =09case 0: /*SEEK_SET*/
> --=20
> 2.24.0.rc0
>=20

