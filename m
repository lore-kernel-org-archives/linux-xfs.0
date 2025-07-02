Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8CD2E49A3
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 19:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482802; cv=none; b=J2rtdCROLmbSOq6TZlnbJ37qV/dfeOy2f4/k+eYtXBKp4bQ2A2iV2P+qosDdElPqHRgsSfzLR6AD2xwh46wJa/S9L6qMK48eGUxme4kEg7hbh7nC+P4Z4ZNzkXGa2j6psfQp6lyD8wk3aSGzvaLC5c1DIYm463pXsGhk515V8hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482802; c=relaxed/simple;
	bh=shgV3YWjgOK+2QTpgyes7Qo096yAT2QcRV8BVK6EJxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2Mv0AVqaRY/SJ2L0WCdwWXt8pkE6/YJnOSOJ0UWFfLyda3ktgQDos5u4xCCQj7rByLxp7cBDzNvKm7G4p/JGe6l5sDkYT3T1cIsAe0BvrmQY+sljO2F8+7K1FLfLT2vs/k9LTax4OY0B7MM7gn+14Qr/8yHvhbctx4M+tOdjus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHR1J0Tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHR1J0Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE16C4CEE7;
	Wed,  2 Jul 2025 19:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751482802;
	bh=shgV3YWjgOK+2QTpgyes7Qo096yAT2QcRV8BVK6EJxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aHR1J0TnT7xsrQv5eJjfDW6SmF+C0k13A8UgAjlfMQ3yqrdJ0zoTXQnhjZ+Z3GB/Q
	 74HSKz7c/7wx70NuGLE3hwB6pwJtpnY1wGIbLuMV98p5GEZ+wOO1E+AJpe3ajuNS5h
	 Wir75h2W2Dx0zqf+L2dvRy8xY6C5I1M0vv2rIZmL3rDKxHxPf62dvwKcz3aT/YZudW
	 1u5Ia5nGhxCE4IZxaOOYBBr2cWWEdVvULph28gcYMKsDVYBSFaNXr1AWzXJ8l4Qcjd
	 /DsTJiYF0bZ94hxORMrOe6qFxF72FemVkX/NWMds87TqOPnVmpwni77eK1lEOhA+PB
	 tLZ4Dut/l20jw==
Date: Wed, 2 Jul 2025 12:00:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: aalbersh@kernel.org, catherine.hoang@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] mkfs: try to align AG size based on atomic write
 capabilities
Message-ID: <20250702190001.GZ10009@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303947.916168.18334224285549571882.stgit@frogsfrogsfrogs>
 <3e7f8c3d-d4ce-4c5a-8de1-5c6bcf44c4d9@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e7f8c3d-d4ce-4c5a-8de1-5c6bcf44c4d9@oracle.com>

On Wed, Jul 02, 2025 at 10:03:54AM +0100, John Garry wrote:
> On 01/07/2025 19:08, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Try to align the AG size to the maximum hardware atomic write unit so
> > that we can give users maximum flexibility in choosing an RWF_ATOMIC
> > write size.
> 
> 
> Regardless of comments below, FWIW:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> 
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >   libxfs/topology.h |    6 ++++--
> >   libxfs/topology.c |   36 ++++++++++++++++++++++++++++++++++++
> >   mkfs/xfs_mkfs.c   |   48 +++++++++++++++++++++++++++++++++++++++++++-----
> >   3 files changed, 83 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/libxfs/topology.h b/libxfs/topology.h
> > index 207a8a7f150556..f0ca65f3576e92 100644
> > --- a/libxfs/topology.h
> > +++ b/libxfs/topology.h
> > @@ -13,8 +13,10 @@
> >   struct device_topology {
> >   	int	logical_sector_size;	/* logical sector size */
> >   	int	physical_sector_size;	/* physical sector size */
> > -	int	sunit;		/* stripe unit */
> > -	int	swidth;		/* stripe width  */
> > +	int	sunit;			/* stripe unit */
> > +	int	swidth;			/* stripe width  */
> > +	int	awu_min;		/* min atomic write unit in bbcounts */
> 
> awu_min is not really used, but, like the kernel code does, I suppose useful
> to store it
> 
> > +	int	awu_max;		/* max atomic write unit in bbcounts */
> >   };
> >   struct fs_topology {
> > diff --git a/libxfs/topology.c b/libxfs/topology.c
> > index 96ee74b61b30f5..7764687beac000 100644
> > --- a/libxfs/topology.c
> > +++ b/libxfs/topology.c
> > @@ -4,11 +4,18 @@
> >    * All Rights Reserved.
> >    */
> > +#ifdef OVERRIDE_SYSTEM_STATX
> > +#define statx sys_statx
> > +#endif
> > +#include <fcntl.h>
> > +#include <sys/stat.h>
> > +
> >   #include "libxfs_priv.h"
> >   #include "libxcmd.h"
> >   #include <blkid/blkid.h>
> >   #include "xfs_multidisk.h"
> >   #include "libfrog/platform.h"
> > +#include "libfrog/statx.h"
> >   #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
> >   #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
> > @@ -278,6 +285,34 @@ blkid_get_topology(
> >   		device);
> >   }
> > +static void
> > +get_hw_atomic_writes_topology(
> > +	struct libxfs_dev	*dev,
> > +	struct device_topology	*dt)
> > +{
> > +	struct statx		sx;
> > +	int			fd;
> > +	int			ret;
> > +
> > +	fd = open(dev->name, O_RDONLY);
> > +	if (fd < 0)
> > +		return;
> > +
> > +	ret = statx(fd, "", AT_EMPTY_PATH, STATX_WRITE_ATOMIC, &sx);
> > +	if (ret)
> > +		goto out_close;
> > +
> > +	if (!(sx.stx_mask & STATX_WRITE_ATOMIC))
> > +		goto out_close;
> > +
> > +	dt->awu_min = sx.stx_atomic_write_unit_min >> 9;
> > +	dt->awu_max = max(sx.stx_atomic_write_unit_max_opt,
> > +			  sx.stx_atomic_write_unit_max) >> 9;
> 
> for a bdev, stx_atomic_write_unit_max_opt should be zero
> 
> However, I suppose some bdev could have hybrid atomic write support, just
> like xfs, so what you are doing looks good

Yeah, it's unlikely ever to happen but if (say) you had a loop device
backed by an xfs file then maybe it'd useful to pass through both atomic
write maxima.

Thanks for the review.

--D
