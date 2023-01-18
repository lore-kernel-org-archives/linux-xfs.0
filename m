Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1A4C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 21:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjARVaS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjARVaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 16:30:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C638B2B085
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 13:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674077374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sgrplrrtl/JeKkdAn9eoyBLOdhX4O8ZNOPv4rP/Tf+8=;
        b=gcIMZSEE0+dy5IPjcXyYeDmCC+TLl6JO7Ik2gun3MKen7lR8UaFSb5FwRPUj5NbaF1pdsv
        Sx2QYhRj0NCVBOkQriDPDJzkPCuJRPEuw7tDzN2to8nM4548RM+P4edOxisz1okkL6X7QG
        OU9dSZucqok3es3Qy/aEP14Unziue8E=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-77-JeRNI1zeNPqY2wOPVSIMvw-1; Wed, 18 Jan 2023 16:29:32 -0500
X-MC-Unique: JeRNI1zeNPqY2wOPVSIMvw-1
Received: by mail-pl1-f200.google.com with SMTP id u6-20020a170903124600b00188cd4769bcso203814plh.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 13:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sgrplrrtl/JeKkdAn9eoyBLOdhX4O8ZNOPv4rP/Tf+8=;
        b=bGJM+QV1ZQ2UrN5LGolhI0o8CJhpF7kqpl5i+WGr6LForWSe2Kilazl/a8rRTWz68k
         O2yBk4GOdbzVX28AySkz+PCTOJQGyRRvRh7s/rn5GTQvwWCWMP2PV0d1kavNvOD7j0V/
         bFiIkmw9j0H0mvURXD3hyYM8Wh4eiJpBq/QqBf1YqKlyduVIlApdMVVNsKU6+SVLPTQu
         byBdhQ7q12xXL6EurAMhau2idY19W6D/7cqs6kogyBplUXhGJOtEeLQEmn3Aq/TZGMdr
         PucwmkT4Ep9CWXHAEJ5+LW8LOzbKkWqegfMOg/hHXjrxgLUoy8XaI/BCyoS+9CqmyQuT
         NNeQ==
X-Gm-Message-State: AFqh2koZPVu2so2h2/XHEibnvfcTGVCG1ZUrlsSBz8vxwlFbi49OSuH2
        Ry1vI4i4ZBpnKb+/ruigHcGK00BK83WadyPAGMmeFZNID3aujjF70U/L5g1RF5itsFTSECVV/bV
        yZVBNzvTOMn9D9/P+/cqDNN40tc+jP9/gxPf1
X-Received: by 2002:a17:902:f7d6:b0:189:7bfe:1eb5 with SMTP id h22-20020a170902f7d600b001897bfe1eb5mr917421plw.9.1674077370837;
        Wed, 18 Jan 2023 13:29:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtt8Vh026otGCgJCUSMBcM83glTyjDfkf6G3KKQhFlnMIb8gayL+YQjl2rTZdZ5Cg6bVwzX68lSAO8FECFB4bA=
X-Received: by 2002:a17:902:f7d6:b0:189:7bfe:1eb5 with SMTP id
 h22-20020a170902f7d600b001897bfe1eb5mr917417plw.9.1674077370613; Wed, 18 Jan
 2023 13:29:30 -0800 (PST)
MIME-Version: 1.0
References: <167406781753.2327912.4817970864551606145.stg-ugh@magnolia>
In-Reply-To: <167406781753.2327912.4817970864551606145.stg-ugh@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 18 Jan 2023 22:29:19 +0100
Message-ID: <CAHc6FU4UQuxayGxkfwuU2PAXP+ho=jy+xHA2wFXWfb3C7TKOOQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfs-linux: iomap-for-next updated to 471859f57d42
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 8:01 PM Darrick J. Wong <djwong@kernel.org> wrote:
> Hi folks,
>
> The iomap-for-next branch of the xfs-linux repository at:
>
> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
>
> has just been updated.
>
> Patches often get missed, so please check if your outstanding patches
> were in this update. If they have not been in this update, please
> resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> the next update.
>
> Just so everyone knows -- I've been summoned for local jury duty
> service, which means that I will be out starting January 30th until
> further notice.  "Further notice" could mean February 1st, or it could
> mean March 1st.  Hopefully there won't be any other iomap changes
> necessary for 6.3; I'll post here again when I figure out what the
> backup plan is.  It is likely that I will be summoned *again* for
> federal service before the end of 2023.
>
> The new head of the iomap-for-next branch is commit:
>
> 471859f57d42 iomap: Rename page_ops to folio_ops
>
> 8 new commits:
>
> Andreas Gruenbacher (8):
> [7a70a5085ed0] iomap: Add __iomap_put_folio helper
> [80baab88bb93] iomap/gfs2: Unlock and put folio in page_done handler
> [40405dddd98a] iomap: Rename page_done handler to put_folio
> [98321b5139f9] iomap: Add iomap_get_folio helper
> [9060bc4d3aca] iomap/gfs2: Get page in page_prepare handler
> [07c22b56685d] iomap: Add __iomap_get_folio helper
> [c82abc239464] iomap: Rename page_prepare handler to get_folio
> [471859f57d42] iomap: Rename page_ops to folio_ops
>
> Code Diffstat:
>
> fs/gfs2/bmap.c         | 38 ++++++++++++++-------
> fs/iomap/buffered-io.c | 91 +++++++++++++++++++++++++++++++++-----------------
> fs/xfs/xfs_iomap.c     |  4 +--
> include/linux/iomap.h  | 27 ++++++++-------
> 4 files changed, 103 insertions(+), 57 deletions(-)

Thanks, Darrick.

Andreas

