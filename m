Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AE543785D
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788197827; cv=none; b=DtPBcEtI6mUX9UjJSIaNrkYYJIc8ktS4+YAKWzG3v3Kzgos8voST5ylLL5HbAHKQsRIByINviD2plLODvy0a33rLITHW8yY6YlT3Sxl5SVY9xWMCh2Y+CXDq/k2nAVcpuW1GvW7Mlxd7/3L6njKDlYwDctbybCBF/7MN6kUt3qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788197827; c=relaxed/simple;
	bh=vxYZcwcQw/OTa7q/P46s4HQP+JTls+hua+JhMicJIvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHOILq6gzuqjOgYxCfg5Wjhli8/ppNptYh6eMQ+5VCO/zThIbLrlwye31D01URdlu72ZmczqaMxNuFHeQPMfFvDygNOnPq5ccvWAQ/Tze6cMkBDZLdYCJkZtAZf6Ads7TEeuYj+jBIPqH2gVdL0mDKrT3HLG3MQ9ba1+mdqp2Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJYGlg7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJYGlg7J"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 915DA1F000E9;
	Mon, 31 Aug 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788197825;
	bh=cydUNuN95L6Il+615e3Ele4l4pV2pl8UJtf/R4f47b4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZJYGlg7JtiPCnHfwByvSrs0+oYuUi3UOQ/NO8SqvUr3fhoudcwLy878OrwXJiS1NU
	 iRwg7OCo/5lMh030QpI7QyfXXN/ofqMCVKmeUR3V2cADwLgFs7LJQFmcAwyYN8g7Zj
	 IofsqbZLxZoba8Tyw9CPXIloqBwAgo7ni/S3cM/PbKfLdhQOoVkK0GJo15epZWrXJl
	 27W2/yLukWa+cdOJqrljmwTrz+G5iWZ0bl55hnOGoKWa17SAt+gjqwJIxiq2mwnzKY
	 1DiadbsQFtt7arcjX0LDMShBym6yuBB2z73uBBGsnxFWyvD/l7Qv+4jcAgxbKQgKQD
	 IUHaKWsUZL2Yw==
Date: Mon, 31 Aug 2026 10:37:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wedgwood <cw@f00f.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] libxfs-diff: also compare libxlog against the kernel
Message-ID: <20260831173705.GA1933798@frogsfrogsfrogs>
References: <cover.1788110147.git.cw@f00f.org>
 <7e3d4d82541b0a7520a19d062fc0043e345066ca.1788110147.git.cw@f00f.org>
 <apWEWJyhaEQc62fK@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apWEWJyhaEQc62fK@infradead.org>

On Mon, Aug 31, 2026 at 06:40:40AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 26, 2026 at 10:08:13PM -0700, Chris Wedgwood wrote:
> > libxfs/ mirrors the kernel's fs/xfs/libxfs/, and the tool checks that.
> > libxlog/ carries files taken from the top level of fs/xfs, and nothing
> > checked those, so a divergence there was invisible.
> 
> Yeah, I recently ran into that as well recently.
> 
> > State the second mapping explicitly rather than searching for a matching
> > name, so each directory has one declared kernel counterpart.
> 
> What I wonder then is why we don't actually have this code in libxfs.
> I didn't get to investigate if there is a good reason for that, but
> if we could move the files to libxfs life would be much easier.

I've long wondered if the kernel logging code should all move to
fs/xfs/libxlog/ and the userspace logging code to libxlog/ to make this
easier?

--D
