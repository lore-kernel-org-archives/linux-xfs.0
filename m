Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220C733984C
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806530; cv=none; b=J5B82pFo3QQ0PAp22cjAnaBNuVJrmup3dSJ/KnIy3FbPznmc+xeASzIPClPs4h4u8Bc1IQbMq3twcwe3NzZeeaKi2Rq/lu/pPyeEarOzPxZVSuM8LWBE/uy2kqKAZMbuXxf9bwwkJVfz/uG4dOR13Aj9SJG8ptU1KXtDDZ5REz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806530; c=relaxed/simple;
	bh=W/6hnrSDzZRQUV7tygs1Ix98On5YEkEtIhkLXWywV6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8UrohBAY4RCsLlnNxEsbOjts3nDYa/hqUUAYo/X4Yz6I3qzXvkYLrgkjg6Yi4l3/RhBRX4j9spcz/usXryuvSRg/hnoTXAWSUcq27lJT1bvCgqowwDwup46iLdFloOCQHgvO8BugO2hxQWvSVjZIE2qsQrQYTeirnyB7hXLrCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sav3/4EJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sav3/4EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433F1C4CEF1;
	Wed,  7 Jan 2026 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767806529;
	bh=W/6hnrSDzZRQUV7tygs1Ix98On5YEkEtIhkLXWywV6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sav3/4EJDnwTrRtblKEUXRqIoJCSm7nGsBJrYnprpmWvA27SVMJQgBzjl8/iUDqjo
	 P8wzllxV97B9XNzbmLthYL7Sx3HXa/K4qQhHgAXhbtHTqirZUMecQqSValLKDwEdC+
	 2xpjghDGFUrBJteF+6qBxU8OGM6shQOcGfZjAPY/nzelQmL75QcT0XcYX9++g9Cf27
	 yty1ZB/x6Ogkw6D7CvtX4R4ZE5DWxAJ1txzok5eRT+serj99Is3p3As5Wln32rvsPU
	 KSBxrVxMWyZA7liozjVEYIeUGcw5xtGGtQd4piB90zv/W41Tha+Bat5FTWRU+4vxTj
	 TUbWRig7QpIHw==
Date: Wed, 7 Jan 2026 09:22:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_logprint: print log data to the screen in
 host-endian order
Message-ID: <20260107172208.GC15551@frogsfrogsfrogs>
References: <20260106185337.GK191501@frogsfrogsfrogs>
 <aV35idJuT2MZdpv_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV35idJuT2MZdpv_@infradead.org>

On Tue, Jan 06, 2026 at 10:13:29PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 10:53:37AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't make support have to byteswap u32 values when they're digging
> > through broken logs on x86 systems.  Also make it more obvious which
> > column is the offset and which are the byte(s).
> 
> I like the new output style.  But this might break existing setups
> (or old users :)).  So maybe make this conditional on a command line
> option instead?

Ok.

--D
