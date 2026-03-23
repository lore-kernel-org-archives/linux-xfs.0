Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26D93845BA
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 08:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774256228; cv=pass; b=FFPfJMC8h6hNHUkMIGkn76m748cGvCRwt5MPINPRbP2INuo9ZPgGwQulNsp70cXW2vBMj2DMVqVhIB+/BvWeIc5UPl9HubTeqjy2FKd3lDMayxcRFvWvVjqoLRWoyGajUDGswUTzikYcrqlH04YYAmVsjd0FuLDVleLJWD3apZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774256228; c=relaxed/simple;
	bh=XLyjnd2WYZDeyQZGlIphSN6mQM6WrPnayPNJNpxRh7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zf81DN7LnLurqI61xrBwPswgSpUhKDRc8kkZDx37jYGc5oFmYMDGuJIvcFEqYHqaIfLo5W9HgWm9mvv7mlYUwKCb4XMbYxs+Dw7eyDDGC9fcUkskbfnz0DIo24Prfsjf1RP7/sI9PVYbM1NTtqNx5Rxkl8BWr3ayfbsYiz9KZ6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aLFl8bqt; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLFl8bqt"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c741692db4cso865595a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 01:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774256227; cv=none;
        d=google.com; s=arc-20240605;
        b=STGJVZPZyUMurwFbu0Npv72Rub5XZ/+QQCDub8dX03OzQKrTJ3eljEKFOIMmvQ9TdC
         SgkmfIMD8Ewt6bcOzhMoeReOj9vcfuCEXKrNwt3+cXM7rhzLFU04B+oO7bSAIetiO5Gy
         5KpRCImeA2EJxjVspCMCqAPY765THv/VYjjUoi/EagkVyMamsyMyh+jEYUgNfnwBGNCs
         sNIG7F2iPU+8BCSuEKb8Xp/pDfa/aEPMQqhSfvXMqsHiZmhYeQmfNQgBl/4TEJDkqGk4
         5kJAUAkbOLE5Oi0PJOq9hQFGXBChdCgwTYeHWoxJFSo05h1B3jqIhnuNfS8rPIFb68L+
         UA/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLyjnd2WYZDeyQZGlIphSN6mQM6WrPnayPNJNpxRh7U=;
        fh=i1ujDwumz+j8wwpXZs/beqGHOk+dzi6JNwFVvsletek=;
        b=hMm/b8EB4K1hQSbvehLBrD+mE6FdBE6I6m1Oun/chebP9N+ZEs58hXxNg5lsaPRAYA
         3AaoRO+TcWj4Ua928j1OK+4ljxrOM91dtF7nUgrUD9SK1/ut2x5wQNeowiDsyivzDDfx
         yJ+knCD8KN6xtKvZ4WZ9BM/5LPeES3uN05PFfvODBVv+755cJOLIA9k0fGmZtWqMVjha
         eEO4nBr4aonCOYXIF1fk/NPp0Id6K+RByC3wlBwlz4s0iFhAWPsytUaR/dKEcM3Crfwd
         V8sN9vwT0lrKe9XAQpR02wHqn2s8pWTfOGK1aEouCb3jJg9H0B5piDPZmcSptD3n/Ygy
         gt7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774256227; x=1774861027; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLyjnd2WYZDeyQZGlIphSN6mQM6WrPnayPNJNpxRh7U=;
        b=aLFl8bqtZl3+G1h+fxdih8pNDI1ufY7aiU3cGvOdtpeq0P/2cN5p4eLHX45lgOLkYm
         5Fy9e4ZJK5fhMFIfcxcXyrbWdwJViWndirmBz8fykY6q9CjHWXEhoYUYwl1DJ40UmJLN
         QeG+UmjbTcHGN8NMd614B5QI7By0lxTFC6EBJYMQcXodCW1gZlQmHKi00mgLZR3MoQUL
         ybdHSg2hdRQ8Ip3IA+CKyA7Or56cIhWdm8ZP2HCeaPM5GmZ68J9iRDU7Te1mOpZZ1fmc
         FwppTiGm0lzMuDTL/47/Y63oAYoicU/oR6pJcqrln3pTZA4BDO5GFbbErWZZNwTYRfSy
         VioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774256227; x=1774861027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XLyjnd2WYZDeyQZGlIphSN6mQM6WrPnayPNJNpxRh7U=;
        b=EXNAQMYwI7uzIusOd1BD3BvrKGSv7iabnAp8e9LriVoqWbvfBdZruiKK2g7F6z3aho
         KsLc2XDW8N5eITb4d3jButzZbdRHv31WfkDwZf9qhiTneKDDVjgPsVlwmwbueqolZnLL
         0JbwMHMzeuVLchkQHmI2bGsP1iad4AB/3oi/Wm9o2zSii6+DeoRQoIlwlttDfYuQDLHp
         DtkiHM5+XpHe/PeQiVTm6mBuo1ggaSHvrBgqs0SZi88cDhtF3i8fsVZPqFKZixOFFCOK
         hKr19y0ZC6+WL9nxZdNtQnnYrhYY0R3iMhtc6BxxpFL8+E+y5i7N3xvBaSdEjY3JuGRr
         pkLw==
X-Gm-Message-State: AOJu0YxZGITCT33dJZ3XrCYL61kTd0NFdpyjLuTIfEFA8cjk9nXN6+j9
	kvf/5yMXLX76WH0jZZMwtkhFXoNT3rJ7Yl/rEv/xM+f/HSQDTf+swOPBBY3w/aRK3KwATplFPmh
	Pp9gOfUO+xEwOGyMDyFcqNh1YiCbFJ/I5oQ==
X-Gm-Gg: ATEYQzySTi38IODS9qXgFu2Vzyz+RVZp8wceBsxBUlE8pamaeuSU14us06J286HEgz3
	jfkNon/Am/+k2BwJXVZ8antSLef1xb1HGxIrUVmTD83xWc0giMjthSxoZAFS5dWAq1Ob7Ub2b/L
	VLBgQn8ktDziN5Kgc/jgRxj9rcbm/rkW476s2hffJ6Xq3CEpZ0apG+sRWjw1QIlDKKbSAP11O+q
	+dyqO5I3wuoPy4VeDLVu5dokAIiNyCSJydGECK3IBDMROelf3Ffhi3mWWWrnrz4+UPIaWQam3C8
	5fugLWIqH8zDkYUqBobfchBQcCO6Swbq/OYHND0=
X-Received: by 2002:a05:6a20:12c5:b0:39b:e44e:d4b7 with SMTP id
 adf61e73a8af0-39be44ed8dfmr7005287637.23.1774256227019; Mon, 23 Mar 2026
 01:57:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHzMYBQ8NiXOTpKn5cBtSmb5ObMNdqhnXjbiZxi7wTdd=aA3WQ@mail.gmail.com>
 <acDZXyVJiEzlkEUm@infradead.org>
In-Reply-To: <acDZXyVJiEzlkEUm@infradead.org>
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Mon, 23 Mar 2026 08:56:55 +0000
X-Gm-Features: AaiRm50DuSqh63GuQxT7vS5BWyYavRF9oK2MgsjQVtoNXHjUnWKB3KMBn8gGJMg
Message-ID: <CAHzMYBTT5Ky6wZ-2MQUJqVeMEcoMwbY7Ai95NF9BhVmZJ+0Z5A@mail.gmail.com>
Subject: Re: OK to use XFS with a 4K sector size with a 512n device
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for confirming.

Jorge

On Mon, Mar 23, 2026 at 6:10=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Sat, Mar 21, 2026 at 10:29:56AM +0000, Jorge Bastos wrote:
> > Are there any known or expected issues, if I were to use XFS with a 4K
> > sector size with a drive that is 512B native other than possibly some
> > wasted space and write amplification?
> >
> > Mostly interested regarding any possible data integrity issues,
> >
> > This would be caused by using an intermediate block device that always
> > reports any device as (logical/physical): 512 bytes / 4096 bytes, and
> > this results in XFS using a 4K sector size when creating the
> > filesystem.
>
> Yes, this is fine.
