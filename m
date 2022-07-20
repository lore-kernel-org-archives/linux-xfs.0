Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C28C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 17:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiGTRZN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiGTRZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 13:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3917AE49;
        Wed, 20 Jul 2022 10:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDCF660EEA;
        Wed, 20 Jul 2022 17:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23511C3411E;
        Wed, 20 Jul 2022 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658337907;
        bh=G2Dk7sk0xMW5hMyPpySlA6A9md2orp1RWIKepH2fQ6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KSq/ozv/ScrYyjqtysCnM6uoYS5/Pn3axz4kZpjhuMCwE+02WvUMe+XgO498MVPtz
         PHb+51n1a/2yxhkP1qsSXapLVwY27pWcVKrNi7876TQE8TYMXJf+2urFBLy4LidsRa
         rr7vn2pVUyvg3pwPYJ7FPhJPPNy7BRRQeh9KAQxuAW9BLbVVQWnra/w5+CHxpgb2ux
         6iSR8V/lTW7fRk0/VIfbmJb3HKTUNbOInres55CV0nxmJ3TitS0GmRoKefODeQYGCy
         ftCAE5paEGZ+vPCCzitG2QJbj0VhlNqBXMAxeSyRyNjJOgH+6YMU7zMoCw2QWBZDeJ
         FcJfPkfQNyQQg==
Date:   Wed, 20 Jul 2022 10:25:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs/018: fix LARP testing for small block sizes
Message-ID: <Ytg6cpoaeegvTWXN@magnolia>
References: <20220719222520.15550-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719222520.15550-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 03:25:20PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix this test to work properly when the filesystem block size is less
> than 4k.  Tripping the error injection points on shape changes in the
> xattr structure must be done dynamically.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Hrmm.  I tried this on an 8k-blocksize filesystem overnight (arm64, 64k
pages), and got this:

--- xfs/018.out
+++ xfs/018.out.bad
@@ -71,14 +71,14 @@
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
-attr_set: Input/output error
-Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
-touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
+Attribute "attr_nameXXXX" set to a 257 byte value for SCRATCH_MNT/testdir/extent_file2:
+0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
+
 attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
-attr_set: Input/output error
-Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
-touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
+Attribute "attr_nameXXXX" set to a 257 byte value for SCRATCH_MNT/testdir/extent_file3:
+0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
+
 attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error

Not sure what that's all about, but could you please take a look?

--D

> ---
>  tests/xfs/018     | 14 +++++++++-----
>  tests/xfs/018.out | 47 ++++-------------------------------------------
>  2 files changed, 13 insertions(+), 48 deletions(-)
> 
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 041a3b24..323279b5 100755
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
> @@ -98,6 +99,9 @@ attr64k="$attr32k$attr32k"
>  echo "*** mkfs"
>  _scratch_mkfs >/dev/null
>  
> +blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> +multiplier=$(( $blk_sz / 276 )) # 256 + 20 to account for attr name
> +
>  echo "*** mount FS"
>  _scratch_mount
>  
> @@ -140,12 +144,12 @@ test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
>  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
>  
>  # extent, inject error on split
> -create_test_file extent_file2 3 $attr1k
> -test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
> +create_test_file extent_file2 $multiplier $attr256
> +test_attr_replay extent_file2 "attr_nameXXXX" $attr256 "s" "da_leaf_split"
>  
>  # extent, inject error on fork transition
> -create_test_file extent_file3 3 $attr1k
> -test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
> +create_test_file extent_file3 $multiplier $attr256
> +test_attr_replay extent_file3 "attr_nameXXXX" $attr256 "s" "attr_leaf_to_node"
>  
>  # extent, remote
>  create_test_file extent_file4 1 $attr1k
> diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> index 022b0ca3..57dc448a 100644
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
> -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
> -Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> +attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
> -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
> -Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> +attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
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
> 2.25.1
> 
