Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975B6C3F6B0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 04:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiHEEc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 00:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiHEEcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 00:32:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FAC20BC3;
        Thu,  4 Aug 2022 21:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4D91B82029;
        Fri,  5 Aug 2022 04:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9CAC433D6;
        Fri,  5 Aug 2022 04:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659673971;
        bh=4EoxUGyX9Jv2o2xA2FF0Uv5YF7PPy0/YFjstr/bTL6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SF5qpeuJbllFnsWXCOngAwbQvzsS3CCMp9PUSYK257LGnG5jwT9WznVo9lBkXaoK/
         EXC3pQhMYUwny0mDJlfVde1Aw6dxtalx6ksjWkS4C56FLOWt+mAyVnEjOoJX01ePlu
         NhzDorlAKwqTYJyZbKL2hbdgfkhgyiSJnVmm6wniUKhIIQdT8rMSsPFw0uXfB8x1vT
         7/2hz1WErThGG7gZwuVUZqF0BRHo7UxC0AkBk4CguvXMgEXm4Ayea0VSWp5EfsO0DD
         giHdNUKBVECXjEj+v8aJmsznHlKqlMfzQCOL9PQbVBMJ8GsBxkAvBoeepSon9Jd6Kh
         FV1yHbaN38GRw==
Date:   Thu, 4 Aug 2022 21:32:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3 1/1] xfs/018: fix LARP testing for small block sizes
Message-ID: <Yuydc1fRmee0+a/b@magnolia>
References: <20220805005552.34449-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805005552.34449-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 05:55:52PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix this test to work properly when the filesystem block size is less
> than 4k.  Tripping the error injection points on shape changes in the
> xattr structure must be done dynamically.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Hmm, this patch got its start with things that I wrote...

> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  tests/xfs/018     | 15 ++++++++++-----
>  tests/xfs/018.out | 43 ++-----------------------------------------
>  2 files changed, 12 insertions(+), 46 deletions(-)
> 
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 041a3b24..1b45edf4 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -47,7 +47,8 @@ test_attr_replay()
>  	touch $testfile
>  
>  	# Verify attr recovery
> -	$ATTR_PROG -l $testfile | _filter_scratch
> +	$ATTR_PROG -l $testfile >> $seqres.full
> +	echo "Checking contents of $attr_name" >> $seqres.full
>  	echo -n "$attr_name: "
>  	$ATTR_PROG -q -g $attr_name $testfile 2> /dev/null | md5sum;
>  
> @@ -98,6 +99,10 @@ attr64k="$attr32k$attr32k"
>  echo "*** mkfs"
>  _scratch_mkfs >/dev/null
>  
> +blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> +err_inj_attr_sz=$(( blk_sz / 3 - 50 ))
> +err_inj_attr_val=$(printf "A%.0s" $(seq $err_inj_attr_sz))

...though I think this particular strategy (using attr values that are
~1/3 the block size) is novel.  I wonder if this deserves a comment on
the calculation, though?

I think the idea here is that we want to build up exactly one attr leaf
block by setting user.attr_name[1-3]; and then the fourth one is
guaranteed to cause a split in the fileoff 0 leaf block, which is enough
to trip both the da_leaf_split and attr_leaf_to_node injectors?

The reason why we have the same userspace code but two different trip
points is that we're trying to test recovery from two different points
in the xattr state machine, right?  So the test code looks identical,
but we're testing two separate things, right?

Assuming that all three answers are yes, then I'm satisfied by this new
approach that is much simpler than the one I came up with:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
>  echo "*** mount FS"
>  _scratch_mount
>  
> @@ -140,12 +145,12 @@ test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
>  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
>  
>  # extent, inject error on split
> -create_test_file extent_file2 3 $attr1k
> -test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
> +create_test_file extent_file2 3 $err_inj_attr_val
> +test_attr_replay extent_file2 "attr_name4" $attr256 "s" "da_leaf_split"
>  
>  # extent, inject error on fork transition
> -create_test_file extent_file3 3 $attr1k
> -test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
> +create_test_file extent_file3 3 $err_inj_attr_val
> +test_attr_replay extent_file3 "attr_name4" $attr256 "s" "attr_leaf_to_node"
>  
>  # extent, remote
>  create_test_file extent_file4 1 $attr1k
> diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> index 022b0ca3..415ecd7a 100644
> --- a/tests/xfs/018.out
> +++ b/tests/xfs/018.out
> @@ -4,7 +4,6 @@ QA output created by 018
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> -Attribute "attr_name" has a 65 byte value for SCRATCH_MNT/testdir/empty_file1
>  attr_name: cfbe2a33be4601d2b655d099a18378fc  -
>  
>  attr_remove: Input/output error
> @@ -15,7 +14,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> -Attribute "attr_name" has a 1025 byte value for SCRATCH_MNT/testdir/empty_file2
>  attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
> @@ -26,7 +24,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> -Attribute "attr_name" has a 65536 byte value for SCRATCH_MNT/testdir/empty_file3
>  attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
> @@ -37,132 +34,96 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
> -Attribute "attr_name2" has a 65 byte value for SCRATCH_MNT/testdir/inline_file1
>  attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> -Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/inline_file2
> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
>  attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> -Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/inline_file3
> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
>  attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
> -Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file1
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
>  attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
> -Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> +attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
> -Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> +attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
> -Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/extent_file4
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
>  attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
> -Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/remote_file1
> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
>  attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
> -Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
>  attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
> -Attribute "attr_name1" has a 64 byte value for SCRATCH_MNT/testdir/sf_file
> -Attribute "attr_name2" has a 17 byte value for SCRATCH_MNT/testdir/sf_file
>  attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
> -Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/leaf_file
> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
>  attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
> -Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/node_file
> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/node_file
>  attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  *** done
> -- 
> 2.34.1
> 
