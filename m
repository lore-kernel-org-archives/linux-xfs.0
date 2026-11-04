Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753734;
	b=bbgW20r24m6AfR+Ti1DYGmKozN8514TBOJ0UWvxQH6A2vG8xaY0rt3eJXtF8mYvGA3tI
	 oTGsGnQ7NJVXitzEPyDCcfGzwaiD9noenQtKpaxhgbHq4UKK/+6daT1AzS6j/H8QeWlyw
	 FQsSngno+2bX2J+QgEkiZgBoc/+7pZF9qWCGC1dk7Setnf0FpL0mOoxQWsIbKMuZsKCM/
	 mbHL8o5ZN+TjSwI+wHiUYv7kagLDd7qYuQ4K3ugV+45ZNknyj1Ao9SsKskWICXGbqpiWw
	 86itZUBSPr2oji6bxDoa7UnpMLbCUN7GVNVLThh5XGTjWSFFos/rs8MgW5rYGfsSMPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=1H0otVvHi5I6PcN07uLIZN852mLgLqhn4l0siUV3pU8VZYvww1moLg14S6WwXf08TVrB
	 UKMIeJO1s/Yz0KnoQFFRDiN/NDhhCx2xMOJm9dNlF96BbVWMXkMOgtscMjPfN3VCbm8gU
	 b8cc41m/viSOpjwS7WvqYHbVBT01OVQ+BgAxRbiz1bbPxhEjePv/exfSQjRzX4BeIB1KB
	 cain59dptEGyf4lAnXWVeWcsVucsRphTv8r5827S1MIEoxsGKKjetgvlBi0MRXJe5pgGf
	 5RSzbqekPJ6shsrzsy3eaLRimWggoHDBLwLxK4k7OKLQ2GyRqnbcVBndpxcWgZsREzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78939606A336
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78939606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso76813a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=sudo5wuzf8me28sIhbntLBwUiKNWuwSV6wtIncQpUBbsN4Zu1yMj1uOdtNMULS+qse
         p10GSTbsQZQej+RmcaRVIPfYXpiJc7DVP332tBPCeYi6iIxYHtw/pCGnwu6pUZaiYkuu
         1jzqj0fIApJI24vXlIZRW+4LFyo/2rv7mV5cIr8Gch74DjfIbhBYVLv8/dyYnqAxTrWw
         7/Kxsv4asQfbrP6PWPBOlk/xWVzyI0hLDQrJy+RjayW+oFANYAqhfVZpq60HUf6srI5f
         LvFF0LRAtEUesVRTlzKq8hIDxyh050q8ogJnunYhdFI0Mss29VGLQmid0PHrrP/vhgJw
         FudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=zPxJcrT4r+MV7vtfRqRf4KTbJYczICXSCCHzJps0uZwmjcSZWprL9o5+ashfUszKQS
         vkm1B2JRqeFiiLCge9rxKATM++H/aJoipVs5MV9bASoyXOsXR/an7FctqRqxawYrRnMn
         5GpCTQ3sGVyoCkzliFREgJS9HcSi/MGS/lzEbBRTrAlg8VFgWnuKgrZZwl62Njqv6JT4
         Stvq4ypczwuHPTQJdsizkJP7wPbBz9wd6is9SiNoio1gMjdU4e5UsbVdDM39eybrdi8J
         uLzidjNdw6pTRuy0vVJSg76wpAakLByleVlIW/4qUu5gJrrm/gEihGwcSVyJUM7FXDHV
         CcdQ==
X-Forwarded-Encrypted: i=1; AKwUvBwScHGvOuPvFIs47np2dY5zEZJkqnpnVmvfQX6MT2fHzcNHTKh5/1MITi6MgQiS1r1jYe+77LDCNGs=@vger.kernel.org
X-Gm-Message-State: APuU4Z9mPMmxOYFFcEzfR47vy9s5DzrYJzIg8UNGKnPPylDm5QpbxAiJ
	KhawSobQhoKEc2yArcfZTzA9+nxMcwAQjf/SGTCcgIfYvFu9rdj8fEfw
X-Gm-Gg: AYBFou3S9cV1PEFqlTvOmtFBxwl/yB+aThrMFLMrXgDfqPGgLavQ3Q1oTMm8EJCniFX
	bg3cL8ukZsvfqbyivsuIKqLM3z/FdmTmIUPe1drrM+Xbe3RB+w/Jc7j45+sMlcL+I4TqLah6DKn
	dvomO7a3C0TbRdyxNK8gK7l9klBwU9GHWgRhS5ytlWJo8pE0sSy/wsMPxR99G2WesnXPYwVt1Ry
	BfK8k2cCZkOIJXztRHDSsdDFAAEmYa6j7+6/HEzEd3j5SCwJv2UGlfjIalD6Y8LckB160a+eSvU
	loy8DOO6QyRLqfbVQ/2pd+qHuPLl/YA5ITEadxhXvjx4RR/BBd6j/xxscgM/peCxWeXFmSo7GuW
	4IxFjNl+NnEhyN041GWDibEQHFNjBNYydH8nJjGke8n3vBXVULZhU20042uyb79Td4zpBHU8DUv
	637RMkxOdN8e0Fs5HcNjkFdV2SqnEi0DKjW3n6ggsFuGPxlk3pfokGtuf+4EVOFaAxCbkuTK+3l
	VzduWWH4a9LzLdXAF5lZdUmMPBThn2vCiOwR3jFzdQQbVQK9QqMV1cdYn+fG8YUArp05vs4BueJ
	USaceboAsjDl8l0XuA==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
