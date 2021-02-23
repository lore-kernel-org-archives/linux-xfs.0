Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779CFC433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 16:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3413364DA8
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 16:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhBWQ0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233542AbhBWQ0B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 11:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5B9064E61;
        Tue, 23 Feb 2021 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614097519;
        bh=L6RyhuMz4LzKTPxhWWWIqy5rxmctdEM8L25oAtLFo3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I3OZySxYQRD/2xF/E13j6pmYHwM4HZoT07nqBQ/gauz1OkdK8YkeNJhcSjtj3NGwf
         llJ8hVDcGeutj1MHMLfjSXwY2/oQrux+eI1a08LLNdHV+NFih8GTic5AkKVURnt/GZ
         bmQlT066dn8k/BZiEDUvqUlYVYScovA0I4N4CaPriUB1hwSfdmfnWyyAXTvwtdT2Mf
         nmZ9pCIe5fbnbdjzqpsNJvZACEAbKlSNOeaTixLaLS5NJOp83anKn4uoLNpnGwuc5S
         AtV0mgAs+oGaYvFJY1rWaocKpqWTB0TVJbVE6wwm7Ch9uQ1yEsHCj12aRJmeVUV6z+
         Buw3iZU/rWkSQ==
Date:   Tue, 23 Feb 2021 08:25:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <20210223162519.GI7272@magnolia>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97534412-b95d-48f8-0a5a-3eafe47d72a6@sandeen.net>
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

Yes, I know of cloudy image generation factories that use old versions
of RHEL to generate images that are then frozen and copied to a
deployment system without an unmount.  I don't understand why they
insist that unmount is "too slow" but freeze isn't, nor why they then
file bugs that their instance deploy process is unacceptably slow
because of log recovery.

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
> I think I'd rather /always/ make a dirty log than sometimes do it, other
> times not. It'd just be more confusion for the admin IMHO.

...but the next time anyone wants to introduce a new in/rocompat feature
flag for something inode related, then you can disable the "leave a
dirty log on freeze if there are unlinked inodes" behavior.

--D

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
