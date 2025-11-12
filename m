Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9512E0412;
	Wed, 12 Nov 2025 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762973107; cv=none; b=XTC8SR7TK05oC7EDrcBRM5GEstAyblJdWDXp4UXOZgdZgoAxAZkaKIt7XfEOqGBmGNF8XHzzBks3qJ6M2/umvKax4QFVFGiJN2CeNmpk5PV70JYYCKhMw6Fy6zf96wBS3IgF3t9WFwJXXM7RymHuLXdaWV5GJuw/8eTF5t+zDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762973107; c=relaxed/simple;
	bh=PzQ6jc3/tvADbthOJJHvxrb92gutP1MPEWajn4hKFAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GHPH2riNWW6s4YsEaAyeeAR6RaJxwJR5KyoMyLKiG+RAUJJA5nzecfk+JIcFTjVVQq4ZvBiPz5JjMlt27SgQGC8vDhLikMiP1yPDASQkRBRxivtieMS+GF2FykL0KTpCLVGy+aD2GZhKRW8VqSctHqG52xaFsdT1G37GlCL7kTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUjUpu8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUjUpu8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B35CC19421;
	Wed, 12 Nov 2025 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762973105;
	bh=PzQ6jc3/tvADbthOJJHvxrb92gutP1MPEWajn4hKFAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kUjUpu8W6HsEmEuyWzGPmStO4xIbBvL9A3ziMfWVYCeXS9HOHauO0MAWH8yi7xmi2
	 2LE+krStDB4iabD3/yCxYJg/HXQX8T5O0YUAgzLPVcEay3kI8ZNS567xaKtVffz/If
	 YDoXPZUJqJTtQZnAE/iIShWAYLhSgPhwpUz6Tv0YR0Wp4y0k3hpQ+XTP3BOtdgnjZ1
	 q4ATfPEvgcsCCs25W5oxXV2QYFiyA35w4sbrcfA3XFYvnOmEu39zmrDZih53ZN26eZ
	 5sGRgf6Nqgjb46lIWAGMty8hlzUKeRhaGK0Hfp3bXVMHF2NWpDC0Gd+9zY96gFBjRX
	 0YSNPXcI3Y1bg==
Date: Wed, 12 Nov 2025 10:45:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, chandanbabu@kernel.org, bfoster@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: reject log records with v2 size but v1 header
 version to avoid OOB
Message-ID: <20251112184504.GA196370@frogsfrogsfrogs>
References: <aRSng1I6l1f7l7EB@infradead.org>
 <20251112181817.2027616-2-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112181817.2027616-2-rpthibeault@gmail.com>

On Wed, Nov 12, 2025 at 01:18:18PM -0500, Raphael Pinsonneault-Thibeault wrote:
> In xlog_do_recovery_pass(),
> commit 45cf976008dd ("xfs: fix log recovery buffer allocation for the
> legacy h_size fixup")
> added a fix to take the corrected h_size (from the xfsprogs bug
> workaround) into consideration for the log recovery buffer calculation.
> Without it, we would still allocate the buffer based on the incorrect
> on-disk size.
> 
> However, in a scenario similar to 45cf976008dd, syzbot creates a fuzzed
> record where xfs_has_logv2() but the xlog_rec_header h_version !=
> XLOG_VERSION_2. Meaning, we skip the log recover buffer calculation
> fix and allocate the buffer based on the incorrect on-disk size. Hence,
> a KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by rejecting the record header for
> h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> since the larger h_size cannot work for v1 logs, and the log stripe unit
> adjustment is only a v2 feature.
> 
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
> ---
> changelog
> v1 -> v2: 
> - reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> - update commit subject and message
> 
>  fs/xfs/xfs_log_recover.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e6ed9e09c027..99a903e01869 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3064,8 +3064,12 @@ xlog_do_recovery_pass(
>  		 * still allocate the buffer based on the incorrect on-disk
>  		 * size.
>  		 */
> -		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
> -		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {

Just out of curiosity, why is this a bit flag test?  Did XFS ever emit a
log record with both XLOG_VERSION_2 *and* XLOG_VERSION_1 set?  The code
that writes new log records only sets h_version to 1 or 2, not 3.

(I can't tell if this is a hysterical raisins compatibility thing, or
just bugs)

--D

> +		if (h_size > XLOG_HEADER_CYCLE_SIZE) {
> +			if (!(rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
> +				error = -EFSCORRUPTED;
> +				goto bread_err1;
> +			}
> +
>  			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
>  			if (hblks > 1) {
>  				kvfree(hbp);
> -- 
> 2.43.0
> 
> 
