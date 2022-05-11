Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A90C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 15:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiEKPqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 May 2022 11:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiEKPqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 11:46:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 676143B038
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 08:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652283988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+4OignPg9vP4iGHerXMdHt9g8IKbgAJmTrKSDfmr00=;
        b=W2b7Df/goPS86Qr3wZGFrolE2hsN4I97IvwGQbc0jSf/qWShEl1eeCix2ruPsvRJ4/xs/H
        P+WKNOHfC3qFHX4aUAt/lcCdUr5QvqgGeT/U8IwvEjPotiqItTozMrU/kw39UXQ22OONA8
        E7DQLX3nVMPr7ST7jV20a80Cwgrx15o=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-TGzSXF-BPaujZFcc1takrA-1; Wed, 11 May 2022 11:46:26 -0400
X-MC-Unique: TGzSXF-BPaujZFcc1takrA-1
Received: by mail-qk1-f199.google.com with SMTP id x191-20020a3763c8000000b0069fb66f3901so2113420qkb.12
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 08:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/+4OignPg9vP4iGHerXMdHt9g8IKbgAJmTrKSDfmr00=;
        b=Iw0IZH5ThDi+eRGCL51q56C2E5rb7rry93O7d2u2MV0xTR97brxMcU2xtCEc5M5dou
         BtvM236xnct357tROgIGogKQpkbksQ3kvXFerUxdL0QZqHRoZs6ujCQr6TB6yrf4Hgzc
         Zf1SR0rGImwdgZDwj4xZjsVORYj1nVuADiiovyRee3R8pNDRv9oTTppCmnf0Gye2uiOY
         E3Svk/agjpwsTsMI+HsTxpFt0NlU/lhuuLsxMxBxCUdwOznEaFOukuvS6ycapVpehO5Q
         iLooOWYtRBFZrG38wmtIZ30e51iMAw6BjC9vhQPoD9m1KXd1ZSbVI3riOouLyiBfyRMo
         b/8g==
X-Gm-Message-State: AOAM533fx36oEHq60IbObFemrE85pppTI1TXgGagk/frLgXNl2T5Z2eR
        XTkVP0N27IMkI1bM0gHlg+4Eei6tr1a8JK7AQXEDYZ2fq6/KHrMW/q5ndWWtepwf8EhaRJPucVu
        HL5WI2o7ckGu4t3DuaRp0
X-Received: by 2002:ad4:4ee6:0:b0:45a:fe5a:1e2c with SMTP id dv6-20020ad44ee6000000b0045afe5a1e2cmr17800480qvb.103.1652283986292;
        Wed, 11 May 2022 08:46:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHJyyb400NIjtl6jd+x7U6gJXg9M9jZ/Z8Emc3xyajqdCq1c3Z9igSxwEyOC5N7aiuvOpnYg==
X-Received: by 2002:ad4:4ee6:0:b0:45a:fe5a:1e2c with SMTP id dv6-20020ad44ee6000000b0045afe5a1e2cmr17800458qvb.103.1652283985996;
        Wed, 11 May 2022 08:46:25 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id h6-20020a37b706000000b0069fc13ce24fsm1355306qkf.128.2022.05.11.08.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:46:25 -0700 (PDT)
Date:   Wed, 11 May 2022 11:46:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <YnvaT4TGUhb+94bI@bfoster>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
 <20220510190212.GC27195@magnolia>
 <20220510220523.GU1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510220523.GU1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 08:05:23AM +1000, Dave Chinner wrote:
> On Tue, May 10, 2022 at 12:02:12PM -0700, Darrick J. Wong wrote:
> > On Tue, May 10, 2022 at 09:21:03AM +0300, Amir Goldstein wrote:
> > > On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > I think the upcoming nrext64 xfsprogs patches took in the first patch in
> > > > that series.
> > > >
> > > > Question: Now that mkfs has a min logsize of 64MB, should we refuse
> > > > upgrades for any filesystem with logsize < 64MB?
> > > 
> > > I think that would make a lot of sense. We do need to reduce the upgrade
> > > test matrix as much as we can, at least as a starting point.
> > > Our customers would have started with at least 1TB fs, so should not
> > > have a problem with minimum logsize on upgrade.
> > > 
> > > BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
> > > practice of users to start with a small fs and grow it, which is encouraged by
> > > Cloud providers pricing model.
> > > 
> > > I had asked Ted about the option to resize the ext4 journal and he replied
> > > that in theory it could be done, because the ext4 journal does not need to be
> > > contiguous. He thought that it was not the case for XFS though.
> > 
> > It's theoretically possible, but I'd bet that making it work reliably
> > will be difficult for an infrequent operation.  The old log would probably
> > have to clean itself, and then write a single transaction containing
> > both the bnobt update to allocate the new log as well as an EFI to erase
> > it.  Then you write to the new log a single transaction containing the
> > superblock and an EFI to free the old log.  Then you update the primary
> > super and force it out to disk, un-quiesce the log, and finish that EFI
> > so that the old log gets freed.
> > 
> > And then you have to go back and find the necessary parts that I missed.
> 
> The new log transaction to say "the new log is over there" so log
> recovery knows that the old log is being replaced and can go find
> the new log and recover it to free the old log.
> 
> IOWs, there's a heap of log recovery work needed, a new
> intent/transaction type, futzing with feature bits because old
> kernels won't be able to recovery such a operation, etc.
> 
> Then there's interesting issues that haven't ever been considered,
> like having a discontiguity in the LSN as we physically switch logs.
> What cycle number does the new log start at? What happens to all the
> head and tail tracking fields when we switch to the new log? What
> about all the log items in the AIL which is ordered by LSN? What
> about all the active log items that track a specific LSN for
> recovery integrity purposes (e.g. inode allocation buffers)? What
> about updating the reservation grant heads that track log space
> usage? Updating all the static size calculations used by the log
> code which has to be done before the new log can be written to via
> iclogs.
> 

If XFS were going to support an online switchover of the physical log,
why not do so across a quiesce? To try and do such a thing with active
records, log items, etc. that are unrelated to the operation seems
unnecessarily complex to me.

> The allocation of the new log extent and the freeing of the old log
> extent is the easy bit. Handling the failure cases to provide an
> atomic, always recoverable switch and managing all the runtime state
> and accounting changes that are necessary is the hard part...
> 

That suggests the "hard part" of the problem is primarily the online
switchover, but is that necessarily a strict requirement for a
reasonably useful/viable feature? ISTM that even being able to increase
the size of the log offline could be quite helpful for a filesystem that
has been grown via the cloudy very small -> very large antipattern. It
not only provides a recovery path for regular end-users, but at least
gives the cloudy dev guys a step to run during image deployment to avoid
the problem.

TBH, if one were to go through the trouble of making the log resizeable,
I start to wonder whether it's worth starting with a format change that
better accommodates future flexibility. For example, the internal log is
already AG allocated space.. why not do something like assign it to an
internal log inode attached to the sb? Then the log inode has the
obvious capability to allocate or free (non-active log) extents at
runtime through all the usual codepaths without disruption because the
log itself only cares about a target device, block offset and size. We
already know a bump of the log cycle count is sufficient for consistency
across a clean mount cycle because repair has been zapping clean logs by
default as such since pretty much forever.

That potentially reduces log reallocation to a switchover algorithm that
could run at mount time. I.e., a new prospective log extent is allocated
at runtime (and maybe flagged with an xattr or something). The next
mount identifies a new/prospective log, requires/verifies that the old
log is clean, selects the new log extent (based on some currently
undefined selection algorithm) and seeds it with the appropriate cycle
count via synchronous transactions that release any currently inactive
extent(s) from the log inode. Any failure along the way sticks with the
old log and releases the still inactive new extent, if it happens to
exist. We already do this sort of stale resource clean up for other
things like unlinked inodes and stale COW blocks, so the general premise
exists.. hm?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

