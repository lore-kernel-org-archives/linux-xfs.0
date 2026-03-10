Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3D32E69A;
	Tue, 10 Mar 2026 05:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120431; cv=none; b=cbCqwWZ0Drom94XDJfwS1QLxxoED5ErYeCsPFJ7jVUH3fEoeLr5ntO7G85U+z57KQXh1tds7PvsjZ31vHvka+UnF6MvIelADCv0OGucpSeFnDUeFtaAHUSOK7Y8xquzdnv9hG6fh6tJQ98/sYbpBdhHgYtECofSVr2hnoqeCUOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120431; c=relaxed/simple;
	bh=SIgI+AOHb6g4dUp9vJorJrq2GcBYrk9rTMlMAcVIQEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOBaC9koeJtczzfydD034TmKVjnfLf5QMhlDmFE3CdjC/0gMIXHKfNXdFK7RgDx7SOFVnvWt+zzD+g/mxPELtZjzLPBTtkEUhD/Nwx3IeyFYcIkC5B+aETVFD+7hCFVEhXWeXRnKLH2r/H6BR2aR0g+ABM+4ze2Gk+Rym7W+Qao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcdrqC8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcdrqC8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6882C19423;
	Tue, 10 Mar 2026 05:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773120431;
	bh=SIgI+AOHb6g4dUp9vJorJrq2GcBYrk9rTMlMAcVIQEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kcdrqC8F11OwVuqwxdqbSC7gPpy+yDumwyGMPKcB4eJa6xZHWNlPOZkrzvRQPvJIP
	 4ObnWSwSlhs8ZQzBsT6dxz7D8oBh7o6S0ZY5sELB1LQiVTkSkE5fpjnW3CnsRCnLBZ
	 TJpILsYE3IDk1bZ6jz1lkiHgMcRTEhUhEmCP94uKfFQEoS/NmvVfeywftrMEd13gNu
	 FwNv+htXlHLK7452/vHKWvJTUFs/ebSIvqU1LoAqP+NhHgz0lQHGeqiiLLznMab2Pi
	 Z+6jCrfzTNz0jiT28FaGJU6Yhc6YiIzdGhVZi5NNE/9nlBiqgOAm0iYz5yCTLwhqE3
	 nqf/KDVasRrmA==
Date: Tue, 10 Mar 2026 16:27:06 +1100
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: avoid dereferencing log items after push
 callbacks
Message-ID: <aa-rqpyApQhssW8A@dread>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-9-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-9-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:08PM +0000, Yuto Ohnuki wrote:
> After xfsaild_push_item() calls iop_push(), the log item may have been
> freed if the AIL lock was dropped during the push. The tracepoints in
> the switch statement dereference the log item after iop_push() returns,
> which can result in a use-after-free.
> 
> Fix this by capturing the log item type, flags, and LSN before calling
> xfsaild_push_item(), and introducing a new xfs_ail_push_class trace
> event class that takes these pre-captured values and the ailp pointer
> instead of the log item pointer.
> 
> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
dgc@kernel.org
