Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F061E0E10;
	Fri,  8 Nov 2024 09:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731058354; cv=none; b=A1i8RaWrhvQXQw6so/cm/iojvknM6KrO40MdSI3IN1A+8MOE3eAcBCxPeXhi8wJAMiodcz2XaiKTRmT2XNmmmeSIB4ae+41PEPEGLZFBGYH26iQFcraH/ZKuY2/YurVExFbVfaBkICaxud5xC0xTw+0SA7wvQaEDBoNz22ZUb/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731058354; c=relaxed/simple;
	bh=5JT9q3gpAwQF2par5+uW69x86vRizd5yo+7cvjN3Xtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjWKwzxM79Fz+0zOT9Xm5TaVb0UUnK2vD54Gw3/okRFujwav+EqBdvcbqxigb0v+gI6ExJ/hRtaMQKEBWuncDRUT8EiQZ2zhmWU23ep+oWJ65YmCBx4KvqK+A/sPlWdMqcsijwrnU6tgk8DG8Nj6HHg4d+cRwVgnZAMNADo8BOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0STvhU/; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0STvhU/"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20e576dbc42so21181275ad.0;
        Fri, 08 Nov 2024 01:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731058352; x=1731663152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w9Hr5K97dzEp00J83GyyZnUGXFd6uzRJ3erdQ6iKcfc=;
        b=T0STvhU/15ksFfbpMgMWnYdk4fNMtA4lfeEytg3o8tdI3c7R554Nq6fGlP/lQEv4HK
         c8fF0pf6ffPFNSK8Dh9pBaD8anRR6JtJZzAxzr92/WRCFge12WUSNxKnnmwdSne9HYhh
         G9x9PsIlIKsO79IBteTb6zEsZPJLMQ5CJzscbTegoPQN8IEyWAVesNLnDQBzILvORjt0
         Fo5oqL9zQzoaO5C3YTkndLNKZwOMe7JwF9YDr8mjCtr5fk5Nb89NOTDXj/sQr6f9Ravp
         Gqgyun71TemPeuNOvTRoPCpuL8f0BbDzwfcaeBNRk2oEisZJrKi8V+CzwzZ7dUKtNN8d
         jnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731058352; x=1731663152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w9Hr5K97dzEp00J83GyyZnUGXFd6uzRJ3erdQ6iKcfc=;
        b=j2VM1gWv1aSyvqZ3hhCZhLDw0iy9ftKSbm1map85uZH5Rq12X8HeEU073Snen0coot
         HJniqcb3v9ehd3BCwpHgxirorkbhxX7ewtQJC703koz/wQO4u42ei0TEXHfycXe9dzn7
         8jqDKmY8rKvIuif2MnmtZgFVZskilGd20AswLm4Tf7Ofql4GVC31EA/vHajxbmnoH+RS
         GJ7XbX5xJTLxALrt+9xkjhr3I+YgqZkThHBF/PHmnw9+AOnmU5ERYOiar0VKUhoVm3hj
         n75vySmf/Yh0vnA04YNHCnG47VitwQvSU81Yz31a0kOijodmFJcn8pB3wyepI7dmi0a6
         fnlA==
X-Forwarded-Encrypted: i=1; AJvYcCWY4nqTsBqerAQfPA5AkkDJYMq33Q0aTfe9VQEatarskv9PXZ5aa1ZKpXs4ur4PNpDsta4sjaueGNKd@vger.kernel.org, AJvYcCXWP4OKg9b4p+GM8waVbJd/jwkac/hYWK2Q7/AW5YrlAyPHmZxeBsO/m/Ss8Eif5LvYOQ0mQ/HpnUxpMVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNwa8Sd1AULH0tldCD3ndmpc5g9nLVjLCZ/bq40F717+CC7Hok
	wmnRYFwFcileId8Sjj0jIN9WdM4ajEfnKn2FzsCWr588zEatqAl8
X-Google-Smtp-Source: AGHT+IFbEmvJJt+qwRNTmhZayKDQTUZX9faEC2skPvQ3lg8UrVWHPGKH7yXifF+492qlWgEO04A+cA==
X-Received: by 2002:a17:903:2ace:b0:211:31ac:89e0 with SMTP id d9443c01a7336-211834dfd86mr28300405ad.4.1731058351879;
        Fri, 08 Nov 2024 01:32:31 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e58117sm26230485ad.172.2024.11.08.01.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 01:32:31 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: djwong@kernel.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	cem@kernel.org,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: check the remaining length of extent after roundup
Date: Fri,  8 Nov 2024 17:32:28 +0800
Message-ID: <20241108093228.1151891-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20241107200539.GR2386201@frogsfrogsfrogs>
References: <20241107200539.GR2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 7 Nov 2024 12:05:39 -0800, Darrick J. Wong wrote:
> On Thu, Nov 07, 2024 at 04:40:44PM +0800, Jinliang Zheng wrote:
> > In xfs_alloc_compute_diff(), ensure that the remaining length of extent
> > still meets the wantlen requirements after newbno1 is rounded.
> 
> What problem are you observing?
> 
> --D

Thank you for your reply. :)

In fact, I haven't encountered any issues with this in production.

My starting point is I was wondering what will happen if
xfs_alloc_compute_diff()'s changes to bnew cause the extent's remaining
length to be less than args->len?

I wonder if this will happen? Am I missing some code to ensure this doesn't
happen?

If it will happen, I think we'd better check it out here; if it doesn't,
please ignore this patch.

Thank you again.
Jinliang Zheng :)

> 
> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> > Changelog:
> > 
> > V2: Fix the error logic
> > 
> > V1: https://lore.kernel.org/linux-xfs/20241107070300.13535-1-alexjlzheng@tencent.com/#R
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 22bdbb3e9980..1d4cc75b7318 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -393,7 +393,8 @@ xfs_alloc_compute_diff(
> >  	 * grows in the short term.
> >  	 */
> >  	if (freebno >= wantbno || (userdata && freeend < wantend)) {
> > -		if ((newbno1 = roundup(freebno, alignment)) >= freeend)
> > +		newbno1 = roundup(freebno, alignment);
> > +		if (newbno1 >= freeend || newbno1 > freeend - wantlen)
> >  			newbno1 = NULLAGBLOCK;
> >  	} else if (freeend >= wantend && alignment > 1) {
> >  		newbno1 = roundup(wantbno, alignment);
> > @@ -414,6 +415,8 @@ xfs_alloc_compute_diff(
> >  				newbno1 = newbno2;
> >  		} else if (newbno2 != NULLAGBLOCK)
> >  			newbno1 = newbno2;
> > +		if (newbno1 > freeend - wantlen)
> > +			newbno1 = NULLAGBLOCK;
> >  	} else if (freeend >= wantend) {
> >  		newbno1 = wantbno;
> >  	} else if (alignment > 1) {
> > -- 
> > 2.41.1
> > 
> > 
