Return-Path: <SRS0=TFM3=YL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C7ACA9EA9
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 17:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0812A21835
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 17:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="lVXh/T6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505159AbfJRRx4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 13:53:56 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41188 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502168AbfJRRx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Oct 2019 13:53:56 -0400
Received: by mail-ot1-f67.google.com with SMTP id g13so5668271otp.8
        for <linux-xfs@vger.kernel.org>; Fri, 18 Oct 2019 10:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+suchrC7dSYtry6mpduWs9WUcNYGz70N938WmY7t+Q8=;
        b=lVXh/T6JgSMtjgWCkm4WK9OaqI3i1kwUs46H8NXjs5ptwtZGQSLN2UA8souKaP8vKQ
         HYQ+ZKbP+QAezbvkC+auMHsGSBH3YutpkXyuAsNeEYTwxWqzEPae0SrARi9yWwS1eSkk
         Dhi366UIsjikxpQVAXgIFz2amNUq7LvOEP4PsEBkMzed9mAcwR/5is8y7lhIwJGa/pEm
         jPV057Rye+DnLyrPzbY8kh+zAFw/N6bNKQPJkOR6KTQJSFqLLPyXVmvhGJ1BRbux9A8d
         5zOpdxX4tkHtzNSwYUzvRmcn/H9rUot5fkMj+PuiFkHdEkeWQtukqjGf9PUU/LekRFuq
         Gf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+suchrC7dSYtry6mpduWs9WUcNYGz70N938WmY7t+Q8=;
        b=L8XlA+g1LEUhNKEkY7qCEukMpn3H/xrFdsUa8LZSOxDeQGvblEQWqIOSgcRXTCSpA/
         MB3bn4vUtCGbApxTvBnWex1DqrnYIND/I3/lUAsecJFAlwf3lKC1JL6L2lnLlV5OkndT
         8miIMV3w2MfP6uKE8+QosCZdnktlaTJHaiZDubZZ6caDCmFonDzJ6LS/gwuO6DYXVush
         xn32JPzKRWdE6YtD/Jd4jkeaPyMoKpt+nuCb8WGAFUwLjAohojDuHfBj17L6f8K816gh
         HVMaE/y421oy+1PME3XYUwrI2z/AH0kP7g0roCG83CCANsYbulQyo7MjikBGsEwVXYD2
         H3mQ==
X-Gm-Message-State: APjAAAUbfRPtQNd+a3ywYdbPhHduMetR/fcdrlUtSo0QeDF4g9YjOpsi
        Ys4PUfNxIU7zRuiWeMDs6Okjj7J6bS5lI53YAtmp6w==
X-Google-Smtp-Source: APXvYqxWDwvCnXnm7fCfDgQLRk7yVqoBcgYqVjS4uxzeo39UcJeWaDU2nThVUFXBVOC98Rw/jSi2KnKvyYLQQW4lDF8=
X-Received: by 2002:a9d:7c92:: with SMTP id q18mr8783006otn.363.1571421235236;
 Fri, 18 Oct 2019 10:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4jZTM6m7=UdoMrC=QpS4X8W4_6X_t_wM8ZjoYDCc_Z4=A@mail.gmail.com>
 <20191018171630.GA6719@magnolia>
In-Reply-To: <20191018171630.GA6719@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 18 Oct 2019 10:53:43 -0700
Message-ID: <CAPcyv4g2U6YYj6BO_nMgUYPfE2d04pZvKP0JQwNAMy9HZ3UNvg@mail.gmail.com>
Subject: Re: filesystem-dax huge page test fails due to misaligned extents
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <esandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 18, 2019 at 10:16 AM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Fri, Oct 18, 2019 at 09:10:34AM -0700, Dan Williams wrote:
> > Hi,
> >
> > In the course of tracking down a v5.3 regression with filesystem-dax
> > unable to generate huge page faults on any filesystem, I found that I
> > can't generate huge faults on v5.2 with xfs, but ext4 works. That
> > result indicates that the block device is properly physically aligned,
> > but the allocator is generating misaligned extents.
> >
> > The test fallocates a 1GB file and then looks for a 2MB aligned
> > extent. However, fiemap reports:
> >
> >         for (i = 0; i < map->fm_mapped_extents; i++) {
> >                 ext = &map->fm_extents[i];
> >                 fprintf(stderr, "[%ld]: l: %llx p: %llx len: %llx flags: %x\n",
> >                                 i, ext->fe_logical, ext->fe_physical,
> >                                 ext->fe_length, ext->fe_flags);
> >         }
> >
> > [0]: l: 0 p: 208000 len: 1fdf8000 flags: 800
> > [1]: l: 1fdf8000 p: c000 len: 170000 flags: 800
> > [2]: l: 1ff68000 p: 2000c000 len: 1ff70000 flags: 800
> > [3]: l: 3fed8000 p: 4000c000 len: 128000 flags: 801
> >
> > ...where l == ->fe_logical and p == ->fe_physical.
> >
> > I'm still searching for the kernel where this behavior changed, but in
> > the meantime wanted to report this in case its something
> > straightforward in the allocator. The mkfs.xfs invocation in this case
> > was:
> >
> >     mkfs.xfs -f -d su=2m,sw=1 -m reflink=0 /dev/pmem0
>
> As we talked about on irc while I waited for a slooow imap server, I
> think this is caused by fallocate asking for a larger allocation than
> the AG size.  The allocator of course declines this, and bmap code is
> too fast to drop the alignment hints.  IIRC Brian and Carlos and Dave
> were working on something in this area[1] but I don't think there's been
> any progress in a month(?)
>
> Then Dan said agsize=131072, which means 512M AGs, so a 1G fallocate
> will never generate an aligned allocation... but a 256M one seems to
> work fine on my test vm.
>

Thanks Darrick. While reducing the fallocate causes physical alignment
to happen some extents are still misaligned to the logical offset, but
adding agcount=2 cleans it up for me.
