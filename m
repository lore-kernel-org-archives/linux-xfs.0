Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D473ACA5D
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281852; cv=none; b=JnTKxuoh0FWtER2DDZkR/TaCZHFiUbxN53AV1JkhTcmtv9g3uGRIxZHWMEPxF05/W9rGnDlKslvfChILWvTqM+bVrpRcim3GXkq1duynh69obNXFHarQnYO2MMHWKEini8olP3AnX5DbolRVzauqF2IBlJahpmZvgOGWhKhmZtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281852; c=relaxed/simple;
	bh=rTGplCyBJkh2bkDYBIKlMH3wsr0SrqCVCW+QaZVCErw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIE+f6uq6Px82MvuvPxaEYeb43cHLibs1ZBqJTTo+CQXFMyQlmaJuzc+wCvoEKsxdk8v585DhMG76zYeevXvoNdgdvEWo83NkEnte2K7I/r3aibnNlCCueVSYSlS/6MbbxjM9PvVYRCIPOUtBoZC85miMIqbc5h1PWyoMOJFrjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ar0o9bA2; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ar0o9bA2"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd4ba9f68so2421785e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 13:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790281845; x=1790886645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=saylt10Fw/9Bgvahm51d7jrIP+G+sTRm7c4tdEvSznw=;
        b=Ar0o9bA2Tq67VKmBBkFaq3Ej4GkY5WNjBE0qb2kKxlPkRJQmj/bwsAltrM8Wx96dcB
         rLkUbYLKQrfMxO7F/N8y498FXssd1UrRoWtU42OqRGt1WNjSM3ng8XOlGscFVs89DTOO
         UzwbTt6N6FDWAFPVR39b98ELI9XTpRhX984J/Myils8DLl3V89ZV6iBgk+IxaBaM+kcW
         8sut7p7WWB6otxH8UcbAHJQrHUVvQIJqjMUKAOe5noURgvW9yvUZ6jL8AL3SPuTzA7IL
         ryHjVI6jGxobexyCAgtirIzWHgp5cq0iIViybJJ9SHpKmJL8LN2JwmxaeHT6uUyoLneL
         F1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790281845; x=1790886645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=saylt10Fw/9Bgvahm51d7jrIP+G+sTRm7c4tdEvSznw=;
        b=qph0ohs8pULH0PVKaukpU6lW4yk1NK1hFP3EnVZwx/p5xskHBnWb5RUf4yCoHNAIe4
         8t4pMmkGUNEjxnOJX6WV2F4TScsCWi6+IQPJRkXvSqcLP8ny9qm2DYa+KW4kWK7i7MMY
         vTHReXeJjMNy8rgh2NUDFhZvG085eCKTztDV8sdrXihB2SbmTVJwdGHs7wF9+3yKiYMu
         D6v4H/7MoyoHqV/EjkOnAQg+99UHdUWaWQn4/Tr5ho+bxH53l8f+Yhqh2V87WgijwjD1
         yEoN4muGoZ583xKmZVlDSkLMUlQGlxRdYy4h/kBjhE2oWabCf7SihltZK1h85OdygOPJ
         RS5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwZaogjRhYjBKsPwtLH+AYj8It5ZYixNwJX8R+6awC2tjPXpS2Ygk4ll7Xr4+qOzocJ76vWE11CSEU=@vger.kernel.org
X-Gm-Message-State: AFuF++nvrIHE0i9D93QI9W0WcPz1LF/QMKglnKCZBZyktVIKf0ESAgXK
	tycFxn8BImrLNKAK92A8nIBF8lOhYPHTct6TrAO4HSclcs2qw2nBGxtV
X-Gm-Gg: AYBFou13NwIgUMYXvd+ycfv5S7lUW9R7rJWcfnG1EnbUPK1nhbEt39731PxZVtj38Mx
	FbKcfbBtKWHJElUc2zsRIGwnaRbYhOp5yKmHVwVBxl0VNwB4SKzFJhKsncNaUTUjU63FKVnuOfR
	bT+wAjOwFAk44cMbHJVJLrhWV845ymVI/UnBOmgVt7+DCiuRv6+3kJ4Sn/3Mstr32WMJkOXAc8E
	ObtuhGjDNs8ZMNpPlZcJgfk+/1TWqJ/FSjioU2lXmzrm+Gp2Vmwmp62oRo8Sp/MbA3gNzcDIgRk
	j1vhciTvmMpCdMUwzHOUsDheyGohLT2pXKXBXr9FGy44rJOC/LPcZ5nSOPPPEq+CVfPy0qLH5ik
	MTZiLKQcpH4ZnwQSGXxd6/p71aAq8cnHJdlBkPUJhPOTgYMshfb+KhWllzePJuJeOupdkJXRbRY
	F8J2PJecOGjqyPJ6AuIFBhAy8+X4oqwpARXeRUGF8AZkzqwG900iSzrBKlPs2d+444I86E0ClXH
	l4qpmCti1AaU5G1ZfsnrL2YbL4UNYkzeLQpQLi8VUPBHc+/jrAR96o=
X-Received: by 2002:a05:600c:1d28:b0:49c:fc6e:8cbd with SMTP id 5b1f17b1804b1-49fe66fc677mr69380595e9.33.1790281844999;
        Thu, 24 Sep 2026 13:30:44 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30c43asm1720776f8f.3.2026.09.24.13.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 13:30:44 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] iomap: don't resubmit an ioend after ->writeback_submit() failed
Date: Thu, 24 Sep 2026 22:30:07 +0200
Message-ID: <20260924203013.9967-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184910.GI2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com> <20260924091203.198225-2-parri.andrea@gmail.com> <20260924184910.GI2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 24, 2026 at 11:49:10AM -0700, Darrick J. Wong wrote:
> I looked around the codebase and saw that iomap_writepages also calls
> ->writeback_submit.  Does that need to null out wb_ctx?
> 
> My guess is that none of the callers do anything with wpc after
> iomap_writepages returns so it's not harming anyone, but we should drop
> the stale context too, right?

Your guess is right: that ->writeback_submit() call is the last thing
iomap_writepages() does, and all of its callers (xfs, gfs2, zonefs,
exfat, fuse, ntfs, ntfs3) have the wpc on the stack for that single
call, so wb_ctx is never looked at again.  Christoph made the same
point on v1 [1], and the last paragraph of the commit message now
spells it out.

Clearing it there as well would be harmless but dead code, so I'd
rather leave it out; happy to add it if you feel strongly about it.

[1] https://lore.kernel.org/all/arITXTsUhrA0N-qr@infradead.org/

Thanks!
  Andrea
