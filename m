Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06901E9905;
	Fri, 21 Feb 2025 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155913; cv=none; b=EK6CnYth/Dua9Lpf6G86XbHqLGb0FIp0YUMwRyAZIIGQZzheoWfPRKLEoYtsAOYFvFin77De3miLtH+oGglcSq5dxNHOTwWDafB4laoiKyfDVSeDXC4YwgEidvBJo5VJBE6MCwdVSkuT6Kk45GxW8rfHPB55fXrMC2o1/VV82M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155913; c=relaxed/simple;
	bh=QmyIH+mIMMQ1X41pdeHl5nhnKAxLMnO9/8puOu5y24Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bagvXV1BbUR6ZeeXgGWR0LKGH+CjYJ7Bzdr59Hmli8tICx4XElVK+jUBfkgGVQKOIyWHFMDxiaj6VOCQED2QuS6axCOwffgZeTvIkZ7bOKpJ1E7RTOyo3fiKBfgdxXRrgLqt9EPw8J+vTeoqS0aNdcX+RHvnToDDmhRDAVmFMuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rsNN1efL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rsNN1efL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDC5C4CED6;
	Fri, 21 Feb 2025 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740155913;
	bh=QmyIH+mIMMQ1X41pdeHl5nhnKAxLMnO9/8puOu5y24Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rsNN1efLb4uEy0RveVrr2XWB8fClxiZahUrCiOvLxm+C3v9ThufDNPywNTarJ9pyp
	 FmbCp5JVzJFxlvCXGTG1OKfSKWRAFPufbcPBUVopspVM288JNvQQjUHCpjglyM0Bev
	 enfwqfs8BmNfuryFQ2Ftdvf7aEDy2+65311gqxSLzwvFwqZRJPJsltgVztubJYIlMD
	 LYzmxTLe6zfa8/om+xW4JeUqS9erU+wVymaqHtWf4g2bRu+cvr2e5/8U7IaUHGsiix
	 ue9ABNyUVb3m1fF6/X8RkzF5VNL5lKfqgqNMxlD7UFrgg21RnbUhFyz7FmuJTV7J4a
	 xT5VrirvfqSCw==
Date: Fri, 21 Feb 2025 08:38:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [GIT PULLBOMB] fstests: catch us up to 6.12-6.14
Message-ID: <20250221163832.GB3028674@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
 <20250221054126.x5dc5wiidsnhen5g@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221054126.x5dc5wiidsnhen5g@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Feb 21, 2025 at 01:41:26PM +0800, Zorro Lang wrote:
> On Thu, Feb 20, 2025 at 02:02:45PM -0800, Darrick J. Wong wrote:
> > Hi Zorro,
> > 
> > Please accept these pull requests with all the changes needed to bring
> > fstests for-next uptodate with kernel 6.12-6.14.  These PRs are
> > generated against your patches-in-queue branch, with the hope that not
> > too much of that will get changed.
> 
> Hi Darrick,
> 
> Are you much hurry to have this large "PR BOMB"? It's Friday for me, I'm
> going to test and release fstests of this week. I planned to have a stable
> fstests release this week, which contains your large random-fixes and some
> other fixes/updates. Then we can move forward after that big feature change
> last time.

No big hurry, just getting PRs lined up for after patches-in-queue goes
to for-next.

--D

> I'll try to make a release next week too, for your big PR bomb. Good news
> is they "nearly" don't affect other filesystems. So if they can through
> my basic regression test, I'll merge them soon. Or merge part of them at
> first.
> 
> I'll merge them to the patches-in-queue branch at first (after the release
> of this week). Then test it and talk with you about more details.
> 
> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> 
