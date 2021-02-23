Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073F1C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 16:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C712964E5C
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 16:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhBWQBO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:01:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233022AbhBWQBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 11:01:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614095984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jKFhGEojpBOiPuul4R9k4ozIq9OJLolLX7fkFzYFPP8=;
        b=jK+3MbJVSlo9y1McbXaGMBEd0gkkwQJvUG7NDF1WriaWQ/+LUT5v+QUzqS9hTrWbn58enn
        saLpMu1AY+isAavwCg/B2FJOVv6Bf6c1LxBDzPXTT+LPwMrPiKOBWftU0H/PDsK0BNbvgK
        hAb7bYT3C+hdWpXHgm828wW94OfqzR4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-bUo2okGmMiCD8wmxlaEA0g-1; Tue, 23 Feb 2021 10:58:43 -0500
X-MC-Unique: bUo2okGmMiCD8wmxlaEA0g-1
Received: by mail-pf1-f199.google.com with SMTP id t7so9406980pfq.6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 07:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jKFhGEojpBOiPuul4R9k4ozIq9OJLolLX7fkFzYFPP8=;
        b=HXtKF1ygUDOabFA1Zq+ECKcO95YL+skd0algajdSzdS7wqO7MfkzNWm5B3/ZPIi9Ap
         TgWfEzUzUVaQjPn4kMKzax1BPmGNwS5NveEKF67zA6eVycFLFuBxLH7WT8ojkEUdt/o8
         AAHphyGX4TP8lwUxaLqE/YGuWMC2CA/LENUeMq6R/cfz1uoIYl/+O+ml7SLqTYqesE28
         kfjlTufl6FuoBeXCcSguzYbkvA/3yvp5Meemc23USC/aI5dd3YJjEp8UdBe73/8PiuDe
         MNXPsH27hFiZJBOuA3BVDoYddWbJ6pBOwlw1CJ5G/ToTe+FT53OKycsKsK5suqUWOY91
         dflA==
X-Gm-Message-State: AOAM530Qt6K7Eq9BEeVJ+hlWyiF7wV/x0dpVnQG4sjKcmbosY75myEO6
        8bwAkO/ePgRvkz24qpvjqVWXULNKHhyJazmCrZHqw4ec9xNLKeLnCmRsYOgZGalJO8GJ7VVtbVk
        PunHunWhSeOUIRbiGZae6
X-Received: by 2002:a17:90a:db8f:: with SMTP id h15mr4664610pjv.212.1614095921200;
        Tue, 23 Feb 2021 07:58:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyyIKUPybah1VNUEi7vMDn90LQqJ3OBZMXXH9jg/+18jaHtw5G5UGofsrWoymZsRfGbVhyh9A==
X-Received: by 2002:a17:90a:db8f:: with SMTP id h15mr4664593pjv.212.1614095920958;
        Tue, 23 Feb 2021 07:58:40 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w8sm15980835pgk.46.2021.02.23.07.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 07:58:40 -0800 (PST)
Date:   Tue, 23 Feb 2021 23:58:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <20210223155830.GA1350554@xiangao.remote.csb>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia>
 <20180326124649.GD34912@bfoster.bfoster>
 <20180327211728.GP18129@dastard>
 <20210223134256.GA1327978@xiangao.remote.csb>
 <a3a02b9b-656a-7284-d1b1-befbafc3e9f9@sandeen.net>
 <20210223150341.GA1341686@xiangao.remote.csb>
 <97534412-b95d-48f8-0a5a-3eafe47d72a6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <97534412-b95d-48f8-0a5a-3eafe47d72a6@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 09:46:38AM -0600, Eric Sandeen wrote:
> 
> 
> On 2/23/21 9:03 AM, Gao Xiang wrote:
> > On Tue, Feb 23, 2021 at 08:40:56AM -0600, Eric Sandeen wrote:
> >> On 2/23/21 7:42 AM, Gao Xiang wrote:
> >>> Hi folks,
> >>>
> >>> On Wed, Mar 28, 2018 at 08:17:28AM +1100, Dave Chinner wrote:
> >>>> On Mon, Mar 26, 2018 at 08:46:49AM -0400, Brian Foster wrote:
> >>>>> On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
> >>>>>> On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
> >>>>>>> Now that unlinked inode recovery is done outside of
> >>>>>>> log recovery, there is no need to dirty the log on
> >>>>>>> snapshots just to handle unlinked inodes.  This means
> >>>>>>> that readonly snapshots can be mounted without requiring
> >>>>>>> -o ro,norecovery to avoid the log replay that can't happen
> >>>>>>> on a readonly block device.
> >>>>>>>
> >>>>>>> (unlinked inodes will just hang out in the agi buckets until
> >>>>>>> the next writable mount)
> >>>>>>
> >>>>>> FWIW I put these two in a test kernel to see what would happen and
> >>>>>> generic/311 failures popped up.  It looked like the _check_scratch_fs
> >>>>>> found incorrect block counts on the snapshot(?)
> >>>>>>
> >>>>>
> >>>>> Interesting. Just a wild guess, but perhaps it has something to do with
> >>>>> lazy sb accounting..? I see we call xfs_initialize_perag_data() when
> >>>>> mounting an unclean fs.
> >>>>
> >>>> The freeze is calls xfs_log_sbcount() which should update the
> >>>> superblock counters from the in-memory counters and write them to
> >>>> disk.
> >>>>
> >>>> If they are out, I'm guessing it's because the in-memory per-ag
> >>>> reservations are not being returned to the global pool before the
> >>>> in-memory counters are summed during a freeze....
> >>>>
> >>>> Cheers,
> >>>>
> >>>> Dave.
> >>>> -- 
> >>>> Dave Chinner
> >>>> david@fromorbit.com
> >>>
> >>> I spend some time on tracking this problem. I've made a quick
> >>> modification with per-AG reservation and tested with generic/311
> >>> it seems fine. My current question is that how such fsfreezed
> >>> images (with clean mount) work with old kernels without [PATCH 1/1]?
> >>> I'm afraid orphan inodes won't be freed with such old kernels....
> >>> Am I missing something?
> >>
> >> It's true, a snapshot created with these patches will not have their unlinked
> >> inodes processed if mounted on an older kernel. I'm not sure how much of a
> >> problem that is; the filesystem is not inconsistent, but some space is lost,
> >> I guess. I'm not sure it's common to take a snapshot of a frozen filesystem on
> >> one kernel and then move it back to an older kernel.  Maybe others have
> >> thoughts on this.
> > 
> > My current thought might be only to write clean mount without
> > unlinked inodes when freezing, but leave log dirty if any
> > unlinked inodes exist as Brian mentioned before and don't
> > handle such case (?). I'd like to hear more comments about
> > this as well.
> 
> I don't know if I had made this comment before ;) but I feel like that's even
> more "surprise" (as in: gets further from the principle of least surprise)
> and TBH I would rather not have that somewhat unpredictable behavior.
> 

Yeah, I saw that comment as well....

> I think I'd rather /always/ make a dirty log than sometimes do it, other
> times not. It'd just be more confusion for the admin IMHO.

Ok, some other alternative approaches I could think out in my mind
aren't trivial (e.g. some hack on log recovery, etc).. Any ideas /
thoughts about this are welcomed :) Thanks!

Thanks,
Gao Xiang

> 
> Thanks,
> -Eric
> 
> > Thanks,
> > Gao Xiang
> > 
> >>
> >> -Eric
> >>
> > 
> 

