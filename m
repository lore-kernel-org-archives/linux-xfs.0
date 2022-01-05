Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08535C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 19:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243362AbiAETKC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 14:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243363AbiAETJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 14:09:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7A3C061245;
        Wed,  5 Jan 2022 11:09:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F50618E1;
        Wed,  5 Jan 2022 19:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F22C36AE0;
        Wed,  5 Jan 2022 19:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641409797;
        bh=1m7JNzEs6h7AUbdTf9WL1gJ+URfwbVnYu243vT+/00E=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=fCiw785/QNNK/3p6u3BjCIuLHg8GUtllV7ZcMi51Eu2LQwiQlefLJ9iOCQna1I8qI
         UxN2PW6qdzTYX+gL1BCBKhITJw7VQA//3P3DwsXb59hOYUdVGhCKBErNygEXI8noPE
         lmoYiltSwOtAMB9wA2PvQTwI/SFz/PUagTaFXHPnF9tUrMSBbizibQ4VLdcbW7cPvJ
         xdc4b1fLNZYPUq3cTiAGkhzT1jwWLOrnuWz2fLiyQeHVv2XkOSP3Ptarm74YFa9Uzl
         SffWzU3u+P+ZBGHy4Xb4boBHVO57BLhga1sls2NCAcOTvnbpu/SbnmLxBMI1sUqg2s
         iV9lcVf1GpMbA==
Date:   Wed, 5 Jan 2022 11:09:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>, zlang@redhat.com
Subject: Re: [PATCH] xfs/014: try a few times to create speculative
 preallocations
Message-ID: <20220105190957.GJ656707@magnolia>
References: <20220104020417.GB31566@magnolia>
 <20220105161905.jaobft32wosjy3fv@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105161905.jaobft32wosjy3fv@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 06, 2022 at 12:19:05AM +0800, Zorro Lang wrote:
> On Mon, Jan 03, 2022 at 06:04:17PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This test checks that speculative file preallocations are transferred to
> > threads writing other files when space is low.  Since we have background
> > threads to clear those preallocations, it's possible that the test
> > program might not get a speculative preallocation on the first try.
> > 
> > This problem has become more pronounced since the introduction of
> > background inode inactivation since userspace no longer has direct
> > control over the timing of file blocks being released from unlinked
> > files.  As a result, the author has seen an increase in sporadic
> > warnings from this test about speculative preallocations not appearing.
> > 
> > Therefore, modify the function to try up to five times to create the
> > speculative preallocation before emitting warnings that then cause
> > golden output failures.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/014 |   41 +++++++++++++++++++++++++----------------
> >  1 file changed, 25 insertions(+), 16 deletions(-)
> > 
> > diff --git a/tests/xfs/014 b/tests/xfs/014
> > index a605b359..1f0ebac3 100755
> > --- a/tests/xfs/014
> > +++ b/tests/xfs/014
> > @@ -33,27 +33,36 @@ _cleanup()
> >  # failure.
> >  _spec_prealloc_file()
> >  {
> > -	file=$1
> > +	local file=$1
> > +	local prealloc_size=0
> > +	local i=0
> >  
> > -	rm -f $file
> > +	# Now that we have background garbage collection processes that can be
> > +	# triggered by low space/quota conditions, it's possible that we won't
> > +	# succeed in creating a speculative preallocation on the first try.
> > +	for ((tries = 0; tries < 5 && prealloc_size == 0; tries++)); do
> > +		rm -f $file
> >  
> > -	# a few file extending open-write-close cycles should be enough to
> > -	# trigger the fs to retain preallocation. write 256k in 32k intervals to
> > -	# be sure
> > -	for i in $(seq 0 32768 262144); do
> > -		$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> > +		# a few file extending open-write-close cycles should be enough
> > +		# to trigger the fs to retain preallocation. write 256k in 32k
> > +		# intervals to be sure
> > +		for i in $(seq 0 32768 262144); do
> > +			$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> > +		done
> > +
> > +		# write a 4k aligned amount of data to keep the calculations
> > +		# simple
> > +		$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
> > +
> > +		size=`_get_filesize $file`
> > +		blocks=`stat -c "%b" $file`
> > +		blocksize=`stat -c "%B" $file`
> > +
> > +		prealloc_size=$((blocks * blocksize - size))
> 
> So we only try same pwrite operations 5 times, and only check the prealloc_size after 5
> times done? Should we break from this loop once prealloc_size > 0?

The second clause of the for loop tests for that, does it not?

--D

> 
> Thanks,
> Zorro
> 
> >  	done
> >  
> > -	# write a 4k aligned amount of data to keep the calculations simple
> > -	$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
> > -
> > -	size=`_get_filesize $file`
> > -	blocks=`stat -c "%b" $file`
> > -	blocksize=`stat -c "%B" $file`
> > -
> > -	prealloc_size=$((blocks * blocksize - size))
> >  	if [ $prealloc_size -eq 0 ]; then
> > -		echo "Warning: No speculative preallocation for $file." \
> > +		echo "Warning: No speculative preallocation for $file after $tries iterations." \
> >  			"Check use of the allocsize= mount option."
> >  	fi
> >  
> > 
> 
