Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242072343AB
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741034749; cv=none; b=J7QUr1GR3PhHUBdmKJViAJkHEh7NMkxKgTTq6VVqH/VjXvnP5/TRMER59i2nVQg6wR4SffzdtgqJqBbBfLTyFHPhGYy6gElhEAiE6RZt4Lh4a6BHM+beXV6hNZ01f+C+P/PRr/3mClBtGkobi312v5kONBqJDPJeie4fg+NOuks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741034749; c=relaxed/simple;
	bh=KtRtIkf+tI8CYP8SpRXKM3DIxX2i9Sg9C47rtalN4zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cK3tuLZibtezDsiSQ2ElJ/gzGaUNGi5gTJeeYRjWyrnFXqzojJ1UHELDTlx86ykV+iHOAvB1nc4S1EOJh1Bi8G883W6qDCKAgLwp2UMlZqi2+oBc3Bfd4hrcYJLxYQqw+C3uR6zUubEBUKWFGEMe3qL8QvaM6fnSusk8khq0NuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=vpn8FO5E; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="vpn8FO5E"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223594b3c6dso84071645ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Mar 2025 12:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741034747; x=1741639547; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7XGk7Og2gqDlm9MRY3vaFJ22GyXfdVp9nEi+0rQBKok=;
        b=vpn8FO5EoejUR6TRVk0cgM4FEi1K4yRllPB8zzvpzsXEktNslkdGlTxVcxZpZDKLmR
         5vJw4EQPyw6ZxfBOV/na8IZRiuvJltS5KmYjrF26d6Q+cQim0BFCJhryhbl/8+zOJZ42
         B2iDsZ+SdsxwC8z44HHUQE/fc3GTOhF9+vEj2IBA2R8lCPNt28HrTfcuqkEfYjgSaaVp
         HV3PRMb6dqhRv2upDYZFA5NHlEfxd0zvBDxW0bwcp1aV7d8bTtgjMuZsF06uN1Wm7TCZ
         2J9B8kQiHxP6OIm62fBkji7FjN0ioPFtt33Pf7iZaP7/jcsx15jFcWn37Lao05DufcPV
         Xsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741034747; x=1741639547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XGk7Og2gqDlm9MRY3vaFJ22GyXfdVp9nEi+0rQBKok=;
        b=ASrjMcisPP+cLy58B8mLQYlXa9c5C427iXCu99JhuK+oEv5mtiMqttm2tIXGsOjAAy
         3XjDo/hSIPu19GDAPYlEl87NCturxxVsJtXkv9g173EFVOlD8NKyF5I+ZYep180wyt4+
         CGo/86D2OVMWNAJsJKnMEcuvrxLP4R58Cggmn9NeNAF/q4zlHF3TxlFtwa8WuRJeKUCm
         9h6E+rkxy5EmasUrOn2S/QV8nMY0i1YxawHqPDxEbGmg3z444++bqJF1ztI0dwoEHwR8
         fzhGoD61khISTFUi/IFfcETU6nEegLoaOBkLxePaz+3m7tx7YJY5OWZ9XlDaZjmmtIno
         1hHA==
X-Forwarded-Encrypted: i=1; AJvYcCUslP6xXsy1bo1vde+dyKLemDdOLWNV+bBYrF9C0mIDoll8a1B/cizg8fOvnJ6YLyy8fjVdusChFwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqAk5lpuhxpYgFgIg30bVw7fy2rmhVdtEv90tO1QesG33cOcho
	tMP1YVc97A4FP+hP+LA5fuR/QCzFRuVYLMkUQ4BYpRVq2g5AYboFbGjxv/v/oigiIFyQJnbAjeH
	Y
X-Gm-Gg: ASbGncu6hq9Rq4sMhnjBpsy+ooSCjTaL7fKYH0WlFSF4yjtakN8Z1+QIZuTdq+br3an
	ZN/170znrKr4Py5SdeEx4RsMQ98tqSDJOCAKWsT/sF6t7JyvaBkG+qkMpvcHwS5j54yeBhtD2rk
	Z292b6MyhNm7U+r3yLxzKhPoRdzWO7ZcW9C+klMTfWyiZxX48plMc4xPQ76h3VP/pGMSOtOqXC9
	5D1HQ7thhRlwQKyIF/qe5Dc61QfdXfsema5WskuMLokXdZUIHiJcjNQByzmd9rOkp0VK8kTZSMk
	VRON3zKj3uz9rzICOySh+VMokqcuasCejEYWxq6vMbXIKkETgC+UL81BdsSsgWM5WrkaAsVK5LV
	xv5UJ5UX7+jRSI9eAU6p5
X-Google-Smtp-Source: AGHT+IH/B18pydy8Pnt7mD3QKhmW6vpxyYQaJWgWpx4izblpWCTAeLTww3Zr6v1OCs7KiIQFew0hqg==
X-Received: by 2002:a17:903:18a:b0:216:5448:22a4 with SMTP id d9443c01a7336-22368f6dc74mr259198795ad.10.1741034747418;
        Mon, 03 Mar 2025 12:45:47 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223d4b94c25sm5167435ad.49.2025.03.03.12.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 12:45:46 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpCfY-00000008Spz-0vWy;
	Tue, 04 Mar 2025 07:45:44 +1100
Date: Tue, 4 Mar 2025 07:45:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	alexjlzheng@tencent.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't allow log recover IO to be throttled
Message-ID: <Z8YU-BYfB2SCwtW6@dread.disaster.area>
References: <20250303112301.766938-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303112301.766938-1-alexjlzheng@tencent.com>

On Mon, Mar 03, 2025 at 07:23:01PM +0800, Jinliang Zheng wrote:
> When recovering a large filesystem, avoid log recover IO being
> throttled by rq_qos_throttle().

Why?

The only writes to the journal during recovery are to clear stale
blocks - it's only a very small part of the IO that journal recovery
typically does. What problem happens when these writes are
throttled?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
