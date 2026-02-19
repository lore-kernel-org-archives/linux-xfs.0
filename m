Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB7634CFC8;
	Thu, 19 Feb 2026 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771521411; cv=none; b=ZejCBYiB1eGts1UPqto1Ktmhhl/aN3Uf3Tigauxca2IT0qjMEs55SjHAGarRBd+xQWV7g6Y4+UCdrNpNUgjpHPgI7DKEOvKAMeDBr69rEoy4hxY2E0QqCL1cXOVkmMSiB3Qd1muiEzsToTBcWK/bwYjHWJQnfmYjkQNH+jxzP3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771521411; c=relaxed/simple;
	bh=HV3YmAJEx9bKYraIHP8+wQjPLs3JUHyrAhNMSIib5xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MA5AyRdwhRaAUnWuXfW9qiYtfvOwA0kc3w7/5lTJf+JYv6Xiq8PbtgAIhBSLWPuw4xcVYQQv4f/b7bEOI5ClC8NUA+TSrtV5kMctuXZ+2Q+PvjImJo/KjYG6g5U9T8kJSNYiTrkE8TtEU/mpIFx5BVjTzfnp32NNRl1c4LVOhhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nr2mIsu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nr2mIsu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DB1C4CEF7;
	Thu, 19 Feb 2026 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771521411;
	bh=HV3YmAJEx9bKYraIHP8+wQjPLs3JUHyrAhNMSIib5xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nr2mIsu16t1mHztmgH6ZK6/KUoZNvt7awq/g/sdq6rv6J2t5qPtDsH+Gq3mvi2tui
	 3YQWhdz4wMPPTXYgp5/ndOCwvhjpEbePvDzf/fYN4RgGBb5Fe2l/RQFkyA/0O96vsu
	 KA8pR3qG8SJu17znYhL7uAA7RmMQWuzjMKiCVciXhlSGLkQzg8N3ZOt09gHHpK4D9B
	 H9dcb8LzKBmRZkkia803p/+Il8TFR95d4UA+qv/aVhdTXkcy5ik3PcOX4lMpSJZ+/i
	 uJBb/HE2jQZXvWx0K+t27nv5Q0pkv8bFMs3jVBnFjc5swdPF6FWWNpV72dQTY/Rz8H
	 6hchY6AqicInw==
Date: Thu, 19 Feb 2026 09:16:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Subject: Re: [PATCH v3 03/35] fsverity: add consolidated pagecache offset for
 metadata
Message-ID: <20260219171650.GJ6490@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-4-aalbersh@kernel.org>
 <20260218061707.GA8416@lst.de>
 <20260218215732.GC6467@frogsfrogsfrogs>
 <xxpvkb5cmadxkifi3onmfmnaorw3emfzr32ha5n6kma2kvg54a@ueu4zhhzrglc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xxpvkb5cmadxkifi3onmfmnaorw3emfzr32ha5n6kma2kvg54a@ueu4zhhzrglc>

On Thu, Feb 19, 2026 at 02:09:54PM +0100, Andrey Albershteyn wrote:
> On 2026-02-18 13:57:32, Darrick J. Wong wrote:
> > On Wed, Feb 18, 2026 at 07:17:07AM +0100, Christoph Hellwig wrote:
> > > On Wed, Feb 18, 2026 at 12:19:03AM +0100, Andrey Albershteyn wrote:
> > > > Filesystems implementing fsverity store fsverity metadata on similar
> > > > offsets in pagecache. Prepare fsverity for consolidating this offset to
> > > > the first folio after EOF folio. The max folio size is used to guarantee
> > > > that mapped file will not expose fsverity metadata to userspace.
> > > > 
> > > > So far, only XFS uses this in futher patches.
> > > 
> > > This would need a kerneldoc comment explaining it.  And unless we can
> > > agree on a common offset and have the translation in all file systems,
> > > it probably makes sense to keep it in XFS for now.   If you have spare
> > > cycles doing this in common code would be nice, though.
> > 
> > fsverity_metadata_offset definitely ought to have a kerneldoc explaining
> > what it is (minimum safe offset for caching merkle data in the pagecache
> > if large folios are enabled).
> > 
> > and yes, it'd be nice to do trivial conversions, but ... I think the
> > only filesystem that has fscrypt and large folios is btrfs?  And I only
> > got that from dumb grepping; I don't know if it supports both at the
> > same time.
> > 
> > OTOH I think the ext4 conversion is trivial...
> > 
> > static struct page *ext4_read_merkle_tree_page(struct inode *inode,
> > 					       pgoff_t index,
> > 					       unsigned long num_ra_pages)
> > {
> > 	index += fsverity_metadata_offset(inode) >> PAGE_SHIFT;
> 
> I don't think it's that easy as ondisk file offset will be the same
> to this. So, this will require some offset conversion like in XFS
> and handling of old 64k offset.

Oh, right, because you still have to audit all the EXT4_PG_TO_LBLK
callsites to translate the fsverity region back to the ondisk offsets
before calling ext4_map_blocks().  You're right, this isn't a trivial
refactoring.  Comment withdrawn.

(I'd still like the kerneldoc tho)

--D

> -- 
> - Andrey
> 
> 
