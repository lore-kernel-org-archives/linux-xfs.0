Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEAAC47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 11:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FFB8613AB
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 11:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhFHLuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 07:50:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232134AbhFHLuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 07:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623152889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lQqNGa8RXRjpqzgykt53Ay9zVXKPLj6nX6sYPWGsGW0=;
        b=BhijHHm9Hr7FaFya8v/OKFAS7rY/RPQfgWXx/uug8zRBs1nBNTnwbfjdH9mi2CsWg2e/bT
        7N81ewahprgJ4zyRSQYGY3DutV8TqNPZcC5ELdIlkkKss0QgjNlJpPWJps50qmxjxi5/Ks
        mnUz4oY6SDRRworjdXR4BVUFnHnOQY4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-B8cTutGkMJmq-6Klchinog-1; Tue, 08 Jun 2021 07:48:08 -0400
X-MC-Unique: B8cTutGkMJmq-6Klchinog-1
Received: by mail-qt1-f199.google.com with SMTP id i24-20020ac876580000b02902458afcb6faso4992726qtr.23
        for <linux-xfs@vger.kernel.org>; Tue, 08 Jun 2021 04:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lQqNGa8RXRjpqzgykt53Ay9zVXKPLj6nX6sYPWGsGW0=;
        b=gcD5f8AQucBzZlHCK7+zWjSiB6q44VRuVQ4xegW1jxNtEufpWZQK+l/ZvvstbeOPEJ
         sAMxjHxFEcolqQCPzpqSnyvv9ICqznmzyuMg6psUX5eakDVYKdSSlkaKIY8oUN/xwSy6
         UqV95Tpy2cKrxllMp7Ph9iFopN4tUVwiYxro8+XS1XkmsKEsC45u9KeMe3fE2SmJo6VX
         eVwdpmhVVDE7JlBjazIjjJN/rpHiBNeKqy5yDPNHihUjN5KxmG8uVBwkjRiRF0z2C7he
         DAnA2QCb2fihhI9DBpfAOtCzO/mPR9TZzaVM0lpvrWNCRqsnyPsKo4cp6H47V6Eya7s3
         CcuA==
X-Gm-Message-State: AOAM533a89eHmhloX164hJPcC2Wjud9iH95dbc9P0XG6O2Ngc2J+vJkO
        MZARmTEuGLc59LwJ+Lv81dLna+GSH9HH1ZR2phxBF4R+rk+61In3IR08w/KLWggOxtsCtVozt8u
        O0GrZjPw1TIcXxgoFtsTD
X-Received: by 2002:a37:8343:: with SMTP id f64mr20831602qkd.12.1623152887914;
        Tue, 08 Jun 2021 04:48:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkaLDz6zc+zB+oYwoOK5AB5r/I4/IMwlnYoZteMULYMvR2Xnp0zDv+ag1oqBgT+2KHUtLUNw==
X-Received: by 2002:a37:8343:: with SMTP id f64mr20831583qkd.12.1623152887618;
        Tue, 08 Jun 2021 04:48:07 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id t201sm6480318qka.49.2021.06.08.04.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 04:48:07 -0700 (PDT)
Date:   Tue, 8 Jun 2021 07:48:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/9] xfs: force inode garbage collection before fallocate
 when space is low
Message-ID: <YL9Y9YM6VtxSnq+c@bfoster>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310472140.3465262.3509717954267805085.stgit@locust>
 <20210608012605.GI664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608012605.GI664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 11:26:05AM +1000, Dave Chinner wrote:
> On Mon, Jun 07, 2021 at 03:25:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Generally speaking, when a user calls fallocate, they're looking to
> > preallocate space in a file in the largest contiguous chunks possible.
> > If free space is low, it's possible that the free space will look
> > unnecessarily fragmented because there are unlinked inodes that are
> > holding on to space that we could allocate.  When this happens,
> > fallocate makes suboptimal allocation decisions for the sake of deleted
> > files, which doesn't make much sense, so scan the filesystem for dead
> > items to delete to try to avoid this.
> > 
> > Note that there are a handful of fstests that fill a filesystem, delete
> > just enough files to allow a single large allocation, and check that
> > fallocate actually gets the allocation.  These tests regress because the
> > test runs fallocate before the inode gc has a chance to run, so add this
> > behavior to maintain as much of the old behavior as possible.
> 
> I don't think this is a good justification for the change. Just
> because the unit tests exploit an undefined behaviour that no
> filesystem actually guarantees to acheive a specific layout, it
> doesn't mean we always have to behave that way.
> 
> For example, many tests used to use reverse sequential writes to
> exploit deficiencies in the allocation algorithms to generate
> fragmented files. We fixed that problem and the tests broke because
> they couldn't fragment files any more.
> 
> Did we reject those changes because the tests broke? No, we didn't
> because the tests were exploiting an observed behaviour rather than
> a guaranteed behaviour.
> 
> So, yeah, "test does X to make Y happen" doesn't mean "X will always
> make Y happen". It just means the test needs to be made more robust,
> or we have to provide a way for the test to trigger the behaviour it
> needs.
> 

Agree on all this..

> Indeed, I think that the way to fix these sorts of issues is to have
> the tests issue a syncfs(2) after they've deleted the inodes and have
> the filesystem run a inodegc flush as part of the sync mechanism.
> 

... but it seems a bit of a leap to equate exploitation of a
historically poorly handled allocation pattern in developer tests with
adding a new requirement (i.e. sync) to achieve optimal behavior of a
fairly common allocation pattern (delete a file, use the space for
something else).

IOW, how to hack around test regressions aside (are the test regressions
actual ENOSPC failures or something else, btw?), what's the impact on
users/workloads that might operate under these conditions? I guess
historically we've always recommended to not consistently operate in
<20% free space conditions, so to some degree there is an expectation
for less than optimal behavior if one decides to constantly bash an fs
into ENOSPC. Then again with large enough files, will/can we put the
filesystem into that state ourselves without any indication to the user?

I kind of wonder if unless/until there's some kind of efficient feedback
between allocation and "pending" free space, whether deferred
inactivation should be an optimization tied to some kind of heuristic
that balances the amount of currently available free space against
pending free space (but I've not combed through the code enough to grok
whether this already does something like that).

Brian

> Then we don't need to do.....
> 
> > +/*
> > + * If the target device (or some part of it) is full enough that it won't to be
> > + * able to satisfy the entire request, try to free inactive files to free up
> > + * space.  While it's perfectly fine to fill a preallocation request with a
> > + * bunch of short extents, we prefer to slow down preallocation requests to
> > + * combat long term fragmentation in new file data.
> > + */
> > +static int
> > +xfs_alloc_consolidate_freespace(
> > +	struct xfs_inode	*ip,
> > +	xfs_filblks_t		wanted)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_perag	*pag;
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> > +	xfs_agnumber_t		agno;
> > +
> > +	if (!xfs_has_inodegc_work(mp))
> > +		return 0;
> > +
> > +	if (XFS_IS_REALTIME_INODE(ip)) {
> > +		if (sbp->sb_frextents * sbp->sb_rextsize >= wanted)
> > +			return 0;
> > +		goto free_space;
> > +	}
> > +
> > +	for_each_perag(mp, agno, pag) {
> > +		if (pag->pagf_freeblks >= wanted) {
> > +			xfs_perag_put(pag);
> > +			return 0;
> > +		}
> > +	}
> 
> ... really hurty things (e.g. on high AG count fs) on every fallocate()
> call, and we have a simple modification to the tests that allow them
> to work as they want to on both old and new kernels....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

