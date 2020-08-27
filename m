Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E3FC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 02:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA612075B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 02:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pp8+YLOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgH0CNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 22:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgH0CNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 22:13:52 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E240C0612EF;
        Wed, 26 Aug 2020 19:13:52 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s2so4301091ioo.2;
        Wed, 26 Aug 2020 19:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0s1W1iJV2XuChfP2d7BeiUo6HMX4XicrVqEnqcngi4=;
        b=Pp8+YLOqTTy7srKgjeb7eXXw1grJfCZgpDx1cBai5zNF2tTnfguoD0e5uH/A+E2po4
         JDOipdc860vl3vw7Mlua80WD0R4zgpuojdbfKbzCpSuWB2dBs3uWCySSUNTjkgIA03vD
         sc835JSXIPKCp1thJWUDwLcLET5TCQAhYkUy7TKPzoSCsBFV++/JsWF1yKOJBlFVdzoL
         Ayo3r453/UbWvP5xPQOKIWEr/YGKXvwZKAT4vIVJm7Ad3ltow0b51CS60auuyUgXuRz4
         Z9BPOLLInPOLa75vq4hZWZb1n+ODDeFK6fOgQ+L10f7FvpjbHml7ukIM138t8go1qInU
         YnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0s1W1iJV2XuChfP2d7BeiUo6HMX4XicrVqEnqcngi4=;
        b=reXt5qCKWlfzKCp0NfPzKxyV9djiWk6dyQIg/w5+kTYwa49X/I0fyWAUhxgJnBaqiG
         o4PZJ2Lnx+EXeNEvKmTaJf2e+VfNqHL4wftXDRyzQMILA7v4hYE8rgKL48D8r6AW/BOQ
         cwUaTT2g9mIkFa4ewa/rVxcD7J81S1Ov+aoR9I66J99pxNP7br8S8H399OmK/rRHqJ5e
         JTH4Dl55SHrBKulUpxzTJJT2snwJlhYPOl4haXvQE2ZHAUuH3je1dxoQblEnPo3d4apa
         mflY5gteHhAxD+H46HQNwUwQ9gP5mwkUojBtmoT1wrANODASXyBHOnO/4r/IxfQ5hI3o
         MOFA==
X-Gm-Message-State: AOAM5327BofuJN8ipEev17zafyzb/wzHluARJDoOj5VMuy8cAqUn5xc9
        Ge7YS7FaeDVEwHXplVRm3rvOazsgaX7fhu0h9BZZeVnMGIDDjlPL
X-Google-Smtp-Source: ABdhPJz2kOS+Qm+C2GfIr6X48vPMyNiHCcyKrtJ8LrqYGcnBsXC0ivmQfPY4jinJpdNFBIy0WySnImNVkZjGPXq1XRI=
X-Received: by 2002:a05:6602:26c1:: with SMTP id g1mr15544424ioo.10.1598494431915;
 Wed, 26 Aug 2020 19:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200827013444.24270-1-laoar.shao@gmail.com> <20200827013444.24270-3-laoar.shao@gmail.com>
 <20200827015853.GA14765@casper.infradead.org>
In-Reply-To: <20200827015853.GA14765@casper.infradead.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 27 Aug 2020 10:13:15 +0800
Message-ID: <CALOAHbA3Twne1ebM+tMZQPCJkL9ghpeeMJXPRjPX=iz8X9=LJA@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] xfs: avoid transaction reservation recursion
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 9:58 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Aug 27, 2020 at 09:34:44AM +0800, Yafang Shao wrote:
> > @@ -1500,9 +1500,9 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
> >
> >       /*
> >        * Given that we do not allow direct reclaim to call us, we should
> > -      * never be called in a recursive filesystem reclaim context.
> > +      * never be called while in a filesystem transaction.
> >        */
> > -     if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> > +     if (WARN_ON_ONCE(wbc->fstrans_recursion))
> >               goto redirty;
>
> Erm, Dave said:
>
> > I think we should just remove
> > the check completely from iomap_writepage() and move it up into
> > xfs_vm_writepage() and xfs_vm_writepages().
>
> ie everywhere you set this new bit, just check current->journal_info.


I can't get you. Would you pls. be more specific ?

I move the check of current->journal into xfs_vm_writepage() and
xfs_vm_writepages(), and I think that is the easiest way to implement
it.

       /* we abort the update if there was an IO error */
@@ -564,6 +565,9 @@ xfs_vm_writepage(
 {
        struct xfs_writepage_ctx wpc = { };

+       if (xfs_trans_context_active())
+               wbc->fstrans_recursion = 1;    <<< set for XFS only.
+
        return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
 }


--
Thanks
Yafang
