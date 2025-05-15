Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1874B1E64
	for <linux-xfs@vger.kernel.org>; Thu, 15 May 2025 02:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747277795; cv=none; b=ZhWu1TJoSOJQ/4AnqWTiYYFerIMPYpjHBLjEbShrcNccWy7PCwUIDAEoPTik1vcsjPKdbur8N2iyYSJ8mKsexJ9otXgh5xnmrjAmA98KRjoZDJaZg98DmTdslpPgTmQMbgDFFY+dQXn4h7qlyJq39LDkHJFfo+Mqhu7z25U3sLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747277795; c=relaxed/simple;
	bh=8wNEv+HhqeRcE4nl0aWh70pk6+83Q2bb5RF+6eBa+kM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Wnz1fOEXpMlZEs+aHkMBt4d94+LJafnSDnXxnuFe5yikzDQeQZln6Sbg8/UU+/xt1iqXczPUJpTFhr1p0W61b/xbH51ZwHM26c0a7Otwco6oMbnL4ky5xsPk6DLmw2pVokneg+lL0ZHWlag6uu4daPgWZvOAk01huK5rKIWP0sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jjY2ZBAs; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jjY2ZBAs"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so432043b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747277793; x=1747882593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8wNEv+HhqeRcE4nl0aWh70pk6+83Q2bb5RF+6eBa+kM=;
        b=jjY2ZBAsjEqJKuCs5AKC4SzGALfqydFTInkqDKk1XPRum0VKxG8Fg5w2WjFkDAawv4
         4eNxmQfgthibrGG8FWzzxR4ioZHk9qspRvmt1FvHC+y8d5oZCB8Y/c6BrAJWM7W2g4qm
         DZBWvyKoZ/MbMHfIvC5dcOq5O+kjGSfoRvg/sQ4If+BNc8jv+43Pk8+AOVIKtyqxjlUX
         AH+ez3yo6plOBb4QgjGNCkvoIpgt3AwgQ5Jb5Dho52O9TvLAD0vrI8xR/j1R7Z8qLHHf
         FhXNsXIdXyo6RlcXIbLNiZM00/zCASph82P6FtapL4rahDw9lc3HQtynOI5JlQqYJUjA
         ZgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747277793; x=1747882593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wNEv+HhqeRcE4nl0aWh70pk6+83Q2bb5RF+6eBa+kM=;
        b=li9XBosxSSkTVD2osY7CxP8lwllZj3KOwdc6+vazgCYPqH8X25iLZbgdBO0bT/ZTyG
         UTmrNcQs84xxJPVvJnsquzInsm+aSzRWT5HTowtJfqCJuS6oSbFB2JSwPz3kDhBLOgUR
         R6d2fQf1CLNC8CQidK1CSfwwWPpMvs8VuS6EzvBzSFCJcR8JrXIfc9cFYF+2tERWf5rM
         rouAUOl240AbGI/b9shMN8yOyjDBXtTsprhG9H4RjrY/2SfhdrONjp0OLti21uPOH/h4
         69Ufk8Yal/lfkSmDEf9X9ws2xEYQPWl9+u9OV6EHv7QVlIPd/VoNbuobA1HGX8bM/oPJ
         0ukw==
X-Gm-Message-State: AOJu0Yze9yRvjKhdzlS2aL7BhHDgbNrr29xM4r+j7JanOqWKhXbd9cKZ
	8hN+KoLccU7HW+QmWiPmD/rmQbJ/ZGn5yOJCYt1O1u+KsGpAsMtNDNxGaT76mnUCWRWCPct2VXi
	j
X-Gm-Gg: ASbGnctdC5AxhbkBnsFWBNYTlQ3a5IOxGYQJuQB1ouph0hqwQKlUOM3rEtqStgGNWV5
	hFGMKryFWqF4fRpk5Ce6IQ3RDvfka2/DS8HINxnGjmOcTkfYjU8flgjZl+KOA6WP3Tr934f+qR1
	4+k5yx5+tvGXmO6aLmbC62zE0jE8DgThlK6C+e/w+AOn1K5bojZYfacA87THUjZALMQND1ldpB4
	t3VFM8V/aogomjWXE8Je/TdzUHvo6tBSkm6HfDlVj6bPPXTsKAmLruG4n++KQd5FVk7zg7TglM9
	dc3LQXtmUOc3LlXVekhHJg+Fh2FYy3N4j4wXs05tDHay/FIlHa7ZncLETIchWqL+vErgvKjJEAV
	gShhm8+V6zBizUydlGN3MRxuGUg==
X-Google-Smtp-Source: AGHT+IEA6h5Q+kiCAztC8JPJo39gUN5kQ8M8dleE1ju4Lla9DgPJqdOAtpTnRZMjFq4kvYYM/kZbPQ==
X-Received: by 2002:a05:6a21:a247:b0:1f5:8754:324d with SMTP id adf61e73a8af0-215ff085904mr8388807637.9.1747277793147;
        Wed, 14 May 2025 19:56:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a3d1cfsm10006871b3a.127.2025.05.14.19.56.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 19:56:32 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uFOlq-00000003f4h-002q
	for linux-xfs@vger.kernel.org;
	Thu, 15 May 2025 12:56:30 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uFOlp-0000000ENhq-3sK0
	for linux-xfs@vger.kernel.org;
	Thu, 15 May 2025 12:56:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: unmount hang fixes
Date: Thu, 15 May 2025 12:42:08 +1000
Message-ID: <20250515025628.3425734-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

These are a couple of shutdown related unmount hang fixes that
check-parallel has been tripping over semi-regularly. The first
fix is relatively straight forward, but the second is marked as RFC
because I've only just got to the bottom of that one and it's quite
a bit more complex to solve.

The second fix will probably have to be split into 3 smaller patches
(tracing needed to find the issue, code rearrangement to make the
fix cleaner, and the fix) but before I do that I wanted to get some
more eyes on it and feedback whilst I do more testing to confirm
that it works as intended and hasn't introduced any regressions.

The fundamental problem that the second patch addresses is that
stale inode buffers need the last reference to the BLI to complete
the stale inodes attached to the buffer when it is released. There's
a corner case where this last reference can be the transaction
commit context, and that doesn't perform the necessary cleanup.

I've kept all the triage notes, analysis and thinking I did to come
up with the fix in the commit message for the second patch -
hopefully that will help people understand what is actually going on
a lot faster than I did....

-Dave.

