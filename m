Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57514D8B9
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721864907; cv=none; b=nRa1o6V2+K6eXIV4W/qQCtXHuWlq7H0ifPEHJOEi3FfY75oJYz0u+bo9EBkZLhIHL7gBaEZWEEVEiQhbOk0Wy0cy6LPgC99Z172i343LeCWNAf+/u8jtxlzg5tqPXGdv2AJC6sy7Ob2lLA+Pv26e5T52DgBH7aZFiQj493KHMPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721864907; c=relaxed/simple;
	bh=8O4GZX7yXNqld9fCvBDUo9hiKlSEh98giAA/3qs9G0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyAoODqJp0MlWVr8GGs3KIfnYa6xfq8y81XsY+WZNQeiwoSb1D9IEKQqysRF3KqHHxAjLhEF8UAFsxnq7/JKErTGSZ8g3jtwdgYiGPiYBqoPpderQksU5XsyOMTikKYml73jo8YNFYN+34d7m7eSylBJR1hmSYI2tIj9MV9AoWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thZagmu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thZagmu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BE9C32781;
	Wed, 24 Jul 2024 23:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721864907;
	bh=8O4GZX7yXNqld9fCvBDUo9hiKlSEh98giAA/3qs9G0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thZagmu3OneXCciANDzac4o8kAk7kh5LnyuELKi17ZEqE+l54NzrMDJCEsBmOLQ53
	 PwpgthQT9HZJx13s/29jmggic98gqwP8zIK+vw3nqaZMZj8P44f6he6WKYrSgRkbjh
	 MuYD7OqIOCK2GPxtJaHFwtyiDVCwmQQxzj6uv90t6ro2aFAZj55U8uoypJNUJjXVLP
	 VWCMM39XbxSNAnvCwtsdfh6ZyDpzflF8tOlWmWWuc/MIZzdt5zL1H7o1dHq+pqEGlk
	 Oo/Ak7raTqCBnWBvNlvjGhINEeYPc9ad4KOqipq00+qynsb1mkbj6aqDoWaLXYx7im
	 IZPNBtuqUInoA==
Date: Wed, 24 Jul 2024 16:48:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <20240724234826.GC612460@frogsfrogsfrogs>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <20240724210833.GZ612460@frogsfrogsfrogs>
 <7c1f47f5-dbf9-4e89-9355-6adc9fad2166@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1f47f5-dbf9-4e89-9355-6adc9fad2166@sandeen.net>

On Wed, Jul 24, 2024 at 05:50:18PM -0500, Eric Sandeen wrote:
> On 7/24/24 4:08 PM, Darrick J. Wong wrote:
> > On Wed, Jul 24, 2024 at 10:46:15AM +1000, Dave Chinner wrote:
> 
> ...
> 
> > Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
> > we allowed people to create single-AG filesystems with large(ish)
> > sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
> > size and copy your 2GB of data into the filesystem.  At deploy time,
> > growfs will expand AG 0 to 100G and add new AGs after that, same as it
> > does now.
> 
> And that could be done oneline...
> 
> > I think all we'd need is to add a switch to mkfs to tell it that it's
> > creating one of these gold master images, which would disable this
> > check:
> > 
> > 	if (agsize > dblocks) {
> > 		fprintf(stderr,
> > 	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
> > 			(long long)agsize, (long long)dblocks);
> > 			usage();
> > 	}
> 
> (plus removing the single-ag check)
> 
> > and set a largeish default AG size.  We might want to set a compat bit
> > so that xfs_repair won't complain about the single AG.
> > 
> > Yes, there are drawbacks, like the lack of redundant superblocks.  But
> > if growfs really runs at firstboot, then the deployed customer system
> > will likely have more than 1 AG and therefore be fine.
> 
> Other drawbacks are that you've fixed the AG size, so if you don't grow
> past the AG size you picked at mkfs time, you've still got only one
> superblock in the deployed image.

Yes, that is a significant drawback. :)

> i.e. if you set it to 100G, you're OK if you're growing to 300-400G.
> If you are only growing to 50G, not so much.

Yes, though the upside of this counter proposal is that it can be done
today with relatively little code changes.  Dave's requires storage
devices and the kernel to support accelerated remapping, which is going
to take some time and conversations with vendors.

That said, I agree with Dave that his proposal probably results in
files spread more evenly around the disk.

But let's think about this -- would it be advantageous for a freshly
deployed system to have a lot of contiguous space at the end?

If the expand(ed) image is a root filesystem, then the existing content
isn't going to change a whole lot, right?  And if we're really launching
into the nopets era, then the system gets redeployed every quarter with
the latest OS update.

(Not that I do that; I'm still a grumpy Debian greybeard with too many
pets.)

OTOH, do you (or Dave) anticipate needing to expandfs an empty data
partition in the deployed image?  A common pattern amongst our software
is to send out a ~16G root fs image which is deployed into a VM with a
~250G boot volume and a 100TB data volume.  The firstboot process growfs
the rootfs by another ~235G, then it formats a fresh xfs onto the 100TB
volume.

The performance of the freshly formatted data partition is most
important, and we've spent years showing that layout and performance are
better if you do the fresh format.  So I don't think we're going to go
back to expanding data partitions.

> (and vice versa - if you optimize for gaining superblocks, you have to
> pick a fairly small AG size, then run the risk of growing thousands of them)
>
> In other words, it requires choices at mkfs time, whereas Dave's proposal
> lets those choices be made per system, at "expand" time, when the desired
> final size is known.

If you only have one AG, then the agnumber segment of the FSBNO will be
zero.  IOWs, you can increase agblklog on a single-AG fs because there
are no FSBNOs that need re-encoding.  You can even decrease it, so long
as you don't go below the size of the fs.

The ability to adjust goes away as soon as you hit two AGs.

Adjusting agblklog would require some extension to the growfs ioctl.

> (And, you start right out of the gate with poorly distributed data and inodes,
> though I'm not sure how much that'd matter in practice.)

On fast storage it probably doesn't matter.  OTOH, Dave's proposal does
mean that the log stays in the middle of the disk, which might be
advantageous if you /are/ running on spinning rust.

> (I'm not sure the ideas are even mutually exclusive; I think you could have
> a single AG image with dblocks << agblocks << 2^agblocklog, and a simple
> growfs adds agblocks-sized AGs, whereas an "expand" could adjust agblocks,
> then growfs to add more?)

Yes.

> > As for validating the integrity of the GM image, well, maybe the vendor
> > should enable fsverity. ;)
> 
> And host it on ext4, LOL.

I think we can land fsverity in the same timeframe as whatever we land
on for implementing xfs_explode^Wexpandfs.  Probably sooner.

--D

> -Eric
> 
