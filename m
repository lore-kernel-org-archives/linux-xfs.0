Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F9039F168;
	Thu, 15 Oct 2026 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075645; cv=none; b=gagUGMMArOfSOX0msZUjWG4mufFFdIQP08AFCBeXRPmnayV+p+saw8GX2UbyQE1o61bnX++WCse5HJk9WBTJ/qdr9aY5+0i65uE7TPEPUFajH6Jdrvpgdrl7MfACWYsGc+vCMPLChsmzsM8XRYB/tjxKe+sGX6I7slgLjOJ+F5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075645; c=relaxed/simple;
	bh=qzUog2qSXZnMUJEUuR+qpJkdUa7WNVb4uTklWJ/pYWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qeGwp6dnv6eMbGVeCoSQYMHlPKsdrMWUpH4o+fjATHraYaxqQNNZLdfMVd7LQ5L/8oGGj1yrw2Nk7HJgDT5AcKx+rmdA7Td+yuVFWft9Q69tTxC+fvT625fpP/7jqlqzs6pf0a1fOfpxN28H8ksulgq7L3OTFVh+EwkwpKzHf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Swsj4a0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Swsj4a0P"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 40AFE1F000C4;
	Thu, 15 Oct 2026 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075644;
	bh=gKBQU5V4BqAbKuNOO8JV9l7sDD5YaW8MSjzPP0vqr0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Swsj4a0PbXdLUw7gOwb3Aya9xU9CUOViBH7hlG0mu43Pwgm/gGxcP8/BQrseZPvW8
	 baiKqvhFOaiGk6eN6AlHlmBklMTQh6m0TQMjSjWVdftJGXq46HEtY3cR0vo4Y0zY+E
	 9TT4dv6dPA/kNpAyMmcfZ8JKQ7qMIQq7hiyMPmoDvGlAkqRCXokm6JI6W1SU7gYIWM
	 3k0vjosgBdDj672lmGc/m1DQOg9UyVxP+q9Ayz8b7073s95pvoGzPh3XqMKTD3ITnc
	 Ng/ibGZr9S1MXMvhLqiks/gQUBDg5E+uKg3ArrTYYq6UCYM9iHoL2XgzThy+yrmzXh
	 yO+uZGUZWFPJA==
Date: Thu, 15 Oct 2026 07:47:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Message-ID: <20261015144723.GQ2705364@frogsfrogsfrogs>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
 <2026-10-14-1-daily-reply-0009-xfs-umount-hang-6-6-needs-ack@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-14-1-daily-reply-0009-xfs-umount-hang-6-6-needs-ack@kernel.org>

On Wed, Oct 14, 2026 at 12:53:12PM -0400, Sasha Levin wrote:
> > Backport of this series:
> > https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/
> 
> I saw Darrick's ack on the 6.12 series. Still waiting for one on this.

This also looks good to me,
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> -- 
> Thanks,
> Sasha
> 
