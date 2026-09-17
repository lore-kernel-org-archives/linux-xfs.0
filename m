Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540E74E533D
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 21:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789680269; cv=none; b=VVt2wed17wilXx5wlLnIW15K/Guv2DBLLI1cIfCb4BFwmX1mYhjWhlxq5V/WCEaTbnhjTqYbAgl83cSEIDwIGddigviKLsCcn0SAnzzljuvU+J27fe2VnJPD8CWVXCiSyKwzJf3Gp0PiqSPxCNNnHzGiIG88MchooxriWS/Oxq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789680269; c=relaxed/simple;
	bh=H+rMQtT5fkiWfM9mSL8Pcff/AxQsQJ9rT4zKFbklWpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYq9oGiKbd+r717BrCCnF0sQSwdDw/ICUjrtpoI2qxeX58SDSU5w72ZnxDuGlLQuoA963pBvLaiDGI4ZPxYH/pDlPgPTKkxoYglmYbDDVhWJOIfpWRBJ8C1kUEM1IcyfXDrzguYk1/eiAFcfpaMxCpwUDd9KH47OJeI3uV55ffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arD5ID04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arD5ID04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1391F00899;
	Thu, 17 Sep 2026 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789680267;
	bh=8vtUfKdGbjKhAK5UY723TQqi1U3xgbEj9G5q6mV3yus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=arD5ID04jxvjirYjxsFSsKfWuKvERKgH//ea9HMNtfR7CcC25qjOZxy1c0nU/JmQO
	 Ee0+1mnGiRyz67vvaFXxBm0/iDwDWazVF3oJfwJ729pr3MIp5Ny2cqwG0efft9Tiee
	 anxS2xaJkGzDAadibIIAiNoCaKLiJb5JtPQLZbeub3YD+lpPJSbCAPtz4rtCSXbQPq
	 wu8GPIJSJVL8pvmdAuN7osRB2/sJP7iFo2jK1s5x1Ji5j5z3tlJa+WA+OMJktdJniw
	 v9Z2LM7iZO1VlM9hpottfEK5O6eRGNLpB++PA/mWHgKv9EogMxGXh+9pPMwRHtUCW7
	 TIDXtS02bLNEQ==
Date: Fri, 18 Sep 2026 07:24:19 +1000
From: Dave Chinner <dgc@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqxag3TcgpYYVwTk@dread>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <aquJIL3Ztk3KBdHV@shinmob>
 <aqvER2bZyAO6H-4v@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqvER2bZyAO6H-4v@shinmob>

On Thu, Sep 17, 2026 at 07:45:11PM +0900, Shin'ichiro Kawasaki wrote:
> On Sep 17, 2026 / 15:52, Shin'ichiro Kawasaki wrote:
> [...]
> > As suggested, now I'm trying to increase the journal/log section size.
> > I added the mkfs options below:
> > 
> >   MKFS_OPTIONS="-l size=128m"
> > 
> > With this, I repeated the test case 30 times, and did not observe the hang.
> > It looks like the log section size increase avoids the hang. I will keep it on
> > running to see if the hang is observed after 100 times run.
> 
> The test case did not hang all through the 100 times repeated runs. Then
> expanding the log section from 64MiB to 128MiB avoided the hang.

Ok, so the fix for the moment is to make the software COW path for
atomic writes use IOLOCK_EXCL, rather than IOLOCK_SHARED. That will
result in all the IO submission blocking on the IOLOCK with no other
resources held rather than blocking on the ILOCK whilst holding an
unreleasable transaction reservation.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
