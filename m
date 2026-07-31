Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A82E974D;
	Fri, 31 Jul 2026 23:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785539590; cv=none; b=H5KL9nxG5k+Ze8dyFuIx/9kLkMyZa5a+MXvTyPbXXSv8BitogVsGhbSUHcvWakfHQccBbbEnyspn7VIxCa3Z0QEPGEe77qKM5SkOVPqHs4+1qrSCOxg4V8UFpp6oSceVN77tlXkRKoZsxXc0dwW4ANDy2lP1rD0GNBLkvoy3J10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785539590; c=relaxed/simple;
	bh=2h81XBfO2KAWvG9Nhdq6FXesJX0dlXewhtgyIwGrlYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5SjwEOe5dOG3mI8ihmmrex11mdzS/H9pStfwYuaIpePI09C5B+gAB4eHPPb/sY9bQcpDzojdZUy1AjsWnom30SAXAKuIfvXV62LokhtsEVuUjobLAELXTt1zfod8y40GyHjUt9OQig+25Glg6hkoIINrIhfmwgVNZwZQthVG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLLcbvba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLLcbvba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9F01F00AC4;
	Fri, 31 Jul 2026 23:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785539588;
	bh=0kKFIXjnpx1F/dXdLYQ4KLSqK04RWf3a/vAFLOyNisU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cLLcbvbalTogJhjySm3mg4JdjA2CCBwixPC9Lk5r4X41v72+6rUg2mO1N7/xEfRoQ
	 ztPXIDpc9vYxIKgNKxmCLI72kZ/v4KR3F5/Z3GydcREVis+0rixYsvqtUJ+XOBqULB
	 NPMcHW/acRqYwwhuvgo4QL6jEFWE/vF8oyJZExYDaKJvd6fIu7ygRRR4gE+p/MwOFY
	 +f+JPgdMp4M28dopCVKWAaDoo2IhAgKlAZdnZF/pkcuRNk31GZuX4FYSA2DBd9ZMxw
	 oTAApacQYi3xM4+1lXlKbHZWfmIHkFqmb+Mb75lDZ2W9OvVcN741yWSwkF8BHvAMs1
	 pD0Zw/j9o9UTA==
Date: Sat, 1 Aug 2026 09:13:00 +1000
From: Dave Chinner <dgc@kernel.org>
To: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: add guard before freeing buffer log item
Message-ID: <am0r_JImI8qE_TDZ@dread>
References: <20260731061448.192010-1-marcelomspessoto@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731061448.192010-1-marcelomspessoto@gmail.com>

On Fri, Jul 31, 2026 at 03:14:48AM -0300, Marcelo Mendes Spessoto Junior wrote:
> A buffer's write completion can race with the CIL walking the same
> checkpoint's item list during a forced shutdown's simulated commit
> callbacks. Whichever side reaches the item last should be the one to
> free it; right now completion frees it unconditionally, so the CIL
> walk can end up touching memory that's already gone.
> 
> Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> Reported-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
> Tested-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> Signed-off-by: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>
> ---
>  fs/xfs/xfs_buf_item.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index f4c5be67826e..c86c4387f52b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1072,6 +1072,9 @@ void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
> +	if (atomic_read(&bp->b_log_item->bli_refcount) != 0)
> +		return;

No.

My conclusion to the original syzbot report was:

| As such, I think that the issue we need to understand here is why a
| write IO completion is being run from read IO context. That's the
| root cause of the UAF, not the commit the bisect landed on....

And if you look at what I posted yesterday about a different hack to
this same code:

https://lore.kernel.org/linux-xfs/amvI_rVUlifIXoZA@dread/

which "fixes" a UAF in the CIL code reported by KASAN under syzbot
conditions. Whilst the syzbot report quoted was different:

https://syzkaller.appspot.com/bug?extid=598a791b31c498b63c6b

The syzbot report indicates exactly the same UAF situation - a write
IO completion being run from a read IO context causing the BLI to be
freed incorrectly and then the CIL access to the BLI triggering a
UAF.  My conclusion to that one is:

| Given that syzbot has only reported this 5 times in 12 hours only on
| a 7.1-rc3 kernel, never before and never since, an external memory
| corruption bug that has since been fixed seems like the most like
| cause here.

All the recent reports of this issue (the cluster in mid May) are
also only from v7.1-rc3 kernels....

So, yeah, people really need to stop trying to hack "fixes" into
xfs_buf_item_done(). The UAF indicates that there has been an
-incorrect free of the item- during IO completion. That's the issue
that needs to be understood and fixed. Fundamentally breaking the
refcounting model of the BLI to silence the downstream UAF that
results from the incorrect free is not an acceptible solution.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
