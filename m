Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355518E750
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 06:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738046698; cv=none; b=nDN50P3zFA0C0PA1+OsYmndjQtByrHbUoWnoOi+57wTncmTFB/mbb/t9XJPzXOM9mieMA+U/S5PFfr5R5VFi/KQa1KNq7x0VB958udhfj6P8kwrs58C5VAgKIbuaA0e8rlhBBi/IYcbLnJBqsLVBbzzZ/WjxKxnafforV0+5jcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738046698; c=relaxed/simple;
	bh=kZw2Yetk7ZfImS4opPwgGTDXY9hzSbOQyUveqjXv7fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNENg0WNLlrayr9+1xoPZUS81Qy5xVlg2BpThD9lNRxdCVJH64h2ExIlNHyu1a98ewiKFPBtNuQ0ScvH+xwnZLKaqsHOvl3knPMzZGLUjg87IlD82HqsMhxSfjg2gRWf1P2unVCxErHI1RThvy6HW7Wa0bkjmNZ98uR2CDz1VB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1yR2daqw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1yR2daqw"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21649a7bcdcso88265565ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 22:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738046696; x=1738651496; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z28yK5YjBnLuaKxsrZrwFhfIlCbm3OtI8dbOLhKFKNs=;
        b=1yR2daqwkfhZeWqjbbD0tEOgOP2+gmDIh8G5S5pIz6bJqKHy0Nf+IvdLomyAHadvGq
         mJnHFWkgVy1pVcQl+Fi9ncQi/y7MT0JwmzTUuiZ4QDfgVgCtHNxtjq/vOjPmMDXyWnZD
         yd1y3hEeEHg8ocmN/JlmtcbLzJ/jgk1udM0XrGbgTWB0S7+KOi7VnjiTnFHdjpqw4Uqa
         k0al5iVtH+TtWv9T1A8nDEvkie82Ks1EMyVd7mj2M1dtlXvyxpgUYuC2Xe4z9UMNC7fw
         ANzAV54rOZSZOTGpX10wInsWte5WpCxHdC0iVXdVTtVnTPCkA2XLNCj0N+/Uwe1stQcg
         jLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738046696; x=1738651496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z28yK5YjBnLuaKxsrZrwFhfIlCbm3OtI8dbOLhKFKNs=;
        b=Ynzg452er6B9s8SYvx+mjdGZa0vH+hdYVI9d9UcBBXlpwQiqcsw3k4UKdRGnygeAjF
         VCLDcosnJb3kdEcexQ1323/v/5LpuRwwvE5ElGOtTG5BO6URcnFoaB+u9EZgdWAAn4e3
         E6TPGh417e+q/5HYkmUOmHaigz5WZnqgkDrXmrNAArO48QJUDoaENuAh+zkKXjI68eWR
         GVzgIXuw7zzNPzxaApTSlhVLgYPV7auYOauBv/XCFcpCIl+hkRWgAz6bWs6l5hTyJIFG
         fOiASn+9H5ohU/AskqCUINZ5zdcdBAEnFzrncH6UAWls+QsBY8iuaRFIc9GifCtyCPDG
         zrtg==
X-Forwarded-Encrypted: i=1; AJvYcCUsII9ZzWy3W0hJUtZtbbPDn1BEotBcZ7X8xBxdLbGw5uR5wkTwenjlogdIND0bI5IHG6dlG+RMIZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxw4U6jjF++JL35IGK535kLyaWW9J2XMkHR86Vs+ljxFijfnV/
	EflXdVKgKeS8tcNzo69tZSxEAAFSNY1eBDUKRbdMEVYLL+sJC5bDPIlkoSXjcp8=
X-Gm-Gg: ASbGncu/6dlPSKOwKciSVPSiiyF0IN0WphVNEJn1FTY7yTme9Yeru/2NUM40E3VB5p/
	y/X5lhOmJDDjiJGbdFRi/lEpLzG5c7dlphqlpA+rYPN3crMNC4vyE8mEnCYAAJJ+sJUFRGL2gXl
	uitmm2bqHDqGNNETZPW37q9yFfUmWi/QXQxiEVyE6gL/Ew/L9PRxMSTv33ABPUAgJkqS2qdOzTY
	B3KcKhy7dzSydRWcEEKFticKjBxN6tu2mXUGLrGsvzr+XKOlaoZBtqUuR6l1Se8lHXzzN5kQpG6
	4PzltjvKJQqD3hjZir4f7iIn611ch43yXWGt0kZZPEwotspeHFeRR4gQ
X-Google-Smtp-Source: AGHT+IEdCKNO0ZcWkzIaQiIpOKdDZK7O2Cj7wxPFCz9HSy4eQm4LOkkE1oX7lQavab6pwYT7jtvesA==
X-Received: by 2002:a17:902:ec92:b0:216:527b:5413 with SMTP id d9443c01a7336-21c3556cf70mr633230675ad.26.1738046696152;
        Mon, 27 Jan 2025 22:44:56 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da41415desm73556355ad.143.2025.01.27.22.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 22:44:55 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcfLB-0000000BTxH-2Z6P;
	Tue, 28 Jan 2025 17:44:53 +1100
Date: Tue, 28 Jan 2025 17:44:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, "Lai, Yi" <yi1.lai@linux.intel.com>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: remove xfs_buf_cache.bc_lock
Message-ID: <Z5h85RIRAjXQizLz@dread.disaster.area>
References: <20250128052315.663868-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128052315.663868-1-hch@lst.de>

On Tue, Jan 28, 2025 at 06:22:58AM +0100, Christoph Hellwig wrote:
> xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
> the hashtable.  But as the rhashtable code already uses fine grained
> internal locking for inserts and removals the extra protection isn't
> actually required.
> 
> It also happens to fix a lock order inversion vs b_lock added by the
> recent lookup race fix.
> 
> Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changes since v1:
>  - document the initial buffer state vs lockless lookups

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
