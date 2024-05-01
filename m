Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC70C4DA04
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 08:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714550807; cv=none; b=tAFOIkt6p7pH7RaoPOcD29fRGNyJfVSSAcjX99OvXVR1qobfxtmjIu3gxQY1rMxcXdfdj3+Jhzwd4OFHk2MkBVdAbSYKTWea+05PFV1nwMTVD6f2o5veaTDKZXSdZpF+fY0UHleaEtKe+S26hFI7UVlpuXYl4LFp99s1OBK3zz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714550807; c=relaxed/simple;
	bh=1wdaH2F2g83FwEVz/NGe+iX00fR9AuY8x3s5HvmbMb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5mtnMedsB6qGztg1pCfTzqk/BRXsBayw8nOqkR1CKcxIWWQ16OcsG4lfvYWDq/FJRvj0DqvZMXSMPnLcopuECSoLN+00qHkbcFU1luroqIbcnV3s2odOThPc8kWznTrg8qGapiGomRi78mor5kjGjekyeJB58n3bN1o10Mi4X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nu7HUQhJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Em25h0cX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nu7HUQhJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Em25h0cX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nu7HUQhJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Em25h0cX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nu7HUQhJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Em25h0cX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0427E1F83D;
	Wed,  1 May 2024 08:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714550804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvOa1RRKhsRXbnRKhGTHJSYYjtSxKx+Tc+58iQcDqlo=;
	b=nu7HUQhJsfl1GUr4gFVkN1JBYwlYjUU4ztPQQ8PTk7s4b+r1zEMnRFWLrodXnJf/jSUYNm
	yms/7TpxMHMtxi16W8hI8LEMsUCa3uwiNCJvMUwm5detBCDsP0vV42R9TiStgC5kOd8zQw
	ScOyDECXMnuMssYw0akplBYf5fSxvH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714550804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvOa1RRKhsRXbnRKhGTHJSYYjtSxKx+Tc+58iQcDqlo=;
	b=Em25h0cXEswYzYaCAYPV2Mt/UYPPZnyIfY4CNMt7C325a14533cu48bTlKA7MAYn5yZjtm
	1raCi2FZx7s5t1AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714550804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvOa1RRKhsRXbnRKhGTHJSYYjtSxKx+Tc+58iQcDqlo=;
	b=nu7HUQhJsfl1GUr4gFVkN1JBYwlYjUU4ztPQQ8PTk7s4b+r1zEMnRFWLrodXnJf/jSUYNm
	yms/7TpxMHMtxi16W8hI8LEMsUCa3uwiNCJvMUwm5detBCDsP0vV42R9TiStgC5kOd8zQw
	ScOyDECXMnuMssYw0akplBYf5fSxvH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714550804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvOa1RRKhsRXbnRKhGTHJSYYjtSxKx+Tc+58iQcDqlo=;
	b=Em25h0cXEswYzYaCAYPV2Mt/UYPPZnyIfY4CNMt7C325a14533cu48bTlKA7MAYn5yZjtm
	1raCi2FZx7s5t1AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D15713942;
	Wed,  1 May 2024 08:06:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PTv4GxP4MWYQZwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 01 May 2024 08:06:43 +0000
Date: Wed, 1 May 2024 10:06:41 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	akpm@linux-foundation.org, hch@lst.de, elver@google.com,
	vbabka@suse.cz, andreyknvl@gmail.com
Subject: Re: [PATCH 0/3] mm: fix nested allocation context filtering
Message-ID: <ZjH4EdwEtPOQZoRH@localhost.localdomain>
References: <20240430054604.4169568-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430054604.4169568-1-david@fromorbit.com>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,linux-foundation.org,lst.de,google.com,suse.cz,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email]

On Tue, Apr 30, 2024 at 03:28:22PM +1000, Dave Chinner wrote:
> This patchset is the followup to the comment I made earlier today:
> 
> https://lore.kernel.org/linux-xfs/ZjAyIWUzDipofHFJ@dread.disaster.area/
> 
> Tl;dr: Memory allocations that are done inside the public memory
> allocation API need to obey the reclaim recursion constraints placed
> on the allocation by the original caller, including the "don't track
> recursion for this allocation" case defined by __GFP_NOLOCKDEP.
> 
> These nested allocations are generally in debug code that is
> tracking something about the allocation (kmemleak, KASAN, etc) and
> so are allocating private kernel objects that only that debug system
> will use.
> 
> Neither the page-owner code nor the stack depot code get this right.
> They also also clear GFP_ZONEMASK as a separate operation, which is
> completely redundant because the constraint filter applied
> immediately after guarantees that GFP_ZONEMASK bits are cleared.
> 
> kmemleak gets this filtering right. It preserves the allocation
> constraints for deadlock prevention and clears all other context
> flags whilst also ensuring that the nested allocation will fail
> quickly, silently and without depleting emergency kernel reserves if
> there is no memory available.
> 
> This can be made much more robust, immune to whack-a-mole games and
> the code greatly simplified by lifting gfp_kmemleak_mask() to
> include/linux/gfp.h and using that everywhere. Also document it so
> that there is no excuse for not knowing about it when writing new
> debug code that nests allocations.
> 
> Tested with lockdep, KASAN + page_owner=on and kmemleak=on over
> multiple fstests runs with XFS.

Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks!


-- 
Oscar Salvador
SUSE Labs
