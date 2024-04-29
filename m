Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D514A8C
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 09:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714383225; cv=none; b=uh7JPFAVjG+s2XPKjM8efpJd72V7ONQJeUJSTm3Q/732zS8kFcZ6ZZGocU9FnkIgn386j3lVP35MZYbo/q8kWVb3KH6S0xs/cLKwa0pSKuFtRRNtg/tq+1TH7vDTM3YnHPuKrvUSpNiwI1DJo6qTT9/frw/o4CDWcoRPo5Dtf5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714383225; c=relaxed/simple;
	bh=ZafJ59LmDQsz41Cpi1oHmI9wZ97evminddiHxU5nuhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aT/QofHsVjobqSMnqSm77d/akL6t5gKHUsfiWYAF0mPyRo1T/yDiAlK49PwjdupYucjt3JLKW05J6o1UOO+5lLsRNV8jIL41cl5f2Yrti5hWAKaKluxcyvPjQwOW/los903tEeB1URIC/8+HjxmzNfpnfKlXP0CGHsi3mev3ulQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JEHb0sHa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RkLnwBXL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JEHb0sHa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RkLnwBXL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JEHb0sHa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RkLnwBXL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JEHb0sHa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RkLnwBXL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B726322CC4;
	Mon, 29 Apr 2024 09:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714383221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GaElOEVvbpGjBVSSS3fYlc3ysMvccgYn0xbuvUkN84c=;
	b=JEHb0sHaea0dSYmXKfcScQSMnlZdc5U+x4U179ZQCTPBz3K6itg0hZmHZp2fIf/YzMPu3g
	9OCYpsRziZHTnspXXfDd/Hmd3whN1+2OqUPPkgW9/3NDUdR5apYcoun/FJOpsKMDW4pIcQ
	GQdkM1G9BKMdsHChBH6gpVd4/S/aTUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714383221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GaElOEVvbpGjBVSSS3fYlc3ysMvccgYn0xbuvUkN84c=;
	b=RkLnwBXL0qHQ1/XRv+GzOUCnujYpOfeqcwUogozXpwk7+5lUhuznKI0+8R+5HtXtNPxhnA
	bGLVW+k3odszuNAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JEHb0sHa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RkLnwBXL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714383221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GaElOEVvbpGjBVSSS3fYlc3ysMvccgYn0xbuvUkN84c=;
	b=JEHb0sHaea0dSYmXKfcScQSMnlZdc5U+x4U179ZQCTPBz3K6itg0hZmHZp2fIf/YzMPu3g
	9OCYpsRziZHTnspXXfDd/Hmd3whN1+2OqUPPkgW9/3NDUdR5apYcoun/FJOpsKMDW4pIcQ
	GQdkM1G9BKMdsHChBH6gpVd4/S/aTUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714383221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GaElOEVvbpGjBVSSS3fYlc3ysMvccgYn0xbuvUkN84c=;
	b=RkLnwBXL0qHQ1/XRv+GzOUCnujYpOfeqcwUogozXpwk7+5lUhuznKI0+8R+5HtXtNPxhnA
	bGLVW+k3odszuNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36F4C138A7;
	Mon, 29 Apr 2024 09:33:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6ie5CnVpL2ajIQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 29 Apr 2024 09:33:41 +0000
Date: Mon, 29 Apr 2024 11:33:39 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, elver@google.com, vbabka@suse.cz,
	andreyknvl@gmail.com, linux-mm@kvack.org, djwong@kernel.org,
	david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] mm,page_owner: don't remove __GFP_NOLOCKDEP in
 add_stack_record_to_list
Message-ID: <Zi9pc0RoVWCJ2aVn@localhost.localdomain>
References: <20240429082828.1615986-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429082828.1615986-1-hch@lst.de>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,google.com,suse.cz,gmail.com,kvack.org,kernel.org,fromorbit.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B726322CC4
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.51

On Mon, Apr 29, 2024 at 10:28:28AM +0200, Christoph Hellwig wrote:
> Otherwise we'll generate false lockdep positives.
> 
> Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
