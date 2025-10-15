Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB232C237E
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 08:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760515679; cv=none; b=uq/aBP6h3B1vAM9We6vvEC2eo3VApzbQWVIFWBSK3FA6ccL9OjE4h2kSY3jQc4btb4pSSmzXRJxKhQmGV4AU+QwF8FIB6065tkFJuEHresiyRsBBDdO4o9hQudu9lw1KaTjVZIoHo7tjJzHdC44x+k6V+JddxMXEGef4/qhdKu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760515679; c=relaxed/simple;
	bh=UyEW64rmyhcIN6ILFqJXD42gT8cl32Dar8Ge+cZOgM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M5j4W/5sJk1OoB/rhDzjjUxu4d+ohqUmZDzwidmCaaMQTmiwvnodbrX7XwuKueQOUSgWWGqHfck5M9pwmUXvlHLTegF6ZdP9y/nmQ7YtRy4NYDs+tkom2kK8YGUBIeTgI2cLQSDjMgloclBGHTV3O5ekK2lWbuxlEDvqeov0iJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eJrbBh2H; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X0FIiQqI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eJrbBh2H; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X0FIiQqI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eJrbBh2H";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X0FIiQqI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eJrbBh2H";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X0FIiQqI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BCA921029;
	Wed, 15 Oct 2025 08:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760515675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K4PW6pYXBs8I8F7rqr6v7rZZDo1MTao7+FQeliy/AWE=;
	b=eJrbBh2HPuZcvuXU1HpvZv8BZrMInDparc0ck2opYzizddkzQgigL55matN2vWgZcKPu/H
	88UPdErz9A4Rk0gI7Z7XiOqKZgp9z8to8tP6OAaN1Nm05KWJ5kRqnux8HrcWFsSSmTlvTb
	5xpJnHB9oFfiJ/T7q7m+S2mpL8hBqGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760515675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K4PW6pYXBs8I8F7rqr6v7rZZDo1MTao7+FQeliy/AWE=;
	b=X0FIiQqIvLaJfaNxLNMkqL6kUl/owGYWSATJjrDYO6Z+zOYwhLc4z5b+xf7MDHwBLR7RwN
	wiFDCiGyXXeRhbCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eJrbBh2H;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X0FIiQqI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760515675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K4PW6pYXBs8I8F7rqr6v7rZZDo1MTao7+FQeliy/AWE=;
	b=eJrbBh2HPuZcvuXU1HpvZv8BZrMInDparc0ck2opYzizddkzQgigL55matN2vWgZcKPu/H
	88UPdErz9A4Rk0gI7Z7XiOqKZgp9z8to8tP6OAaN1Nm05KWJ5kRqnux8HrcWFsSSmTlvTb
	5xpJnHB9oFfiJ/T7q7m+S2mpL8hBqGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760515675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K4PW6pYXBs8I8F7rqr6v7rZZDo1MTao7+FQeliy/AWE=;
	b=X0FIiQqIvLaJfaNxLNMkqL6kUl/owGYWSATJjrDYO6Z+zOYwhLc4z5b+xf7MDHwBLR7RwN
	wiFDCiGyXXeRhbCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B09313A42;
	Wed, 15 Oct 2025 08:07:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rIUaDltW72gbYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 08:07:55 +0000
Message-ID: <93c2e9a0-f374-4211-b4a0-06c716e7d950@suse.cz>
Date: Wed, 15 Oct 2025 10:07:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] xfs: quietly ignore deprecated mount options
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 Oleksandr Natalenko <oleksandr@natalenko.name>,
 Pavel Reichl <preichl@redhat.com>, Thorsten Leemhuis <linux@leemhuis.info>
References: <20251015050133.GV6188@frogsfrogsfrogs>
 <20251015050431.GX6188@frogsfrogsfrogs>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251015050431.GX6188@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 4BCA921029
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.51

On 10/15/25 07:04, Darrick J. Wong wrote:
>  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> +	/*
> +	 * These mount options were supposed to be deprecated in September 2025
> +	 * but the deprecation warning was buggy, so not all users were
> +	 * notified.  The deprecation is now obnoxiously loud and postponed to
> +	 * September 2030.
> +	 */

FWIW, this seems at odds with the subject "quietly ignore" ;)
"loudly ignore"? ;)
"warn about but otherwise ignore"?

Also there's maybe a difference of ignoring "attr2" because it's enabled
anyway, and ignoring "noattr2" because it's going to be enabled regardless.
AFAIK prior to b9a176e54162f8 "noattr2" still prevented the enabling? But
maybe it's not important. (I don't know how (no)ikeep works.)

Hypothetically someone might complaing after taking a disk out of very old
system without attr2, booting it on 6.18 that will enable attr2, and not
being able to use it again in the old system. (Funnily enough similar issue
recently happened to me with btrfs from Turris 1.0 router's microSD). But
maybe there are other things besides attr2 that can cause it anyway.

Anyway I think even in 2030 it will be the best to just keep warning instead
of refusing to mount.

> +	fsparam_dead("attr2"),
> +	fsparam_dead("noattr2"),
> +	fsparam_dead("ikeep"),
> +	fsparam_dead("noikeep"),
> +
>  	fsparam_u32("logbufs",		Opt_logbufs),
>  	fsparam_string("logbsize",	Opt_logbsize),
>  	fsparam_string("logdev",	Opt_logdev),
> @@ -1417,6 +1431,9 @@ xfs_fs_parse_param(
>  		return opt;
>  
>  	switch (opt) {
> +	case Op_deprecated:
> +		xfs_fs_warn_deprecated(fc, param);
> +		return 0;
>  	case Opt_logbufs:
>  		parsing_mp->m_logbufs = result.uint_32;
>  		return 0;
> @@ -1537,7 +1554,6 @@ xfs_fs_parse_param(
>  		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>  		return 0;
>  #endif
> -	/* Following mount options will be removed in September 2025 */
>  	case Opt_max_open_zones:
>  		parsing_mp->m_max_open_zones = result.uint_32;
>  		return 0;

