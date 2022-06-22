Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7481BCCA47D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376939AbiFVQzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377063AbiFVQyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:54:53 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DE6192A2;
        Wed, 22 Jun 2022 09:54:46 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id 8so3391531vkg.10;
        Wed, 22 Jun 2022 09:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O1qJAf4HAty3CF7JiBeqFj7ldYF9Aih6Diudc1f4scI=;
        b=TdxbxPDHvM+V+BL85pFozcnxBrQSlyGv0T0ierPVsZLu2Xv02Ue7QCO4H3CAiX9Kw5
         mP7hHteuzqOBnghWmvXT61aYIF+sGgeAHRnsiPo4bjg2onDyHxHzWRzZcaYlk+esxRuP
         wrapjat14HFipSJ6uucbwAd0G6OHUL+MXnjJ7XnzWD3LwtVbo3wsgQaYjI0EXe3adOHd
         AqlnX3ND3WKltkvSoQR7rnW5mtKAB5ZdjOp2TEAm29G0sT1ehq7sQs/qwWZyXmfjyNai
         JuFcX7RBRPiBzp9WdfqS7ysL3GBycHB+Cqec73Ye+LAAgYy0TG6NCUUfF6pw6dqQThS3
         vJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O1qJAf4HAty3CF7JiBeqFj7ldYF9Aih6Diudc1f4scI=;
        b=BlVe+GLkSWf368L9pWoNJ22pfMclIOzGpicpcVRDdbu25Yz8ur3YReUyb3kaacJgHT
         EmBAlAsNeFxq8fzugB3Z2GiNUD9P7DsnKZw3lGFxRsurCBaGMLiTAg5nHG8gEvwB++Cg
         FifnUqlKiVLsEnjbzVh8Z4Z0a8P9fpNI07sO+q5bsid+kU8svCtLSh4LJhd3MiEmgiXd
         921rskJougxav82YaepnT4NKliivTFtN110ETxAgYZWh7e0yydxnJWZvH2Vho/M46RHt
         Osq3OAr008Hm63GyF2i4orNHMfJ5ZQAEfBYByZgxxcmB08/0PRfMFW5rHyPZdre1RV7x
         6MPw==
X-Gm-Message-State: AJIora/lfOvILprKRuw4AZ6YooqhxHuME1/NShebdK0rH+jX2rtBKwIu
        mT/D4Kf910kiDgKlodUaHdfSQn5MeI2cD5PaADc=
X-Google-Smtp-Source: AGRyM1v9em8UGLt14tzQqis1Lp51FkSeKA1VeuMOuUv2K2ytsOf5rVKmS7GwM97bvtXLDZ6/wIoDETguLl/mQGm8PF8=
X-Received: by 2002:a1f:eec2:0:b0:36c:1c9b:465f with SMTP id
 m185-20020a1feec2000000b0036c1c9b465fmr7796839vkh.3.1655916885301; Wed, 22
 Jun 2022 09:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <20220617100641.1653164-10-amir73il@gmail.com>
 <YrNFb9999OY/8JDZ@magnolia>
In-Reply-To: <YrNFb9999OY/8JDZ@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 22 Jun 2022 19:54:33 +0300
Message-ID: <CAOQ4uxi1th2XJ7Ss8avKjrR=k1wMw524+2+ahyafBhSAUsS7dQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 09/11] xfs: only bother with
 sync_filesystem during readonly remount
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 7:38 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Jun 17, 2022 at 01:06:39PM +0300, Amir Goldstein wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> >
> > commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.
> >
> > In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
> > into xfs_fs_remount.  The only time that we ever need to push dirty file
> > data or metadata to disk for a remount is if we're remounting the
> > filesystem read only, so this really could be moved to xfs_remount_ro.
> >
> > Once we've moved the call site, actually check the return value from
> > sync_filesystem.

This part is not really relevant for this backport, do you want me to
emphasise that?

> >
> > Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/xfs_super.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 6323974d6b3e..dd0439ae6732 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1716,6 +1716,11 @@ xfs_remount_ro(
> >       };
> >       int                     error;
> >
> > +     /* Flush all the dirty data to disk. */
> > +     error = sync_filesystem(mp->m_super);
>
> Looking at 5.10.124's fsync.c and xfs_super.c:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/sync.c?h=v5.10.124#n31
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/xfs/xfs_super.c?h=v5.10.124#n755
>
> I think this kernel needs the patch(es) that make __sync_filesystem return
> the errors passed back by ->sync_fs, and I think also the patch that
> makes xfs_fs_sync_fs return errors encountered by xfs_log_force, right?

It wasn't my intention to fix syncfs() does not return errors in 5.10.
It has always been that way and IIRC, the relevant patches did not
apply cleanly.

THIS patch however, fixes something else, not only the return of the error
to its caller, so I thought it was worth backporting.
If you think otherwise, I'll drop it.

Thanks,
Amir.
