Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055044052C4;
	Fri, 25 Sep 2026 05:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313274; cv=none; b=CHS/WgbUSnvN4ORtBxMa0kLPeyupwiOVkcMw0aolsuWUnIljmmeqMPoMC5X2ka6LtSTYyFbHxjcQb7rYcFeKlBrB9KA1FpxOb+YIKO/nlO87PV4mY6Wzdv+hnBZ07sK3SdzUg5mmwuUK2rjn2/4h4I+89D+ITk6FFpgnLn97yuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313274; c=relaxed/simple;
	bh=inyUqdWmMk6Xi5GTH3gtRSrWebEOsK++2vbEVN9R9H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dtm0q8kU8hXAbG0noH7J0Q6kSstg4WZetQg0abne86QbKaBsHV/3KjwHj/rTAYB0CyqBj18ZP6dg0xJJ+dqqcK0cNWzk1TtBNxJYvQofN0P8DcvlugLTgUr9NTQ3GXTTPlzm5VmNukDkWUb0U8ufAbsRO/g2ex9uFTpCUnrFPPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=c+s5PtC7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ofPAGOVL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PNMDKD9Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GuDcHeEd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="c+s5PtC7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ofPAGOVL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PNMDKD9Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GuDcHeEd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 462BF21CFE;
	Fri, 25 Sep 2026 05:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790313264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOpvbDL1MnlsGJleBCqgU9n75lUBDxUlMNPY0qUqrGo=;
	b=c+s5PtC758CtUvBblec7bKLdFrQXQ2M/xNNZ37j+IT3/IhkXN7Q51TAAjhabjL+sTnldgz
	GfsO5bpIxPmTUwaPe97J55plpVJMp3JX4ZBrSNMOlQmCfODiMUQ/jd3xkPY6c2e2d+paDh
	PGOoEIYX/sbJ4x/jVStF4dq+8t22FY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790313264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOpvbDL1MnlsGJleBCqgU9n75lUBDxUlMNPY0qUqrGo=;
	b=ofPAGOVLRf+W2qaB33NUZEDtmQznygaW9gpVYGa0eSDlvJ6Krj/ysvigntN7dqHW6CyHGr
	0Isllbuj2j+Id6AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790313260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOpvbDL1MnlsGJleBCqgU9n75lUBDxUlMNPY0qUqrGo=;
	b=PNMDKD9ZdJyWuHvxa7/nG8UBN6o80V1arvnG22z0duAegY6s3aB0/qsA8LbauH9jv7EZ7C
	azk2QjWwn10tsHQRYGnZLCpCtPA+kFUpX60eVXWYtu8pe1av0eXT3hP0C7WnMgZ0c9SkxM
	29dtdzXBMraa0aUVT121ontDSUrtUgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790313260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOpvbDL1MnlsGJleBCqgU9n75lUBDxUlMNPY0qUqrGo=;
	b=GuDcHeEdRDBsH5JoGxNNVENTWS8qUbity0nbjhQEE2YHqBK+D51ZKtY1sBcvvd7zINGllD
	5xgOFtKUCYkNC4BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C9C5136F7;
	Fri, 25 Sep 2026 05:14:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pSfkFysDtmq9AwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 25 Sep 2026 05:14:19 +0000
Message-ID: <f8464d20-0cca-4816-bfb5-d19839a1bc4d@suse.de>
Date: Fri, 25 Sep 2026 07:14:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] block: fail a short atomic pin in
 bio_iov_iter_get_pages()
To: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Hannes Reinecke <hare@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 John Garry <john.garry@linux.dev>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
 <20260923-blkdev-fixes-v5-5-89e60d66eb38@columbia.edu>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260923-blkdev-fixes-v5-5-89e60d66eb38@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 9/24/26 1:56 AM, Tal Zussman wrote:
> On a partial page pin, __blkdev_direct_IO_simple() and
> __blkdev_direct_IO_async() submit what was pinned with REQ_ATOMIC set
> and leave the rest to the buffered fallback, tearing an IOCB_ATOMIC
> write.
> 
> This can be triggered deterministically. A 16K pwritev2(RWF_ATOMIC)
> whose last page is PROT_NONE, on a scsi_debug device with atomic_wr=1,
> completes short with only three of the four pages written, violating
> RWF_ATOMIC semantics.
> 
> Make bio_iov_iter_get_pages() release the pins and return -EINVAL when
> a REQ_ATOMIC bio doesn't cover the whole iterator, since an atomic
> write is submitted as a single bio and a short one would be torn. That
> covers iomap as well, where a partially unmapped buffer could trip the
> WARN_ON_ONCE() in iomap_dio_bio_iter_one(). The async block device path
> currently sets REQ_ATOMIC after pinning, so set it before, and move
> REQ_NOWAIT along with it.
> 
> Fixes: caf336f81b3a ("block: Add fops atomic write support")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
> Assisted-by: Claude:claude-fable-5
> Reviewed-by: John Garry <john.garry@linux.dev>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>   block/bio.c  | 46 ++++++++++++++++++++++++++++++----------------
>   block/fops.c | 12 ++++++------
>   2 files changed, 36 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
