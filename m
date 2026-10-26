Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793029018;
	b=f3YEb5lEn7JwcP/f9rtYZMQuHXudZnVUCAdKw3Zroz6mrCyzU39Tc10qvikjps7oPCIm
	 m2XWxOsQoSxoJiG8zfKfioKfnfxImbcYG50nUmJNaAXfyTVdXVykwLP4Pv0h6xctJZ2zf
	 bTH8XnHRJqG2jZok1nqU6eMc6tBYQCH5KNwVLCy2CWgvRVlAeTLSiNvkDdJe9L8YJroha
	 tvcPSo3fPT1g7OYOqpBSy0VPsazSmIeMZz+JM6GGHxQXfqsoIG4QELcrHIt1mdmxkbgTo
	 mR3f3gOfz7ABhT0X82WEMe39rLNYBSPU84RqledBemDU6QNGEl1d4TRDzH/vf5Wr4cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029018;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 Organization:References:Date:Message-ID:MIME-Version:Content-Type:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=cF2LelxJ3MDx6ecMIAXwpCiisZ4MqO9Mbe0g8HDsS6s=;
	b=k73SJMCfYVAxm899nETXLEYMjVpYhPg4tipfnrev+/pC4kMqf3hUhKoVa6CzQsBENRkP
	 ubl1DZu3GaeNItx2Li5yRUc6a+EBd5ZRR0+tWcVlNdlFeP3I4JB6hOMCRnBUYGW5vmM+n
	 gxI0oHuBkYv5Pkp84J8jmng3vc6iZqZG0Gti1aMEEayBDZdKBiA9Utlro50Ry9uyVMznB
	 k64Z86+MsyIICvKsxRnGnAFatStjlJm7y88k5aVWYp0oUX9GqYufJVispjfutE2zoUiN0
	 /AlK98IV2Ta67ijQhdk2YNYMIwZB0vZ6XeY/qOC8Wl6pHwvGze0LHwl9Kv/yy8V2azg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="iAXN/Nag";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JNbRYef1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="iAXN/Nag";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JNbRYef1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831BD606A31A;
	Mon, 26 Oct 2026 15:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 831BD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=iAXN/Nag;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JNbRYef1;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=iAXN/Nag;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JNbRYef1
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB4C422006;
	Mon, 26 Oct 2026 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793029015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cF2LelxJ3MDx6ecMIAXwpCiisZ4MqO9Mbe0g8HDsS6s=;
	b=iAXN/Nag4cQ5zMf3PtgdB40d+rYxX9JJN392R9AezuxUIItNEQ/LY77WUmZXGiI+Kau6jF
	EUjwcW/0CsKEYhNOhVu/Klm1vydI+Krvw9KcB/8R3CZnxZjAewQxYpXaduCDyngii1qj+O
	93ayObOHgbUgLno/tEFsOXWtAD5Y1dA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793029015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cF2LelxJ3MDx6ecMIAXwpCiisZ4MqO9Mbe0g8HDsS6s=;
	b=JNbRYef1E6RPpmJFcMsn/WUm7pdSpJLIiRoVJ+/h1NgtY/IBx57KvXgX79gIHfUFPKx1ml
	xZApWHb5f0C9gTCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793029015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cF2LelxJ3MDx6ecMIAXwpCiisZ4MqO9Mbe0g8HDsS6s=;
	b=iAXN/Nag4cQ5zMf3PtgdB40d+rYxX9JJN392R9AezuxUIItNEQ/LY77WUmZXGiI+Kau6jF
	EUjwcW/0CsKEYhNOhVu/Klm1vydI+Krvw9KcB/8R3CZnxZjAewQxYpXaduCDyngii1qj+O
	93ayObOHgbUgLno/tEFsOXWtAD5Y1dA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793029015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cF2LelxJ3MDx6ecMIAXwpCiisZ4MqO9Mbe0g8HDsS6s=;
	b=JNbRYef1E6RPpmJFcMsn/WUm7pdSpJLIiRoVJ+/h1NgtY/IBx57KvXgX79gIHfUFPKx1ml
	xZApWHb5f0C9gTCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56F0C13408;
	Mon, 26 Oct 2026 15:36:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E23TBZdz32pSfwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 26 Oct 2026 15:36:55 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, "Christian Brauner (Amutable)"
 <brauner@kernel.org>
Subject: Re: [PATCH 0/2] dcache: don't leave negative dentries in casefolded
 directories
In-Reply-To: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
Organization: SUSE
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
Date: Mon, 26 Oct 2026 11:36:53 -0400
Message-ID: <87y0bkqxre.fsf@mailhost.krisman.be>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.30

Christian Brauner <brauner@kernel.org> writes:

> ext4, f2fs and tmpfs keep negative dentries out of casefolded
> directories. A negative dentry remembers one spelling of the name and
> the next create() through it would write that spelling to disk.
>
> So their ->lookup() doesn't cache a miss and their ->unlink() and
> ->rmdir() call d_invalidate() on the dentry so that d_delete() doesn't
> turn it into a negative dentry.
>
> But d_invalidate() is the wrong primitive for that. It's for a name that
> went stale. It walks the subtree, prunes it and detaches every mount it
> finds, under namespace_sem, and here that runs from inside the
> filesystem's own directory operation. ext4_rmdir() does it with the
> journal handle still open and ext4_unlink() does it even when the
> unlink failed. All anyone wanted is the unhash.
>
> So d_delete() now unhashes the dentry when the parent is casefolded,
> next to the dentry-negative sysctl that does the same for every
> directory. ext4, f2fs and tmpfs drop their d_invalidate() calls.
>
> xfs's ascii-ci doesn't set S_CASEFOLD and can't so it d_drop()s instead.
> I did consider setting S_CASEFOLD on ascii-ci directories and didn't.
> overlayfs warns when a layer's casefold flag disagrees with the
> superblock having an encoding, and xfs has none.
>
> Nothing changes for userspace. A miss still isn't cached and a removed
> name still leaves no negative dentry behind. Verified with the same
> create, unlink, create, readdir and stat sequence in a plain and in a
> casefolded directory on tmpfs and on ext4, before and after.

I think the change looks fine and it passed fstests.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Of course, the better approach would be to enable negative dentries
but the last attempt went sideways, though not for any good reason.

thanks!

-- 
Gabriel Krisman Bertazi
