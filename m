Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A24CB8AC
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281853; cv=none; b=Hn8lnrvjfRj6XpbU+co8eI5FDhuQ4AusuXqPsxRYCJthGwBwhsn3S/nbi1PhikHYnRN6drlNrxVyqjzQZFXWs07q0usv6h7LpxzAFUJaJ+GMZlQquL7nGcBffJO4hNj8J3pVmukneMcpKjkDmzKsUQYYchpOUHQllEWlx85DuEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281853; c=relaxed/simple;
	bh=P5Ft9dr+LBOSEEDPSbCudgRMxke72Gt5Qr6Xn7/TvZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXR6gJOiuh1L7NIfw+rcMV9SDqZ6KQvHmCFzqduoBadwKhotAwOBWTWqVF8+zmPV2uEAu2aOeq0wS67f78ahMAniUPkFiO1iLSCSUGMh/5cXKO8wNjuMQMcPgkaZ9G6CmkC5qmh6AhEugIejGPUv+moDFZ97K357i3XEXS7D4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RTSIFR2l; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RTSIFR2l"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d8239so1883945e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 13:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790281846; x=1790886646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b3c90xok/6YjBzo9H+uGtCHNhEBukv6txB+RoRb7X78=;
        b=RTSIFR2lvUk3esGyEIqohsSLFAIJ0oyPvX/MvoTKst+zc/GxI6DmO6yxeiHiCpx6kO
         HiUFqFxo9SwNMEvw+4TNeQ0mTlXzEAIDT3LGSMBD//O7UCtWuazV+Z9fvirtePVnD1Zv
         fI1Mxq33mcwq5e5KjvNDuJkAUXHPUevXIpKLVmaMET4VoTWuenvoi872Z9Vl+h7dy96q
         VYeOhz6w1cIINBnCeAQq8SjedoI/oNApn73oTR/Yc7XD1Artk+VtomAH3dcwSUuGIxlY
         sF3zvAWRkwJ7GgtkZ844JjR0hl23A60zTuGfCHT6h1gbyDsEyfZzC9o2kGAWoAyayjyn
         AVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790281846; x=1790886646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b3c90xok/6YjBzo9H+uGtCHNhEBukv6txB+RoRb7X78=;
        b=wYDFgz5X43vzhAi+iUZu1sp+43WJdo4sdQqX65mTakU27vBTzMCE3ySTV8Bm61eWqS
         TTURMDE5OFd3pF1pIMVakEo2NT+CzWukyEf4v5w8tPaN7EB1A2T6UtT7pw2SwG5gdueW
         MsdczdUooobHg9aWta3SLi1/KlE8QbZgH/JYerdkMx37dP7MGF88UrhwstMkXKVK0+KR
         2EjjaWRRIx9jOb57xChQkq7Jtqaw3kAnFiXCZ+Wqx9uSSyEJ3+Ebsz8v2yoh39jE1bQ/
         dr/VVWQgg3YiZGEa3k1PcWfSVzhLffqglkmB1t/7TdDVmSBSvbBBJLnA6GJVnu5X/mFo
         XVag==
X-Forwarded-Encrypted: i=1; AKwUvBxp1kJbz2NqLvoH2tkerAYbNN94Z5tTEnsnzbQMdHg4XE3g/G6ACYZLSXbHoDWHAEySMZRcZK7HOT0=@vger.kernel.org
X-Gm-Message-State: AFuF++kTM/NPW68fsK3p8Lke4D5Er5yY4H1sN2/0ytpDWL3b8UUb5IxJ
	SLHsM4Xb7GTefmO8j2mHHRegqaRyunncePDRNPFTRsDUaj0ueF7vXouu
X-Gm-Gg: AYBFou04/kYwgZJ/sILA7MBHXQ+tQu6ilUlaipFLVst6d9cStEVIiwlCdhyi1K0/AUM
	g733fcX4yFLLX92Ysyb9A8jMffTKAzZvrlw7a0rflnq8M/8jenKw2WUMj9GkhGJZXSZmbMZMMPN
	U4lp4aNf+ItOpTEOQ/+DOqWzb9GYF3m/Y3vcrho3RcbYth2T7Lz/8a3L/7SbVqPD0TNPD5WiLOD
	GIRSYV8pLYJ0+cYRfzMK93u2/6yIBtRKYd6Cuoq/OVGw5K4Mq3Lx2TO6j9/1J/r97ZZKFHjUh7Q
	IfVrPVkE/KeOJQQHs8EnOlRIDQuJPW0IjMzz40JznfBzSrfVHDE0SHaBcRdT48YuH82TfGq8Few
	tQWIsOw+mC6pqR6hRaq0lHrRJdGSIQffYfkfTw0tuZDLEhq7vN54ghZTJ65fPDjD5Fz+vuXcrzF
	U0Jh/qkJDmdQo2FfSt1dnLHuT1Hf0q1mu24eD96Rig8MPgm7T3wmdmE3LHHEod0CQLbbDkFJTgW
	xuXQ6xNSIAsi4yNDK3oqFKQqGkgozwuZpZkfSgm+4It
X-Received: by 2002:a05:600c:8718:b0:49c:fa21:1c84 with SMTP id 5b1f17b1804b1-49fe7bba7e7mr53535645e9.25.1790281846574;
        Thu, 24 Sep 2026 13:30:46 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30c43asm1720776f8f.3.2026.09.24.13.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 13:30:46 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] iomap: don't lose a failed direct I/O bio's error when zeroing the tail
Date: Thu, 24 Sep 2026 22:30:08 +0200
Message-ID: <20260924203013.9967-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924185317.GK2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com> <20260924091203.198225-5-parri.andrea@gmail.com> <20260924185317.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 24, 2026 at 11:53:17AM -0700, Darrick J. Wong wrote:
> > Cc: stable@vger.kernel.org
> 
> Cc: <stable@vger.kernel.org> # v6.12

Fixed for v3.

> > @@ -582,8 +578,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
> >  		/* zero out from the end of the write to the end of the block */
> >  		pad = pos & (fs_block_size - 1);
> >  		if (pad)
> > -			ret = iomap_dio_zero(iter, dio, pos,
> > -					     fs_block_size - pad);
> > +			iomap_dio_zero(iter, dio, pos, fs_block_size - pad);
> 
> I think this is the original cause of the bug, right?  We might have
> already had a nonzero ret, and the assignment here blows that away.
> Right?

Right.  When iomap_dio_bio_iter_one() fails we break out of the loop
with ret < 0 and fall through to the tail zeroing, and this assignment
replaced that error with iomap_dio_zero()'s 0.

> If the answer to that is yes, then
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks, picked up for v3.

> (I should probably whine about how changing the function signature of
> iomap_dio_zero should be a separate patch to make it more obvious what's
> the actual fix...)

Fair point.  FWIW, before 10553a91652d iomap_dio_zero() returned void
and neither call site touched ret; that commit made it return int and
added both "ret = iomap_dio_zero(...)" assignments.  So the signature
change here is really undoing the part of 10553a91652d that introduced
the bug, and keeping it in one patch makes the stable backport
self-contained.  If you'd still prefer a one-line fix followed by the
void conversion, I'm happy to split it.

Thanks!
  Andrea
