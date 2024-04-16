Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504FB130E30
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 15:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713282573; cv=none; b=K1nY9HMbW7RQ4j9v6h2Dm2QSRDev/Oa9SfwTI5U8njKv7MpXj3CrqkSqWxME/3ePPYEVqafVxGDx5RkQ78yy/CkfX7OqoP8ozX/tG4huUHbTzNyRB5Z9aIeS1OSitHOgVnI7J2FIq53NmSGG6xohJL/MnjM4V/lFTBJktpd0sLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713282573; c=relaxed/simple;
	bh=5rqqLpwsbMAGPZnnODgbbMOQxCAtXwXmvUvPA79EjOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZVMFmyqB/17Jwz3sc+jYmXYJZJv1enGF7FwACGkVJ0rLej2XoXcAxdgxoSQxoTzbWL0dYTOouz72cNQc3uZDisHh2k5Q2rr8SJhiRCoqMcJDXCVazWfBHabgRenzZM3tCmn9bZ9Ez9r/irhfCNRF54Re4xFQNe14PPRdk3jZxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pu9b/Mqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pu9b/Mqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEB3C113CE;
	Tue, 16 Apr 2024 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713282572;
	bh=5rqqLpwsbMAGPZnnODgbbMOQxCAtXwXmvUvPA79EjOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pu9b/MqabQ5jWidkTa2XoPskuVz2KUP8Msqx6en+ueTszVZqBMm3i2rdmY3C8D1LP
	 aCgoA8jmVzeDD7041LrWIxasQU8WpSvqmSqMrImwaYMpc1PZjxyUiThUflRxe6G0fZ
	 Q9pQLVxAHQFiwZ7fTcE3mNY65WLb38PicmU2IGrEYnU5HmtMlbHiw9PtJ5Qfn0uz+W
	 h3Y4wwBPZqNcTE7sF4WIsIGAata9+FV15YqwlAm+NfRZ31eV35nvx5ID4qBLFswN8g
	 b6rupatSqBm9ZiijVKd5TCjkJDLZUBFfC1RVNJcp+/aDrTwmVxTNl0Ej3MeSipMYvk
	 NgxoY/DfcfEjQ==
Date: Tue, 16 Apr 2024 08:49:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <20240416154932.GH11948@frogsfrogsfrogs>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
 <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
 <Zh4EpDiu1Egt-4ii@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4EpDiu1Egt-4ii@infradead.org>

On Mon, Apr 15, 2024 at 09:55:00PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 06:00:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make it so that we can partition a memfd file to avoid running out of
> > file descriptors.
> 
> Not a fan of this, but I guess there is a real need somewhere because
> we run out of the number of open fds otherwise?

Yes, we can hit the open fd limit...

>                                                  Given that repair
> generally runs as root wouldn't it make more sense to just raise the
> limit?

...and we /did/ raise the limit to whatever RLIMIT_NOFILE says is the
maximum, but sysadmins could have lowered sysctl_nr_open on us, so we
still ought to partition to try to avoid ENFILE on those environments.

(Granted the /proc/sys/fs/nr_open default is a million, and if you
actually have more than 500,000 AGs then either wowee you are rich!! or
clod-init exploded the fs and you get what you deserve :P)

--D
