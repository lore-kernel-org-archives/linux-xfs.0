Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1129427C851;
	Tue, 22 Apr 2025 12:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325574; cv=none; b=mw5n/hCMVTYwOL38DqncBTjmZLJeUD4D4/1mWhNzjrOhI4hkXd5V09CItyg9mJqH7pO4xKsPy0ZL/b1BBpLakovecQoh74G6Zm8sCRHcdXhm6Agvoj4K0B0yG759fGCjrSs3GJgpMMchrf+qXz80mOYJv1AU7Zd/ggVsuP6u51o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325574; c=relaxed/simple;
	bh=xP8Dv5I1fJiOex+Vj8UPxNH7vE0QPVtpzuMKiEQT+24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHmXS08UD2YzA4iVkFclJYNcWTY6aPvhmoy2mC75ufzKihvfc6TNajQn4bsgvFUGz/Lp6QHw7XbiRVB2aZTe0MJh30nvzDXbahnFhJZ06BQh9TPSMNTtsmY6dSmFt7ev2f7tpLGu7DkDNIxkt9JFq1NvFBhk0UV6DGeV0JgFJJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQMQmt82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQMQmt82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A87C4CEE9;
	Tue, 22 Apr 2025 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745325573;
	bh=xP8Dv5I1fJiOex+Vj8UPxNH7vE0QPVtpzuMKiEQT+24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FQMQmt82A0wep1yJlcQaDueszEc8Z1XNmvlwPK7e40zLXS2uQ1OY0zxzfpRvz6A6P
	 ow78l+mEGvwLNtiyv7E/RV7y9CCPeX4s9vZVnFWr3BxkfXUsPM7b2cATJANKxnv6gb
	 lfE+HCMaZkTdneT7+0zwDvWGDIFFbwug5L1+WKNyxKc3S7yGEgpQP375e59m+kfUse
	 bdCR8uUF9cAJc1VaPu8j8ac1vXHyQVMNub6uhGjEx/hL4cVnuRzPXOynlrCOV7xzqo
	 GSIBuq8JRFAAamrvkdrbDiWfXe4KNjkjRU6oSNRlUqxXdAQs0CWemjpNt9IfLjIJnV
	 OMjDlh7BjZoCA==
Date: Tue, 22 Apr 2025 14:39:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	hch <hch@lst.de>, "linux@roeck-us.net" <linux@roeck-us.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH] XFS: fix zoned gc threshold math for 32-bit arches
Message-ID: <y2yqlycoihdszskhm57idjmzmllj3qvppp27tqqylwfi3uqrwe@qcsmimh5vv73>
References: <20250422114231.1012462-1-cem@kernel.org>
 <37cQwsCB-vfrE2GVpLDweuT6AGImO9AX7_gX5a2Zy2geWo5AdDrN4NXJTXvX_5hkHEf04owtz-_FoYdo79RElg==@protonmail.internalid>
 <fb6536ec-244f-4a90-949d-ddff7f15d18b@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb6536ec-244f-4a90-949d-ddff7f15d18b@wdc.com>

On Tue, Apr 22, 2025 at 12:31:01PM +0000, Hans Holmberg wrote:
> On 22/04/2025 13:42, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > xfs_zoned_need_gc makes use of mult_frac() to calculate the threshold
> > for triggering the zoned garbage collector, but, turns out mult_frac()
> > doesn't properly work with 64-bit data types and this caused build
> > failures on some 32-bit architectures.
> >
> > Fix this by essentially open coding mult_frac() in a 64-bit friendly
> > way.
> >
> > Notice we don't need to bother with counters underflow here because
> > xfs_estimate_freecounter() will always return a positive value, as it
> > leverages percpu_counter_read_positive to read such counters.
> >
> > Fixes: 845abeb1f06a ("xfs: add tunable threshold parameter for triggering zone GC")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202504181233.F7D9Atra-lkp@intel.com/
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >
> >  fs/xfs/xfs_zone_gc.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> > index 8c541ca71872..b0e8915ef733 100644
> > --- a/fs/xfs/xfs_zone_gc.c
> > +++ b/fs/xfs/xfs_zone_gc.c
> > @@ -171,6 +171,7 @@ xfs_zoned_need_gc(
> >  	struct xfs_mount	*mp)
> >  {
> >  	s64			available, free;
> > +	s32			threshold, remainder;
> >
> >  	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
> >  		return false;
> > @@ -183,7 +184,12 @@ xfs_zoned_need_gc(
> >  		return true;
> >
> >  	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> > -	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> > +
> > +	threshold = div_s64_rem(free, 100, &remainder);
> 
> Hmm, shouldn't threshold be a s64?

Uff, yes, I wrote it to use as a divisor initially, changed my mind and forgot
to fix the definition. I'll send a V2, thanks for spotting it. Only remainder
must be a s32.


> 
> > +	threshold = threshold * mp->m_zonegc_low_space +
> > +		    remainder * div_s64(mp->m_zonegc_low_space, 100);
> > +
> > +	if (available < threshold)
> >  		return true;
> >
> >  	return false;
> 
> 
