Return-Path: <SRS0=JBSb=7N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37124C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 12:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C391206F0
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 12:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BW3WLK+I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgEaMaz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 May 2020 08:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgEaMaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 08:30:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA08C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 05:30:54 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 18so6770845iln.9
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 05:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NC9JYlOsAlQGwFDQAEcxiocATnZ39u0db9936kK59K8=;
        b=BW3WLK+IazYKb2/JTxf3yoRGFafenwL9DoPCfESXoK1Uj30wdVSZ1xffxrwnc9Ai82
         s6HRxudnOMBXnew+wKvArwyjQYi+bZtLPHsP3P3aJeRoZBpTuyXBCJqO1vx61wwjqQv9
         D7F1MdHEQwTpacgivb59Zr/WGnDint3UBzgifiTnX0RqByRC5D7xyGClAmyh4ngx5XHt
         r7bevU1QSKu5Y3/zSDcj/NZidCHNb1ZUviSjkeeKremT9SRQjFPup6GPP7Qc2c6SJZZK
         4NQfWV8EsIoAbELD5lvuQ8msBdQQ8YR9FKswtUtk7f45e6ZEMu8nAzsOiHbdLuFM++ry
         06YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NC9JYlOsAlQGwFDQAEcxiocATnZ39u0db9936kK59K8=;
        b=j+G+rSY610hH5U3/0VQ3+k6pDqHex39py1vrTFV4JfABkALnXNA01Jt249+9lXOyKG
         a1pLpYVWJIlPohskLYRGEEbcVdSrN8LeQyUB5PHqwhc/jBCtUMdWcEvrEzK4leLV21dx
         oiZlDrVdmdbMuDTqkXCts5vUGAPavYF8gnCkUEUb8nd+L6egN0QarINWZ69kXyaBthEq
         7hGmw1TI2qbHrK5O/gghRu7qpwxaI1nZcTwRGXiLf/SQ+4+LQTHzdOtgV67gpPjvMAR5
         jugXU7p4Dz49X/ZeaqQOGxnEs1PtW96gCCrdsAm716u1QwvTkwBk1fTn+VPQTsGYR83E
         1tng==
X-Gm-Message-State: AOAM532tFxsfoJf28q6oawNfHF4yG/WWCJzHFl0qHLZ6e8aVMgmOHIv5
        H2DTEIiYLRmOMWF+FK8CbeTT4rkgpYkHwsZwrHetUA==
X-Google-Smtp-Source: ABdhPJzIpkqPatfnv1vLhjoLh3OZ16WCi3GDFXarn/YoHj7hWXdAfY4VGb4nzqMQikZFqnwNGNG5TJP+JhZzVYFUq8c=
X-Received: by 2002:a92:1b86:: with SMTP id f6mr16898249ill.9.1590928253484;
 Sun, 31 May 2020 05:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia> <157784113220.1364230.3763399684650880969.stgit@magnolia>
In-Reply-To: <157784113220.1364230.3763399684650880969.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 31 May 2020 15:30:42 +0300
Message-ID: <CAOQ4uxj9_6AHPkBmPUpqZ_-nnqgzkwPT4xik=Xi1XQ61JJcTFw@mail.gmail.com>
Subject: Re: [PATCH 11/14] xfs: widen ondisk timestamps to deal with y2038 problem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -265,17 +278,35 @@ xfs_inode_from_disk(
>         if (to->di_version == 3) {
>                 inode_set_iversion_queried(inode,
>                                            be64_to_cpu(from->di_changecount));
> -               xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> +               xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> +                               &from->di_crtime);
>                 to->di_flags2 = be64_to_cpu(from->di_flags2);
>                 to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> +               /*
> +                * Convert this inode's timestamps to bigtime format the next
> +                * time we write it out to disk.
> +                */
> +               if (xfs_sb_version_hasbigtime(&mp->m_sb))
> +                       to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
>         }

This feels wrong.
incore inode has a union for timestamp.
This flag should indicate how the union should be interpreted
otherwise it is going to be very easy to stumble on that in future code.

So either convert incore timestamp now or check hasbigtime when
we write to disk.

Thanks,
Amir.
