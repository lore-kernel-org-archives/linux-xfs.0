Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8621F151C;
	Wed, 25 Mar 2026 08:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774428621; cv=none; b=q4JpD/iKF9wnbYKzCSlGAkHhhv6CejMjRCiHtaWeRBsyR//o3hdga+AIwWDjU3OxIUr8Z9SKDIFA0RKbRmUBk3z7YGbjCIklTGnWUWGSeiGdeQQZsa8p9djMAuVlMr1ZWksaIHunmkTGC9+zQwWIt+JyuEMLMdzi0hIGkRkeq2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774428621; c=relaxed/simple;
	bh=uQiPCdXO1+IrPJyrvjwSsm8zGCK0ZftzMK6ZUfbm3+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJC+ilD9nsNAZQTIQRsCPs8q6hRMOjc0/U7X82qo/pTm9zPCAA+JaJtuerRxxA1I6R48V0TFtSrjvHC5ql35kG8mhC1PH2lr88XrApP8y76odId7ZG7uDNcWJ3qUqFDEp8VCp+uoksQiw4MNWHdlGUMBm2VsHSdArie4musAtWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAQtfMK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAQtfMK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC3C4CEF7;
	Wed, 25 Mar 2026 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774428620;
	bh=uQiPCdXO1+IrPJyrvjwSsm8zGCK0ZftzMK6ZUfbm3+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pAQtfMK54R+z/CJabQiUfeUeQMCK9FVuN8rF8g9ZAq4wbj5QtldvxFVIZGXCErS4i
	 KB9Tc3YLgHT/sov1zimeb6jfau01x3zqtHIAMI2PElwiHfMFXKsGQSVscvEbAb3IS6
	 UWrXECeOT6TV8va163AP0j0Jc2XV7zUf7T0QvwOzkpHF/mjNFT94WsGmzMX0KRJRwx
	 2xKHekRa0thu9+ysaTOu4rmqqZjw8OwFfHB5zyV/TXmCY3DOeGGBIq5b1kTD+XzKeC
	 cooszfb5efGt4VFQt3rP4HUEBPBtO8cFn7wfpIz8VsC4G/cVEQqWzbJ9AnT0uKcKhg
	 uT7aWHKpvHjxg==
Date: Wed, 25 Mar 2026 19:50:15 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Cen Zhang <zzzccc427@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2] xfs: use xfs_trans_ail_copy_lsn for lockless li_lsn
 read in CIL formatting
Message-ID: <acOhx2Y1yfiLTest@dread>
References: <20260323070949.3769170-1-zzzccc427@gmail.com>
 <acN_Mh5I_auSv_VM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acN_Mh5I_auSv_VM@infradead.org>

On Tue, Mar 24, 2026 at 11:22:42PM -0700, Christoph Hellwig wrote:
> Looks good to me, even if the additional lock on 32-bit might hurt
> that one person or two running performance critical workloads on
> 32-bit systems:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But I'd really like to have Dave look over this as he's the resident
> expert in this area.

Seen it, haven't had time to look at it in depth. Complex.

In general, updates to lip->li_lsn at AIL insert time do not hold
object locks (buffer locks, dquot locks, inode locks, etc) and so
can race with reading of lip->li_lsn at any other time.  On 64 bit
platforms, this isn't an issue - but on 32 bit platforms any of
these LSN reads could tear if lip->li_lsn is updated at the same
time.

However, I think -all- objects are pinned pinned in memory when
lip->li_lsn is updated in the xlog_cil_ail_insert() path. Hence I
suspect the race condition of concurrent update/read is much more
limited that it possibly could be because being pinned while
updating rules out all the buffer writeback path verifier reads
from racing with writes.

I suspect that inode and dquot relogging are one possible vector.
inode and dquot flushing are another (e.g. xfs_inode_to_disk() in
xfs_iflush() looks suspect), and then it gets complex...

... because we also read lip->li_lsn in various IO completion
routines.  There's the possibility that objects are relogged whilst
IO is in progress (inodes, yes, dquots maybe, buffers no) and so
reads in IO completion processing could also possibly race with
journal completion modifying the lip->li_lsn....

I really don't have time audit all this code, but I a in a quick
scan I do see several locations where there could potentially be
similar torn 64 bit reads and writes...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
