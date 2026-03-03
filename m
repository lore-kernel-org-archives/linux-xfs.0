Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E97C370D5B
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772558041; cv=none; b=t+jQ7DZYS1iSFpIOu30NgDyRclCzrc23CuTg5BINCL1b6D9CAk3do6OC4ZZWC62+R9e5ECGYscteRrTKqwyyHsCppHN7RM152EUy4Lcc5WmbdbxGkQl8JaA9TnKvFaoUl5rDnZJDtwaEhXoIR3CBzJAymq8Rj3pisp7ukBHBXOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772558041; c=relaxed/simple;
	bh=RTabP742TzaRnfwgegrkeF2fas6LzqKGGu+x3cC8IYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kh39a6LM5MiOHtI8tJoVhz4sXri25gH1pjX+Fu28oL84MtvtbaQWFOWyJyhSe8ShHUa2WtM+d9Ss0otScq+ZqJ3xbqY36zCNz8YOEYVMy7b3YCgGumHaOAzYcqMKJYVQCi/WY7Aa3TwnLQNAQreaYJ0zu5McPzDwn5UuIL0shW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qamP6evz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qamP6evz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BC9C116C6;
	Tue,  3 Mar 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772558041;
	bh=RTabP742TzaRnfwgegrkeF2fas6LzqKGGu+x3cC8IYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qamP6evzEEtdGOZyrNd3jN+irWyjahpSt71Mq0M8itvlrgFjYzZRpCoc4TatmYl5+
	 vviAty7yOw+5maM1qLDXrwwkhUDTQKtIHjLEIvtX7M7aj2AtJgWB9lGy01OQdRxL+G
	 naMMgYl0dmo4OQl4zTjEAUitxqA4DmlYiGFod3M6dSQL8Wu5F7ENQEY4P3NlbbNG4G
	 R5ykgK7y6n63FzDHMECRfRZKcHHD6j7Kts7hINmdZSby5j3U6yUsYBh0Nj9/OdpMGq
	 ZL6MxZSpPsWSdnhIGuSv/pHZj8CxMPmOrrCbU6Rs2nT/VBiZcm8p4usuArOHCioEwc
	 WSVxKeFTjOMYA==
Date: Tue, 3 Mar 2026 09:14:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] debian: enable xfs_healer on the root filesystem
 by default
Message-ID: <20260303171400.GP57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
 <aacFKgnRvvhSVsH_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacFKgnRvvhSVsH_@infradead.org>

On Tue, Mar 03, 2026 at 07:58:34AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:40:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we're finished building autonomous repair, enable the service
> > on the root filesystem by default.  The root filesystem is mounted by
> > the initrd prior to starting systemd, which is why the udev rule cannot
> > autostart the service for the root filesystem.
> > 
> > dh_installsystemd won't activate a template service (aka one with an
> > at-sign in the name) even if it provides a DefaultInstance directive to
> > make that possible.  Use a fugly shim for this.
> 
> Given that this is brand new code it feels a bit too early.  But maybe
> that's just me.

A lot depends on the distro -- RHEL and SUSE require the sysadmin to
activate services.  Debian turns on any service shipping in a package by
default, which is sort of funny since they don't enable online fsck in
their kernel at all, so all the healer services fail the --supported
checks and deactivate immediately.

(By contrast stock OL doesn't enable the service but enables scrub in
the kernel; and UEK enables everything.)

--D
