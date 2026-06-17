Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07453F1AD1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781691717; cv=none; b=D7d0p9hMoL7hAEdtue+EemPDcyplkUJEpU5wl1pjDfWdK+HBwB6MFud4LlsncV0Vs2TkuFD+UkuaUTiuZ3kzE0xj2zfyX4Kg3a8tdVi33PARL7C36RWaGsPpmRwLnRkkdp7HjODN9LUQVKx6KoZm2REp6V9ZRmG+U+sRmXargJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781691717; c=relaxed/simple;
	bh=K8W+9Bq0vfZHg1QVMPczyxSBkzHBN0aeDnwJ7sfsvf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvtKcZt10o66tq8l3Zwlm8C3K7hPlWrQYmhLaQDcj760cYpmvuSuH2dDgvwpszPKcU3lnrOBIeqB0AjE+SlpwskMis4NjuSQdx7KYwIt1CVBVFmtpj5XjBgYb8Zq9oTWn8gALgu6QSPubzQ2jvfY675MwY77YV2ETq541uSH6JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rtxc+e96; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=frHyLg00; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rtxc+e96";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="frHyLg00"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781691710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s0EAsm/2HXwiPNnkNEoOhpX+wYzOETlihifH0vVI2ps=;
	b=Rtxc+e96gmYh+mLUFyjasG5sf5CM2rs9CyX0hs/SIUvAiuT97LDvaH2cCtddOVHZsx3CEB
	Qe7T1zUoBIXi4hK88tJ/5cQQ5sq2d225yYzG37oEWnlAJDq+wCW+nAWipcj/kTLfsP+Gq9
	ixN8BVahnFzRVx1fvLBS8dqQSxGAdTo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-DwkvPMsLMjOvQkL-1XIhxg-1; Wed, 17 Jun 2026 06:21:48 -0400
X-MC-Unique: DwkvPMsLMjOvQkL-1XIhxg-1
X-Mimecast-MFC-AGG-ID: DwkvPMsLMjOvQkL-1XIhxg_1781691708
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45eee3f9f03so4934926f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781691707; x=1782296507; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s0EAsm/2HXwiPNnkNEoOhpX+wYzOETlihifH0vVI2ps=;
        b=frHyLg00RYO+ZrQAoc79C8eM4s+uZeMp6uOrIHFqePvfU7pTXaU8u3cXAwqhS34mnB
         aFmpEfuhZKUY1ekujB8x2fEwiyk55CzfwRVjtnUewT3c08WrjF29dm2Vn5KK65/Yf01q
         LAEiuVb11JI5OZ6XqNuLP8F16WksQLZO6P5XPCLNkgeMIn0UHG4UlMeVbR6MB8oyAqHr
         YhXYI4AK0ETmvqvysUNN593GcyF1+o+ACTBGtWgLqQz0vPdW4mUy/2RvGHaBpU6ekpAn
         8AHRCQsiMHRBMXwdD2KIJ3srE+PH5+F5cRT3/a781lDiG6TgN18D9Hhg/P7EuNKQPXG/
         OERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781691707; x=1782296507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s0EAsm/2HXwiPNnkNEoOhpX+wYzOETlihifH0vVI2ps=;
        b=IU746sWAPNMeaVhjsopNHkPm4lUo0DcvR9pm7j9UjMZkwjsJl4LCMeh/sf9vkL3y0R
         u9w1Q1oMDwGCslrYCrfNYj3monB0S21zamXSPd37JdX3Dv10gVWOAHAbF2uzSGaOwkOl
         kGPr5bXRMKqkUkQfEiWqwErLHZjK3rxsy3uFyp87ytD4cUjY22/0h6hX6gsCTL9hk0OZ
         JrUd8it1xtZUNSFzTahJMVm/fgzmRU3VFjvfh+vzmqxNV4jAX/XOU6YIRu5SnFFmzJOk
         KTwJ4u3zhdo2hMq4+Hx2IV6HUic6LNcsFOGL9hAw3Z0gTgQpIjtODHvoU8d4EGkbm1I9
         hdtw==
X-Forwarded-Encrypted: i=1; AFNElJ86beIGRshYs4iN3hEwChJJutD9SawyYLHItwqx82akS8n9CheqQ0ZPW7k0mZCE2vQKK8NAxSkPShA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBsuKbCrNDcyoGh73+GTRIKWBIAL6UPDc13uuEAzgjmqEtLIwQ
	EaXQchW9FtZqPGHlYa8EY4o4woYvUc2N3Yv+fFVK/cQwBHhffCT8warWr5dSWZ8JHFssuMPtu1p
	CvEXCCsm7zEE24le1+FBzM8ZcbqSxiiFSmJDniD+8mBE3VkqoIxw98tTRa9Wv
X-Gm-Gg: Acq92OGnehix9NEOf//seoIVoPebvfwkpk78In9WUtxZLABqk8GMfvPQQ21kZtx/O+9
	l5q3bdw4ZX/+9LZV20pM545cAczIMzFmwfKWWuu6ll1qQDDvjeK4YlIGDJUekAuBMf4qF6PH34A
	7N4Dj4KOAoJ347CQOalDy0yMbfb01/AR8ZxSsS2H9fPjEtu3VVIa4rLF8tQgYgLtFoshedaOgnX
	xyUwP1xpg9FBgPQzh9ICwOzG8j1gfraRmLEhQXfOuSq5jNokxxIqlH0qe+rQt491EB7Z4Critk/
	6vKlughB6GN0ALeLDT7HoXkdgRthOYkhOyd1ckuAvSKViuqI0A2MTBlqMcvYayvpusE2+qCdob6
	gWOgsp8L5kmUS25pEgbwX7nS38hRdFl/GZrm4vThVN/ovMQ==
X-Received: by 2002:a05:600c:5252:b0:490:b00c:8e6a with SMTP id 5b1f17b1804b1-492333d6f07mr51619505e9.28.1781691707390;
        Wed, 17 Jun 2026 03:21:47 -0700 (PDT)
X-Received: by 2002:a05:600c:5252:b0:490:b00c:8e6a with SMTP id 5b1f17b1804b1-492333d6f07mr51618885e9.28.1781691706794;
        Wed, 17 Jun 2026 03:21:46 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa3a8efsm147887045e9.2.2026.06.17.03.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:21:46 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:21:46 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs_healer_start: increase statmount buffer size
Message-ID: <ajJ1J8XSRoOq1e6I@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <178118661334.728615.10301394467406944970.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661334.728615.10301394467406944970.stgit@frogsfrogsfrogs>

On 2026-06-11 07:06:08, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that our statmount call asks for the mount point,
> filesystem type, and mount root data for each mount.  The first and
> last items in that sequence are paths, so we need at least PATH_MAX for
> each of them to avoid overflowing the buffer.  I don't know what is the
> maximum filesystem type string length so we'll just hope that NAME_MAX
> is enough.  Switch the allocation to dynamic because 9k is a lot.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

