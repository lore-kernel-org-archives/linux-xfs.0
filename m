Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097A8C38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 06:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJ1GIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 02:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiJ1GIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 02:08:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801CC1B76E7;
        Thu, 27 Oct 2022 23:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 209A9B827D5;
        Fri, 28 Oct 2022 06:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993D5C433D6;
        Fri, 28 Oct 2022 06:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666937299;
        bh=JuhjBOt0Wb3byZkdejholpWzVMf1uSjwtv1nJTtFtDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pkZfF4fcwe4Xrzsbe+crVzKyA6Gvt1ZTqq2/+LtrkK848ZeeF08Fs5lIbVjayQhgi
         qB9owVy4ORANhNuJa/CCyV3NL+b3R8AxfWLDeF6T8ZQXhziDyjTR91VjSKRKK0DDw+
         7DfJxZRkhg5lueFcMYPL7nVngvmwQQBuvUuH1rfneCtaHIyZNXGQGtUm0V02FuW3zB
         bYFDiZ/7cLpUoTBFCAJvVk77F/VMJ9eHNkKLmv9l58tE1iII3LXmQ/mxKpqoEwF3KY
         FPUz3bqjY+SG9Pzb0H4QxsM6PkHzPOXEU1dhuw1ZTMWK6m0RPuOAFNpgk1azT9I+4K
         3UrLemFADLAwQ==
Date:   Fri, 28 Oct 2022 14:08:14 +0800
From:   Zorro Lang <zlang@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor filesystem directory block size
 extraction logic
Message-ID: <20221028060814.r3lrrnymeqpf4x7t@zlang-mailbox>
References: <166681099421.3403789.78493769502226810.stgit@magnolia>
 <166681100562.3403789.14498721397451474651.stgit@magnolia>
 <20221027165916.4ttwfx7g66pznsrt@zlang-mailbox>
 <Y1q5yYiIjWole+lj@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1q5yYiIjWole+lj@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:03:05AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 28, 2022 at 12:59:16AM +0800, Zorro Lang wrote:
> > On Wed, Oct 26, 2022 at 12:03:25PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > There are a lot of places where we open-code determining the directory
> > > block size for a specific filesystem.  Refactor this into a single
> > > helper to clean up existing tests.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Hmm... sorry I failed to merge this patchset:
> > 
> > $ git am ./20221026_djwong_fstests_refactor_xfs_geometry_computation.mbx
> > Applying: xfs: refactor filesystem feature detection logic
> > Applying: xfs: refactor filesystem directory block size extraction logic
> > error: sha1 information is lacking or useless (common/xfs).
> > error: could not build fake ancestor
> > Patch failed at 0002 xfs: refactor filesystem directory block size extraction logic
> > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> 
> I don't know what exactly failed, but if you're ok with pushing your
> working branch to kernel.org, I can rebase my changes atop that and
> send you a pull request.

Hi Darrick,

Not my working branch, it failed on offical for-next branch too. By checking the
patch 2/4, I found (see below) ...

> 
> --D
> 
> > >  common/populate |    4 ++--
> > >  common/xfs      |    9 +++++++++
> > >  tests/xfs/099   |    2 +-
> > >  tests/xfs/100   |    2 +-
> > >  tests/xfs/101   |    2 +-
> > >  tests/xfs/102   |    2 +-
> > >  tests/xfs/105   |    2 +-
> > >  tests/xfs/112   |    2 +-
> > >  tests/xfs/113   |    2 +-
> > >  9 files changed, 18 insertions(+), 9 deletions(-)
> > > 
> > > 
> > > diff --git a/common/populate b/common/populate
> > > index 9fa1a06798..23b2fecf69 100644
> > > --- a/common/populate
> > > +++ b/common/populate
> > > @@ -175,7 +175,7 @@ _scratch_xfs_populate() {
> > >  	_xfs_force_bdev data $SCRATCH_MNT
> > >  
> > >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> > >  	if [ $crc -eq 1 ]; then
> > >  		leaf_hdr_size=64
> > > @@ -602,7 +602,7 @@ _scratch_xfs_populate_check() {
> > >  	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
> > >  
> > >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > >  	leaf_lblk="$((32 * 1073741824 / blksz))"
> > >  	node_lblk="$((64 * 1073741824 / blksz))"
> > >  	umount "${SCRATCH_MNT}"
> > > diff --git a/common/xfs b/common/xfs
> > > index c7496bce3f..6445bfd9db 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -203,6 +203,15 @@ _xfs_is_realtime_file()

...
I can't find this _xfs_is_realtime_file() in my common/xfs, did I miss someone
prepositive patch?

Thanks,
Zorro

> > >  	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
> > >  }
> > >  
> > > +# Get the directory block size of a mounted filesystem.
> > > +_xfs_get_dir_blocksize()
> > > +{
> > > +	local fs="$1"
> > > +
> > > +	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
> > > +		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
> > > +}
> > > +
> > >  # Set or clear the realtime status of every supplied path.  The first argument
> > >  # is either 'data' or 'realtime'.  All other arguments should be paths to
> > >  # existing directories or empty regular files.
> > > diff --git a/tests/xfs/099 b/tests/xfs/099
> > > index a7eaff6e0c..82bef8ad26 100755
> > > --- a/tests/xfs/099
> > > +++ b/tests/xfs/099
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((dblksz / 40))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > diff --git a/tests/xfs/100 b/tests/xfs/100
> > > index 79da8cb02c..e638b4ba17 100755
> > > --- a/tests/xfs/100
> > > +++ b/tests/xfs/100
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((dblksz / 12))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > diff --git a/tests/xfs/101 b/tests/xfs/101
> > > index 64f4705aca..11ed329110 100755
> > > --- a/tests/xfs/101
> > > +++ b/tests/xfs/101
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((dblksz / 12))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > diff --git a/tests/xfs/102 b/tests/xfs/102
> > > index 24dce43058..43f4539181 100755
> > > --- a/tests/xfs/102
> > > +++ b/tests/xfs/102
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((16 * dblksz / 40))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > diff --git a/tests/xfs/105 b/tests/xfs/105
> > > index 22a8bf9fb0..002a712883 100755
> > > --- a/tests/xfs/105
> > > +++ b/tests/xfs/105
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((16 * dblksz / 40))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > diff --git a/tests/xfs/112 b/tests/xfs/112
> > > index bc1ab62895..e2d5932da6 100755
> > > --- a/tests/xfs/112
> > > +++ b/tests/xfs/112
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((16 * dblksz / 40))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > diff --git a/tests/xfs/113 b/tests/xfs/113
> > > index e820ed96da..9bb2cd304b 100755
> > > --- a/tests/xfs/113
> > > +++ b/tests/xfs/113
> > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > >  
> > >  echo "+ mount fs image"
> > >  _scratch_mount
> > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > >  nr="$((128 * dblksz / 40))"
> > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > 
> > 
> 
