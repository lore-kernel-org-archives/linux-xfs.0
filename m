Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFA13D6CDA
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496052; cv=none; b=n4b/T4cMLdCXyeXDPe491INNEgg5vukYslQzAfdT+4W2l9iU+SFbjoMnAOiy7LJYZYRignaiyz+X5ijWd+ulPm1u9qSphf//RYrYuEVhnpbUKR55O5zjzHxRh39rnR3fRwEBeA3MIuANew2O+S4CMwTl8ApkOfe/6GDSR3Y6Ai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496052; c=relaxed/simple;
	bh=VtsMyVwIw3zeVf+uRlyH+hOC4mszj1Ql43U91QE3Z5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRnGI7X3qwgzNhRqWCMUgChA3HcKucSBGKOjNgupa8lmfQP8Z3K+GF0TwTFVc102IxuDBryXY9WeVvM+0rMc0DnfG/8eSG8AFOjn6sTJ9rGX0odVer69XalDwW5PGKPjrY4vpwuFz9eQobAZqtVJ6hIMy/sLMFdBSPvxTPmAuQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E9hlLfBG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NeV8ucgr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E9hlLfBG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NeV8ucgr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E9hlLfBG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NeV8ucgr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E9hlLfBG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NeV8ucgr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B07F61904;
	Mon, 11 May 2026 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778496048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAUaYE8qP+XAFZqYUfz9R6sQul4DlQ4vYtfeCnmoRto=;
	b=E9hlLfBGmLSTwNb+VqQ2sCVSiBiEPHo/vgYdDB2au5o6mlfFp5NeY93EhooK7pqRnglRjH
	7un3PwiHpnI55UAWBqyAi8It5BQotmn0ocfBH68h6xzo+7QGRMa1VrGYdkbP62DGjFFgwp
	T658CUNg1AThyfFTg+uAKLDoX5IUUpA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778496048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAUaYE8qP+XAFZqYUfz9R6sQul4DlQ4vYtfeCnmoRto=;
	b=NeV8ucgrZL9Y4Y+dU8aHMyWiIQfmCqVsv0a4+6ujZvsefO8ET4FjL52+kId0k6NJIY2IyU
	D01iT8ismTqsFRAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=E9hlLfBG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NeV8ucgr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778496048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAUaYE8qP+XAFZqYUfz9R6sQul4DlQ4vYtfeCnmoRto=;
	b=E9hlLfBGmLSTwNb+VqQ2sCVSiBiEPHo/vgYdDB2au5o6mlfFp5NeY93EhooK7pqRnglRjH
	7un3PwiHpnI55UAWBqyAi8It5BQotmn0ocfBH68h6xzo+7QGRMa1VrGYdkbP62DGjFFgwp
	T658CUNg1AThyfFTg+uAKLDoX5IUUpA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778496048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAUaYE8qP+XAFZqYUfz9R6sQul4DlQ4vYtfeCnmoRto=;
	b=NeV8ucgrZL9Y4Y+dU8aHMyWiIQfmCqVsv0a4+6ujZvsefO8ET4FjL52+kId0k6NJIY2IyU
	D01iT8ismTqsFRAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5052F593A9;
	Mon, 11 May 2026 10:40:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BGXEETCyAWrHeAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 11 May 2026 10:40:48 +0000
Message-ID: <2be5b81c-a7c2-40ed-9d90-4129669a9a6c@suse.de>
Date: Mon, 11 May 2026 12:40:47 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: align down bounces bios
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260507050153.1298375-1-hch@lst.de>
 <20260507050153.1298375-3-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260507050153.1298375-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,lst.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6B07F61904
X-Spam-Level: 

On 5/7/26 07:01, Christoph Hellwig wrote:
> Just like for the extract user pages path, we need to align down the
> size to the supported boundary.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index f3e5d8bea08c..5f10900b3f42 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1345,7 +1345,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
>   
>   	if (!bio->bi_iter.bi_size)
>   		return -ENOMEM;
> -	return 0;
> +	return bio_iov_iter_align_down(bio, iter, minsize - 1);
>   }
>   
>   static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
> @@ -1383,7 +1383,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
>   	bvec_set_folio(&bio->bi_io_vec[0], folio, bio->bi_iter.bi_size, 0);
>   	if (iov_iter_extract_will_pin(iter))
>   		bio_set_flag(bio, BIO_PAGE_PINNED);
> -	return 0;
> +	return bio_iov_iter_align_down(bio, iter, minsize - 1);
>   }
>   
>   /**

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
