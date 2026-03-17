Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AB3B8D45
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749976; cv=none; b=OLhI37Nrlsy0igm40S+8BPU6Yhtvk1eOYrK7lYosIw4/Y6sklZwWHKlFjJUtmFyJ10WeeoG/1V+3jfqxyTrQIV0TWCtdFE8GGPfKykjUyC+uGAVJRcTP8Oo6opcbgf4sw9TmnEXDBMyqhDWdOub7JgMIotm4blltnuKZjKXTve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749976; c=relaxed/simple;
	bh=0/xIkT4qQXWp5g+xXl8Z8LCE3Pn8nJN7e49yDZyCACE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9G/D7oolV69m2xjYySxH1wTx3pptO3TlRxkWGD/moU6FVdrmT7rVdVehk5aOjkFsn1CjVSLQRo/xmIyKAqXDFNCVxp0iknHSr8fnyznJlikPAegJuxalCEvRe1pGBwYUsyeS8keFHNo6dJEAM4PX+TUJhjT9mPyTJhwczyrj0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SED8nT5y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HrRiRMrW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qb+sUQXk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=y7yZ4b0G; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SED8nT5y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HrRiRMrW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qb+sUQXk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="y7yZ4b0G"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9005A5BDE6;
	Tue, 17 Mar 2026 12:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773749973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZIC4Jk7klYHy+Wq5io4Fu3fBBeN1vqr8yZeX/XHW1E=;
	b=SED8nT5y3xBcdB2fNrUU5psd/f6KuVIjXZB//p1hcym9HGVupcUJGYwezIKHKLbk1r3hEX
	49ft/qSP98+UGX9D5wguzRm6tp39BQ85Xx+2wwwdC5z9pwkmGWtHCd9IVug/wiLtWZBgmp
	FxM5FwSOLxQEeyVJA9zAMFKb+sPQMb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773749973;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZIC4Jk7klYHy+Wq5io4Fu3fBBeN1vqr8yZeX/XHW1E=;
	b=HrRiRMrWfydplOeBecALNwIJLJf9yg7jSs2yE9TA3iTlzfBIiO3x/9Efezls2ATTtCElES
	eBgmYbbEXYs8gtAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qb+sUQXk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y7yZ4b0G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773749972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZIC4Jk7klYHy+Wq5io4Fu3fBBeN1vqr8yZeX/XHW1E=;
	b=qb+sUQXkjEi5j+Oc/UVcCKVRqRpBkPs6Ppom/QUYrzKZcHBQAoKgf0gVouhFsugtXXArIN
	xV/qn8noqMWOeyVSfYmdKsZ0TQrnGbjZ2WMmb/BvJNYiz8J/FGdOoFoBlFpIY+tSNc2ORU
	wc3obr5BWdZPBh5+oKNv9Li9JAhYyks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773749972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZIC4Jk7klYHy+Wq5io4Fu3fBBeN1vqr8yZeX/XHW1E=;
	b=y7yZ4b0GvuDPDERQcGMyY0VzpsxFIlsQg88SP5hxjhnaHmYgKBGhJTOX4v5n/uI+Z/Ma7j
	zDQmPf3FshrsosBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C7684273B;
	Tue, 17 Mar 2026 12:19:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1fu9DtRGuWlLdwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Mar 2026 12:19:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0172A0A5B; Tue, 17 Mar 2026 13:19:23 +0100 (CET)
Date: Tue, 17 Mar 2026 13:19:23 +0100
From: Jan Kara <jack@suse.cz>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	adilger@dilger.ca, jack@suse.com, cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317065947.306954-1-ravising@redhat.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9005A5BDE6

On Tue 17-03-26 14:59:47, Ravi Singh wrote:
> When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> though default quota limits are configured and enforced against that
> ID.  This means unprivileged users who have never used any resources
> cannot see the limits that apply to them.
> 
> When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> zero-usage response with the default limits filled in from
> m_quotainfo rather than propagating the error.  This is consistent
> with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> pushes the same default limits into a dquot when it is first
> allocated.
> 
> Signed-off-by: Ravi Singh <ravising@redhat.com>

So XFS guys should also review this but from quota POV this looks like a
right fix to me. So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  v2:
>   - Moved fix from VFS (fs/quota/quota.c) to XFS
>     (fs/xfs/xfs_qm_syscalls.c) per review feedback
>   - Return default limits on ENOENT instead of granting
>     unprivileged access to ID 0's dquot
> 
>  fs/xfs/xfs_qm_syscalls.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index d50b7318c..2176dc617 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -391,6 +391,30 @@ xfs_qm_scall_setqlim(
>  	return error;
>  }
>  
> +/*
> + * Fill out the default quota limits for an ID that has no dquot on disk.
> + * The default limits are enforced against such IDs by
> + * xfs_qm_adjust_dqlimits() when a dquot is first allocated.
> + */
> +static void
> +xfs_qm_scall_getquota_fill_defaults(
> +	struct xfs_mount	*mp,
> +	xfs_dqtype_t		type,
> +	struct qc_dqblk		*dst)
> +{
> +	struct xfs_def_quota	*defq;
> +
> +	defq = xfs_get_defquota(mp->m_quotainfo, type);
> +
> +	memset(dst, 0, sizeof(*dst));
> +	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, defq->blk.soft);
> +	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, defq->blk.hard);
> +	dst->d_ino_softlimit = defq->ino.soft;
> +	dst->d_ino_hardlimit = defq->ino.hard;
> +	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, defq->rtb.soft);
> +	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, defq->rtb.hard);
> +}
> +
>  /* Fill out the quota context. */
>  static void
>  xfs_qm_scall_getquota_fill_qc(
> @@ -451,8 +475,18 @@ xfs_qm_scall_getquota(
>  	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
>  	 */
>  	error = xfs_qm_dqget(mp, id, type, false, &dqp);
> -	if (error)
> +	if (error) {
> +		/*
> +		 * If there is no dquot for this ID and it is not ID 0,
> +		 * return the default limits with zero usage so that
> +		 * unprivileged users can see what limits apply to them.
> +		 */
> +		if (error == -ENOENT && id != 0) {
> +			xfs_qm_scall_getquota_fill_defaults(mp, type, dst);
> +			return 0;
> +		}
>  		return error;
> +	}
>  
>  	/*
>  	 * If everything's NULL, this dquot doesn't quite exist as far as
> -- 
> 2.49.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
