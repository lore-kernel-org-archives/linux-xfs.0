Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA07C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E60D21835
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:37:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QClycUEr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfLEOh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:37:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33208 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729402AbfLEOh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 09:37:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575556675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gW1nqTv+a4tlZqxZFPvWJiJ+Bx6J6q5q7kwvwRt6EwI=;
        b=QClycUErnk/to5Ku+nTWOYQQ/JzglFX6RMb2/cr6bAe21JHlWpljyDQcJ/dMrb7+O/o4OP
        ICJXBL3Kt1yM/I9/jyqJTCE9+Vbtp3L7ejQAnuLVwdlFuFiDGfXvAYGqDkrws7QkdPwgWv
        axAXT1phqLvJy70Sl61tDdV9vOHJHA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-c7A8lAjpPrOlZn-jyw0wRQ-1; Thu, 05 Dec 2019 09:37:52 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846721005512;
        Thu,  5 Dec 2019 14:37:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02AD2610D8;
        Thu,  5 Dec 2019 14:37:50 +0000 (UTC)
Date:   Thu, 5 Dec 2019 09:37:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 4/6] xfs_repair: refactor fixed inode location checks
Message-ID: <20191205143750.GD48368@bfoster>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547908997.974712.1071264960710221462.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157547908997.974712.1071264960710221462.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: c7A8lAjpPrOlZn-jyw0wRQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 09:04:50AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Refactor the checking and resetting of fixed-location inodes (root,
> rbmino, rsumino) into a helper function.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/xfs_repair.c |  106 ++++++++++++++++++---------------------------=
------
>  1 file changed, 37 insertions(+), 69 deletions(-)
>=20
>=20
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 3e9059f3..94673750 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -395,6 +395,37 @@ do_log(char const *msg, ...)
>  =09va_end(args);
>  }
> =20
> +/* Make sure a fixed-location inode is where it should be. */
> +static void
> +ensure_fixed_ino(
> +=09xfs_ino_t=09*ino,
> +=09xfs_ino_t=09expected_ino,
> +=09const char=09*tag)
> +{
> +=09if (*ino =3D=3D expected_ino)
> +=09=09return;
> +
> +=09do_warn(
> +_("sb %s inode value %" PRIu64 " %sinconsistent with calculated value %"=
PRIu64"\n"),
> +=09=09tag, *ino, *ino =3D=3D NULLFSINO ? "(NULLFSINO) " : "",
> +=09=09expected_ino);
> +
> +=09if (!no_modify)
> +=09=09do_warn(
> +_("resetting superblock %s inode pointer to %"PRIu64"\n"),
> +=09=09=09tag, expected_ino);
> +=09else
> +=09=09do_warn(
> +_("would reset superblock %s inode pointer to %"PRIu64"\n"),
> +=09=09=09tag, expected_ino);
> +
> +=09/*
> +=09 * Just set the value -- safe since the superblock doesn't get flushe=
d
> +=09 * out if no_modify is set.
> +=09 */
> +=09*ino =3D expected_ino;
> +}
> +
>  static void
>  calc_mkfs(xfs_mount_t *mp)
>  {
> @@ -463,75 +494,12 @@ calc_mkfs(xfs_mount_t *mp)
>  =09/*
>  =09 * now the first 3 inodes in the system
>  =09 */
> -=09if (mp->m_sb.sb_rootino !=3D first_prealloc_ino)  {
> -=09=09do_warn(
> -_("sb root inode value %" PRIu64 " %sinconsistent with calculated value =
%u\n"),
> -=09=09=09mp->m_sb.sb_rootino,
> -=09=09=09(mp->m_sb.sb_rootino =3D=3D NULLFSINO ? "(NULLFSINO) ":""),
> -=09=09=09first_prealloc_ino);
> -
> -=09=09if (!no_modify)
> -=09=09=09do_warn(
> -=09=09_("resetting superblock root inode pointer to %u\n"),
> -=09=09=09=09first_prealloc_ino);
> -=09=09else
> -=09=09=09do_warn(
> -=09=09_("would reset superblock root inode pointer to %u\n"),
> -=09=09=09=09first_prealloc_ino);
> -
> -=09=09/*
> -=09=09 * just set the value -- safe since the superblock
> -=09=09 * doesn't get flushed out if no_modify is set
> -=09=09 */
> -=09=09mp->m_sb.sb_rootino =3D first_prealloc_ino;
> -=09}
> -
> -=09if (mp->m_sb.sb_rbmino !=3D first_prealloc_ino + 1)  {
> -=09=09do_warn(
> -_("sb realtime bitmap inode %" PRIu64 " %sinconsistent with calculated v=
alue %u\n"),
> -=09=09=09mp->m_sb.sb_rbmino,
> -=09=09=09(mp->m_sb.sb_rbmino =3D=3D NULLFSINO ? "(NULLFSINO) ":""),
> -=09=09=09first_prealloc_ino + 1);
> -
> -=09=09if (!no_modify)
> -=09=09=09do_warn(
> -=09=09_("resetting superblock realtime bitmap ino pointer to %u\n"),
> -=09=09=09=09first_prealloc_ino + 1);
> -=09=09else
> -=09=09=09do_warn(
> -=09=09_("would reset superblock realtime bitmap ino pointer to %u\n"),
> -=09=09=09=09first_prealloc_ino + 1);
> -
> -=09=09/*
> -=09=09 * just set the value -- safe since the superblock
> -=09=09 * doesn't get flushed out if no_modify is set
> -=09=09 */
> -=09=09mp->m_sb.sb_rbmino =3D first_prealloc_ino + 1;
> -=09}
> -
> -=09if (mp->m_sb.sb_rsumino !=3D first_prealloc_ino + 2)  {
> -=09=09do_warn(
> -_("sb realtime summary inode %" PRIu64 " %sinconsistent with calculated =
value %u\n"),
> -=09=09=09mp->m_sb.sb_rsumino,
> -=09=09=09(mp->m_sb.sb_rsumino =3D=3D NULLFSINO ? "(NULLFSINO) ":""),
> -=09=09=09first_prealloc_ino + 2);
> -
> -=09=09if (!no_modify)
> -=09=09=09do_warn(
> -=09=09_("resetting superblock realtime summary ino pointer to %u\n"),
> -=09=09=09=09first_prealloc_ino + 2);
> -=09=09else
> -=09=09=09do_warn(
> -=09=09_("would reset superblock realtime summary ino pointer to %u\n"),
> -=09=09=09=09first_prealloc_ino + 2);
> -
> -=09=09/*
> -=09=09 * just set the value -- safe since the superblock
> -=09=09 * doesn't get flushed out if no_modify is set
> -=09=09 */
> -=09=09mp->m_sb.sb_rsumino =3D first_prealloc_ino + 2;
> -=09}
> -
> +=09ensure_fixed_ino(&mp->m_sb.sb_rootino, first_prealloc_ino,
> +=09=09=09_("root"));
> +=09ensure_fixed_ino(&mp->m_sb.sb_rbmino, first_prealloc_ino + 1,
> +=09=09=09_("realtime bitmap"));
> +=09ensure_fixed_ino(&mp->m_sb.sb_rsumino, first_prealloc_ino + 2,
> +=09=09=09_("realtime summary"));
>  }
> =20
>  /*
>=20

