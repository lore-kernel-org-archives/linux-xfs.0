Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13429C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 17:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbiDMRMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 13:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiDMRMN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 13:12:13 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2279CBCB2
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 10:09:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s137so2369996pgs.5
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 10:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3oz53a9Ng+DbhMPj3RmOVulLJKw0oHFC07pKdWasCM=;
        b=TyHwk2+ZDToVQLJjhJ+GwARFZdQ6fdXaVDK/YYC0qiPJ7F3HvvKdsIy4kR9NZ9lfiE
         xNbBBit8CgoQNMM3vbwz+zcUp+XG/QEgMchCYBLIqOoKHYh9qiClo5rVQPmmMpqSPUnO
         fTwAt+4RIGqoQKVn7FHmUl91EINKQGRX9V6O4XaYR3KKGwQ7DyuU+XskDD/yq+WfPPb0
         jHhSsiDLvDy2OM8+L6vgYYlOIp1RyCtA5mM1o9SZx1R1D8uyT7qDjUAy/V21ZTuRI2KZ
         15EHyz55yFLViX9GowNZKfzHIy8YpYtk99kUuRUamcEDzFAgVe0K5UkAGDXYVx+esSvD
         6SWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3oz53a9Ng+DbhMPj3RmOVulLJKw0oHFC07pKdWasCM=;
        b=FSsqc6CO7ySn2H4KlQMUYCaJUAGUC4z9/4pyhY27kXkvcjUCHbLQedK3LKVMKmK+oQ
         5LPL+1wlKeRoYVikM7Wsby4LD5RpdrP50zUb81Vz12oBW2k51otlrNrg3fWq7KVPVPsr
         NbW/CWc09pqtXlyU7eoW0oej6L8bEU/QYltSjo5K21xAMpaJD52TmK2AyF+ioTyFgYsN
         p4XSTlztJwRDnZwUkl2ln6Kgoy5f6dKauN4K8PhJA63Q13pFRNE/Cn/g9Nz+NLRbs4SU
         qD0B60Qm8oWdP/yISwDuA9r9tt9C/iIJIq6A34HMUB3NcCed5bEsn16jOqSNoq+0fe1Y
         H6QA==
X-Gm-Message-State: AOAM5312QbWFvK/okCs1GMcq6L6im26xkpX5zEpCg11GvjY1cvmQUcDT
        60+v2Y3o9xOCDCvlvejVTGMOqG3fFD3Q+0yQPJsrBA==
X-Google-Smtp-Source: ABdhPJzLi8gMisuellOBcvRBO68apFNBLKqg7RJ1uejuUvIlQHfa3U9nodhdf0gc7bErx9RfyUux7vESwpwfRM8oyF0=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr35296654pgb.74.1649869791634; Wed, 13
 Apr 2022 10:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-7-ruansy.fnst@fujitsu.com> <20220413000423.GK1544202@dread.disaster.area>
 <CAPcyv4jKLZhcCiSEU+O+OJ2e+y9_B2CvaEfAKyBnhhSd+da=Zg@mail.gmail.com> <20220413060946.GL1544202@dread.disaster.area>
In-Reply-To: <20220413060946.GL1544202@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 13 Apr 2022 10:09:40 -0700
Message-ID: <CAPcyv4jPgX3w2e1dENJvKjhCpiB7GMZURXWMoGUNNcOQFotb3A@mail.gmail.com>
Subject: Re: [PATCH v12 6/7] xfs: Implement ->notify_failure() for XFS
To:     Dave Chinner <david@fromorbit.com>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 11:10 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Apr 12, 2022 at 07:06:40PM -0700, Dan Williams wrote:
> > On Tue, Apr 12, 2022 at 5:04 PM Dave Chinner <david@fromorbit.com> wrote:
> > > On Mon, Apr 11, 2022 at 12:09:03AM +0800, Shiyang Ruan wrote:
> > > > Introduce xfs_notify_failure.c to handle failure related works, such as
> > > > implement ->notify_failure(), register/unregister dax holder in xfs, and
> > > > so on.
> > > >
> > > > If the rmap feature of XFS enabled, we can query it to find files and
> > > > metadata which are associated with the corrupt data.  For now all we do
> > > > is kill processes with that file mapped into their address spaces, but
> > > > future patches could actually do something about corrupt metadata.
> > > >
> > > > After that, the memory failure needs to notify the processes who are
> > > > using those files.
> ...
> > > > @@ -1964,8 +1965,8 @@ xfs_alloc_buftarg(
> > > >       btp->bt_mount = mp;
> > > >       btp->bt_dev =  bdev->bd_dev;
> > > >       btp->bt_bdev = bdev;
> > > > -     btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off, NULL,
> > > > -                                         NULL);
> > > > +     btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off, mp,
> > > > +                                         &xfs_dax_holder_operations);
> > >
> > > I see a problem with this: we are setting up notify callbacks before
> > > we've even read in the superblock during mount. i.e. we don't even
> > > kow yet if we've got an XFS filesystem on this block device.
> > > Hence these notifications need to be delayed until after the
> > > filesystem is mounted, all the internal structures have been set up
> > > and log recovery has completed.
> >
> > So I think this gets back to the fact that there will eventually be 2
> > paths into this notifier.
>
> I'm not really concerned by how the notifications are generated;
> my concern is purely that notifications can be handled safely.
>
> > All that to say, I think it is ok / expected for the filesystem to
> > drop notifications on the floor when it is not ready to handle them.
>
> Well, yes. The whole point of notifications is the consumer makes
> the decision on what to do with the notification it receives - the
> producer of the notification does not (and can not) dictate what
> policy the consumer(s) implement...
>
> > For example there are no processes to send SIGBUS to if the filesystem
> > has not even finished mount.
>
> There may be not processes to send SIGBUS to even if the filesystem
> has finished mount. But we still want the notifications to be
> delivered and we still need to handle them safely.
>
> IOWs, while we might start by avoiding notifications during mount,
> this doesn't mean we will never have reason to process events during
> mount. What we do with this notification is going to evolve over
> time as we add new and adapt existing functionality....

Yes, sounds like we're on the same page. I had mistakenly interpreted
"Hence these notifications need to be delayed until after the
filesystem is mounted" as something the producer would need to handle,
but yes, consumer is free to drop if the notification arrives at an
inopportune time.
