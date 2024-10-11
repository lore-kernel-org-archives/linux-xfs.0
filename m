Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B2638DF9;
	Fri, 11 Oct 2024 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728670762; cv=none; b=n7ymQLH31Y7ph4Edej4PlB/OvSuSSwCQml6WK4jqqui9+5xHCWORlm4KiuIjPSCkBw9EcE+mLz62xDYHscysf6NUv8jePGZOy+IHa+ybkzNd7brxERQQf9gMko0e6tOgXtEvqYy/vuHy8rqT0D4AXNUqkORXNPqaPG4SonBbmA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728670762; c=relaxed/simple;
	bh=rasa6/SvZ4L4zkORf4p4Ln99RF1ZEJ7z1Z8/hhVND7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXIOfFJkMX6IRYR5nH5xFoU5vfYdZ/RHAFp4O9GHj7ZaI0+RkTZjg8SxCap99Q9+6jlOKYgWy8cUqHhQaAoIEKHfVsePLcbyyOkvHCtn/coV/KfRZHciFl7bXF1Nbjw3Ot0abvLJGhdK8NwVlfLQRRJz2Y5eMsYRwcwdDGPwO4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPT3br+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPT3br+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCC8C4CEC3;
	Fri, 11 Oct 2024 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728670761;
	bh=rasa6/SvZ4L4zkORf4p4Ln99RF1ZEJ7z1Z8/hhVND7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LPT3br+SYTWiYgh46FZnUPEYJ2UExs/zucAjG7DiqYts0rbVAR+3h9y3tMtSe6swQ
	 VwOhyj0gUsjCDcKwJhBHwLz3fpB65hDtbR4VC9yrA9wbAJVU4IHanDSsDMCOFG1n8t
	 dlKl2858mY0RsqJSukDovQsqljJiwbJ0OkSORpmEk7JkUoacayFInKKytsGwR8msS3
	 rVKEh6EhwIcOIeqkp+PKwf7UebfbLgBVZWps9+WrQ5iY0lmriIjiryma66vxMzwWzE
	 f8qa9SooA+ApQKaM9yOSQk6XdJp48HgkxctxZFXgMGCLokdeUC7htG96kP5A8hcGa+
	 1ThsNFh1JcQPA==
Date: Fri, 11 Oct 2024 11:19:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/122: add tests for commitrange structures
Message-ID: <20241011181920.GO21840@frogsfrogsfrogs>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
 <ZvzeDhbIUPEHCP2D@infradead.org>
 <20241002224700.GG21853@frogsfrogsfrogs>
 <20241011062858.p5tewpiewwgzpzbo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011062858.p5tewpiewwgzpzbo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Oct 11, 2024 at 02:28:58PM +0800, Zorro Lang wrote:
> On Wed, Oct 02, 2024 at 03:47:00PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 01, 2024 at 10:45:50PM -0700, Christoph Hellwig wrote:
> > > On Tue, Oct 01, 2024 at 09:49:27AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE.
> > > 
> > > Meh.  Can we please not add more to xfs/122, as that's alway just
> > > a pain?  We can just static_assert the size in xfsprogs (or the
> > > xfstests code using it) instead of this mess.
> > 
> > Oh right, we had a plan to autotranslate the xfs/122 stuff to
> > xfs_ondisk.h didn't we... I'll put that back on my list.
> 
> Hi Darrick,
> 
> Do you want to have this patch at first, or just wait for your
> next version which does the "autotranslate"?

Let's drop this for now, machine-converting xfs/122 to xfs_ondisk.h
wasn't as hard as I thought it might be.  Would you be ok with merging
the fiexchange.h patch and the fsstress funshare patch this week?

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> 
> 
