Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D4DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 18:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiGGSFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 14:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236107AbiGGSF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 14:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2F12BB09;
        Thu,  7 Jul 2022 11:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC83762039;
        Thu,  7 Jul 2022 18:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D25C3411E;
        Thu,  7 Jul 2022 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657217126;
        bh=sVfNWtuiyMyoF9iJyzoeZK2AN0442XyPVb/3aA0K0bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M0yIzauU48phEt3SseDG2yobwXZfBhzTwsbLXLp5/kLH2yzLfVMcj2GguCFS8KTDj
         +HRWYgNonzCTAa91+AzpRp9/oz+zmv2AwAT1LQX2w9TVRUurKrrzFB6/MkSuiWAZE1
         tiFgo6NX62WNqUvT/wTTp30SJFw1bSZKNG3OBWoLu8bent/anuhNskhTvChbHKa2i4
         8mPxNSIkS4vEueg4EZ85n6RZfFGqZSUoh7/tTJKHt1Kx60prx5Ya0+eYRusC6KjPIi
         b3bFST2cE9wJWc0a4AFKvEQ0pdgnHhkXh8tpoW53jWVFcstIJP3B8K93t7CPL4ObQj
         WOcbBnABHyVCQ==
Date:   Thu, 7 Jul 2022 11:05:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/547: fix problems with realtime
Message-ID: <YscgZQsgDjkgEkQM@magnolia>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
 <165705853976.2820493.11634341636419465537.stgit@magnolia>
 <20220707131527.g73ablzdf7p7pmsu@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707131527.g73ablzdf7p7pmsu@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 09:15:27PM +0800, Zorro Lang wrote:
> On Tue, Jul 05, 2022 at 03:02:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This test needs to fragment the free space on the data device so that
> > each block added to the attr fork gets its own mapping.  If the test
> > configuration sets up a rt device and rtinherit=1 on the root dir, the
> > test will erroneously fragment space on the *realtime* volume.  When
> > this happens, attr fork allocations are contiguous and get merged into
> > fewer than 10 extents and the test fails.
> > 
> > Fix this test to force all allocations to be on the data device, and fix
> > incorrect variable usage in the error messages.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/547 |   14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/547 b/tests/xfs/547
> > index 9d4216ca..60121eb9 100755
> > --- a/tests/xfs/547
> > +++ b/tests/xfs/547
> > @@ -33,6 +33,10 @@ for nrext64 in 0 1; do
> >  		      >> $seqres.full
> >  	_scratch_mount >> $seqres.full
> >  
> > +	# Force data device extents so that we can fragment the free space
> > +	# and force attr fork allocations to be non-contiguous
> > +	_xfs_force_bdev data $SCRATCH_MNT
> > +
> >  	bsize=$(_get_file_block_size $SCRATCH_MNT)
> >  
> >  	testfile=$SCRATCH_MNT/testfile
> > @@ -76,13 +80,15 @@ for nrext64 in 0 1; do
> >  	acnt=$(_scratch_xfs_get_metadata_field core.naextents \
> >  					       "path /$(basename $testfile)")
> >  
> > -	if (( $dcnt != 10 )); then
> > -		echo "Invalid data fork extent count: $dextcnt"
> > +	echo "nrext64: $nrext64 dcnt: $dcnt acnt: $acnt" >> $seqres.full
> > +
> > +	if [ -z "$dcnt" ] || (( $dcnt != 10 )); then
> 
> I'm wondering why we need to use bash ((...)) operator at here, is $dcnt
> an expression? Can [ "$dcnt" != "10" ] help that?

dcnt should be a decimal number, or the empty string if the xfs_db
totally failed.  The fancy comparison protects against xfs_db someday
returning results in hexadecimal or a non-number string, but I don't
think it'll ever do that.  I think your suggestion would work for this
case.

I don't think it works so well for the second case, since the fancy
comparison "(( $acnt < 10 ))" apparently returns false even if acnt is
non-numeric, whereas "[ $acnt -lt 10 ]" would error out.

--D

> Thanks,
> Zorro
> 
> > +		echo "Invalid data fork extent count: $dcnt"
> >  		exit 1
> >  	fi
> >  
> > -	if (( $acnt < 10 )); then
> > -		echo "Invalid attr fork extent count: $aextcnt"
> > +	if [ -z "$acnt" ] || (( $acnt < 10 )); then
> > +		echo "Invalid attr fork extent count: $acnt"
> >  		exit 1
> >  	fi
> >  done
> > 
> 
