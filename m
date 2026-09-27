Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361B4379EF5;
	Sun, 27 Sep 2026 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790521580; cv=none; b=jrrz2ZxKCtOuDva/lusdBiPYb/tQBelEgZNwuKjBc9ewhbZ0O4gGD1lQsQvjc/BS8v7hbtY8lbBTncgYkZqwBIyvu//wF1HkdUF1EigRwJQYyubRzKrVGnki/2GQ+ikF5Y/BMocT4kYlvv2tnXnlwz9gpMoZnjvy1H3VIVQhjEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790521580; c=relaxed/simple;
	bh=cehWBRom1egDZ/wQmrT68b2iHHIuhGD42Fxp6GPLbak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5iu7Ml43A14aqS6WtXQZfZ+Istft+R54OH8XEVQvDXApSArHv3wT7KKNVMLezpHqOytLkne4gnW+sWc3WaM0EJ2drj5nqHHu2z8n0WXk5bmIFulZQQhqWob+/zbKUFspRg1y1asoldGPGz3Ok2FVvEwkZp9bSNK8KUedR+6Av0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma1cAF5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma1cAF5H"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 01F201F000FF;
	Sun, 27 Sep 2026 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790521579;
	bh=hRe0FLP4Z/GQs9oxTcORN2hCNFjQ7djxlHIhDcwiwKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ma1cAF5HNGtcWmhf6z1+cEN3WONC9jYnw2/c46P6f3McV5+RPy+sI7zQ0pOkco8iy
	 QcUOWdKmBgcEnKBNdPjDP5k/iVEPhdPKwReKmwlx32PDdpaCM9CGVUdiF7bwhrB+uf
	 +804YkhJhf9NPEkvtlPSPLk909iUPr+Jlseq/RYF7frwr/WL8uLmmqnYbaymb2B7o5
	 SHL37NA71QxgIy/RSkB/sgfOso9KbEZ+JRkJRnFiVAGiTGZBO6u/39ZFalLDABtNuH
	 0pII3eFMT2yx2vZ+LbKVPG0xyNHEhGGK/TYfbZfSPZehdOrBOH6SOMlwyl1LG/Capr
	 fiSW1zS/+0BSw==
Date: Sun, 27 Sep 2026 08:06:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Suveer Jain <asj@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 13/13] fstests: test UUID consistency for clones with
 metadata_uuid
Message-ID: <20260927150618.GZ6253@frogsfrogsfrogs>
References: <cover.1784949154.git.asj@kernel.org>
 <905a961a3bb2ec345285f056053e3016ad3bef6e.1784949155.git.asj@kernel.org>
 <apc5PMJFYtrUyG8U@zlang-mailbox>
 <ea5b61d4-0cba-4afc-b5e0-8720d4717872@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea5b61d4-0cba-4afc-b5e0-8720d4717872@kernel.org>

On Sun, Sep 27, 2026 at 12:41:46PM +0800, Anand Suveer Jain wrote:
> On 2/9/26 04:51, Zorro Lang wrote:
> > On Sat, Jul 25, 2026 at 03:39:10PM +0800, Anand Jain wrote:
> >> Btrfs and xfs uses the metadata_uuid superblock feature to change the
> >> on-disk UUID without rewriting every block header. This patch adds a
> >> sanity check to ensure UUID consistency when a filesystem with
> >> metadata_uuid enabled is cloned.
> >>
> >> Signed-off-by: Anand Jain <asj@kernel.org>
> >> ---
> >>  tests/generic/806     | 74 +++++++++++++++++++++++++++++++++++++++++++
> >>  tests/generic/806.out |  6 ++++
> >>  2 files changed, 80 insertions(+)
> >>  create mode 100644 tests/generic/806
> >>  create mode 100644 tests/generic/806.out
> >>
> >> diff --git a/tests/generic/806 b/tests/generic/806
> >> new file mode 100644
> >> index 000000000000..6d3166491006
> >> --- /dev/null
> >> +++ b/tests/generic/806
> >> @@ -0,0 +1,74 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 806
> >> +#
> >> +# Verify that the cloned filesystem UUID remains consistent, even when the
> >> +# `metadata_uuid` feature is enabled.
> >> +#
> >> +
> >> +. ./common/preamble
> >> +. ./common/filter
> >> +
> >> +_begin_fstest auto quick mount clone
> >> +
> >> +_require_test
> >> +_require_block_device $TEST_DEV
> >> +_require_loop
> >> +
> >> +_cleanup()
> >> +{
> >> +	cd /
> >> +	rm -r -f $tmp.*
> >> +	umount $mnt1 $mnt2 2>/dev/null
> >> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
> >> +}
> >> +
> >> +filter_pool()
> >> +{
> >> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
> >> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
> >> +}
> >> +
> 
> 
> >> +# Create base loop device and its clone, applying the metadata_uuid tuning
> >> +# callback to the base filesystem before the copy occurs.
> >> +devs=()
> >> +_loop_image_create_clone devs _change_metadata_uuid
> > 
> > Should we have and run a _require_metadata_uuid before changing it?
> > As I know, btrfs can do `_require_btrfs_fs_feature metadata_uuid`.
> > 
> 
> _require_metadata_uuid() is better than doing the same thing within
> _change_metadata_uuid(). Now _change_metadata_uuid() calls
> _require_metadata_uuid(), as shown below.
> 
> 
> _require_metdata_uuid()
> {
>         case $FSTYP in
>         xfs)
>                 _require_command "$XFS_ADMIN_PROG" "xfs_admin"

The presence of xfs_admin doesn't guarantee metauuid support on xfs;
the script predates the creation of that feature flag + cli args.

--D

>                 ;;
>         btrfs)
>                 _require_btrfs_fs_feature "metadata_uuid"
>                 _require_command "$BTRFS_TUNE_PROG" "btrfstune"
>                 ;;
>         *)
>                 _notrun "Require filesystem with metadata_uuid feature"
>                 ;;
>         esac
> }
> 
> 
> _change_metadata_uuid()
> {
>         local dev=$1
> 
>         _require_metdata_uuid
> 
>         case $FSTYP in
>         xfs)
>                 $XFS_ADMIN_PROG -U generate $dev >> $seqres.full
>                 ;;
>         btrfs)
>                 $BTRFS_TUNE_PROG -m $dev
>                 ;;
>         esac
> }
> 
> 
> 
> >> +mkdir -p $TEST_DIR/$seq
> >> +mnt1=$TEST_DIR/$seq/mnt1
> >> +mnt2=$TEST_DIR/$seq/mnt2
> >> +mkdir -p $mnt1
> >> +mkdir -p $mnt2
> >> +
> >> +# Get the uuid from the source device
> >> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
> >> +
> >> +# Mount both clone and baseline
> >> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> >> +						_fail "Failed to mount dev1"
> >> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> >> +						_fail "Failed to mount dev2"
> >> +
> >> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> >> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> >> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> >> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> >> +
> >> +# Cycle mounts and reverse the initialization order to ensure UUID tracking
> >> +# doesn't mismatch or flip when metadata_uuid optimization is active.
> >> +echo "**** mount cycle ****"
> >> +_unmount $mnt1
> >> +_unmount $mnt2
> >> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> >> +						_fail "Failed to mount dev2"
> >> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> >> +						_fail "Failed to mount dev1"
> >> +
> >> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> >> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> >> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> >> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> >> +
> >> +status=0
> >> +exit
> >> diff --git a/tests/generic/806.out b/tests/generic/806.out
> >> new file mode 100644
> >> index 000000000000..918f422ecddf
> >> --- /dev/null
> >> +++ b/tests/generic/806.out
> >> @@ -0,0 +1,6 @@
> >> +QA output created by 806
> >> +DEV1 MNT1 FSUUID
> >> +DEV2 MNT2 FSUUID
> >> +**** mount cycle ****
> >> +DEV1 MNT1 FSUUID
> >> +DEV2 MNT2 FSUUID
> >> -- 
> >> 2.43.0
> >>
> 
> 
