Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB12628D
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779194932; cv=none; b=uf5APe1AJMJACusW3SigbDs8JSIM3r7WL08yx6h9FpeVfD8MJxNUYM/M8HbNbIbBvCvDQI3t57gUcxoCXa2X7E0YqXe42BTREWAavRmLz/B6DQQ3pZEnYA1u0vJ4BMdD1+8sjwoE7Chgj3IodWZWYHsJVr9eV34BuagRvPeo6l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779194932; c=relaxed/simple;
	bh=y0Lhp5/BCsgbf8DQ3cQRLuZnzrjLo/N1F265iVj1gTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+5vh7wcqORT5Kp8xKseKvy/yJcx1lLt5xf9BEvw0Se7TvOK8j2jXuKnf+sne+SMjYrabo+9aqRTIlwU9dwJ1tHqxh9wM1IjAO6eXM1wbll5hB4OxoGQczNBWCLa1ikB/CvziMbqsQlNUZXDGWJHhfA8IUa1jbO56OWNlvuBrxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ0c016B; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ0c016B"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8bb09239328so29330466d6.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 05:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779194930; x=1779799730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mayj3mKodS45dh24BWdqAhTjWaDxUFyowh6qUvPhU9s=;
        b=lQ0c016B/hrRD7NA3M47SCqNaYh7QlZGZ1QJApAK7VZsjo6kbTC0T2yR2LoJ5FqWbH
         HHP4SjBliVeFZnj5PyJR+a5pLqcA3vf7aoccNfPFKpeo9Be1wr5bYRPc7H/5BuHGDy2E
         7KfpAG8gZ/B2ebdi1r7l9FPBcSSg1iNmZoatwW38nfSnl0XjUKdUFdWDQP41uUvMqV+b
         3dQ8GLt50V613VnBBXCdEr9sGaSQtUfu4jmxdZpp68bfj7zXwg+GmbAlcd+B8ojPkOSU
         NxwB1qgYGI/uFePwwax2pQikAqlpz7Qv6boPJAL2Yd4FP2uHqQNBh28Vo/O0scInAxUQ
         /++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779194930; x=1779799730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mayj3mKodS45dh24BWdqAhTjWaDxUFyowh6qUvPhU9s=;
        b=sfqDp2kSKdrNR8H+6erB37QMbLwOtzdY7lYcptsm9ypfuwySq1fgksyIiTB7PODBaW
         lebluEeZkSjf/HDCsUNb1E44N1HIOhRE4XAzVVj1JyziS+UkDJ/iUH2KpvOacKoKezfO
         uhYNp7XZQMESTquxhNOdGfgPliSRQPzygJBIjCjZPeARGnJWqgA95/oSOmPtx2iLQ894
         v9vbK5N+JRRKjt2bVyUURfKMSwBpl3mli5054VrvBfWPoQxdVMUGNVVMecR+1E6zXOq+
         lGRbdavsfOaqAufhLf9CIT3PMx4QBS4TE7H/OoX9M5ffYNWk7JJJK3y+L2UrHJfnoHF9
         pNJA==
X-Forwarded-Encrypted: i=1; AFNElJ8H3Fa72IblCjcqmyjw7xmXJeFgg/8YiZcRZCqIiHaxGADok6abyDT4R37fV7FABziV/oxrRz/s3ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdGUO1j/a29zN1qNMBuDFvJgRVsCaeUxeaqk5SLVQ8BscaRON2
	3+fqVF4fQyohKgo2Lt3axQlT4mG7DYv4uYlLRd25/uuwWH46nyIMq7rp
X-Gm-Gg: Acq92OGFfXDDJOJIyHkqN54X4b3R53JbyKmribR2+QvSX349MdU9o4w1CswVNFY3TgP
	6WwYdGd7ZKAY78LcQxinNbGqDKYZ61ToloVW1n/rpD8X27qyxycJfyaCvCgoV3kWPBIker8uupY
	etHv7hj/7ib6jIxV/mMbvIm1eA6U4Q3sAY6NJYdqPycuhG3XidoZqITER/h3Z6o7sv47bA9L4JU
	Mhhm1rCU7+KWSpvuR2ZSemcEi3X7kxt7dWmPIA4mxI7AdPH1vFLQf0DVyE2mroB6TOkiFXulv3q
	EsN8+CScQgoXybS+yD6Ie0nQ67jOtmBbJU4e7G4NpE+AQ8PxxBn9hDDGCmBoHwnQGztzKaQmW7V
	MQ8dbMY2+szC+5GF51AyzEY7iqOqE7ZpBNZ5hEKhxkGrrlTm7PckL8itJj+bL301ARRJ7nouBzH
	yDJF/7A9gBVZdQGPSkfYM6+cvrGW7Tz/CmmBC8xjhWMJoASiWvsLhuNHyuUDChWpiIxMFS7OC7S
	ZIRVrUw3x71uTAxSl4oEaKDFFFerIc=
X-Received: by 2002:a05:6214:428d:b0:89c:4ea7:a70f with SMTP id 6a1803df08f44-8ca0f6353cdmr280438626d6.14.1779194930452;
        Tue, 19 May 2026 05:48:50 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca361905d4sm88391606d6.32.2026.05.19.05.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 05:48:49 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: detect cycles in recovered unlinked inode lists
Date: Tue, 19 May 2026 08:48:33 -0400
Message-ID: <20260519124833.2020871-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <agwfrZAchLLFX7c7@infradead.org>
References: <20260518013143.1532327-1-michael.bommarito@gmail.com> <20260519050235.GI9568@frogsfrogsfrogs> <agwfrZAchLLFX7c7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Christoph,

This research agenda and patch comes from a hardening project
focused on automount filesystems in major modern distros.
Maybe the USB stick threat model isn't worth the patch for
just DoS impact, but that's at least why I thought it worth
submitting in the first place.

I looked more closely at current xfsprogs for-next
to answer Darrick's repair question.  Plain xfs_repair refuses
the reproducer because the log is dirty and needs replay; that
replay is the mount-time path that hangs on the vulnerable kernel.

xfs_repair -n diagnoses the AGI unlinked bucket and inode
next_unlinked damage, and xfs_repair -L clears the bucket /
next_unlinked state and repairs the image, with the usual log-loss
caveat.

I also found a narrower userspace diagnostic issue: xfs_db
dump_iunlinked follows di_next_unlinked until NULLAGINO and will
spin on the same self-cycle.  xfs_repair itself does not appear to
use that unbounded walker in the tested repair path, and xfs_scrub
userspace is mostly driving the kernel scrub ioctls.

To be fully safe from automount attacks, I think both sides would
need to be addressed.

Your bigger point about regressions and test coverage is still
valid though.  FWIW, I have been talking with some other fs
maintainers about adding test/ fuzzing coverage either in-tree
or external.  I would be happy to help with add XFS coverage
as part of that project, although I'd defer to your preference
about where those tests should actually live.

All that said, just let me know if you still want a v2 based
on the threat model.

Thanks,
Mike
