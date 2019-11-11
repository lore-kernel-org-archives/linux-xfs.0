Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E4DC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E31214E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:24:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XyD9dzpd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKKSYy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 13:24:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbfKKSYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 13:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573496692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DHaO1Ml3l39m2oFo2QkgFCAEyxWCSbKNXqddvfY7LgU=;
        b=XyD9dzpdVRbZSjGK6lzM74lQWEyTIk05XjL63XwTmjWPLwWnUkPXM8xeJUHEJvUNZUJSEQ
        oZkkcPZDGwNp7ix1ed4l4+lwjHYTk+Taj5giwyk54aY1kwWPErA8qqt9L+Shi80OOiBZXg
        KTzEJeEOv6+QkKLmSRILZJfc95Fpr7g=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-Fg8NkvLzNAimzXtp9cd_0w-1; Mon, 11 Nov 2019 13:24:48 -0500
Received: by mail-ua1-f70.google.com with SMTP id d8so5074717uan.4
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 10:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AMmEewPGjArjbxBIQ0lMmWxiUlLlCze1moyA3CuB4lc=;
        b=PGsIzxyLGtqcNEiPKhQlno1JrVD2Dwj9/hDzOlBcjcSL9RU9Z/11bCldh64x8WkGFA
         hFxbvKdbIiJ18Kru2JDyJ/bYigjqOz7nZpcs0QqhISjm89w960M51WBdrwpNwoyyrMU7
         w3OwAJvGO6w/s4jUtAFfTQxG3Z7HEI/ptIIF3BhJJNps2WU3zGTYZOtBZktMbwH279YT
         lryphAXCQQ6CVsI2kUNZnk4HrNh1yYJ2ACBfvNrZWekOrVScsetZqz98uvRSWZyQUaQx
         pr43QI5fZUv0qYNeM8VLcd0oioepxqN52OMIeWd4fZsFQOZSdXSnNYyE5YWfzvuSl+G1
         15Uw==
X-Gm-Message-State: APjAAAV6RQTzehxY9HyOXDO6PmzAWTGkm9NGMN+r0kKCr4aOmbvD3B0S
        nCsEs1i5dmIhN3tPERcr803dhOaVYmbZMjjcGIIRu8IpdbV5vJtuJk/i6t3KosGNru4lQMGQ8vw
        Cr1wEAuVvdQiHvJ+FY73inFs40YL+/15auAst
X-Received: by 2002:a05:6102:752:: with SMTP id v18mr20060818vsg.3.1573496687822;
        Mon, 11 Nov 2019 10:24:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYxppWQ8ZYlrbqtuWnv0Ef05OfEbb+Za40CwGuJwqRnjSrFKn+8sADt9bq5IvzHDRZU+VdqRHcConTmjHJIQQ=
X-Received: by 2002:a05:6102:752:: with SMTP id v18mr20060800vsg.3.1573496687441;
 Mon, 11 Nov 2019 10:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20191108210612.423439-1-preichl@redhat.com> <20191108210612.423439-3-preichl@redhat.com>
 <20191108221617.GL6219@magnolia>
In-Reply-To: <20191108221617.GL6219@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Mon, 11 Nov 2019 19:24:36 +0100
Message-ID: <CAJc7PzW0fV-DRojU1A1HPUygUdxXRscij=ZhXs5O_u3K97zJmQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] xfs: remove the xfs_quotainfo_t typedef
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: Fg8NkvLzNAimzXtp9cd_0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Darrick,

thanks for your patience with this patchset and for catching these issues.

I'm in the process of improving my vimrc so these little embarrassment
will soon disappear from my patches completely...hopefully :-)

Bye.

Pavel


On Fri, Nov 8, 2019 at 11:18 PM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> On Fri, Nov 08, 2019 at 10:06:10PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/xfs_qm.c          | 20 ++++++++++----------
> >  fs/xfs/xfs_qm.h          |  4 ++--
> >  fs/xfs/xfs_trans_dquot.c |  2 +-
> >  3 files changed, 13 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index c11b3b1af8e9..92d8756b628e 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -30,10 +30,10 @@
> >   * quota functionality, including maintaining the freelist and hash
> >   * tables of dquots.
> >   */
> > -STATIC int   xfs_qm_init_quotainos(xfs_mount_t *);
> > -STATIC int   xfs_qm_init_quotainfo(xfs_mount_t *);
> > +STATIC int   xfs_qm_init_quotainos(struct xfs_mount *mp);
> > +STATIC int   xfs_qm_init_quotainfo(struct xfs_mount *mp);
> >
> > -STATIC void  xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
> > +STATIC void  xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
> >  STATIC void  xfs_qm_dqfree_one(struct xfs_dquot *dqp);
> >  /*
> >   * We use the batch lookup interface to iterate over the dquots as it
> > @@ -540,9 +540,9 @@ xfs_qm_shrink_count(
> >
> >  STATIC void
> >  xfs_qm_set_defquota(
> > -     xfs_mount_t     *mp,
> > -     uint            type,
> > -     xfs_quotainfo_t *qinf)
> > +     struct xfs_mount        *mp,
> > +     uint                    type,
> > +     struct xfs_quotainfo    *qinf)
> >  {
> >       struct xfs_dquot        *dqp;
> >       struct xfs_def_quota    *defq;
> > @@ -643,7 +643,7 @@ xfs_qm_init_quotainfo(
> >
> >       ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> >
> > -     qinf =3D mp->m_quotainfo =3D kmem_zalloc(sizeof(xfs_quotainfo_t),=
 0);
> > +     qinf =3D mp->m_quotainfo =3D kmem_zalloc(sizeof(struct xfs_quotai=
nfo), 0);
> >
> >       error =3D list_lru_init(&qinf->qi_lru);
> >       if (error)
> > @@ -710,9 +710,9 @@ xfs_qm_init_quotainfo(
> >   */
> >  void
> >  xfs_qm_destroy_quotainfo(
> > -     xfs_mount_t     *mp)
> > +     struct xfs_mount     *mp)
>
> This indentation here   ^^^^^ should be tabs, not spaces.
>
> >  {
> > -     xfs_quotainfo_t *qi;
> > +     struct xfs_quotainfo *qi;
>
> Please fix this space here  ^ to be a tab too.
>
> (FYI, the 'list' option in vim will show you tabs vs. spaces to make
> your life easier...)
>
> --D
> >
> >       qi =3D mp->m_quotainfo;
> >       ASSERT(qi !=3D NULL);
> > @@ -1568,7 +1568,7 @@ xfs_qm_init_quotainos(
> >
> >  STATIC void
> >  xfs_qm_destroy_quotainos(
> > -     xfs_quotainfo_t *qi)
> > +     struct xfs_quotainfo    *qi)
> >  {
> >       if (qi->qi_uquotaip) {
> >               xfs_irele(qi->qi_uquotaip);
> > diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> > index b41b75089548..185c9d89a5cd 100644
> > --- a/fs/xfs/xfs_qm.h
> > +++ b/fs/xfs/xfs_qm.h
> > @@ -54,7 +54,7 @@ struct xfs_def_quota {
> >   * Various quota information for individual filesystems.
> >   * The mount structure keeps a pointer to this.
> >   */
> > -typedef struct xfs_quotainfo {
> > +struct xfs_quotainfo {
> >       struct radix_tree_root qi_uquota_tree;
> >       struct radix_tree_root qi_gquota_tree;
> >       struct radix_tree_root qi_pquota_tree;
> > @@ -77,7 +77,7 @@ typedef struct xfs_quotainfo {
> >       struct xfs_def_quota    qi_grp_default;
> >       struct xfs_def_quota    qi_prj_default;
> >       struct shrinker  qi_shrinker;
> > -} xfs_quotainfo_t;
> > +};
> >
> >  static inline struct radix_tree_root *
> >  xfs_dquot_tree(
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index ceb25d1cfdb1..4789f7e11f53 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -585,7 +585,7 @@ xfs_trans_dqresv(
> >       xfs_qwarncnt_t          warnlimit;
> >       xfs_qcnt_t              total_count;
> >       xfs_qcnt_t              *resbcountp;
> > -     xfs_quotainfo_t         *q =3D mp->m_quotainfo;
> > +     struct xfs_quotainfo    *q =3D mp->m_quotainfo;
> >       struct xfs_def_quota    *defq;
> >
> >
> > --
> > 2.23.0
> >

