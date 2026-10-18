Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4E73F9278;
	Sun, 18 Oct 2026 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792355414; cv=none; b=QfNStcR3idevKp2jCCcPSY88g/xqvcIpEDcrj7DeSis7jYxd/lU40/5eLwvj974doqU0UNrmNylO6iLkMlK7drdiMMdXNYfO/R7kfA6HUyqOTz+w6ARdajZ+8B87hvmb190sUTU12m5byQWJB8arG5dRNF2CjPDoH8mGSkQbpTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792355414; c=relaxed/simple;
	bh=Kar2dXHe/21OigJEsMWTdCtgR97bg2VR1iw+z+1S2Tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDI6JLONPW/qtpcSrCeh2shDUF+F14/h+74dqq88pyTDgtaaZ6twXkHSr8p0MUZLsMtisj4lQyAWroUoSC6w/pKUSrjLlAQ58IR3HhgQJ2d/RtzFUs5EdbqqjNlwiqt3yxH3TkA1bQzEeOAwIiGiyIzeHTi2EC5Lu/moLNLZLQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hhgc0Cth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hhgc0Cth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F2C1F000C4;
	Sun, 18 Oct 2026 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792355412;
	bh=w734DO+DV/mfXlxo1yQCnhpD5cjX2+mWpAB4n/8mGfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hhgc0CthZQLtO1LI1YYtgSxYVgK5x+Vbma5NN0vGzJL04gnlZwuCn6ux5A0Hna5G/
	 8v9egb7zPVGGUGUCWJi+zNuMhFiKqHiFuoxnLuKLSdRLZ5mklqHABi+DeoqxSMwZas
	 BwGMcPldykiP0wDBul6PNrKYikVDRt4ucTXDO9c5MZIp+PP/jloxLmXR5MMz6Z/xhG
	 URBqwJ8uDkKH9ToAWcBsIairjE/UmMF6JogatUi1DWOAVw6RDSEHWqsxAwQ0nJKWUy
	 ctFDlgUVD69sGMSTU2rPdiw4PAzfsXuArv8kaBtyOlP1e/23tBHzg6qgm/OWgrUjzr
	 rZ7DE2E73/ySw==
Date: Mon, 19 Oct 2026 07:29:53 +1100
From: Dave Chinner <dgc@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+c32fff62cf4913d345d0c@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: Re: [PATCH] xfs: do not release buf log item prematurely in
 xfs_buf_item_done
Message-ID: <atUsQVuCKnAIZc3X@dread>
References: <20261018170913.3104-1-igorpetindev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018170913.3104-1-igorpetindev@gmail.com>

On Sun, Oct 18, 2026 at 08:09:13PM +0300, Igor Putko wrote:
> When a buffer with an active log item is written synchronously to disk
> via xfs_bwrite() (for example, in xfs_sync_sb_buf() during
> FS_IOC_SETFSLABEL), I/O completion invokes xfs_buf_item_done().
> 
> Currently, xfs_buf_item_done() unconditionally calls
> xfs_buf_item_relse(), which frees the xfs_buf_log_item even if it still
> has active references (e.g. bli_refcount > 0 while the item is pinned in
> a CIL context and queued on cilpcp->log_items). When xlog_cil_push_work()
> subsequently runs on another CPU, xlog_cil_push_pcp_aggregate() accesses
> the freed log item while splicing cilpcp->log_items, triggering a
> slab-use-after-free:
> 
>   BUG: KASAN: slab-use-after-free in xlog_cil_push_pcp_aggregate
>   Write of size 8 at addr ffff888036db9c40 by task kworker/u8:7/300
>   Call Trace:
>    <TASK>
>    __list_splice include/linux/list.h:577 [inline]
>    list_splice_init include/linux/list.h:619 [inline]
>    xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
>    xlog_cil_push_work+0x986/0x2a90 fs/xfs/xfs_log_cil.c:1417
> 
> Fix this by checking if the buf log item still has active references
> in xfs_buf_item_done(). If bli_refcount is elevated, the item is still
> owned by an ongoing transaction or the CIL and must not be torn down.
> 
> Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> Reported-by: syzbot+c32fff62cf4913d345d0c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>
> ---
>  fs/xfs/xfs_buf_item.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1a4ef34af8d5..6b32061bac53 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1067,6 +1067,14 @@ xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	struct xfs_log_item	*lip = &bip->bli_item;
> +
> +	/*
> +	 * If the log item still has active references (e.g. pinned by the CIL
> +	 * or held by an ongoing transaction), we cannot tear it down here.
> +	 */
> +	if (atomic_read(&bip->bli_refcount) > 0)
> +		return;

As I have said several times before: this does not fix the UAF.
Please review the mailing list for similar issues and discussion
before posting fixes.

I've already outlined the root cause and overall fix direction here:

https://lore.kernel.org/all/aqI6v-_dc2DDSbgB@dread/

Jeffin (cc'd) had started working on this, but I don't know how far
he has got with it.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
