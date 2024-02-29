Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFC863113;
	Thu, 29 Feb 2024 17:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709228912; cv=none; b=VWRQhAqu57St/J9augpjxrAgYEAZWVMUV60HnF3AKWfaRe1t6m8Q0PvhXhHnQtUT9ivQU6R1kCWuvPWbyENHmG5EdCUoXkojJbkO6YYyVfchoap4Mrr1KCe/rerdMJCU1dzh3sLxGXsdtfr90CIZ73lJzGLt4V7bdQw11CvDsOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709228912; c=relaxed/simple;
	bh=UNiYCunT2UCAvBD2uQlgDLdoBs42SZ66NYTMKIDSauo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7VomalT50yxku+Jh9qJJ4Lfbczyyb7ZddALdVCMdHW4AzNa7L/vrCxA67Klmv26iNSJttkQusTKd0nmb3kGJ8Lit3uAetDAVkAG5W5OlcNbvvRauyh+fRaNY/Z9584Sh1sMmq6dbmeILfKNew8kp5vFHdtTmW9n9dzeh0hXflA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DT53xOyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DT53xOyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C517AC433F1;
	Thu, 29 Feb 2024 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709228911;
	bh=UNiYCunT2UCAvBD2uQlgDLdoBs42SZ66NYTMKIDSauo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DT53xOyhc42jrzlkIUrnv67nkShugzMH/Ua5T1J24WvWuHFo0mz3pPFDl4Xg3NPKT
	 hTyrDTi2ayKLJqjCpxymflBFEQCubbhyQsCcRUikbLBeVFzlac86TCENuMNw0D1o66
	 Mz1BpdPM33QoZGfr3cclVGQ5kixQLwnMj2EXYNtrrS2g72z0kGTFgNvUrOjw5G3EpZ
	 KUiff8tHiw1nLXiKmmTLbXIV13CsPUtRutpbF3W97b/tNjnEVtNtcTOF04q6JzqgjI
	 zC8x1GWoRczM119vIMNp0Gdq07MfdCI1ZwnvHjeMY6+7CCG+TTAV9cBVsi/cKuWl3e
	 nTV4RlNk1Au9w==
Date: Thu, 29 Feb 2024 09:48:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
	fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240229174831.GB1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
 <Zd9TsVxjRTXu8sa5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9TsVxjRTXu8sa5@infradead.org>

On Wed, Feb 28, 2024 at 07:39:29AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 27, 2024 at 05:27:04PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 27, 2024 at 06:54:41AM -0800, Christoph Hellwig wrote:
> > > Can we please just kill the goddamn test?  Just waiting for the
> > > xfsprogs 6.8 resync to submit the static_asserts for libxfs that
> > > will handle this much better.
> > 
> > I'll be very happen when we scuttle xfs/122 finally.
> > 
> > However, in theory it's still be useful for QA departments to make sure
> > that xfsprogs backports (HA!) don't accidentally break things.
> > 
> > IOWs, I advocate for _notrunning this test if xfsprogs >= 6.8 is
> > detected, not removing it completely.
> > 
> > Unless someone wants to chime in and say that actually, nobody backports
> > stuff to old xfsprogs?  (We don't really...)
> 
> Well, who is going to backport changes to the on-disk format in a way
> that is complex enough to change strutures, and not also backport the
> patch to actually check the sizes?  Sounds like a weird use case to
> optimize for.

It turns out that xfs/122 also captures ioctl structure sizes, and those
are /not/ captured by xfs_ondisk.h.  I think we should add those before
we kill xfs/122.

--D
