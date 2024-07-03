Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70732030A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982915; cv=none; b=M0hfAx7WptEqlgIhsPEY+ifhwXAye4rou58AC5B/72GkLHwmhKmg891Rj4TPJMB0gDWzsG6e6NhhIennrCFrND+N/w/6Tf9AsNr0LPVJfyifkk1arI/TN1lGfF7xUY0oXjeRJmy9uB8R89k2plf+AYv9VyqvThcJVXXP3Kcn8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982915; c=relaxed/simple;
	bh=6GI+jsK3znC+ArJuB3veAVBQgZzdo0xz0pXeG/2eJ1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTr5k4916fltaVtzi4t0kgTOg1vn4CWJiH7w9hTk5cpRWZU5VFxLSI0o2zPCCC6EICBwNJvVjJX0cKaGWdqifG2a1yhc+214hBEKhD9ZU/ZowPWRU6mq5XMCdZyRo3mxKDZAQRzFvbE2fNgcbBE6t4PsRpL/HPIDgfOmYn9M0fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKGBRSWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKGBRSWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68368C32781;
	Wed,  3 Jul 2024 05:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719982915;
	bh=6GI+jsK3znC+ArJuB3veAVBQgZzdo0xz0pXeG/2eJ1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AKGBRSWcycto9R/kKiaV0DKML+A/vxbf/yjgT/5hAlgoud6P5qK2S9LrmkKdESwI3
	 S47dJCtu1evvDZNxzeweAH6g2+7lFSd/pjFQ84RmowpKlA/PezWaMVGSiUuehq1vmX
	 LFHII57xua4dUvPy9fWZjRcs2fSoIpjZckdlY3lemoA4epxnclS83va3OpHzYr39LX
	 ADfKXdI7rBtCzmTshNJi8uLAyMU83Z27xbAkiWqp1CdpYenta3uFBdFwe2euZrV9vb
	 sbx3RgmfrSb6SO19Kv5Md8exj4jOM7NZjdZ+NLQ4q1mKxiYCEIsgchKaNlc/iTzahL
	 bcQg0cRtOXwYQ==
Date: Tue, 2 Jul 2024 22:01:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240703050154.GB612460@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
 <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
 <20240702054419.GC23415@lst.de>
 <20240703025929.GV612460@frogsfrogsfrogs>
 <20240703043123.GD24160@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703043123.GD24160@lst.de>

On Wed, Jul 03, 2024 at 06:31:24AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 07:59:29PM -0700, Darrick J. Wong wrote:
> > CONFIG_XFS_ONLINE_SCRUB isn't turned on for the 6.9.7 kernel in sid, so
> > there shouldn't be any complaints until we ask the kernel team to enable
> > it.  I don't think we should ask Debian to do that until after they lift
> > the debian 13 freeze next year/summer/whenever.
> 
> I'm not entirely sure if we should ever do this by default.  The right
> fit to me would be on of those questions asked during apt-get upgrade
> to enable/disable things.  But don't ask me how those are implemented
> or even called.

Some debconf magicks that I don't understand. :(

A more declarative-happy way would be to make a subpackage that turns on
the background service, so the people that want it on by default can add
"Depends: xfsprogs-background-scrub" to their ... uh ... ansible?
puppet?  orchestration system.

--D
