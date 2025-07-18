Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C7B2D8782
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837374; cv=none; b=hJqQcLkk1/bvW+0TmCObQ96KkcdkTNclM7ltBJYDG1oo2lTDHifnoF5HHP57lz8WHq3y904V/p0hLCvdLpi6FXOfK+VHIbxah07cZbdTPmuajVXHekI7KqZkku8n2SOM9zzuFi5tCS2I5t/1/pma2eOOY3WCrWcasnLv3MX5JXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837374; c=relaxed/simple;
	bh=KAC7tKnqNw6ghQsIQoBhWab53HCnxnYmc4lm5r7+vxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKUYQnU95gYN0N8rHf6d9FmjdSzTwujw0ufX4cQjICHuT+WO8rkTpD6pbnMWc7ZhwWgvb3XhM3o0uilQKWLUHr/6puYvQchoUXWSj81go/Pk3uVzUsv+CqUodqHMnMVU/FWuS0PK25rGi/3JJ5AE04vY/w0CJLtEo6QldJp6x1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=295fLNDI; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="295fLNDI"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235e1d710d8so21820565ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 04:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1752837372; x=1753442172; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qpf3i0yhcut+LszaoQo/We6g+NwrXQm4EMP35kSjpEQ=;
        b=295fLNDIraQZGqmW7Ys3e6G6wT0JrU4jopR8MNVHx5yIdgl/3r/EG4vc4PcRr736fC
         G263dTU0ppCQOjICqEyC7ydrYaJGViYNjlO5+MLWQ/GjpuYoCZjEd6RE7Mq8HhfgzHzA
         yxXPupl9berZtTq3/Z0uKFUruLjPttTfH5LJXN4A9xnmcJVSkO+Mk76inN3Cl6wsrvlF
         6qq5j4FMLDRLad6FYz1/5SF93eAef/AmvW/o74QGTqd+JZ/EdwREi2mg8MfWswIL0CWy
         O1TRqeIy0rSSJD7oIXqIctGE1yK4bkQOV6co2OyaxNjmQkpscB7N5enIsnNvCPKIVnYy
         JuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752837372; x=1753442172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qpf3i0yhcut+LszaoQo/We6g+NwrXQm4EMP35kSjpEQ=;
        b=dcG25eGctHbVEan9Iydk8oQWqjjZwqG6JAOuKOvOUmImq6bAnasSB0f9pMT9/8QKwO
         SmjAkmLYe7YG0OxmGE64oTaWlwcjQa1Krt37ACf6gDYsLak7h3j4uzqL4K0yF4m4bRKG
         wmobXAiGHoL/mAEtkNxffnPPTb+pgZKdYLPfvSjxyRiERuxYwxRYq32eEo6RlN1FwEnA
         wmb3Krmy0Wypbx7zcAKniSH7L8EmafoPtGnv1Irf/NW0lpZYXVLs3hDgTtCzqOwjNH82
         hrSXjgxa2KihYzTIr18gfko9kF7/pWQEq1a8ReQD2bTjCCs2LFc1RV9+3ql0ZFawJThD
         PZLg==
X-Forwarded-Encrypted: i=1; AJvYcCWXvm3Lj6dsKtJTNJA12LL2Fa75cfhKgbaeh3zk3jaONz7gkRmTomdb6hQBIjsoUXVuXU9a68Zo/ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkVaVxc0ogI5kGtxLo1xTWWp6zEif6dYBFB8dJa5DyOXCR2StI
	/5sfoGYzLtt7k8NJLV4tL2CAUSeR33f1nBOUBfsQ234aKdSn2rLKDffcLsI4TePwHAo=
X-Gm-Gg: ASbGncsPATkcD3O7OVQvdW3gaDopL+SLo0l31KGWyUNNTJWbJ1BvGgWeQIa6ItxAB7n
	ByTRAa1fJmuXvDyVnnEHTZgVeJrVbYGZzbFTPsvQx4E+6A39Obdgv8g3uTytuSZnbDLOICW11bQ
	r0JHJZ2JWo/Qt4zail9SFgDAQgvkJcZmGuFVrB62vxGjvyye/MAL5nqei5Xqv5S4XTRDpy+mRUn
	pdcIRYX+/1od5sSdnXKhUBXtK0rJwdDMou1dYlpkhMgPjqyNe0crXcBCrcOkJ6NX+fSB8mLHs3q
	Sn7iGV+hmcrtO/FqN5/2i6/DaQMX0UeSUP+Pmv5SCWLKdER1ymODfHvMvGmHklsoE2nCexbJjjs
	BHHKmJa7qv4L1FNN/PMosjB5vZOJWmPX/A1EUHotSi5PQ2WXnyyekKHBMVQYlexp0pnlySJy72Q
	==
X-Google-Smtp-Source: AGHT+IH+YNkMNydCV8+ckYpqEo/rurDfmxt/BmZG9DSn518D6//2LQGAwxPczvGdppJLXJX8W68Ctw==
X-Received: by 2002:a17:903:350d:b0:234:c549:da14 with SMTP id d9443c01a7336-23e303389aamr104128795ad.29.1752837371571;
        Fri, 18 Jul 2025 04:16:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-64-170.pa.nsw.optusnet.com.au. [49.181.64.170])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ff9e964sm1016534a12.59.2025.07.18.04.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 04:16:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ucj4S-0000000CZ8f-1Fgb;
	Fri, 18 Jul 2025 21:16:08 +1000
Date: Fri, 18 Jul 2025 21:16:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
Message-ID: <aHos-A3d0T6qcL0o@dread.disaster.area>
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com>
 <aHg7JOY5UrOck9ck@dread.disaster.area>
 <CAPZ3m_gL-K1d2r1YSZhFXmy4v3xHs5uigGOmC2TdsAAoZx+Tyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPZ3m_gL-K1d2r1YSZhFXmy4v3xHs5uigGOmC2TdsAAoZx+Tyg@mail.gmail.com>

On Thu, Jul 17, 2025 at 02:34:25PM -0300, Marcelo Moreira wrote:
> Given that the original `strncpy()` is safe and correctly implemented
> for this context, and understanding that `memcpy()` would be the
> correct replacement if a change were deemed necessary for
> non-NUL-terminated raw data, I have a question:
> 
> Do you still think a replacement is necessary here, or would you
> prefer to keep the existing `strncpy()` given its correct and safe
> usage in this context? If a replacement is preferred, I will resubmit
> a V2 using `memcpy()` instead.

IMO: if it isn't broken, don't try to fix it. Hence I -personally-
wouldn't change it.

However, modernisation and cleaning up of the code base to be
consistent is a useful endeavour. So from this perspective replacing
strncpy with memcpy() would be something I'd consider an acceptible
change.

Largely it is up to the maintainer to decide.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
