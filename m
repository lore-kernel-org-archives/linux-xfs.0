Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9B2C375E
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 07:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762326272; cv=none; b=ZW19jBkEk+MnfbDTdYn/7cipptpZPp7dNZ5Q/zDVi4+yW1Pao7HrYh+FgYl8j/M53gWzSSv7TN51cJmgB7iQOlDk9B0jtuAGidg1rlF8Xs8eGKiLcNjtrjMw+9EiITSx0oAIY8WKgwMMZK9KtXzgiTG7oc8O3DTH+eWxDi1GLM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762326272; c=relaxed/simple;
	bh=kSs7qMoHl1DAuBZE522q7Kg1LZ4tJ6HM1jibtbvTYWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nMOWwRaRHM+27Xnsn5gzZMb2to5ZZPqfaOJKBwyQnlKjSFh4/EYlB/d7SnHyyYRwK1aFcngA/vSWnUtm8v0OOi7QxFDrXnlUlR+hzjSYbV/7FjYEAhObOZIELwFFHG4qyLLKe5/yTLz2yamJCEV9zqAt2n6cOLt105hhPbxeg04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qHBv0de8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=paOpXCVB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oI7Pewzk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LiWriEA+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qHBv0de8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="paOpXCVB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oI7Pewzk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LiWriEA+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E8E8A2118E;
	Wed,  5 Nov 2025 07:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762326265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qKiNghwEz9ttm5RQCpMgWipz8U7w6mWbcKyxmieObA=;
	b=qHBv0de8QNmjh8OPtvy/yOf3METcsmKMaULYbUxN9CvP/pz6oh0OozITlNG7nO2buLb9/Q
	fUq20dUDbO43jquD5WigLP+EwlDga/Q6FdfmuSab/OsTQzC2HAaZI8M90JmO8jIEBRjCIq
	2T3uQlc2Stpw94nwxaeqCF3bS9XdwPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762326265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qKiNghwEz9ttm5RQCpMgWipz8U7w6mWbcKyxmieObA=;
	b=paOpXCVBBWsD2fwUMSbNSj2H6sIUCJmtukWD+Jy6vO6X6cAQCICq7U25a2CscemBJaEDs7
	aqmhCNKBSUchkgAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI7Pewzk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LiWriEA+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762326263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qKiNghwEz9ttm5RQCpMgWipz8U7w6mWbcKyxmieObA=;
	b=oI7PewzkEkneKYWBlZLXuhMUZgySyvBSpjqPVtLOT4C3fE30XjSsdY5ux1/f3JUq7M0TDI
	gm3prwFJp9BtzFT8iPqpON+z/ZI+EplNoHz/kwT5+DJ3d1qGNaTYXd2UTuhQHmw75MaKkI
	eRXvcRXzV0fshKkgC6GxS87bCHle8/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762326263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qKiNghwEz9ttm5RQCpMgWipz8U7w6mWbcKyxmieObA=;
	b=LiWriEA+z4oUYO7tk2NipdTpC4xs+5e0wsKRAHA0FJmX/wx1Wlj0MdOPMX+e7SMLs0RYVP
	yRnvyTx8vVTxuHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81B73132DD;
	Wed,  5 Nov 2025 07:04:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DWetHff2CmmkDgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 05 Nov 2025 07:04:23 +0000
Message-ID: <5f37d8a5-5f0d-4948-9efd-5fe168ee1f7f@suse.de>
Date: Wed, 5 Nov 2025 08:04:23 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/15] block: use zone condition to determine
 conventional zones
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <20251104013147.913802-1-dlemoal@kernel.org>
 <20251104013147.913802-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251104013147.913802-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E8E8A2118E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,lst.de:email,suse.de:email,suse.de:mid,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 11/4/25 02:31, Damien Le Moal wrote:
> The conv_zones_bitmap field of struct gendisk is used to define a bitmap
> to identify the conventional zones of a zoned block device. The bit for
> a zone is set in this bitmap if the zone is a conventional one, that is,
> if the zone type is BLK_ZONE_TYPE_CONVENTIONAL. For such zone, this
> always corresponds to the zone condition BLK_ZONE_COND_NOT_WP.
> In other words, conv_zones_bitmap tracks a single condition of the
> zones of a zoned block device.
> 
> In preparation for tracking more zone conditions, change
> conv_zones_bitmap into an array of zone conditions, using 1 byte per
> zone. This increases the memory usage from 1 bit per zone to 1 byte per
> zone, that is, from 16 KiB to about 100 KiB for a 30 TB SMR HDD with 256
> MiB zones. This is a trade-off to allow fast cached report zones later
> on top of this change.
> 
> Rename the conv_zones_bitmap field of struct gendisk to zones_cond. Add
> a blk_revalidate_zone_cond() function to initialize the zones_cond array
> of a disk during device scan and to update it on device revalidation.
> Move the allocation of the zones_cond array to
> disk_revalidate_zone_resources(), making sure that this array is always
> allocated, even for devices that do not need zone write plugs (zone
> resources), to ensure that bdev_zone_is_seq() can be re-implemented to
> use the zone condition array in place of the conv zones bitmap.
> 
> Finally, the function bdev_zone_is_seq() is rewritten to use a test on
> the condition of the target zone.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c      | 153 +++++++++++++++++++++++++++++------------
>   include/linux/blkdev.h |  37 +++-------
>   2 files changed, 117 insertions(+), 73 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
