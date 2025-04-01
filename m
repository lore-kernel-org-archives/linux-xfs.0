Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC13B20C030;
	Tue,  1 Apr 2025 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524109; cv=none; b=X6sD7sJTFmqXaQDF9lKPs/vgLtafVJLqkNoFhAI525BaI/lzHo06atncUyuq7yY8a3/NzXaA/Y7ixxaKL77Zob5JR4RuRRE2UdIHpU5/MPagvd80+odQfHOolwB8iADZAbG1P7L/MjLOXs+4XPSO4bkL8IjtavOJYJrlfpNT4Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524109; c=relaxed/simple;
	bh=/ONfagkohhhiZRJPzYx2p+Vo1swPb6lMi17snaUkFH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryglQj7zxj4FXIjBuYul0p1gx/cv3+BxDPX1DiXv77GlBq58E+qkzj4vMUytzMsLnVJaSmCqwf9wr/w4Hkc11vGQ7Rglcu0bsrC5DjFpinvVu1tr5z6VlpgQQwrN91n0N3RADqzjaURXhP8rcdNVrMA88IJL5Ik05RPD8yZkuIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tqJ6YYP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tqJ6YYP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B391C4CEE4;
	Tue,  1 Apr 2025 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743524109;
	bh=/ONfagkohhhiZRJPzYx2p+Vo1swPb6lMi17snaUkFH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tqJ6YYP5IdrY2MGTWtph+dzGi1EKfds4HJTQCB41hKqrtu6Yf/+WOGReafdEgCf2N
	 PAuSsHnuWBJyUqi7w18TfVYSSToRlijV+KwN1+0v9m14QXeLbN0zTI9oFw2CEt8NEd
	 NqChL+aa4RsfrHsqMXxZpBALDPfaTe3uG9/nwoV/6hEHH/wOLgICHKyhYhb/kDqIKM
	 TGFn/qNCoqkEiGnOHCrS6OI3oin9VBuECL30Hj/JY7/oJI5G8dQijS03iNkwgCA/yJ
	 0aUUpqO9om4mSXD+vh24suwr+CqruzJL2Sfvh2ma5eNJLLgVAaOvNaojSgKYnx79ST
	 GIP7Jv4iSTSqw==
Date: Tue, 1 Apr 2025 09:15:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: document zoned rt specifics in admin-guide
Message-ID: <20250401161508.GT2803749@frogsfrogsfrogs>
References: <20250331091333.6799-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331091333.6799-1-hans.holmberg@wdc.com>

On Mon, Mar 31, 2025 at 09:15:00AM +0000, Hans Holmberg wrote:
> Document the lifetime, nolifetime and max_open_zones mount options
> added for zoned rt file systems.
> 
> Also add documentation describing the max_open_zones sysfs attribute
> exposed in /sys/fs/xfs/<dev>/zoned/
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

This is consistent with what I saw when the code went by, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  Documentation/admin-guide/xfs.rst | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index b67772cf36d6..9d0344ce81f1 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -124,6 +124,14 @@ When mounting an XFS filesystem, the following options are accepted.
>  	controls the size of each buffer and so is also relevant to
>  	this case.
>  
> +  lifetime (default) or nolifetime
> +	Enable data placement based on write life time hints provided
> +	by the user. This turns on co-allocation of data of similar
> +	life times when statistically favorable to reduce garbage
> +	collection cost.
> +
> +	These options are only available for zoned rt file systems.
> +
>    logbsize=value
>  	Set the size of each in-memory log buffer.  The size may be
>  	specified in bytes, or in kilobytes with a "k" suffix.
> @@ -143,6 +151,14 @@ When mounting an XFS filesystem, the following options are accepted.
>  	optional, and the log section can be separate from the data
>  	section or contained within it.
>  
> +  max_open_zones=value
> +	Specify the max number of zones to keep open for writing on a
> +	zoned rt device. Many open zones aids file data separation
> +	but may impact performance on HDDs.
> +
> +	If ``max_open_zones`` is not specified, the value is determined
> +	by the capabilities and the size of the zoned rt device.
> +
>    noalign
>  	Data allocations will not be aligned at stripe unit
>  	boundaries. This is only relevant to filesystems created
> @@ -542,3 +558,16 @@ The interesting knobs for XFS workqueues are as follows:
>    nice           Relative priority of scheduling the threads.  These are the
>                   same nice levels that can be applied to userspace processes.
>  ============     ===========
> +
> +Zoned Filesystems
> +=================
> +
> +For zoned file systems, the following attribute is exposed in:
> +
> +  /sys/fs/xfs/<dev>/zoned/
> +
> +  max_open_zones                (Min:  1  Default:  Varies  Max:  UINTMAX)
> +	This read-only attribute exposes the maximum number of open zones
> +	available for data placement. The value is determined at mount time and
> +	is limited by the capabilities of the backing zoned device, file system
> +	size and the max_open_zones mount option.
> -- 
> 2.34.1
> 
