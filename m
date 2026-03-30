Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5E23815F9
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 02:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774839165; cv=pass; b=uLfgwUJukNV4IZSOB4BhB2ghszS41d9STavl4Q/Wa2Dirl7a4ehUd1CTLtkoQiaHKz2ptfZgxoxVCYr0hL8f+/G9KyklMAqRiuPF/JC0x/BpRP20ELyv8RpdcpQvabOotRwlfJeShccSIQczCGOVbzGWOuswB0jG3TcwMS/+zOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774839165; c=relaxed/simple;
	bh=SfrGjdlcRjT4L4uWuViBvdklEQoncEmijAAgKf1l1bI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GsTDswUK1P50DIcYKloS5vZzRIN8jSu8Z7k2LMbt5WzYBQaSCEY+BWpYvsCzIc9pG6vhsGu8MVUodFMgeETJiXCBQF9EIyu0AulW7oyn3Wm/m/A4OAIRo8pszgwNzb0MVu7PJ/JRolvNM3NdeBXKPqz1/K88FzZYwZF6yOtmv8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YXaEvoXX; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXaEvoXX"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-64eee7b83cfso3707542d50.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2026 19:52:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774839163; cv=none;
        d=google.com; s=arc-20240605;
        b=PTGLj1MOetmqc0pM54wtMjGKFv6Sq1RYBO+OgB35at4WviHIpcGglbX7khhl7HXeCN
         ua6XC4+OPQM4+ir6e5/NmsIf4C0x3EFYrLalOXYLUWd2sYhJSY8CwhoJK4TqM6uUtB5W
         Jgrjwsg6bh5GynVebOi/xMEbbc4HrBtVeCFElDK5aos33nzfO03NPBhnQSn2h2xzROsw
         A3Z4NIgK5Bikv25aTp/31kHQvYDXQEGgkg3855Z+dtTXU0jL6mxChbyo/ghJXh8J0Qc5
         zFtHShAjmtcKbw2R2263Am3pXhhIXuQXEfNp9UoQxza49456fdDNSeESY6w1bAWxVNj5
         CpvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lrXg6QpqOaU442980eJaCWaSPNp0oMwMQIp4gID6wto=;
        fh=XMdz1lwrbF7yANxNgswNYz2mftaiKtMCC7tZdYD3zVI=;
        b=fdLBlh1viITGge8E4d1VQOnHV6NvLf2lN8yFJU9MmyRIcronhF+0jJxC2DhvH4hagG
         sE1C+v94AIutPLbZr3kLbwNUo6WA++k3TR8aqPIvC3NF5M1TJEZODZC7Wi7DRzjIwRyG
         vHOyqd/yeGie9SqtudmS7MgkzEUSl64U5bwGFQC4GUXRy/MDSuEO3XDjSCyEaxqyKZCA
         dDKiRH9IxfL70CVc6ml+xdw5N2Qz3O/y6EyVHGE8D4i/jWc1AzeWaAhe6xl6dMS6nC6Q
         pEFhxawjWvpW5LXBV4KuF+Fow5EJUs06Xf7HhSXv0xag+y0qfK8deU0vou5JbacinytB
         M/OA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774839163; x=1775443963; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lrXg6QpqOaU442980eJaCWaSPNp0oMwMQIp4gID6wto=;
        b=YXaEvoXXMGg/3CCAHgSmBegPGDEncGe0pQwhca1mnQE+0r/x3eRtxtHIvhw0RwUW3Q
         ukoynh96PEO4+n58HY9IEN+jUcixPyGAfhz+MzJ8U33f45R3NIFCK96XHJetJSKm368J
         2kyp1CkOnzqslt/f455H0nXu/HNHlO8Bei7I6HSOzsrBCEP/83bmFPWc/2reB/WmvuII
         9ROX1faVug//Qf7morf/T5q7td3BU8UYoPDmKSnU59/sFcZP//l8nxQXiPZ3xlZnNqbE
         KY1XTb9kP/QaXdzqBImbgeTKw6W9zCBkzRTWR3KDpQSopZbrdcNg8+CY3jxbznB4n6Ab
         Wvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774839163; x=1775443963;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrXg6QpqOaU442980eJaCWaSPNp0oMwMQIp4gID6wto=;
        b=kpWGhT3fG6KBAuc4BEw018Qq48ruexQq8c6Y/b6ReKa7oBr2XdXQzY/6QAi3AEAw4x
         9x2/Gp2+R5r+BWBOCiitx42i3UBtK562/ZIXB59eFL/DkBTtR2+LhLlNrXVXyB6AWfzi
         ZucLO/lT1Tr7S2SXG2wP2bJSJPglONSLB6ZNY+HCR3lmb2d0zFr4bbLgyViJv32ScycJ
         HfBfutkfWfU+wrk/+fqJ8VViOR2Ig9g+y+AObPtV1ticg+jCajtSrvdiwiHiyrYKISvV
         ZQPGuA3TkxYxvp/uW80bGISGcDQxL5Ka2B92G3np71Ksl7jEMLkxUfmTGVbHBEEbDuoX
         oa3w==
X-Forwarded-Encrypted: i=1; AJvYcCUmxxaA2R10hnNwNAGcQdrygmPW6Xydj84ak6PhTTaDb9TtXHJfsIU4V7NMVaitjrujx/hNJ/wjfzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqaY982ENgyma8ooAtnNRXv9Ah9vDKkoXxYDqdYtrM3ZH5FlbI
	xEto0o7h72bSS66BhSRfrhxWcWNuCIRWqOpeVSgflD/mZHEhulw1/ieDwC6PE0D5B21gUhZgdS4
	u4QPB1TefosgIXdaEg0syPMkpUpByo7I=
X-Gm-Gg: ATEYQzxHKyT8VKagnYPEd3Io1L2a7TlO8f1v09bTwczMr3gYIqjUDQhsmCzu8T0/ALw
	++i9kzULNjxmW0DhajvkdqZZBo8czwU3aU6WRRfR5wa37WKhdMSZPUv4de1lBQKCarMu9UIkrZf
	JqujzPuqSyKnVQfQpD8P2hqnjeeKva8j6jXFAplPr2GX9SRTgejmTtGM7uWIoG1KNRETtJB0DVF
	Gimms7J8oiTQgBV4sEqQCAEmBBJvUeepV+cnwVfAq2gg2xGy8XET4L8vEC5Rf/CG4nbSzgx4O4j
	Kqxt8DbiHw==
X-Received: by 2002:a05:690c:f13:b0:79a:b879:bdf0 with SMTP id
 00721157ae682-79bde0fa2bbmr109572217b3.46.1774839162876; Sun, 29 Mar 2026
 19:52:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327131152.155617-1-zzzccc427@gmail.com> <acnJMhFpp42bdW93@dread>
In-Reply-To: <acnJMhFpp42bdW93@dread>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Mon, 30 Mar 2026 10:52:31 +0800
X-Gm-Features: AQROBzDgkko_b5X2k_jPUm3cQ0Tz68mTMbkE5KDOr-P3gm_XEs-Ju4vtpIrupOk
Message-ID: <CAFRLqsXH3dBk_s8HmvLMaineikWneZpE1PHsH_oJzAfLxyvmOA@mail.gmail.com>
Subject: Re: [PATCH] xfs: annotate lockless b_flags read in xfs_buf_lock
To: Dave Chinner <dgc@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Dave,

> No. READ_ONCE should not be used to annotate a benign data access
> race. data_race() should be used because all it does is turn off
> KASAN for that access, and unlike READ_ONCE(), there is no code
> change when KASAN is not enabled.

Thank you for the review.  You're right -- data_race() is the correct
annotation for a known-benign race.  READ_ONCE() adds an unnecessary
compiler barrier and, without a paired WRITE_ONCE() on the write side,
is not the right pattern here.

> But, in reality, the race condition here is more than just the
> b_flags access.  There is a big comment above the function explaining what
> the check does, and that the buffer pinned check that precedes the
> b_flags check can race with journal completion, too.

Agreed.  The atomic_read() on b_pin_count is already KCSAN-safe, so
only the b_flags access needs a data_race() annotation to suppress
the KCSAN report.  The commit message in v2 now acknowledges that the
entire pre-semaphore check is racy by design.

I'll send a v2 using data_race().

Thanks,
Cen
