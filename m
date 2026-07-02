Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ED03C7E13
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989782; cv=none; b=iZiIjmX0wTho1uVLV59hOEsAXnYVrNhcke8cKgfkqEiFSsxAxoo2B4Fw5OZWeekEM9BKLfS6mi9qBOCBWehcKgiKepEBDp5rGBU4Jx3EXnkPrYxJIP6Vt86T1tYACy3rSRlWAoXquTtuIdGHA4riMX5/Z3Sc3hdlKEGla8ix5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989782; c=relaxed/simple;
	bh=kI54gr7ugaeSnj7Bgy1qG4coa4dRmJ/kMRyoGZ4T4ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfTrt/K0SU8Jqo0f2S5BHFXhUKJUg6HOE6WrkOpuH/dgvehz0U3oeMW+ClnUi0CUeWIBx0aECuNvQjMMeKVyYgZefWvee37WS+QeCcz7h14i5fz8QgM9sVGaVXnq+k3K5OT4r05wPcpsGbu4Jts3mmOOSt4V3XgkTqB4EUEKd5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1/fjeBC3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e0q9EKjL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZCeqKcmd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MlXGgfam; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1/fjeBC3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e0q9EKjL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZCeqKcmd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MlXGgfam"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3F6E74172;
	Thu,  2 Jul 2026 10:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782989778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnrAkZwi8Pz5kfnJegfmhTKjyozQ+TU0cg6VJ2nlGD8=;
	b=1/fjeBC3QIrT5W6zQa7uudBF7lwqPFtX+lujpEOqjuhOuCWwpy5Yis73a67MsfodN5WIva
	49RxVdJz/P9k8L13vbmoTFfC1kx36TNPxi0TyDiqj0dqAExIk8Bzbe6AnoNmosESv6O5nJ
	SfrFBc2iUOtS/HTWy9rFs5YbRf+7qwo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782989778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnrAkZwi8Pz5kfnJegfmhTKjyozQ+TU0cg6VJ2nlGD8=;
	b=e0q9EKjLmyAs1smiUwLfOB2EOHvqEocQo2oeiWWEaPclzw1/6oVuYJP+Dy/DF2UQ0WJoVw
	9oYipwrp44d9IQBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782989776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnrAkZwi8Pz5kfnJegfmhTKjyozQ+TU0cg6VJ2nlGD8=;
	b=ZCeqKcmd3yQA54HtUVLxOSMHpxadhYhrjYaD21ObIOgNbUnn30qQJ9GD4YRP4PHnzhXWhH
	sxLRyc+Rh/lU1+ZvtsmNGyRlKuqfC34np1I3udcouElZ4+NPZTOqujhKuS6yhEU3uGtP0N
	h9B4UEM67lSDn7wg5cfp1sfSQe7qFPY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782989776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnrAkZwi8Pz5kfnJegfmhTKjyozQ+TU0cg6VJ2nlGD8=;
	b=MlXGgfamfEf0uFlwr+RAWsyEsU5DaOA37XIgle59fP99YwT2IOYExXBhArKSBGytK6UV/z
	xoxkAOQY9SOIh5DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C853A779AA;
	Thu,  2 Jul 2026 10:56:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VdzlMNBDRmr9VAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 10:56:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 634ECA12AD; Thu, 02 Jul 2026 12:56:16 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:56:16 +0200
From: Jan Kara <jack@suse.cz>
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/5] quota: Don't issue audit messages on quota
 enforcing
Message-ID: <xommujufw6puvxysjes2nl55uc4ovjachsh4nl54gosyvg4huz@uui7ik3irsnl>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-7-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702093324.127450-7-cem@kernel.org>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,hallyn.com:email,uni-hamburg.de:email,suse.cz:email,fromorbit.com:email,imap1.dmz-prg2.suse.org:helo,lst.de:email]
X-Spam-Level: 
X-Spam-Score: -3.80

On Thu 02-07-26 11:33:21, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Calling capable() to determine if we can bypass quota enforcement or not
> can trigger spurious audit messages. We don't really require it here so
> just use the capable_noaudit() version.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Makes sense. Feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/quota/dquot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 9850de3955d3..dab93422a57b 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1308,7 +1308,7 @@ static int ignore_hardlimit(struct dquot *dquot)
>  {
>  	struct mem_dqinfo *info = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type];
>  
> -	return capable(CAP_SYS_RESOURCE) &&
> +	return capable_noaudit(CAP_SYS_RESOURCE) &&
>  	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
>  		!(info->dqi_flags & DQF_ROOT_SQUASH));
>  }
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
