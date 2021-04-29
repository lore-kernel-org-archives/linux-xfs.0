Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BDCC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 00:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D5761424
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 00:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhD2AkE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 20:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhD2AkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 20:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7859613F4;
        Thu, 29 Apr 2021 00:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619656758;
        bh=7skRQzN0Jg4hxeT/pDKbiRSiLQN+9FjManoMfXXoYeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gymfj/fIzcVqrNKXiJ8lNgaGgAtfBo1t7ZbUILZzxPhh/4wedoBTblARE9dhXT+JW
         H6H56C7mbgMB7VlFWpEGd+sZEq3xwi21Q/zkT15BDzWweqlx1fNc3v8sVwGxtf9+lX
         AL3lsfwR+nmLzROtQAIHKWWwb2IrBLlCjOg3o7uiOSBnGSP8+RiL5YIc/m0nFvkXr/
         4ljhzkBN98tPLD1k1BPthSVTXonDtW0tvd8XD2hv+yzQdpMuOeeNTJcULBoR0syw+g
         USnKD2Ve+wkKuIuf6OXuhcOO8CMoV73JBL5sEvjYr8llDa/L4ZbTZSkCTfBdZ3tej9
         cpamEpVsKzSQg==
Date:   Wed, 28 Apr 2021 17:39:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/5] generic/449: always fill up the data device
Message-ID: <20210429003918.GJ3122235@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958295276.3452351.11071488836337123863.stgit@magnolia>
 <YImftSB+Pa/LRZug@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YImftSB+Pa/LRZug@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 01:47:33PM -0400, Brian Foster wrote:
> On Tue, Apr 27, 2021 at 09:09:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is yet another one of those tests that looks at what happens when
> > we run out of space for more metadata (in this case, xattrs).  Make sure
> > that the 256M we write to the file to try to stimulate ENOSPC gets
> > written to the same place that xfs puts xattr data -- the data device.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/449 |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > 
> > diff --git a/tests/generic/449 b/tests/generic/449
> > index a2d882df..5fd15367 100755
> > --- a/tests/generic/449
> > +++ b/tests/generic/449
> > @@ -43,6 +43,11 @@ _require_attrs trusted
> >  _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> >  _scratch_mount || _fail "mount failed"
> >  
> > +# This is a test of xattr behavior when we run out of disk space for xattrs,
> > +# so make sure the pwrite goes to the data device and not the rt volume.
> > +test "$FSTYP" = "xfs" && \
> > +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +
> 
> This seems like the type of thing we'll consistently be playing
> whack-a-mole with unless we come up with a better way to manage it. I'm
> not sure what the solution for that is though, so:

I don't know either, sadly.  Most of the culprits are either
xfs-specific tests that fiddle with the disk format, or ENOSPC testers
that rely on data writes using the same space manager as metadata, or
vice versa.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  TFILE=$SCRATCH_MNT/testfile.$seq
> >  
> >  # Create the test file and choose its permissions
> > 
> 
