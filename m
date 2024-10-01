Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2CB1CB539
	for <linux-xfs@vger.kernel.org>; Tue,  1 Oct 2024 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727799468; cv=none; b=Ax1XeDaBXDK5mkrSiQFmupr3s1vCBElDUmfYPAWVvdx/fFLOXUty52147hWIjnGhazF9sVZ156I+BoczbtB/sAxQh+e9mlSsdsD3ldu+JG35jKwhDX5F89+epMuuNxsqWztVjkTSIs9tYn46RXfmaKUY+hMSfq0lMuvd5qC9npc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727799468; c=relaxed/simple;
	bh=nvUOMkUhAIlhTvp2v7jF7CiybAc7a4O7z3ckYf3J0cE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WJna9yhyfxa4GKBgcrzQuPCrl7IrGf59nuIO7gMZ8ONVJUtIhE/+8Hbn0/+uUjgaViH0LW9A6vBEsqMYy3g0i0nEFWgBIpO1hvyQOfNm4u1sH+/iRX6UEC7YTVQmUAA+QXVwCH49IHBytf8buvmRDiGChnm59Yxr3kKA9gavsWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n6M89iS2; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n6M89iS2"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a90188ae58eso730049866b.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 09:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727799464; x=1728404264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1gtQcrWNpd5RcxSJdvlyP5hnxs6NY26BZrJEREQ6SI=;
        b=n6M89iS2RniF2RYZSWZ4sNnyvw19kd8737yL+vkFqxGdtXv65HFs2ne4xHZd6EiYt2
         haa2Fv20tWSAxqboq9E7vJL2wubXsiT+lOrWuEc61seBF8uBVNv+If5X7cBvx8Uzqe8z
         So0UkNfksKxLK+1R2NXRpJppJ41dikYYlsWT2AnaCo0t75hDiJs6/Mbl7onU80uBBL9a
         79OzYZaFjq5IoE2dD50Prd48wqdBsK7676+GnLr7ahyqqeQ9bj8O46u3aGZ+1wq3leoG
         4M2EvP8M6YPxpjsCchzrzGIvbgE1CwnGeCGykgQxL1138DSMhM6PuG1Yxrzm0+pND/jW
         FAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727799464; x=1728404264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1gtQcrWNpd5RcxSJdvlyP5hnxs6NY26BZrJEREQ6SI=;
        b=re5CXxXlhTc3R95nvbYPY7fQwXWTcrnXpKoPro8hhJxTQt6V2m0Y3Jt8WV262oC+Lf
         i/gv79BBYn4DEx7ReadIujgkpvuvmVLBM6F7FRzws1+Szgnp57bjaS6474iOnsDgsBEk
         7S8yrQ5hEkfJXo+wODGfXyDhqmUXLd1/Dnda0mWOCyrn2cUGF3x79vDyuTpLp3MR/z8F
         TMrTwK30dI8ec3OFLpfBNLa/1S96ROXW0b7WflSthSP1QJDg32g1wam9l0avaRY0VRoE
         gQr2LRWqGslZpT5vzqSxannkJ9oSJ0XsMVbMGrnyBlJxhZx5QIbogbfC1QiSmbN2bDO2
         L6gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLtIKTKJASCO2C9+979I5mDtWaavXS7PpJlFiAXFdRiCuqjk+0bj8mXDXObqW6+upksFKHqWxIRpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhiMUUKRpdnW5hRM3t7gfUsGU2yQUHNOv/NgMtjcxJzlKAn5B2
	TKHKWVFjl9jm8tHO714Lv+ZrsOxRHLuguNj80Vtp2nGsd1fLDzFnnc7OMcazOPWsLkkc49MkXl9
	rXGqzidWjGLfTnu9VX9WJtV3GmjH7XuUZU6s=
X-Google-Smtp-Source: AGHT+IEb55N3RbLLnNditOaIXzMGvdtfhXP4P7OFauiPnc3PqRDlMwtWq4LEIawZw0mkwT8uv4u9xKZ9+AFgQWhXcHQ=
X-Received: by 2002:a17:907:3f97:b0:a86:b923:4a04 with SMTP id
 a640c23a62f3a-a98f834d078mr13740866b.50.1727799463691; Tue, 01 Oct 2024
 09:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241001-mgtime-v8-0-903343d91bc3@kernel.org> <20241001-mgtime-v8-1-903343d91bc3@kernel.org>
In-Reply-To: <20241001-mgtime-v8-1-903343d91bc3@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 1 Oct 2024 09:17:31 -0700
Message-ID: <CANDhNCrKFvUYchQ8UStxUEpBmFpN4ZeP4W4DdwJ5WxZ5EbqjMw@mail.gmail.com>
Subject: Re: [PATCH v8 01/12] timekeeping: add interfaces for handling
 timestamps with a floor value
To: Jeff Layton <jlayton@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Chandan Babu R <chandan.babu@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 1, 2024 at 3:59=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> Multigrain timestamps allow the kernel to use fine-grained timestamps
> when an inode's attributes is being actively observed via ->getattr().
> With this support, it's possible for a file to get a fine-grained
> timestamp, and another modified after it to get a coarse-grained stamp
> that is earlier than the fine-grained time.  If this happens then the
> files can appear to have been modified in reverse order, which breaks
> VFS ordering guarantees.
>
> To prevent this, maintain a floor value for multigrain timestamps.
> Whenever a fine-grained timestamp is handed out, record it, and when
> coarse-grained stamps are handed out, ensure they are not earlier than
> that value. If the coarse-grained timestamp is earlier than the
> fine-grained floor, return the floor value instead.
>
> Add a static singleton atomic64_t into timekeeper.c that we can use to
> keep track of the latest fine-grained time ever handed out. This is
> tracked as a monotonic ktime_t value to ensure that it isn't affected by
> clock jumps. Because it is updated at different times than the rest of
> the timekeeper object, the floor value is managed independently of the
> timekeeper via a cmpxchg() operation, and sits on its own cacheline.
>
> This patch also adds two new public interfaces:
>
> - ktime_get_coarse_real_ts64_mg() fills a timespec64 with the later of th=
e
>   coarse-grained clock and the floor time
>
> - ktime_get_real_ts64_mg() gets the fine-grained clock value, and tries
>   to swap it into the floor. A timespec64 is filled with the result.
>
> Since the floor is global, take care to avoid updating it unless it's
> absolutely necessary. If we do the cmpxchg and find that the value has
> been updated since we fetched it, then we discard the fine-grained time
> that was fetched in favor of the recent update.
>
> Note that the VFS ordering guarantees assume that the realtime clock
> does not experience a backward jump. POSIX requires that we stamp files
> using realtime clock values, so if a backward clock jump occurs, then
> files can appear to have been modified in reverse order.
>
> Tested-by: Randy Dunlap <rdunlap@infradead.org> # documentation bits
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: John Stultz <jstultz@google.com>
