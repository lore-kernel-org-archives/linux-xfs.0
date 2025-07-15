Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872F2224F6
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752594337; cv=none; b=s7W6OYBUPEjUSuw7dRBkfjcQE2F4pO+1+UYpB2GLy3b1eWdN0JV5hQ+0mDeHQkVpjFPu7M8XcyLN3+nAv5qU95DTGITfuB4iZ8agSSaUvb6p0bBqmSzsRZ/oyHe8g2bUhK8zsmNIY/TtpbG1lNyCi7z/O4f50t2P9FUKNKbBBMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752594337; c=relaxed/simple;
	bh=LDpNTipuO5bRSqJl1m3c3YNQeDiHo/SOS4mTmQGmiwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7j03jPAaH36PGPMjh98l42tT/K25sNN1lRYz/9RRejVJYIipLuWXxcecigm3ZzgS9pGFC18bPrhckutCdl+tAIr+7cyFWlFyEF4gliB1heeBwXwia+CNVx+o9YkWMwnbBQ8JI8Fc4aDn+xzzvYRp8XGexBrm+PjuJztQg3+bHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TKc0KITs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0Ttg9INF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TKc0KITs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0Ttg9INF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TKc0KITs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0Ttg9INF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TKc0KITs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0Ttg9INF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B25FF1F7D2;
	Tue, 15 Jul 2025 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752594333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZUtDa8Gu1XzlNh0JTUT8Vy6AJDYvm4awcDQs1w5mww=;
	b=TKc0KITsE47uX6yHEkRMdU2n4mWxchQRES0Txba/MnT+KbZ+GIvVpwGcCYY0g63kK01jUK
	QVR3cup0ErtqF8hyupN8NoHqwIIXwJqeroXjaCMd4Ydq/UcPomNTdj3OsyOMUetD4Qobd4
	ceqlT5xhRfY7AmrZYrlw1dIHpdyoC14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752594333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZUtDa8Gu1XzlNh0JTUT8Vy6AJDYvm4awcDQs1w5mww=;
	b=0Ttg9INF+n5mGmRfO8oRH6bJWwQt+XKyEt4b42fVvLtFFQU91T3bk88HAxs+JeWOsZkbbW
	PQIK5RSFIGiPh/AA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TKc0KITs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0Ttg9INF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752594333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZUtDa8Gu1XzlNh0JTUT8Vy6AJDYvm4awcDQs1w5mww=;
	b=TKc0KITsE47uX6yHEkRMdU2n4mWxchQRES0Txba/MnT+KbZ+GIvVpwGcCYY0g63kK01jUK
	QVR3cup0ErtqF8hyupN8NoHqwIIXwJqeroXjaCMd4Ydq/UcPomNTdj3OsyOMUetD4Qobd4
	ceqlT5xhRfY7AmrZYrlw1dIHpdyoC14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752594333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZUtDa8Gu1XzlNh0JTUT8Vy6AJDYvm4awcDQs1w5mww=;
	b=0Ttg9INF+n5mGmRfO8oRH6bJWwQt+XKyEt4b42fVvLtFFQU91T3bk88HAxs+JeWOsZkbbW
	PQIK5RSFIGiPh/AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F42213A68;
	Tue, 15 Jul 2025 15:45:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cWt4Cp13dmgsZAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 15 Jul 2025 15:45:33 +0000
Message-ID: <0a33bc37-bb9e-4e70-afd8-59366d46b250@suse.de>
Date: Tue, 15 Jul 2025 17:45:28 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com,
 nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 ojaswin@linux.ibm.com, martin.petersen@oracle.com,
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
 <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
 <20250714055338.GA13470@lst.de>
 <c71ce330-d7b5-45ea-ba46-97598516e9fc@kernel.org>
 <20250714061300.GA13893@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250714061300.GA13893@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: B25FF1F7D2
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 7/14/25 08:13, Christoph Hellwig wrote:
> On Mon, Jul 14, 2025 at 03:00:57PM +0900, Damien Le Moal wrote:
>> Agreed, it would be nice to clean that up. BUT, the chunk_sectors sysfs
>> attribute file is reporting the zone size today. Changing that may break
>> applications. So I am not sure if we can actually do that, unless the sysfs
>> interface is considered as "unstable" ?
> 
> Good point.  I don't think it is considered unstable.
>
Hmm. It does, but really the meaning of 'chunk_sectors' (ie a boundary 
which I/O requests may not cross) hasn't changed. And that's also
the original use-case for the mapping of zone size to chunk_sectors,
namely to ensure that the block layer generates valid I/O.
So from that standpoint I guess we can change it; in the end, there may
(and will) be setups where 'chunk_sectors' is smaller than the zone
size.
We would need to have another attribute for the zone size, though :-)
But arguably we should have that even if we don't follow the above
reasoning.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
