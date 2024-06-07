Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88FF20328;
	Fri,  7 Jun 2024 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717784184; cv=none; b=aMF9uuevRYRAyxMZXJV5P3D/qF9fapoh+dl3D51yu/yUzB9+be7oDAXPBGJEGdpBJHlvVJzHz9S/iZQp9acjyharyz9/KP4gHF74pY8pU02ykvpPFgrHohDKtjzkFunglh/ezBLP+IvYZWb4lUGnftVyVxsvoosjwAF0cD5uVCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717784184; c=relaxed/simple;
	bh=JXZUAF1M4vQTr6VpW3B38YSyXXvILfMnD0BrpTGqeGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeOlQZlfb+sUAliJ5N8GyGlq9w/vn4mRbFzJJVqPnCyz1/yOGMLk8ONiRngQNnZaATet8u6FVxvDJJ2ENlbY7k8nElL4SaHinECbZd47m2GFDLaQMGAQhJcJgxHj8qA2vhDb+wyF+Ydck4Y9Ccg/5SGBW3A1NVlTax3BRzN9QLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvOkCDMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvOkCDMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8059AC2BBFC;
	Fri,  7 Jun 2024 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717784183;
	bh=JXZUAF1M4vQTr6VpW3B38YSyXXvILfMnD0BrpTGqeGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LvOkCDMoMpKx862D90b+AnbUfo7K3a1eCgDByvp9Bu8OfR24sCsy9bteluiU1FTMQ
	 Ww1USi9P2Zu9deWwHAwgNqbofkW7P2/uLbGwrjIdv7pR2PWd5exFTljJKkI8dHYoV8
	 xfdNNxlAHQIFzW+aghpJUzSLLCxiUgn8dL3YfVRdRRGUIqiNA4oEmA7xd5fAgULAXx
	 /0y7gm7xffOzDtO2aB+ihn8oIjdAEiJkfMplDZbZbvfYSvRWlmgcfg2uGqjcayiKt7
	 +8ppsqd4ZZIW477OFkyTW1DxDAdZQEiHHuoyVI/ZLLqERSXnYLP65gc1o9XqdfvwNT
	 z+kGSiM9tJHJA==
Date: Fri, 7 Jun 2024 11:16:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCHSET 3/3] xfsprogs: scale shards on ssds
Message-ID: <20240607181622.GN53013@frogsfrogsfrogs>
References: <171744525781.1532193.10780995744079593607.stgit@frogsfrogsfrogs>
 <Zl6hdo1ZXQwg2aM0@infradead.org>
 <20240605005636.GI52987@frogsfrogsfrogs>
 <ZmKVYsgIkh-h5PG5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmKVYsgIkh-h5PG5@infradead.org>

On Thu, Jun 06, 2024 at 10:06:42PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 04, 2024 at 05:56:36PM -0700, Darrick J. Wong wrote:
> > Not much other than the AG[IF] and log grant heads becoming less hot.
> > That pushes the bottlenecks to the storage device, which indeed is about
> > 8 per device.  More if you can raid0 them.
> > 
> > *Fortunately* for metadata workloads the logging code is decent about
> > deduplicating repeated updates, so unless you're doing something truly
> > nasty like synchronous direct writes to a directory tree with parent
> > pointers that is being modified heavily, it takes some effort to
> > overload the ssd.
> > 
> > (Or a crappy ssd, I guess.  Maybe I'll pull out the 860 QVO and see how
> > it does.)
> 
> Ok.  I'm also a little worried about creating lots of AGs for tiny
> file systems.  Then again I've not actually been able to find the code
> yet which I should probably look at first.

It shouldn't create fewer AGs than what the default algorithm would have
calculated, and it won't create AGs smaller than 4GB.

--D
