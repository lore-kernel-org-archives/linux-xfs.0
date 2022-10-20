Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87277C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 12:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJTMPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 08:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJTMPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 08:15:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676C3157455;
        Thu, 20 Oct 2022 05:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8241B82749;
        Thu, 20 Oct 2022 12:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514FCC433D6;
        Thu, 20 Oct 2022 12:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666268139;
        bh=kLUua2MQPknPHyHh0J7vwZ3jzMfnOxkW6mB09vRr0Pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6x3wtykx1g8xEK6DbhBhsGyKt8f2UlACdu8LPg2JHQM4FezH78YV30A60JNz71E0
         taERyczr0jYboixg9a8tbaYTeDzS3dvSrbe+e/5Wq4oR1fsrknhmQxvwCUJu8smtGu
         XFbFzEXlb6I/OtfuSWzsrEMjdtmHTmjdxfyyXPOUYeb8UywHf0he7BfKvpMKa71fq8
         N+GdYmh/gHJZgX8P9A0rT0uwGZIgAbofoxvUAryKP6Dn+Emp6F7+mx8gB6JuclXMrj
         KYAjn6kTv8u/d/aSLbJid/bOcgYxxqvKv9DyvmG9FcqK0Pa5fYoc/X2hnmOzsKclMG
         id/L6dHf1GJzg==
Date:   Thu, 20 Oct 2022 20:15:34 +0800
From:   Zorro Lang <zlang@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: refactor filesystem realtime geometry detection
 logic
Message-ID: <20221020121534.pp7esou4wxneaz4i@zlang-mailbox>
References: <166613312194.868141.5162859918517610030.stgit@magnolia>
 <166613313870.868141.4913572781093963547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <166613313870.868141.4913572781093963547.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2022 at 03:45:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a lot of places where we open-code detecting the realtime
> extent size and extent count of a specific filesystem.  Refactor this
> into a couple of helpers to clean up the code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |    2 +-
>  common/xfs      |   29 +++++++++++++++++++++++++++--
>  tests/xfs/146   |    2 +-
>  tests/xfs/147   |    2 +-
>  tests/xfs/530   |    3 +--
>  5 files changed, 31 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 23b2fecf69..d9d4c6c300 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -323,7 +323,7 @@ _scratch_xfs_populate() {
>  	fi
>  
>  	# Realtime Reverse-mapping btree
> -	is_rt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rtextents=[1-9]')"
> +	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
>  	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
>  		echo "+ rtrmapbt btree"
>  		nr="$((blksz * 2 / 32))"
> diff --git a/common/xfs b/common/xfs
> index 6445bfd9db..20da537a9d 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -174,6 +174,24 @@ _scratch_mkfs_xfs()
>  	return $mkfs_status
>  }
>  
> +# Get the number of realtime extents of a mounted filesystem.
> +_xfs_get_rtextents()
> +{
> +	local path="$1"
> +
> +	$XFS_INFO_PROG "$path" | grep 'rtextents' | \
> +		sed -e 's/^.*rtextents=\([0-9]*\).*$/\1/g'

Same as patch 2/3, how about:

	$XFS_INFO_PROG "$path" | sed -n "s/^.*rtextents=\([[:digit:]]*\).*/\1/p"

and ...

> +}
> +
> +# Get the realtime extent size of a mounted filesystem.
> +_xfs_get_rtextsize()
> +{
> +	local path="$1"
> +
> +	$XFS_INFO_PROG "$path" | grep 'realtime.*extsz' | \
> +		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'

...
	$XFS_INFO_PROG "$path" | sed -n "s/^realtime.*extsz=\([[:digit:]]*\).*/\1/p"

> +}
> +
>  # Get the size of an allocation unit of a file.  Normally this is just the
>  # block size of the file, but for realtime files, this is the realtime extent
>  # size.
> @@ -191,7 +209,7 @@ _xfs_get_file_block_size()
>  	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
>  		path="$(dirname "$path")"
>  	done
> -	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> +	_xfs_get_rtextsize "$path"
>  }
>  
>  # Decide if this path is a file on the realtime device
> @@ -436,13 +454,20 @@ _require_xfs_crc()
>  # third option is -v, echo 1 for success and 0 for not.
>  #
>  # Starting with xfsprogs 4.17, this also works for unmounted filesystems.
> +# The feature 'realtime' looks for rtextents > 0.
>  _xfs_has_feature()
>  {
>  	local fs="$1"
>  	local feat="$2"
>  	local verbose="$3"
> +	local feat_regex="1"
>  
> -	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -w -c "$feat=1")"
> +	if [ "$feat" = "realtime" ]; then
> +		feat="rtextents"
> +		feat_regex="[1-9][0-9]*"
> +	fi

How about use this format:

case "$feat" in
realtime)
	feat="rtextents"
	feat_regex="[1-9][0-9]*"
	;;
...)
	feat="..."
	feat_regex="..."
	;;
*)
	feat="$2“
	feat_regex="1"
	;;
esac

due to I think you might add more "$feat" which not simply equal to 1/0 later :)

Others looks good to me.

Thanks,
Zorro

> +
> +	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -E -w -c "$feat=$feat_regex")"
>  	if [ "$answer" -ne 0 ]; then
>  		test "$verbose" = "-v" && echo 1
>  		return 0
> diff --git a/tests/xfs/146 b/tests/xfs/146
> index 5516d396bf..123bdff59f 100755
> --- a/tests/xfs/146
> +++ b/tests/xfs/146
> @@ -31,7 +31,7 @@ _scratch_mkfs > $seqres.full
>  _scratch_mount >> $seqres.full
>  
>  blksz=$(_get_block_size $SCRATCH_MNT)
> -rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> +rextsize=$(_xfs_get_rtextsize "$SCRATCH_MNT")
>  rextblks=$((rextsize / blksz))
>  
>  echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> diff --git a/tests/xfs/147 b/tests/xfs/147
> index e21fdd330c..33b3c99633 100755
> --- a/tests/xfs/147
> +++ b/tests/xfs/147
> @@ -29,7 +29,7 @@ _scratch_mkfs -r extsize=256k > $seqres.full
>  _scratch_mount >> $seqres.full
>  
>  blksz=$(_get_block_size $SCRATCH_MNT)
> -rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> +rextsize=$(_xfs_get_rtextsize "$SCRATCH_MNT")
>  rextblks=$((rextsize / blksz))
>  
>  echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> diff --git a/tests/xfs/530 b/tests/xfs/530
> index c960738db7..56f5e7ebdb 100755
> --- a/tests/xfs/530
> +++ b/tests/xfs/530
> @@ -73,8 +73,7 @@ _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
>  formatted_blksz="$(_get_block_size $SCRATCH_MNT)"
>  test "$formatted_blksz" -ne "$dbsize" && \
>  	_notrun "Tried to format with $dbsize blocksize, got $formatted_blksz."
> -$XFS_INFO_PROG $SCRATCH_MNT | grep -E -q 'realtime.*blocks=0' && \
> -	_notrun "Filesystem should have a realtime volume"
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
>  
>  echo "Consume free space"
>  fillerdir=$SCRATCH_MNT/fillerdir
> 
