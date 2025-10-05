Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CEB39ACF
	for <linux-xfs@vger.kernel.org>; Sun,  5 Oct 2025 23:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759707506; cv=none; b=sSURAj25z/nv3vO0pxFK6b6Y5WjZY/rxkUuZX0uFixlthmr8Mou3Z/v1qn0oC73mfZf67+PrHVkAcsyqlT4P6ndXAh7bA+QImoQOUtSdegXwBW+scbPWyiVUJyd2IMQMdBSmMCk0fWXJaRz0AezgY7cwBWX3wGbbWbblx1SxHqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759707506; c=relaxed/simple;
	bh=ZeL8g3+NIGghkoED2HmChwuHilgupZ9KQh+zbVphGW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fiCUHThzxYzQIH9UWuUxqqLeqcBj+6CUPSE8tD9mk/uCJ9iPAQFYnZGdHHLqy41vn/YjUhuhvW4dOc7QQUGU+inqxRj8JjcNLTpFGGbj1wUwsQgaTsDLgQp4+xpTr/QjSRdlUL2HG8hJnKBO1xiEE6zyliCFrslg3MeW2YvGJJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=f0YxxFUi; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="f0YxxFUi"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7800ff158d5so3594360b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 05 Oct 2025 16:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1759707504; x=1760312304; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wYZUqfHCkY9qWTGMyfXAR/EXot/02oxeQhh+iKW+hV4=;
        b=f0YxxFUizS+cjK9jC4Js5RK/Xohje1aPyaKmEKmM0Z87/e75/2C4exmGVIbzXACCbT
         GbzOuDsRPmq1w5RL8GcvmIehgtsR12PW61g4mxzrI28atyQSC/+eU2qctJUehTFqL5Eo
         hEfFHtvWk7ORUjMAnJKHZc+Uq9hZJ7OA1pJRqxz5VwGmdp69dhqoXeT9nH7hSe1HxyI5
         G7mi2m+W6WKK+GZk/VXzfUQ0rydyWmiwFLdF0MiHpWP1SH6hA2zldNOCAZccoiJqw143
         LG8nhZG7wVCJjD8h2sHAB2fOvjUGz2lOFaopEFVThHyFRm8AbnJK3P/x8ZK9oEc9BpDD
         I4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759707504; x=1760312304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYZUqfHCkY9qWTGMyfXAR/EXot/02oxeQhh+iKW+hV4=;
        b=ORD6mgrS+c2oW6ylh0oc+nKje/n6HMeSAxddcVV1/a40hmWUCFK5IQXRzQLpmGvvJc
         gwWN7S9aIka3ATQo27TYKErsb9+2EfMMXS2ED7DBlSRwQS1jw+sz2/oTiAYBV749J7Zy
         acoEnTdpR2/hqPmQ/3YbukDjzqCfCkEBp9JcDZbVrrU+Jk3AVEVAi6y8gw7gN1EYLnOs
         WZyBkjODnWGB8Cpw1gJEEWed2mrWPqmEDU9lh8zuNM3v/61hM11RIK/bmoGb99RXfRVr
         or1YRZfUaNcyRENOmNg5e9pSyS1H75hhJATis+VdTxJ2Psp3p3ENyz+4YxMTsDJ51LgL
         Glug==
X-Forwarded-Encrypted: i=1; AJvYcCXNuKFX8lSHUMYUbmmOHb7dqpiUhL1DGyt/A5U2QYyQA0jsSmorOVwnDo3dUvI0MsDeT68Eq0z0CFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfIdU3pGfh/komNAgT3ibvsfMqQj22/xmiCS3Juow64uM3sB9j
	cJ5XY+q1drxXmr2JsrC0TRXHATHoELnctPmPcR5DoBdsotlAtt6x9jiw//3qmp5rErE=
X-Gm-Gg: ASbGncuptuEsr3vSvQvT3HDtGW7j0PdnlR3t0R9BgptjWGjDonC7euOatxTBGYsR8jv
	wWgZxtFFD6YOaLOF3iZXLU/8ZKu3VjIB6C86b9eSXJDcuUltmspKUBFPhMlqu+IbgBtvIeZdfps
	Sj7DRqvd89PIh4RadhT5d7ZIAEBYz+VnMJHWaIHdKXyfQZ0zLmffUKT3f9Q5ys2Ur8ElS5w+YMt
	TJvova10iPSCD/rKBvWn5FtEWlWZ6pPYI9M06eiNd9SAqcIyQ/9/BmwMJouLXRdk6esnygpQSG+
	FfLuaedTgrrd3YVa+kTOyfCcGpppmwu6CUd9S+ZIWZrRhXdkI1eZIBkZv3+Q/RzHpzbO9qt13CR
	3tsyCQC3bKI6rdT3ZzlVYlnDZ+oCuiNlnRJc+DBAdkqt+7RM+spS8sz2F9ZSTyEwhqf8yk9LA5M
	gd1yshod2MQI6xwpLvBnOi5w==
X-Google-Smtp-Source: AGHT+IHsY0pPmwLcFhMINPZMciPWEOHQAe8XZcWIZ+42Ncu6X7pq8uNjulttyDUGl4xm8ixxs91eVA==
X-Received: by 2002:a05:6a00:39a6:b0:77f:11bd:749a with SMTP id d2e1a72fcca58-78c98cb7834mr10735744b3a.20.1759707503195;
        Sun, 05 Oct 2025 16:38:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b020537e0sm10861937b3a.56.2025.10.05.16.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 16:38:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v5YJ2-0000000B2DA-1HKV;
	Mon, 06 Oct 2025 10:38:20 +1100
Date: Mon, 6 Oct 2025 10:38:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Emelyanov <xemul@scylladb.com>, linux-fsdevel@vger.kernel.org,
	"Raphael S . Carvalho" <raphaelsc@scylladb.com>,
	linux-api@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: Propagate FMODE_NOCMTIME flag to user-facing
 O_NOCMTIME
Message-ID: <aOMBbKUlvv2uYLzD@dread.disaster.area>
References: <20251003093213.52624-1-xemul@scylladb.com>
 <aOCiCkFUOBWV_1yY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOCiCkFUOBWV_1yY@infradead.org>

On Fri, Oct 03, 2025 at 09:26:50PM -0700, Christoph Hellwig wrote:
> On Fri, Oct 03, 2025 at 12:32:13PM +0300, Pavel Emelyanov wrote:
> > The FMODE_NOCMTIME flag tells that ctime and mtime stamps are not
> > updated on IO. The flag was introduced long ago by 4d4be482a4 ([XFS]
> > add a FMODE flag to make XFS invisible I/O less hacky. Back then it
> > was suggested that this flag is propagated to a O_NOCMTIME one.
> 
> skipping c/mtime is dangerous.  The XFS handle code allows it to
> support HSM where data is migrated out to tape, and requires
> CAP_SYS_ADMIN.  Allowing it for any file owner would expand the scope
> for too much as now everyone could skip timestamp updates.

We have already provided a safe method for minimising the overhead
of c/mtime updates in the IO path - it's called lazytime.  The
lazytime mount option provides eventual consistency for c/mtime
updates for IO operations instead of immediate consistency.

Timestamps are still updated to have the correct values, but the
latency/performance of the timestamp updates is greatly improved by
holding them purely in memory until some other trigger forces them
to be persisted to disk.

> > It can be used by workloads that want to write a file but don't care
> > much about the preciese timestamp on it and can update it later with
> > utimens() call.
> 
> The workload might not care, the rest of the system does.  ctime can't
> bet set to arbitrary values, so it is important for backups and as
> an audit trail.

Lazytime works for this use case; a call to utimens() will cause a
persistent update of the timestamps. As will any other inode
modification that has persistence requirements (e.g.  block
allocation during IO or other syscalls that modify inode metadata).

> > There's another reason for having this patch. When performing AIO write,
> > the file_modified_flags() function checks whether or not to update inode
> > times. In case update is needed and iocb carries the RWF_NOWAIT flag,
> > the check return EINTR error that quickly propagates into cb completion
> > without doing any IO. This restriction effectively prevents doing AIO
> > writes with nowait flag, as file modifications really imply time update.
> 
> Well, we'll need to look into that, including maybe non-blockin
> timestamp updates.

This came up recently on #xfs w.r.t. lazytime behaviour - we need to
pass the NOWAIT decision semnatics down to the filesystem to allow
lazytime to be truly non-blocking.  At the moment the high level VFS
NOWAIT checks (via inode_needs_update_time()) have no visibility of
this filesystem specific functionality, so even if we can do the
lazy timestamp update without blocking we still give an -EAGAIN if
IOCB_NOWAIT is set.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
