Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A0EA55;
	Wed, 28 May 2025 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748471786; cv=none; b=B6VqtDCNcqB0I8VYCNC9HIru0pdp8vOplbLpNUBWZRBoxv2Px4NFoO5iAomuePDs1tH+MQ0LQ4RnjI+7ydmwjk3p7PNJGZXbP26vKx+iqfHu9k57iOcture0Sca/8uE3rjaH0addvGtRpP7LHJUsWxIZkSeZ4QbArWdIYB7zq/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748471786; c=relaxed/simple;
	bh=sNXxs0AbF0t4D6W/D+w5nOvNTKxz4dhhCs4/dCJoUL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr5DKJ9k6WfXMxhxZh68VIlTSM0Ror8/AG1zBPIKxRWR+E7vvMkqFgZAluVrYUPvtPZk5MAS2hwSi4pf9muXjOUJzPkGGkE5n3CXPXXkT+J5vUvmMonBYLGmR0Xva5EQjPTP1DHJFKLBMIB9WqcsrlRNADfD5Bwg6TDJjsBMPJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqW3MAQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqW3MAQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27A1C4CEE3;
	Wed, 28 May 2025 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748471786;
	bh=sNXxs0AbF0t4D6W/D+w5nOvNTKxz4dhhCs4/dCJoUL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sqW3MAQba4I98dTV1Yv5n25Uk6W0CTm+unWLRT5rGt4r6YR9pTnZ3uhalUex7LdVn
	 VonVfx4UNGXqkCa5AYTojlpX7rrNC+hzPv+mS672kyzBC+F1mpIdn6qEXW1R+w1jIo
	 j84dJXszB9tGA04A9bTl21mv6T+EG7+0U5i9u9g7UYw2bhOrj5o2h5VAVMQ9BnDlPC
	 zw0dw26vyI8dE6H4ZJs5JQ85+idZwTmBpnk1gGiftRydgYzxlXWFeixZYB9BtfwXnZ
	 2eHQyCum5f0AeKmQv1rBIaI8pv6iwX6CFW1BjWHgXRJUd3aigJEc0M4J+4XP5apsw8
	 Vz/P55L9XGLAQ==
Date: Wed, 28 May 2025 15:36:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/259: try to force loop device block size
Message-ID: <20250528223625.GC8303@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
 <aC58FjhTGEDAQiGb@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC58FjhTGEDAQiGb@dread.disaster.area>

On Thu, May 22, 2025 at 11:21:26AM +1000, Dave Chinner wrote:
> On Wed, May 21, 2025 at 03:41:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Starting with 6.15-rc1, loop devices created with directio mode enabled
> > will set their logical block size to whatever STATX_DIO_ALIGN on the
> > host filesystem reports.  If you happen to be running a kernel that
> > always sets up loop devices in directio mode and TEST_DEV is a block
> > device with 4k sectors, this will cause conflicts with this test's usage
> > of mkfs with different block sizes.  Add a helper to force the loop
> > device block size to 512 bytes, which is implied by scenarios such as
> > "device size is 4T - 2048 bytes".
> > 
> > Also fix xfs/078 which simply needs the blocksize to be set.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/rc         |   22 ++++++++++++++++++++++
> >  tests/generic/563 |    1 +
> >  tests/xfs/078     |    2 ++
> >  tests/xfs/259     |    1 +
> >  tests/xfs/613     |    1 +
> >  5 files changed, 27 insertions(+)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 657772e73db86b..4e3917a298e072 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4526,6 +4526,28 @@ _create_loop_device()
> >  	echo $dev
> >  }
> >  
> > +# Configure the loop device however needed to support the given block size.
> > +_force_loop_device_blocksize()
> > +{
> > +	local loopdev="$1"
> > +	local blksize="$2"
> > +	local is_dio
> > +	local logsec
> > +
> > +	if [ ! -b "$loopdev" ] || [ -z "$blksize" ]; then
> > +		echo "_force_loop_device_blocksize requires loopdev and blksize" >&2
> > +		return 1
> > +	fi
> > +
> > +	curr_blksize="$(losetup --list --output LOG-SEC --noheadings --raw "$loopdev")"
> > +	if [ "$curr_blksize" -gt "$blksize" ]; then
> > +		losetup --direct-io=off "$loopdev"
> > +		losetup --sector-size "$blksize" "$loopdev"
> > +	fi
> > +
> > +	#losetup --raw --list "$loopdev" >> $seqres.full
> > +}
> 
> I think it would make more sense to use a
> _create_loop_device_blocksize() wrapper function and change the call
> sites to use it that to add this function that requires error
> checking of the parameters even though it is only called directly
> after loop device creation.
> 
> _create_loop_device_blocksize()
> {
> 	local file=$1
> 	local blksize=$2
> 
> 	dev=`losetup -f --show $file --sector-size=$blksize`
> 
> 	# If the loop device sector size is incompatible with doing
> 	# direct IO on the backing file, attempting to turn on
> 	# direct-io will fail with an -EINVAL error. However, the
> 	# device will still work correctly using buffered IO, so we
> 	# ignore the error.
> 	test -b "$dev" && losetup --direct-io=on $dev 2> /dev/null
> 	echo $dev

Yeah, I guess that works too.

--D

> }
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
