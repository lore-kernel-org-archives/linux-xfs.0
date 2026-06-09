Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67652E1F06;
	Tue,  9 Jun 2026 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781015868; cv=none; b=ttYT3W0X3hGV8S457QWhDdZOCsLZNQAabYy8yENfYDkzpydMXaBEhWsh3Os4suKqc/KC+9I2sXkilWVRIXF8Vi2t+z5reNHXltBczet1YmE8kd7hpl746U0tbhsDvFgcw9vd5UgOG+2gQtmHW+ZFcFLS3P+1mOkZU9OFtUuC0Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781015868; c=relaxed/simple;
	bh=5V7YN0sGJU82TW7Hx4zLzYRmIOeFqeizIyoHB+R4xH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtJZe5SlN0Dfu1TsJCURXKJn91bLkkIhYbHQr29ZrRUN8UZhyqjW9Nk++YN3JT6RclZBt00Ph6gRWBb71AdrFpY4zcVTCeqhVmq9elkdQEle5WP7tu6UIoeoW5aBUPoMSo5nODGcxKEQUjxhGXndjhdcuChBovSFeh61HTOnrj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6+bIDKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6+bIDKL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A4791F00893;
	Tue,  9 Jun 2026 14:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015867;
	bh=lL08VxpC+fvKfvxxiZW5i89/CQrjnPa2IrCmxpJFjzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X6+bIDKLdkj2W0Lb7IltN17ZG2SOht70RK/4CN90rs/RaFDcXTKPK90ZKgElO8hCT
	 o9/5CpKIkEISeBQZKusBNnqymcuLjpOYZShxN7CSIq+9fVe/B0lw7FvygEoWlN071n
	 AoYxrdFZ7Nv2s0FAWgiYFwkbWxroS0smkPCU0UuERhs67aooJYOi5QwmmWl1El5jz4
	 PM4xcwc+U0QrAZGBvulYq2JfVzUWEjz73k6IvLs/fhIV/ZMpXDPn3tWNVzIB5vWWql
	 bzUSvmXvNCvSEiHPaPt3sKcHofH04djqtyChyd2wTUpGf9r5cNkLs9HFMdSbI8akKH
	 mavK6tlp7TALw==
Date: Tue, 9 Jun 2026 07:37:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Suveer Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 01/11] fstests: add _loop_image_create_clone() helper
Message-ID: <20260609143746.GL6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1779939330.git.asj@kernel.org>
 <20260529042743.GB6070@frogsfrogsfrogs>
 <9c0989d8-202f-42ab-9347-df082c25aa72@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c0989d8-202f-42ab-9347-df082c25aa72@kernel.org>

On Mon, Jun 08, 2026 at 10:39:04PM +0800, Anand Suveer Jain wrote:
> On 29/5/26 12:27, Darrick J. Wong wrote:
> > On Thu, May 28, 2026 at 12:05:32PM +0800, Anand Jain wrote:
> > > Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> > > image file and clone it to another image file, and attach a loop device to
> > > them. And its destroy part.
> > > 
> > > Signed-off-by: Anand Jain <asj@kernel.org>
> > > ---
> > >  common/rc | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 63 insertions(+)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 79189e7e6e94..d7e3e0bdfb1e 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -1520,6 +1520,69 @@ _scratch_resvblks()
> > >  	esac
> > >  }
> > > +# Create a small loop image, run an optional tuning function ($2) on it,
> > > +# clone it, and attach both to loop devices, returned in ($1).
> > > +# Args:
> > > +#   $1: Nameref to return the array of allocated loop devices [base, clone].
> > > +#   $2: Optional callback function to tune the base filesystem before cloning.
> > > +_loop_image_create_clone()
> > > +{
> > > +	local -n _ret=$1
> > 
> > That switch   ^^ is very clever.  I always wondered how one did indirect
> > variables in bash.
> > 
> > > +	local pre_clone_tune_func="$2"
> > > +	local img_file=$TEST_DIR/${seq}.img
> > > +	local img_file_clone=$TEST_DIR/${seq}_clone.img
> > > +	local size=$(_small_fs_size_mb 128) # Smallest possible
> > > +	local loop_devs
> > > +
> > > +	# Since we copy the block device image, we keep its size small.
> > > +	_require_fs_space $TEST_DIR $((size * 1024))
> > > +
> > > +	_create_file_sized $((size * 1024 * 1024)) $img_file ||
> > > +				_fail "Failed: Create $img_file $size"
> > > +
> > > +	loop_devs=$(_create_loop_device $img_file)
> > > +	_ret=($loop_devs)
> > 
> > Should this check that a loopdev actually got created?
> > 
> 
> Hmm, in the function _create_loop_device(), we are
> calling _fail if create fails, so no need to duplicate, right?

Oh right.  Question withdrawn.

> > > +	case $FSTYP in
> > > +	xfs)
> > > +		_mkfs_dev "-s size=4096" ${loop_devs[0]}
> > > +		;;
> > > +	btrfs)
> > > +		_mkfs_dev ${loop_devs[0]}
> > > +		;;
> > > +	*)
> > > +		_mkfs_dev ${loop_devs[0]}
> > > +		;;
> > > +	esac
> > > +
> > > +	# Only execute if the function argument is not empty
> > > +	if [ -n "$pre_clone_tune_func" ]; then
> > > +		$pre_clone_tune_func ${loop_devs[0]}
> > > +	fi
> > > +
> > > +	sync ${loop_devs[0]}
> > > +	cp $img_file $img_file_clone
> > > +
> 
> 
> > > +	loop_devs="$loop_devs $(_create_loop_device $img_file_clone)"
> > 
> > 	local lodev="$(_create_loop_device ...)"
> > 
> > 	test -z "$lodev" && _fail "second loopdev not created"
> > 	_ret+=("$lodev")
> > 
> > ?
> 
> If the second `_create_loop_device()` happens to fail, it will
> already have called `_fail`, so "second loopdev..." won't be
> used at all.

<nod> Both comments withdrawn :)

--D

> 
> Thanks, Anand
> 
> 
> 
> > > +
> > > +	_ret=($loop_devs)
> > > +}
> > > +
> > > +# Teardown loop devices and delete their underlying backing image files.
> > > +# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
> > > +_loop_image_destroy()
> > > +{
> > > +	for d in "$@"; do
> > > +		# Retrieve the path of the backing file
> > > +		local f=$(losetup --noheadings --output BACK-FILE $d)
> > > +
> > > +		# Detach the loop device from the backing file
> > > +		_destroy_loop_device "$d"
> > > +
> > > +		# Clean up the backing disk image file
> > > +		[ -n "$f" ] && rm -f "$f"
> > > +	done
> > > +}
> > >  # Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
> > >  # errors found or errors were fixed) and nonzero otherwise; also spits out
> > > -- 
> > > 2.43.0
> > > 
> > > 
> 
> 
