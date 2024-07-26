Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6905417FF
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 00:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721954515; cv=none; b=l7kg9Vs8pfyK5xiyS9H4vRCRsWH00RnJG1KTtzNJj/N+krtGBxMOBIGshGKf5V1VTPN9TlGFxgRE9WaEpWiffcUVgUKlKHY0BYZtaUhtb4VgBFyCDse4jQPwCy07AKc7Qcz4EJAdxShsjYGgKrkIMRe8wpqul/4n9ZyK76/r+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721954515; c=relaxed/simple;
	bh=EvOeJGqQepJHTQ9pH3jLB1xBxDyczNWBCTDxjgGprw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucklCGuk4OG8svnYhdbl3SdddhEoajtWvYj8heQbi3PZReZVAUt37uynPg8XdscScTik9RK0dgNCFihsnNxPgEJxqNlLIQWXTqMDDeF0SvwPrFfByOT0VuUjkLW9IaNvYFmLCpLBzDAjBlLt2awipvx+xalXdpRKJw/ysZhNkX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VA844/t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VA844/t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB3CC116B1;
	Fri, 26 Jul 2024 00:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721954514;
	bh=EvOeJGqQepJHTQ9pH3jLB1xBxDyczNWBCTDxjgGprw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VA844/t54ynusqB7y2RNGMohij/SiUojIuP+Dbvfh4G1bZow2nPqVZ8qOOcrrONfa
	 iq/Aj3KXbywUwrFQs+aBVfIziJArQRMO/YzJMstgmKhrML8phqrxtDvOkXjlH/B2pn
	 94mYMUor/KiIHGUbW5PmDasM4XghgRAN6auDxns6HR8CyGS1374DH84Q4uXoRQ5KfN
	 176qsdyVt3YvY5lCpkjYNZUEJ05yCFuhpNiTmhbeGSJNzIXSKWOb0dHeRGkpdgkAJG
	 vkqeuGVD03I2oYG00m/dsScuprH0lmT/F0/In/arWyN/abncelbRgEiTjS5/sAyF3Z
	 81K1dcbwE8N5A==
Date: Thu, 25 Jul 2024 17:41:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <20240726004154.GD612460@frogsfrogsfrogs>
References: <20240724213852.GA612460@frogsfrogsfrogs>
 <ZqGy5qcZAbHtY61r@dread.disaster.area>
 <20240725141413.GA27725@lst.de>
 <ZqLSni/5VREgrCkA@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqLSni/5VREgrCkA@dread.disaster.area>

On Fri, Jul 26, 2024 at 08:33:02AM +1000, Dave Chinner wrote:
> On Thu, Jul 25, 2024 at 04:14:13PM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 25, 2024 at 12:05:26PM +1000, Dave Chinner wrote:
> > > Maybe I'm missing something important - this doesn't feel like
> > > on-disk format stuff. Why would having online repair enabled make
> > > the fileystem unmountable on older kernels?
> > 
> > Yes, that's the downside of the feature flag.
> > 
> > > Hmmm. Could this be implemented with an xattr on the root inode
> > > that says "self healing allowed"?
> > 
> > The annoying thing about stuff in the public file system namespace
> > is that chowning the root of a file system to a random user isn't
> > that uncommon, an that would give that user more privileges than
> > intended.  So it could not hust be a normal xattr but would have
> > to be a privileged one,
> 
> 
> I'm not sure I understand what the problem is. We have a generic
> xattr namespace for this sort of userspace sysadmin info already.
> 
> $ man 7 xattr
> ....
> Trusted extended attributes
>        Trusted extended attributes are visible and accessible only
>        to processes that have the CAP_SYS_ADMIN capability.
>        Attributes in this class are used to implement mechanisms
>        in user space (i.e., outside the kernel) which keep
>        information in extended attributes to which ordinary
>        processes should not have access.
> 
> > and with my VFS hat on I'd really like
> > to avoid creating all these toally overloaded random non-user
> > namespace xattrs that are a complete mess.
> 
> There's no need to create a new xattr namespace at all here.
> Userspace could manipulate a trusted.xfs.self_healing xattr to do
> exactly what we need. It's automatically protected by
> CAP_SYS_ADMIN in the init namespace, hence it provides all the
> requirements that have been presented so far...

<nod> Ok, how about an ATTR_ROOT xattr "xfs.self_healing" that can be
one of "none", "check", or "repair".  No xattr means "check".

> > One option would be an xattr on the metadir root (once we merge
> > that, hopefully for 6.12).  That would still require a new ioctl
> > or whatever interface to change (or carve out an exception to
> > the attr by handle interface), but it would not require kernel
> > and tools to fully understand it.
> 
> That seems awfully complex. It requires a new on-disk
> filesystem format and a new user API to support storing this
> userspace only information. I think this is more work than Darrick's
> original compat flag idea.
> 
> This is information that is only relevant to a specific userspace
> utility, and it can maintain that information itself without needing
> to modify the on-disk format. Indeed, the information doesn't need
> to be in the filesystem at all - it could just as easily be stored
> in a config file in /etc/xfs/ that the xfs-self-healing start
> scripts parse, yes? The config is still privileged information
> requiring root to modify it, so it's no different to a trusted xattr
> except for where the config information is stored.

Sysadmins can already do that via systemctl mask, as I pointed out in
the earlier thread.  I think between that and the xattr we're covered.

> Userspace package config information doesn't belong in the on-disk
> format. It belongs in userspace configuration files (i.e. as file
> data) or in trusted named xattrs (file metadata).

Sounds reasonable to me.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
