Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7065C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 04:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiFBEUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 00:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiFBEUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 00:20:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4631F5EDDD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 21:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654143599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oOuLkTXlID9nS9hkEm1uqKJ2/RduGLKOQfwqsVk+aEw=;
        b=aOHpZO891O/cVWgKsGUlyXERyA7aSU16oTnajKrCsiukF7ZYrFxfpAV2eo19+gDK9PR+dm
        m1cLxNs0yBDYltK7FVIWPiYasx+f8CJjZrGgtKFFlVBu80EUGAvJxsBNoSYg7aPb+76g6G
        WrSbUzoJLfMKDr6urGSgx54cEHW3AWk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-smJqDMYYMxO6-37n_OPGVg-1; Thu, 02 Jun 2022 00:19:58 -0400
X-MC-Unique: smJqDMYYMxO6-37n_OPGVg-1
Received: by mail-qk1-f198.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so2812913qkb.23
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jun 2022 21:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oOuLkTXlID9nS9hkEm1uqKJ2/RduGLKOQfwqsVk+aEw=;
        b=E0hFk2klMw7wwdq1HYD8mIAxdI1okqTXUhEVBnK7r5EDu1sAYUCMiY66SUvKD+jkFQ
         rsXJGaRw4SqIWYD6kp9Hm4o3S5v3yIDD8xvSztLzVDRZNz+Zh+HbaVs6a6HLT+o9ZZHc
         9smOhJv2I2jEK0jWNv8Yeqg71Bfus+5FcjjKKh3JmUAE/5IgiymJlNvGR403LejzDfuk
         1fpJ2zCQ8pGy7/AdBl9m7dg4nAvzYDrqAvuXle1JCyeh5giDULjf42SuZg9gFZ1GfJqN
         5X7tfn4fm4ZO4+X6x6UW09TqI4vcmAn5VA6JQ85CQHak5DJF4yhUXfdgTqNijOmu5Et9
         TK7Q==
X-Gm-Message-State: AOAM5307SYtdSwR0hPWUux24J0299+yQ0IIIg133FKFmyobAnAIA3jb0
        qIUcjmdx0orNbMcK+Z8DWKol/ELdQTu0sAOVUp2RW+ac4VZamz9sXvEZ9PSQ5+cSwfX57DN9Lkr
        zta0GnJh56psg+FrAW0Pn
X-Received: by 2002:a05:620a:4083:b0:6a6:4f4d:a5b9 with SMTP id f3-20020a05620a408300b006a64f4da5b9mr1893441qko.741.1654143597306;
        Wed, 01 Jun 2022 21:19:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwN9gourdbGtVEcq+bMrQrn4uBSZUcxRUvIGamNTlOkRFz8VVVKgXYJjt5CaY+hDkuLtCaggQ==
X-Received: by 2002:a05:620a:4083:b0:6a6:4f4d:a5b9 with SMTP id f3-20020a05620a408300b006a64f4da5b9mr1893432qko.741.1654143597018;
        Wed, 01 Jun 2022 21:19:57 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y184-20020a37afc1000000b0069fc13ce225sm2413016qke.86.2022.06.01.21.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 21:19:56 -0700 (PDT)
Date:   Thu, 2 Jun 2022 12:19:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic/623: fix test for runing on overlayfs
Message-ID: <20220602041950.otq3lref6edt4sh6@zlang-mailbox>
References: <20220601123406.265475-1-amir73il@gmail.com>
 <20220601234443.GI227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601234443.GI227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 02, 2022 at 09:44:43AM +1000, Dave Chinner wrote:
> On Wed, Jun 01, 2022 at 03:34:06PM +0300, Amir Goldstein wrote:
> > For this test to run on overlayfs we open a different file to perform
> > shutdown while keeping the writeback target file open.
> > 
> > xfs_io -c fsync perform fsync also on the writeback target file, which
> > is needed for triggering the write fault.
> > 
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> > 
> > Zorro,
> > 
> > Following your comment on v1, this version does not change the
> > behavior of the test when running on non-overlayfs.
> > 
> > I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> > and tested that both configs fail with the same warning on v5.10.109.
> > 
> > Thanks,
> > Amir.
> > 
> >  tests/generic/623 | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tests/generic/623 b/tests/generic/623
> > index ea016d91..5971717c 100755
> > --- a/tests/generic/623
> > +++ b/tests/generic/623
> > @@ -24,10 +24,22 @@ _scratch_mount
> >  # XFS had a regression where it failed to check shutdown status in the fault
> >  # path. This produced an iomap warning because writeback failure clears Uptodate
> >  # status on the page.
> > +
> > +# For this test to run on overlayfs we open a different file to perform
> > +# shutdown while keeping the writeback target file open.
> > +# xfs_io -c fsync post-shutdown performs fsync also on the writeback target file,
> > +# which is critical for trigerring the writeback failure.
> > +shutdown_cmd=()
> > +shutdown_handle="$(_scratch_shutdown_handle)"
> > +if [ "$shutdown_handle" != "$SCRATCH_MNT" ];then
> > +	shutdown_cmd+=("-c" "open $shutdown_handle")
> > +fi
> > +shutdown_cmd+=("-c" "shutdown")
> 
> IMO, this is unnecessary complexity. The original patch with the
> "fsync acts on all open files" comment above explains the xfs_io
> fsync quirk that enables the test to do what it is supposed to be
> doing without any of the this conditional command construction.
> 
> The less special case handling we need to splice into the test code,
> the better.

So you'd like to give below change a RVB?

-$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
+$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
+             -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \

I don't want complexity, just hope to keep the original testing logic.
As I don't know if the current behavior of open_f and fsync_f is stable, it
won't be changed in one day. Especially when I saw "open_f" says it
"Closes the current file, and opens the file specified by path instead"
but it doesn't. Now we depend on it opens a file as "current file", then
shutdown will happen on this file, then fsync will sync all 2 opened files.
That's the complexity for me.

Thanks,
Zorro

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

