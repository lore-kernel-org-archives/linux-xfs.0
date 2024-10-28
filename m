Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068781D969C;
	Mon, 28 Oct 2024 11:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730114054; cv=none; b=XnNGecO05eEDmwoDZRKFNEVTvpW4o3Xuh19kN3/+d8ZcXt50cjzAeijhnzgWA7FGBXKMgqS7FMmTs7d+fPq7xfF/Qqp4pqWYHxHKBB8hlsfwgGjtRM7+ZgOO8Nay34ukIYOkkibyxlyfVug/kYyh/qTNM2YQPUUhoDRB5cG/4aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730114054; c=relaxed/simple;
	bh=erLeB07KltMNhtVUTSNmqhcya7ulzw3FQO5guEpxiQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAoPKEgzuVwv4PTGqYgzZH2pm0eC1WB+Yuh8atfwKIHW/bLvwLZ5OlT8JEv2oOvmahYNZjKS2iaPLRqm569flVX0CvIqmh1+QpVWOo7oPQteFwLiaQ0yGjC9qu9c9F9UpwFy2TFYI6vSaf8Natn+7VHG5U0gHZEhFAmISSzxWtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pR/xvaX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pR/xvaX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACE4C4CEC3;
	Mon, 28 Oct 2024 11:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730114053;
	bh=erLeB07KltMNhtVUTSNmqhcya7ulzw3FQO5guEpxiQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pR/xvaX/JFa2S9ocNjlhgJVkttAR2vDb3yHHgqsOFa8+wx+RtjpQapMQPd3+6Xfb6
	 aAiMZQpWTV8a9NFU97S+Yr6PL0wVOz8FoRzyUlc6r4oj1j17CRuzzg2ulfhx2RZ4V4
	 IB2/WSHCDiJTVtRGgieJN/riP8innt04vO3W7Q3WKhvHs5V28zFZ5lHL9sBMUFjr0v
	 yNNpdAoXKYSIzem6cNT8VSTc+r2n+lXdgxuMx9s5vHUISUo1/JYZmzT97LaQVXHMw9
	 69PJyV4FUvgRvHBCLpgzQ1q4oyrqcmbDiB5ct+G2q6I06U7qV3e+m7CV35KP7wehLx
	 fJJrUskPO/dvQ==
Date: Mon, 28 Oct 2024 12:14:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ruansy.fnst@fujitsu.com, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, willy@infradead.org, cem@kernel.org
Subject: Re: [PATCHSET] fsdax/xfs: unshare range fixes for 6.12
Message-ID: <20241028-zugpferd-esszimmer-6781201ff512@brauner>
References: <172796813251.1131942.12184885574609980777.stgit@frogsfrogsfrogs>
 <20241007-ortstarif-zeugnis-bfffcb7177aa@brauner>
 <20241025222444.GM21836@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241025222444.GM21836@frogsfrogsfrogs>

On Fri, Oct 25, 2024 at 03:24:44PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 07, 2024 at 01:52:18PM +0200, Christian Brauner wrote:
> > On Thu, 03 Oct 2024 08:08:55 -0700, Darrick J. Wong wrote:
> > > This patchset fixes multiple data corruption bugs in the fallocate unshare
> > > range implementation for fsdax.
> > > 
> > > With a bit of luck, this should all go splendidly.
> > > Comments and questions are, as always, welcome.
> > > 
> > > --D
> > > 
> > > [...]
> > 
> > Applied to the vfs.iomap branch of the vfs/vfs.git tree.
> > Patches in the vfs.iomap branch should appear in linux-next soon.
> 
> Er, this has been soaking for 18 days, is it going in soon?
> (Apologies, I just saw that you've been under the weather.)

Sorry about this. I'll get it out this week.
