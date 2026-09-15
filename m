Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0103F7ABD;
	Tue, 15 Sep 2026 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789495849; cv=none; b=h9lgxVdR7GY0l6OC4apGR/DoHCXRhikfUC+9Bu48VxJPi9FcZCUa8SySt1zEWztvKZJw4bixfs5OCuW0HgC35HU3XxYhkgMkpSBstpt74bYh0BT5lrF3PlZFimY6VrKmUDeKqa0m9A/tYehuyB1RoLZzQQ7bxraR4KNNJ+x58ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789495849; c=relaxed/simple;
	bh=qqZvLPysOT22biuZ1XQteHVw5VUDw3w00MS4ZFvf3iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFWi38xdldZULJPR3xLBVL54z5uSoPO9vYRnL4J2ocEX1mbpL57OIKoThJ3vjMsygRg+FbknzL4K9DLUMIKfMd0erYQD69p/HoOYZa2Tkd5mRHDG8v0rd5uqxeqjfbNtBY6v0BRx9Tm1yhm9xy0KQ86iT8raiQlkPF+ejcI9820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9S75vAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9S75vAA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 345D51F000FF;
	Tue, 15 Sep 2026 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789495848;
	bh=EcdkYrj1TRsoLe8g8bfebaILjX8LuQvq2Gn5CVLhRSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T9S75vAAU245GWUED1qCYN4k1ZneD2f69jZdHv9qMwX66usxLxd4VeDgWzeDPsMt/
	 R5ZOb1gapGcsp4XG41GgqjdELdXUqLMExsTeekTQgB4lxgZD1wUYdkNleh0LjQ1PLV
	 d9RV+hO35vymS/8s4uebIHNoMivmSHl92B4eZbwdngrmzM9HJLPz2x/5l1On2S+1wZ
	 Iy5LktjtN1zXN547Hi+sgx5JEXiyr6C4NtDRWMEDE9x2Q7MBC8UsxecUMe5sXcuJW3
	 NDBRM0HaI4F3AMaJYzWWeOZ5WZYUrYdgiHnnGFGr6QNtov0SAHiT9FYBL9dRGVO4v2
	 c/GpUW3c0jOug==
Date: Tue, 15 Sep 2026 11:10:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: quotactl(2) (was: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls)
Message-ID: <20260915181047.GI6283@frogsfrogsfrogs>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
 <aqLfs-6crlKiqZw9@devuan>
 <aqMwVislUcWIRTUb@devuan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqMwVislUcWIRTUb@devuan>

On Fri, Sep 11, 2026 at 12:38:23AM +0200, Alejandro Colomar wrote:
> [CC trimmed]
> 
> Hi Darrick,
> 
> > > Date: 2026-09-10 09:44:28-0700
> > > From: "Darrick J. Wong" <djwong@kernel.org>
> > >
> > > quotactl (and xattrs) have a similar weird history of originating in XFS
> > > and later getting yanked into the vfs.  Every time I have to go look up
> > > the quota syscalls I just get a headache. :/
> 
> I have recently worked on having quotactl(2) split into more organized
> manual pages.  This has been part of the man-pages-6.19 release.
> Have you had a look at these manual pages after that change?  Did the
> headache experience improve (or worsen) after this change?
> 
> Michael's man7.org already includes the latest version:
> <https://www.man7.org/linux/man-pages/man2/quotactl.2.html>
> 
> I'd welcome feedback, and any improvements or suggestions to improve
> the pages.

Oh hey, that /is/ a lot better!

The only addition I can think of is that QUOTAOFF generally isn't
supported anymore.

Thanks for breaking up that big messy manpage. :)

--D

> 
> Have a lovely night!
> Alex
> 
> -- 
> <https://www.alejandro-colomar.es>


