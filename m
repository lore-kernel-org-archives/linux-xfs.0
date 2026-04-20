Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FE7385524
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 08:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776675260; cv=none; b=agNciL2gFP+2rzqbD0LMD65EsvOKvOXCDdpyrlaviiLH/Hff5GwiW9nMXtgyG768d+v/qtG5DrujErJn7MFWc0dBC/Wf4iGlPY72oIpn2ymh7E7pTiuKZSExEaGo8RnM2vmk6kfxXe4RWyAiQzWfFTg8sVMYJr+H1Imkt1IBht0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776675260; c=relaxed/simple;
	bh=dSx76QyoCgSjpxqgeGcqbla4YBk4KSC5LrUnmrtLEws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUk114KOu6Xnr7640ZGsu5ul2uA7pzat0PfXm3ycIR6M3I8E7Ph+hXJD2wossmNT3/cKipzl4kUxakch5jXq/UiDMvQOkb97IBpMDcQuht4azfxwRjLUtrce4WgO1GdXZqtHmrxatQpfE+YSa7as9CtXJjvkJ2o5tj7wq4FJ1N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fmw+RmcT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ga8NOVGH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fmw+RmcT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ga8NOVGH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776675258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+aQiPPIHxREJ9LojQxFqJyqV/j9nuS5AUjoGZFBuLmU=;
	b=fmw+RmcT/6w/4VFpPcacHLXp8sSx7E1R44dbsgHNiBgIXt4pQhz3ofCpGv6NWYNdzrsZts
	W1PQZCIDqyXXwwA8nsBLNeuuc/Hcwcw7RLfW3vZzRXiVBRC/p8uK/A1AOCUqWSRi3v6Szg
	xv7e+40hcsPp6FVtBZ7DcHDI3t20DCk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-ZgrHRDGKMNeViD5W3GQAYg-1; Mon, 20 Apr 2026 04:54:16 -0400
X-MC-Unique: ZgrHRDGKMNeViD5W3GQAYg-1
X-Mimecast-MFC-AGG-ID: ZgrHRDGKMNeViD5W3GQAYg_1776675256
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48378df3469so17633365e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 01:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776675255; x=1777280055; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+aQiPPIHxREJ9LojQxFqJyqV/j9nuS5AUjoGZFBuLmU=;
        b=ga8NOVGHu2o8GuEunPt+iW9+zndazxyRd8WlD3nAI1L9aoqg0vgMUTWfvkFjVWWVGZ
         1ohB6c2rN1Oi3tc6IbhyFyAsZbo2Jv/ni+dbA1DEuGpaBWh/9XMVjHQjt5EybORxGWPe
         VTvZUHFBRD9K7bZ8GIWpDVLAqyuiiy/ILdhWcX4TOfdXdQI09a5w1TZNDvGdqpE37IeN
         f9Z+ixCndFgg1NagA+91v+v/BzZYb+l1oRehFh8KxZHrN9wgmVGLlfl8NoK3D+/oIlr6
         Jc/GkIrezFNzRs3SAMYovIOTZw430xqrx+u5hVZGgn6Iv4oVU9U8JUJnahpROn0O+g2p
         D1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776675255; x=1777280055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+aQiPPIHxREJ9LojQxFqJyqV/j9nuS5AUjoGZFBuLmU=;
        b=MP3lm9feCjyoUawIUhhCgiKnqVZB9jholsY5hv43l6yxnZkh7DwUteQC1qFk53eOhA
         S8UXhcTn4ZSyHP5+8WXqVC2CzzwzhxRrgn039OS9zAMLj91u9CCDSWv4v1eJev/549Hm
         QFPj4JdhqMTY5qrRNDfGCxyrAuEM/AXYK/b6n/sMtzJOlfavzQ01Zqp6SbxQd53NN9iy
         mc+W75PVbcWU+dKV3Ib0iceSbRLmeBHhsmOTwEOl5q3ikWiYBwpEcLmu8Api9scJuJwN
         fggCZNgxt2zXN6pcMKIMxckU/K/UUgSnaUrVWPiiEv/YaIh+4KaN4qBdttBTPCvu4SNL
         QoFQ==
X-Gm-Message-State: AOJu0YwYEhvudOqT643rKfoDsW2LzwbZItKmLysLECy1VmaAoUt6tt9V
	yFAEzxdKzFcfvr3jOei2sTaO2+Qt9Kgm/hAi677vO5C1bIBO2u3pVluMogXjnCKk3xUxepq9MVn
	bUv3n1DcrP9zOHpYNfdOt4faeif14FgmKJQ+VgGh+OtEQsHyvzFpxmQ4zvjR3OFFNmoEU
X-Gm-Gg: AeBDievO1DqMBVbuNDLeKbn22UrNaXGmlQPr0mLx3i8pvZpI0nXgN6YbpKHkqfKJJfw
	WD8KdPjBWK1EPq4Nkbmpw8+KJzZWUA3dEiZuk7d745yBM4E9tAxsTblFiZ/22KLh2CoxIFfc5Vy
	9jNxR51WUgVJaCpHADlwhgTH6H5KRvj2y7f+b3gbQ10oy6jXM4teaI+T8HjrRsJZJDdQ0LOz3Dm
	kRrcSQulP/I+lO6y8gJcNsVU35PBxiLnNKf5nMjmTsB6w/b2/IPGUfBnL4+3Y+1Ph9XLlNwViyK
	fzJsHIyZ2ASn68+iWcQ4tyhn6/RI+xyuqCmL/FtZp1Otk/8YaD/m3etBR5T865ps6+6Ql1Rk0MB
	4ChyP8h7Su5dhpQUvP4wqrg==
X-Received: by 2002:a05:600c:34ca:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48a07615b87mr10570145e9.8.1776675255316;
        Mon, 20 Apr 2026 01:54:15 -0700 (PDT)
X-Received: by 2002:a05:600c:34ca:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48a07615b87mr10569805e9.8.1776675254786;
        Mon, 20 Apr 2026 01:54:14 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48919f54572sm32462695e9.26.2026.04.20.01.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 01:54:14 -0700 (PDT)
Date: Mon, 20 Apr 2026 10:54:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: Should we hook up sashiko.dev?
Message-ID: <bvbjjxtpeup63ycakpn3igvcmapwyclkgsqszj5pvjeqjbnkej@7v74qii6s3ws>
References: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>

On 2026-04-15 11:49:50, Eric Sandeen wrote:
> Hi all - 
> 
> "Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."
> 
> This is something built by Chris Mason and others, with Google providing the LLM and tokens.
> 
> The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.

I've tried Chris's prompts [1] with Claude for review (the ones
sashiko is based on), and it didn't produce much of a value. But
maybe Gemini models/sashiko is better with them.

I think it's still worth trying to enable it for xfs, maybe it will
give some results. But without Cc imho.

1: https://github.com/masoncl/review-prompts

-- 
- Andrey

> 
> We could send a PR to request adding linux-xfs, and I think we should try it.
> 
> However, if you look at the config, for example for linux-ext4:
> https://github.com/sashiko-dev/sashiko/commit/d921c59
> 
> there are options to:
> 
> 1) reply back to the patch other (or not), and
> 2) automatically cc: one more more people on every review if desired
> 
> so before single-handedly making this decision for every future patch author
> and/or possible cc: individuals, what do we think?
> 
> (One can drive Sashiko from the command line, too, with or without the list
> subscription mentioned above, see the github repo for details.)
> 
> Oh, and I guess we could add xfs-specific review prompts, too, see
> https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/btrfs.md
> for example. EXT4, OTOH, does not have this. (and the btrfs prompt looks quite
> limited right now.) Maybe we could distill the xfs documentation into prompts...
> but I'm getting ahead of myself now.
> 
> Thanks,
> -Eric
> 

