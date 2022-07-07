Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC65CCA479
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 22:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiGGWKK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGGWKK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 18:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1BF1F2C0;
        Thu,  7 Jul 2022 15:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81D6162414;
        Thu,  7 Jul 2022 22:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1285C3411E;
        Thu,  7 Jul 2022 22:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657231807;
        bh=3dj8vPaRVVtQHqAxHEuZna9RP5oEmKNkKObzxWwJhnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BmITM7SFEJriC0fdsktFg40Crw9/anYAJOw9pOAWkQYi+EZD9RFcnqsFbNCZLDM/8
         mNaRNXYjOtO3g2kKzKsnEmsdSRYPgQOFxom7tG90CWwkDj3UiehbqNZP40uP0yk/lO
         VcDnBmHjEgZE64myseD62izmBZY3j/TVaFfRW57b1PWw8PXpnphACwrn+zpF4jxHEj
         pTAS8TQYl21PVlexopRx+I5VZv+FMDrdEh++LjUu8jDb+e6a9sak833owvU2BR5gjc
         yZZX9yZiZa5STXcf1fBQTbv6s64+AzVByJpWC2xpfJ1l42lD5FPCyue2f+kPcIM0mQ
         woMsEN1+/kmwA==
Date:   Thu, 7 Jul 2022 15:10:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me,
        Catherine Hoang <catherine.hoang@oracle.com>
Subject: Re: [PATCH 2/3] xfs/018: fix LARP testing for small block sizes
Message-ID: <YsdZv6AF7tyalkZz@magnolia>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
 <165705853409.2820493.9590517059305128125.stgit@magnolia>
 <YscglleRpAIkrHiA@magnolia>
 <89d1e21b688d880b200f9dd32891023b55726735.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89d1e21b688d880b200f9dd32891023b55726735.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 02:55:07PM -0700, Alli wrote:
> On Thu, 2022-07-07 at 11:06 -0700, Darrick J. Wong wrote:
> > I guess I should've cc'd Allison and Catherine on this one.
> > 
> > Could either of you review these test changes, please?
> > 
> > --D
> > 
> > On Tue, Jul 05, 2022 at 03:02:14PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Fix this test to work properly when the filesystem block size is
> > > less
> > > than 4k.  Tripping the error injection points on shape changes in
> > > the
> > > xattr structure must be done dynamically.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/018     |   52
> > > +++++++++++++++++++++++++++++++++++++++++++++++-----
> > >  tests/xfs/018.out |   16 ++++------------
> > >  2 files changed, 51 insertions(+), 17 deletions(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/018 b/tests/xfs/018
> > > index 041a3b24..14a6f716 100755
> > > --- a/tests/xfs/018
> > > +++ b/tests/xfs/018
> > > @@ -54,6 +54,45 @@ test_attr_replay()
> > >  	echo ""
> > >  }
> > >  
> > > +test_attr_replay_loop()
> > > +{
> > > +	testfile=$testdir/$1
> > > +	attr_name=$2
> > > +	attr_value=$3
> > > +	flag=$4
> > > +	error_tag=$5
> > > +
> > > +	# Inject error
> > > +	_scratch_inject_error $error_tag
> > > +
> > > +	# Set attribute; hopefully 1000 of them is enough to cause
> > > whatever
> > > +	# attr structure shape change that the caller wants to test.
> > > +	for ((i = 0; i < 1024; i++)); do
> > > +		echo "$attr_value" | \
> > > +			${ATTR_PROG} -$flag "$attr_name$i" $testfile >
> > > $tmp.out 2> $tmp.err
> > > +		cat $tmp.out $tmp.err >> $seqres.full
> > > +		cat $tmp.err | _filter_scratch | sed -e 's/attr_name[0-
> > > 9]*/attr_nameXXXX/g'
> > > +		touch $testfile &>/dev/null || break
> > > +	done
> > > +
> > > +	# FS should be shut down, touch will fail
> > > +	touch $testfile 2>&1 | _filter_scratch
> > > +
> > > +	# Remount to replay log
> > > +	_scratch_remount_dump_log >> $seqres.full
> > > +
> > > +	# FS should be online, touch should succeed
> > > +	touch $testfile
> > > +
> > > +	# Verify attr recovery
> > > +	$ATTR_PROG -l $testfile >> $seqres.full
> > > +	echo "Checking contents of $attr_name$i" >> $seqres.full
> > > +	echo -n "${attr_name}XXXX: "
> > > +	$ATTR_PROG -q -g $attr_name$i $testfile 2> /dev/null | md5sum;
> > > +
> > > +	echo ""
> > > +}
> > > +
> 
> 
> Ok, I think I see what you are trying to do, but I think we can do it
> with less duplicated code and looping functions.  What about something
> like this:
> 
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 041a3b24..dc1324b1 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -95,6 +95,9 @@ attr16k="$attr8k$attr8k"
>  attr32k="$attr16k$attr16k"
>  attr64k="$attr32k$attr32k"
>  
> +blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> +multiplier=$(( $blk_sz / 256 ))

The scratch fs hasn't been formatted yet, but if you use _get_block_size
after it's mounted, then, yes, I'm with you so far.

> +
>  echo "*** mkfs"
>  _scratch_mkfs >/dev/null
>  
> @@ -140,7 +143,7 @@ test_attr_replay extent_file1 "attr_name2" $attr1k
> "s" "larp"
>  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
>  
>  # extent, inject error on split
> -create_test_file extent_file2 3 $attr1k
> +create_test_file extent_file2 $(( $multiplier - 1 )) $attr256

Hm.  The calculations seem slightly off here -- name is ~8 bytes long,
the value is 256 bytes, which means there's at least 264 bytes per attr.
I guess you do only create multiplier-1 attrs, though, so that probably
works for all the blocksizes I can think of...

>  test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"

If we keep the 1k attr value here, do we still trip the leaf split even
if that 1k value ends up in a remote block?

>  # extent, inject error on fork transition
> 
> 
> 
> Same idea right?  We bring the attr fork right up and to the edge of
> the block boundary and then pop it?  And then of course we apply the
> same pattern to the rest of the tests.  I think that sort of reads
> cleaner too.

Right, I think that would work in principle.  Does the same sort of fix
apply to the "extent, inject error on fork transition" case too?

--D

> Allison
> 
> > >  create_test_file()
> > >  {
> > >  	filename=$testdir/$1
> > > @@ -88,6 +127,7 @@ echo 1 > /sys/fs/xfs/debug/larp
> > >  attr16="0123456789ABCDEF"
> > >  attr64="$attr16$attr16$attr16$attr16"
> > >  attr256="$attr64$attr64$attr64$attr64"
> > > +attr512="$attr256$attr256"
> > >  attr1k="$attr256$attr256$attr256$attr256"
> > >  attr4k="$attr1k$attr1k$attr1k$attr1k"
> > >  attr8k="$attr4k$attr4k"
> > > @@ -140,12 +180,14 @@ test_attr_replay extent_file1 "attr_name2"
> > > $attr1k "s" "larp"
> > >  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> > >  
> > >  # extent, inject error on split
> > > -create_test_file extent_file2 3 $attr1k
> > > -test_attr_replay extent_file2 "attr_name4" $attr1k "s"
> > > "da_leaf_split"
> > > +create_test_file extent_file2 0 $attr1k
> > > +test_attr_replay_loop extent_file2 "attr_name" $attr1k "s"
> > > "da_leaf_split"
> > >  
> > > -# extent, inject error on fork transition
> > > -create_test_file extent_file3 3 $attr1k
> > > -test_attr_replay extent_file3 "attr_name4" $attr1k "s"
> > > "attr_leaf_to_node"
> > > +# extent, inject error on fork transition.  The attr value must be
> > > less than
> > > +# a full filesystem block so that the attrs don't use remote xattr
> > > values,
> > > +# which means we miss the leaf to node transition.
> > > +create_test_file extent_file3 0 $attr1k
> > > +test_attr_replay_loop extent_file3 "attr_name" $attr512 "s"
> > > "attr_leaf_to_node"
> > >  
> > >  # extent, remote
> > >  create_test_file extent_file4 1 $attr1k
> > > diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> > > index 022b0ca3..c3021ee3 100644
> > > --- a/tests/xfs/018.out
> > > +++ b/tests/xfs/018.out
> > > @@ -87,22 +87,14 @@ Attribute "attr_name1" has a 1024 byte value
> > > for SCRATCH_MNT/testdir/extent_file
> > >  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
> > >  
> > >  attr_set: Input/output error
> > > -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> > > +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
> > >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2':
> > > Input/output error
> > > -Attribute "attr_name4" has a 1025 byte value for
> > > SCRATCH_MNT/testdir/extent_file2
> > > -Attribute "attr_name2" has a 1024 byte value for
> > > SCRATCH_MNT/testdir/extent_file2
> > > -Attribute "attr_name3" has a 1024 byte value for
> > > SCRATCH_MNT/testdir/extent_file2
> > > -Attribute "attr_name1" has a 1024 byte value for
> > > SCRATCH_MNT/testdir/extent_file2
> > > -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > > +attr_nameXXXX: 9fd415c49d67afc4b78fad4055a3a376  -
> > >  
> > >  attr_set: Input/output error
> > > -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> > > +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
> > >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3':
> > > Input/output error
> > > -Attribute "attr_name4" has a 1025 byte value for
> > > SCRATCH_MNT/testdir/extent_file3
> > > -Attribute "attr_name2" has a 1024 byte value for
> > > SCRATCH_MNT/testdir/extent_file3
> > > -Attribute "attr_name3" has a 1024 byte value for
> > > SCRATCH_MNT/testdir/extent_file3
> > > -Attribute "attr_name1" has a 1024 byte value for
> > > SCRATCH_MNT/testdir/extent_file3
> > > -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > > +attr_nameXXXX: a597dc41e4574873516420a7e4e5a3e0  -
> > >  
> > >  attr_set: Input/output error
> > >  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> > > 
> 
