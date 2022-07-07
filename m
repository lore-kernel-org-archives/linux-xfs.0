Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE54C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 18:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiGGSI0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 14:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiGGSIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 14:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2DC83;
        Thu,  7 Jul 2022 11:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E14B822CC;
        Thu,  7 Jul 2022 18:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD195C3411E;
        Thu,  7 Jul 2022 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657217300;
        bh=RgxPrlTYUAr/uI+PuFpamDg9ijBkeK236jJD2oxXrY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pR5rGYntSbwUmtlxz1UQv2FFtVZVb+igJm9H7M7XmRdDYLYEQHh96qa3raLELGfaF
         q6rogPxBGzX+uJwXGDZYKt3KEEfo5Y/z4mcJgTpuoiXnQR77Ax5sxZ8c55Lyf7qXQt
         YwZx9IRKJq3pK7d1pnCIozoLTuz2MvgIlqKZ65Rp1RC3PgIPUQnhSDT9pv7ratTajH
         9f9jsh1okFTie81cqct/vhSXJbth3BdJrxm6iu/fuPj4fSWTK/LSKPBioyUREAZ5Fe
         39cRbCPq6dfjLrT9q2YbPac3ARCG6Hw66Ir5KG/qd5nHABf6BTDwAiGfZHs7KEYrYg
         oNW7M/g87VbHw==
Date:   Thu, 7 Jul 2022 11:08:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/288: skip repair -n when checking empty root
 leaf block behavior
Message-ID: <YschFMW4rVuQz9Mi@magnolia>
References: <165705854325.2821854.10317059026052442189.stgit@magnolia>
 <165705855433.2821854.6003804324518144422.stgit@magnolia>
 <20220707122525.so6alaa63hdz3bbx@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707122525.so6alaa63hdz3bbx@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 08:25:25PM +0800, Zorro Lang wrote:
> On Tue, Jul 05, 2022 at 03:02:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update this test to reflect the (once again) corrected behavior of the
> > xattr leaf block verifiers.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/288 |   32 +++++++++++++-------------------
> >  1 file changed, 13 insertions(+), 19 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/288 b/tests/xfs/288
> > index e3d230e9..aa664a26 100755
> > --- a/tests/xfs/288
> > +++ b/tests/xfs/288
> > @@ -8,7 +8,7 @@
> >  # that leaf directly (as xfsprogs commit f714016).
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto quick repair fuzzers
> > +_begin_fstest auto quick repair fuzzers attr
> >  
> >  # Import common functions.
> >  . ./common/filter
> > @@ -50,25 +50,19 @@ if [ "$count" != "0" ]; then
> >  	_notrun "xfs_db can't set attr hdr.count to 0"
> >  fi
> >  
> > -# make sure xfs_repair can find above corruption. If it can't, that
> > -# means we need to fix this bug on current xfs_repair
> > -_scratch_xfs_repair -n >> $seqres.full 2>&1
> 
> So we drop the `xfs_repair -n` test.

Yep.

> Will the latest xfs_repair fail or pass on that? I'm wondering what's the expect
> result of `xfs_repair -n` on a xfs with empty leaf? Should it report errors,
> or nothing wrong?

xfs_repair -n no longer fails on attr block 0 being an empty leaf block
since those are part of the ondisk format and are not a corruption.

xfs_repair (without the -n) will clear the attr fork since there aren't
any xattrs if attr block 0 is empty.

--D

> Thanks,
> Zorro
> 
> > -if [ $? -eq 0 ];then
> > -	_fail "xfs_repair can't find the corruption"
> > -else
> > -	# If xfs_repair can find this corruption, then this repair
> > -	# should junk above leaf attribute and fix this XFS.
> > -	_scratch_xfs_repair >> $seqres.full 2>&1
> > +# Check that xfs_repair discards the attr fork if block 0 is an empty leaf
> > +# block.  Empty leaf blocks at the start of the xattr data can be a byproduct
> > +# of a shutdown race, and hence are not a corruption.
> > +_scratch_xfs_repair >> $seqres.full 2>&1
> >  
> > -	# Old xfs_repair maybe find and fix this corruption by
> > -	# reset the first used heap value and the usedbytes cnt
> > -	# in ablock 0. That's not what we want. So check if
> > -	# xfs_repair has junked the whole ablock 0 by xfs_db.
> > -	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" | \
> > -		grep -q "no attribute data"
> > -	if [ $? -ne 0 ]; then
> > -		_fail "xfs_repair didn't junk the empty attr leaf"
> > -	fi
> > +# Old xfs_repair maybe find and fix this corruption by
> > +# reset the first used heap value and the usedbytes cnt
> > +# in ablock 0. That's not what we want. So check if
> > +# xfs_repair has junked the whole ablock 0 by xfs_db.
> > +_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" | \
> > +	grep -q "no attribute data"
> > +if [ $? -ne 0 ]; then
> > +	_fail "xfs_repair didn't junk the empty attr leaf"
> >  fi
> >  
> >  echo "Silence is golden"
> > 
> 
