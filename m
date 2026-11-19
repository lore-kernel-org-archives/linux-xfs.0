Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795118711;
	b=X0tvgS+3muG14DLeK+2KWxozPD5b0xLAJb4EaBRGYO8KLuXE6WmbJG+w8i4Uyhf6l1k8
	 N8SKWrzzsB5CXENeN2TiQ/1U4KenQimo7ogn6rO+48wxprgfIM+Y++c2qhtIyaaWDWsH6
	 afSHfqDcLDvkzqYpmDOS1N7EQ4EokwZLPsDuU849bFS4V1RiSCV2+KpS928AEQz/GCmLF
	 Wx2q9CZ9AJi+RrnNrdNYk5CzmP4bYd+qQupXiF8Hp8tZ9uBvXFvZszjCqHkGpQdhpbA7d
	 kjQ1MWJzP1TWEcnE2eEpbYAkmmaPeDghE7Q/pIBKRtBHKVSOattGTMHfCMvnsXpbwjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118711;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=03I6wjDEiblELfAS7QQgi6boZSqyYStegum8bFV18fY=;
	b=hANpmY8vmYtKqtojQ07ObCKL0ws9pPDZUb7dAQJYeLDZNQZMIjR7nX6lS4/tccCEMajh
	 7JqeWZntuuMwCiWX2GfrQfsLODSxRpkESABON1H0aTlBdTn2hGGRKtGIy6lIhnghXapnW
	 vQUddotCTszSw84TQGExrSR6lcSikwuvIw2Le3gkrp+Xp3qDVVXuKbI44ok5COWvXkpdM
	 E548Lz8x/zOpdD2tbCJPiA6yrWF9p2boP7fKHF2pwXD7hUemy79Kl2IjebAvbjfovqWcO
	 rsLKJVCh/KRoTzQ2Nb8wpBW0PWgIQqT9qIe0mDIhUrretr4ZxF15OZO60CbnJw8UKcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="YH79WWB/";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=oR9s5FiO;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2648E606A32A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 20:05:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2648E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YH79WWB/;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=oR9s5FiO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795118710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03I6wjDEiblELfAS7QQgi6boZSqyYStegum8bFV18fY=;
	b=YH79WWB/8SEhkD73Iti//+6bQ90NNj/m4lB+mTvFm82b+sRSVl0O63Mf00g1aqhxCi5r8Y
	TMWOBSrSt5E+uqLazLmBEw9Gd5pDKwbqrWNB7DmQIQubmKET5aczBUEVYOa4cIZ/Zr/9Uu
	meFtq6nUfemankmWqr9hC53IEIpZyDU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-Jj6py7CIN3eEfxRMBWSf3Q-1; Thu, 19 Nov 2026 15:03:37 -0500
X-MC-Unique: Jj6py7CIN3eEfxRMBWSf3Q-1
X-Mimecast-MFC-AGG-ID: Jj6py7CIN3eEfxRMBWSf3Q_1795118617
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-949b0d322fcso30042085a.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 12:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795118616; x=1795723416; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=03I6wjDEiblELfAS7QQgi6boZSqyYStegum8bFV18fY=;
        b=oR9s5FiOUx2Iz2plEYA5rrEoKDhQEnQuYq8dIJTfpEtwSW2+iAuckLZylk+85SG6si
         alr7kBk/2+6pTHp4vtGMTzpN8tJgsFyd7l2w9WiUYfrx3Zre5iu7MqHx043JQ+KzrW/1
         PvtTAMJ7ovmtMQYI4/Xc/Aol62atWBJyUig6yBpbC5Q6O4xEATz97EAXGZHr+5LAMS/8
         khXL5IyFcg65Qu7gLeZpfwK5vDpUNwzw4sys/NptberbAm23OZObYy6hbr7X5RXxc0PL
         FvJy9n74nkufDV3nBiGpBctdFKKULGBInmurWyduAiDVWtfPjcGAsLatwkEDTF/WLb4H
         Nuog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795118617; x=1795723417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=03I6wjDEiblELfAS7QQgi6boZSqyYStegum8bFV18fY=;
        b=ij8yK66g4+++zM3L69HmhUBRkM4J3WR3RObZf/QGrhwSeh6QJFWuI9wXUwcNMcKrbn
         00QZuivlkCaySVljcoWTfLzetf+ONnBq3ip2RPRcukp0Ds1c20BaK8A5JuZU9Hy9iylF
         yOn1C0drHZE+pFeR87NBI63NlPnx6mmWYSwqODenuab05DE9gksVoWMYsBJvo6r7ZsBm
         acaBOt7NQgdXKXNUrSsrRuZFqheesAca9EW0HmAjwf7Ni79wpvWStFR7mHJjP2UX7afW
         upKq1aj7Bp48M6kwqGhiy804Cl4nU0nl+Z54oQGf3sVgMnufqRUK6ptdr16rF/d7HeRp
         01ug==
X-Gm-Message-State: APuU4Z+D+jQcN3Up2+GlIZynvvtXvQN9yR3HD/ZADxC5aA5U9hnhGerr
	BPtr80o8NEoQNZenJw0E41jZii+O0/6VaFjX+GvcTInn2PyyqQgEJD3P2Gk0d+Q8u9VyIFBNZsr
	6gFh2PT1O6Ilbcd73EcyO88XplbmQZnkEwVQUWficPXca6PXgrTotSTL3mAsYvi8R6GgJMINKjG
	W4U9UtCQapuvicWOKGFCXIzTA5QVGzml3jYe6qh1z2G1Uh
X-Gm-Gg: AYBFou2koTL20RjcIhqdK+HGg9gXMpGg9vwVVA0INsFzk0Y0RJ1wjqd3dTpXUwnKHqa
	IztEUQ4TV6h+MHCYg/NIb6yUKyv/EN9QB0UQYBZzTwGJgF7OUVkQqHYb8o2TJic8oMcBBx2kxdl
	mDQbzMBff2NwEcRBMs1TVzq+d+Sv62fk9KhUVbRUdMiU3QTeMMbvp0zgbzam73wl1lanETQSeVi
	mkaoZe4CH080f8MyO3DpN2Vf21MlyHC1//veSvucLYYsD6N0KD7wOG8ESnVjdIfpzy0mvtK0gt8
	mj+6A4A9pWUvP6CYPcKBA2EgM1ALj0rKuGjERVMCV5IY+Uz7F7sV3ReNfHLVZe1l6GKLipps+ZV
	h77SNlDtDToaIk3UKF6HFnykynJwfoXZeHIi9P0sBb8VC2oV89cnqphdgJopM9Z5KfpnRSbUO43
	doLbe7SCizy9c=
X-Received: by 2002:a05:620a:17aa:b0:949:9985:e097 with SMTP id af79cd13be357-949ba96becfmr128046785a.15.1795118616388;
        Thu, 19 Nov 2026 12:03:36 -0800 (PST)
X-Received: by 2002:a05:620a:17aa:b0:949:9985:e097 with SMTP id af79cd13be357-949ba96becfmr128035985a.15.1795118615479;
        Thu, 19 Nov 2026 12:03:35 -0800 (PST)
Received: from [10.0.4.228] (174-20-5-40.mpls.qwest.net. [174.20.5.40])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb0319fcsm40760085a.4.2026.11.19.12.03.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 12:03:35 -0800 (PST)
Message-ID: <932ff720-e339-4518-b448-14a76f929d58@redhat.com>
Date: Thu, 19 Nov 2026 14:03:33 -0600
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: initialize error in xfs_getfsmap_rtdev_rtbitmap()
To: linux-xfs@vger.kernel.org
References: <20261119170449.1513687-1-irogers@google.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20261119170449.1513687-1-irogers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/26 11:04 AM, Ian Rogers wrote:
> When xfs_getfsmap_rtdev_rtbitmap() was converted to iterate over realtime
> groups with xfs_rtgroup_next_range(), 'error' was left uninitialized. If a
> continuation or range-bounded FS_IOC_GETFSMAP query has start_rgno >
> end_rgno (for example when keys[0].fmr_physical + keys[0].fmr_length lies
> in a higher realtime group than keys[1].fmr_physical while both remain
> below eofs), the while loop executes zero iterations and returns the
> uninitialized stack variable 'error' directly to userspace as the ioctl()
> return value.
> 
> Initialize 'error' to 0, matching xfs_getfsmap_rtdev_rmapbt().
> 
> Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
> -Wconditional-uninitialized enabled; fix and changelog drafted with an AI
> coding assistant. Build-tested with LLVM=1 W=1 and
> -Wconditional-uninitialized; not runtime-tested on a live XFS realtime
> filesystem.
> 
> Fixes: e3088ae2dcae ("xfs: move RT bitmap and summary information to the rtgroup")
> Signed-off-by: Ian Rogers <irogers@google.com>

This looks right to me. Returning "nothing, successfull, with error 0" is
correct. xfs_rtgroup_next_range() also cannot return an error that must be
captured. There might be weird subtleties if we ever get shrink going, but
for now this looks correct, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_fsmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 041bb2105ec6..3ccf3ce23332 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -760,7 +760,7 @@ xfs_getfsmap_rtdev_rtbitmap(
>  	xfs_rgnumber_t			start_rgno, end_rgno;
>  	struct xfs_rtgroup		*rtg = NULL;
>  	uint64_t			eofs;
> -	int				error;
> +	int				error = 0;
>  
>  	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
>  	if (keys[0].fmr_physical >= eofs)

