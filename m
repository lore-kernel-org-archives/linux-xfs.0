Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C8939BFFE;
	Thu, 10 Sep 2026 09:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033215; cv=none; b=tLWIktk69e/vlu+HdYaP9j6fr1bRqaXVO3EqtAmZsThgRw6aVZO9bABgFZI+U5Hq17umJq3gDrlzZ041oW1/saQuhiNK8q5Eo8YDOlhff7YGWeMhbe838M9Ovc+21td5f2wmdgwL3AnaDfN6ZkmFtpZVx9gfif2Hw5v1gHp1WLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033215; c=relaxed/simple;
	bh=g6DNwX1IX8DYHZ/XHUGkAW+uwlC2tbfwpTwwiXe/nik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeXTOZ3EwbuFquw/cy6vyW0b6WwgxUMdA6gOu3T85CHtMjY5DwPHyQNngQU84Li7GvUHADz7z3Pup9+aVlVPQObCVxr02gMt7XW9tzKIpUPPntqvbCaErEbiZ3Zd4t/H9fZTJxu5jB9kn6VveI48bqBLxG8piL+JXLcSeHNLJsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJgjHXqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJgjHXqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408351F000FF;
	Thu, 10 Sep 2026 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789033213;
	bh=T3YM+CLgixvbSPj54AmuRrfcrWqftMSxxcS26gaqTOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PJgjHXqLZKk4ND0YYTWOBoUWYxmjI0637ooUE3/4RyMMWPRmp4LBCvZOZ16nYOR+a
	 p6GGJDgdABHJeJHtQ7634kLhLThRtBebUHb/hk7IjoclocWakxv+BQqJK8LA0me5nm
	 Z9yB+V/2RU3V/vEb4gG8XhpY2I0pbAvx/Q/ToQRYHbYzINHqZRjDnObFK70OsuV5JJ
	 MOjFItRHTknYU+x5FDGzOM3rKJIYVPECl4E1Fln9rIoKu/D86Hctnw7kJ6/9J6oHrK
	 nCD7avYndOzOSZMxDELmKh0AE2DVaCHDe6gRqINxLlBTeHAnbbn1/Ib9xzMMZBQdSh
	 LOzu2rpbomeXA==
Date: Thu, 10 Sep 2026 11:40:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-ID: <aqJ6yulX3XBEoj4u@andromeda.toxiclabs.cc>
References: <20260906144629.17009-1-kartikey406@gmail.com>
 <20260907045150.GI1933798@frogsfrogsfrogs>
 <aqI7LFBkAhMSaDnx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqI7LFBkAhMSaDnx@infradead.org>

On Wed, Sep 09, 2026 at 10:07:56PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 06, 2026 at 09:51:50PM -0700, Darrick J. Wong wrote:
> > On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
> > > __xfs_healthmon_insert() asserts that hm->lock is held
> > > (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> > > after allocating hm, before ever taking the lock, triggering a
> > > lockdep warning.
> > > 
> > > Take hm->lock around the call.
> > > 
> > > Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
> > > Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > 
> > Heh, I added a patch just like this one to my own tree.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Can we get this queued up ASAP?  It's also causing a lot of failures in
> our zoned XFS CI.
> 
> 

Done. It's in for-next already. Not sure if I'll manage to push the
attrs fsblock fix yet this -rc, but this one will go to Linus on
Saturday
