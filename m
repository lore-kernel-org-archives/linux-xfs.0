Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D1B23D291;
	Sat,  3 Oct 2026 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791029250; cv=none; b=ZBWHO4DgpJTLacdeIt/Wz2QULxXWiK2klcF4y56rLdmn4bXAfrgNT+gMiPjJDVmBHRwkUNlqvffqObxf53yF57gTfPjrBO/OPnUiZtQ+tluLr84szvN8G7L/emLJLBicKjOGQgHGfUTZulyqiie9t15Ng9GB7EEYAyQfNanExDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791029250; c=relaxed/simple;
	bh=GmUXC8F9gWZKI9ouwcpeT04awqh9xaPt0KtbUTjpz6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9eZJXuuyU9OIA4uPWN81tKQ9CMtFOEdImabJEyTqdTwaZ9499uDblA871hv6ULSvZRnxso/se5+t1gbK+kjgjSiwMnsX1MOXO0keANFNgZS5I2gVMAU7kf5lmukDbLtZ1G6dvp11ZMC/KNth9eGDBTo0Slp6vqCbNEa4JLR/AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsG07AbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsG07AbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192971F0089B;
	Sat,  3 Oct 2026 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791029248;
	bh=EnFaP/Rj6/FO7QhoFI4cAaoDyUrDm9rWa6WobuyTgnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FsG07AbR32O0eAWDEJ+kolPUINuSS/W/hWYnOEbW1yICoXQ1mL1BHF8uqyqyVKdxW
	 KzHbZi2UebWAh1TPFfuJt8mSJgMLVSskFAdLZrPqirZcCyl9mbXYY47NUR8sSMQGP5
	 f7WGG3f6w0hOd58m40O2deJNgZbk2T50TUHVkWGe564svrY5ivna56btCVpuTSZX6B
	 L35uvOGCIWDkwwDvvL9SnQ/v6hdjYe+r7OH8X1Cghzwj/PFbvDdL/cVCBaTGsrtusi
	 fZSS3iS5wsIzw38RbH+aYuJukEae6cUna3S1uZiutQIK7Hatu+HPZfuz9KfRxwwqLl
	 W/epvyyGy3k7w==
Date: Sat, 3 Oct 2026 14:07:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	hch@lst.de, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <asDvqctUgrxflcCa@nidhogg.toxiclabs.cc>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002232542.GA15366@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002232542.GA15366@quark>

On Fri, Oct 02, 2026 at 04:25:42PM -0700, Eric Biggers wrote:
> On Sat, Oct 03, 2026 at 12:36:41AM +0200, Andrey Albershteyn wrote:
> > Andrey Albershteyn (19):
> >   fsverity: report validation errors through fserror to fsnotify
> >   fsverity: expose ensure_fsverity_info()
> >   fsverity: pass digest size and hash of the all-zeroes block to ->write
> >   fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
> >   fsverity: don't allow setting DAX file attribute on fsverity files
> >   fsverity: hoist statx reporting of fs-verity flag
> 
> Would it be helpful if I applied these six patches to fsverity/for-next
> for 7.4, or do you want to wait for the full series to go in at once
> (presumably through the XFS tree)?
> 
> - Eric
> 

It's your call, I *think*, this is too late for xfs 7.4, so I want to
queue it as soon as possible for 7.5.

If you want to take the fsverity patches into 7.4, go for it, then the
xfs ones I'll pull in once yours are merged.

Sounds reasonable?

Carlos
