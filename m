Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F663E1229;
	Mon,  9 Mar 2026 16:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072156; cv=none; b=qAD6y9YqPCHZE+3dsyMeWW/FPoHDsXz7f3K7uhNQsjVdFk9JYCrHHIkeHjwRktb1YMnBH0YzweO62HKjre3cTaSATB/ixYOh2avddW6+fDK80QkyzKf7Vqd46enXGQTGak+Tu/RBTN/PZdf9Eq6s5+leSamiTflxRUV/LdW0Cq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072156; c=relaxed/simple;
	bh=7gJTBjpk8wrJP9SKNEto2JFBOZ4no8pFKzp7/nr7/r4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EueK+pb6kN7/ol2scnsTrOBp27g97zIihiU4Q1vX/hVlOl3O6LeZNQxDBQtBt+XsQS39nFtpme2Gdb5B0ITMTzjMSP/Z5NfHd7X+5WrD9jqM+m4O1viyEHIScw3KD4b1sZtQNhxeun52whwqVzRX9xTLDSLZcHA7C6TlsnyaclE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rzv7sero; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rzv7sero"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C37C2BCB0;
	Mon,  9 Mar 2026 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773072156;
	bh=7gJTBjpk8wrJP9SKNEto2JFBOZ4no8pFKzp7/nr7/r4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rzv7seroo2lu4SNXuG80SAFO4QOjuSiAO71ujq4WtSF9XgvnPTQXRmjsGS/OkhKLd
	 2seRvvZq1+tspVlUIFwrvl9OoOLGlCBV1Q5AbIrf6W3HUsZvN0bfi68hsZr6j2gbjj
	 WtGIqSVzWU9I8Kp5a9GtZ12mmq/qLOXsGtv2qWyMCWR1oX/VgfiEwDE6p/4d6503Hs
	 qb6fksXpEXIKDPgHitC/WwImyWNS9gMiSG948opURmT3S1NINUuXabkDDe1udifaLH
	 XHZAhRcIVpW/1P2TmRgu2WAc7RREZ85K0S4QZPpGJkYRyfMwebVy+mX3n9LcWe3Njq
	 bsHo9XtK24GWg==
Date: Mon, 9 Mar 2026 09:02:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] xfs: stop reclaim before pushing AIL during
 unmount
Message-ID: <20260309160235.GA6033@frogsfrogsfrogs>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-7-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-7-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:06PM +0000, Yuto Ohnuki wrote:
> The unmount sequence in xfs_unmount_flush_inodes() pushed the AIL while
> background reclaim and inodegc are still running. This creates a race
> where reclaim can free inodes and their log items while the AIL push is
> still referencing them.

Is this a general race between background inode reclaim and AIL pushes?
Or is the race between an AIL push and the explicit call to
xfs_reclaim_inodes below?

I ask because there's a call to xfs_ail_push_all_sync from various
places in the codebase:

- Log covering/quiescing activities

- xchk_checkpoint_log in the online fsck code if the inode btree
  scrubber thinks it's racing with inode reclaim.

If inode reclaim happens to be running at the same time as these AIL
pushes, won't the same race condition manifest there?  But maybe you
meant the race is with the explicit xfs_reclaim_inodes below?

> Reorder xfs_unmount_flush_inodes() to cancel background reclaim and stop
> inodegc before pushing the AIL, so that background reclaim and inodegc
> are no longer running while the AIL is pushed.
> 
> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/xfs_mount.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9c295abd0a0a..786e1fc720e5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -621,9 +621,9 @@ xfs_unmount_flush_inodes(
>  
>  	xfs_set_unmounting(mp);
>  
> -	xfs_ail_push_all_sync(mp->m_ail);
> -	xfs_inodegc_stop(mp);
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> +	xfs_inodegc_stop(mp);

xfs_inodegc_inactivate (aka the inodegc worker) can call
xfs_inodegc_set_reclaimable, which in turn calls xfs_reclaim_work_queue.
That will re-queue m_reclaim_work, which we just cancelled.  I think
inodegc_stop has to come before cancelling m_reclaim_work.

--D

> +	xfs_ail_push_all_sync(mp->m_ail);
>  	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
>  	xfs_healthmon_unmount(mp);
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
