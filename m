Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8610EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 15:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4604664E61
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 15:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhBWPHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 10:07:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhBWPHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 10:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614092733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DarpnSYgCZTgyQMQ1MznbzajY5yWtTd6xD5DVrtS9f0=;
        b=eYV2vmsA6tnxjgfyMHaOg5hBuP+/TUN9y3Gw08N4KTZnai9r+I52ZJn/OGwRx8eD1PAMzd
        rfVRhwnPfnenWfixt+yMmH3Of7R4khLOEBnSS/D86M4UZemJ9LH6kYx0I3B8ci9jb99D0n
        NvGYLYsymYzagn9m8jYvxVw1aSQkvKU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-WPZbRiRONG2g9djQpOvSwg-1; Tue, 23 Feb 2021 10:04:45 -0500
X-MC-Unique: WPZbRiRONG2g9djQpOvSwg-1
Received: by mail-pl1-f200.google.com with SMTP id d8so10205478plo.23
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 07:04:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DarpnSYgCZTgyQMQ1MznbzajY5yWtTd6xD5DVrtS9f0=;
        b=ThlZo7Z76T28G858J5kQPm7PM2ZraomUAmXQLkCmNmvBDLdEOC11Ga41zmYOgla1hG
         F0n3mC6J4zxYvICRRMMbHC06yMLvomrqYnqy1dpT645H2f4C4RyZPqZ/SyEt3Ebc9qZi
         ir0eSaFGZmBr4LTaEULOZDJNbv6EgqN5wRawHQQpkEM5Z0/a+ZybNh6sIkDe82TTp3yq
         eThMmICxaKlkLQ7uSRH3nbvbA3yNwyqrtAFthNR0VbCUKVSXdc4qCO6jZxt1Lp223B2l
         MrRuXnkg4VRQt2y+LOoQ2+ODAzR1diNMkLfwuvBN/z3sxKF/aMC9GI/8ctQfm3VrAIi+
         vePQ==
X-Gm-Message-State: AOAM531ecLKEAkVDYKk3m2Ci/rxsAqGhRm5KB4/udDd9Q3QKwc7wMDlN
        FSERV/NT8nHd5H1KGFaWEE6jcc+U0FDtMR65oGsOccXohTzPSBhvUlyayK+19fa3gVsJaWGvvSm
        A8vh4dGZEOMQrCzifEgy6
X-Received: by 2002:a17:90a:a117:: with SMTP id s23mr18004471pjp.208.1614092683968;
        Tue, 23 Feb 2021 07:04:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyxjz09PvyQfmTrmQp6XHW0L7UQSsAoJo+O608YdIPpChUJ4yzqpSJB0Eli1RMeQSfsBRFKw==
X-Received: by 2002:a17:90a:a117:: with SMTP id s23mr18004446pjp.208.1614092683738;
        Tue, 23 Feb 2021 07:04:43 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k15sm9355130pfh.17.2021.02.23.07.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 07:03:54 -0800 (PST)
Date:   Tue, 23 Feb 2021 23:03:41 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <20210223150341.GA1341686@xiangao.remote.csb>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia>
 <20180326124649.GD34912@bfoster.bfoster>
 <20180327211728.GP18129@dastard>
 <20210223134256.GA1327978@xiangao.remote.csb>
 <a3a02b9b-656a-7284-d1b1-befbafc3e9f9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3a02b9b-656a-7284-d1b1-befbafc3e9f9@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 08:40:56AM -0600, Eric Sandeen wrote:
> On 2/23/21 7:42 AM, Gao Xiang wrote:
> > Hi folks,
> > 
> > On Wed, Mar 28, 2018 at 08:17:28AM +1100, Dave Chinner wrote:
> >> On Mon, Mar 26, 2018 at 08:46:49AM -0400, Brian Foster wrote:
> >>> On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
> >>>> On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
> >>>>> Now that unlinked inode recovery is done outside of
> >>>>> log recovery, there is no need to dirty the log on
> >>>>> snapshots just to handle unlinked inodes.  This means
> >>>>> that readonly snapshots can be mounted without requiring
> >>>>> -o ro,norecovery to avoid the log replay that can't happen
> >>>>> on a readonly block device.
> >>>>>
> >>>>> (unlinked inodes will just hang out in the agi buckets until
> >>>>> the next writable mount)
> >>>>
> >>>> FWIW I put these two in a test kernel to see what would happen and
> >>>> generic/311 failures popped up.  It looked like the _check_scratch_fs
> >>>> found incorrect block counts on the snapshot(?)
> >>>>
> >>>
> >>> Interesting. Just a wild guess, but perhaps it has something to do with
> >>> lazy sb accounting..? I see we call xfs_initialize_perag_data() when
> >>> mounting an unclean fs.
> >>
> >> The freeze is calls xfs_log_sbcount() which should update the
> >> superblock counters from the in-memory counters and write them to
> >> disk.
> >>
> >> If they are out, I'm guessing it's because the in-memory per-ag
> >> reservations are not being returned to the global pool before the
> >> in-memory counters are summed during a freeze....
> >>
> >> Cheers,
> >>
> >> Dave.
> >> -- 
> >> Dave Chinner
> >> david@fromorbit.com
> > 
> > I spend some time on tracking this problem. I've made a quick
> > modification with per-AG reservation and tested with generic/311
> > it seems fine. My current question is that how such fsfreezed
> > images (with clean mount) work with old kernels without [PATCH 1/1]?
> > I'm afraid orphan inodes won't be freed with such old kernels....
> > Am I missing something?
> 
> It's true, a snapshot created with these patches will not have their unlinked
> inodes processed if mounted on an older kernel. I'm not sure how much of a
> problem that is; the filesystem is not inconsistent, but some space is lost,
> I guess. I'm not sure it's common to take a snapshot of a frozen filesystem on
> one kernel and then move it back to an older kernel.  Maybe others have
> thoughts on this.

My current thought might be only to write clean mount without
unlinked inodes when freezing, but leave log dirty if any
unlinked inodes exist as Brian mentioned before and don't
handle such case (?). I'd like to hear more comments about
this as well.

Thanks,
Gao Xiang

> 
> -Eric
> 

