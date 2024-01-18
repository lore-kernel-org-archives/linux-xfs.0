Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B5032193
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616544; cv=none; b=GwPE2Y8m3ypJJI+3ZKXjHQaCTB6vfhnUMNQD6ZpxCJjpOr8mK+dNwJOc3WHbNyx/IwqquDfrbJ94y55UfYjg1VxY0xIR8Bci2vddzg5vGg/AXxpr2OJBLe3/nFsOWnzJ4vh+LSIRXw8LnZOROvWo0rwNUxZ4xYNoQ1ZpwFqV3Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616544; c=relaxed/simple;
	bh=84W3Bd5MABUgqXS5IdrwnrLtM1D5jLLSOMBtMMnAZ8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CohNWX0sfXucbcsZXuuAti0QxCk2+R0vq8wf4bpBdJlXZ9R6jIQj1OKCivObwwBuGOP1LDs8M3/bdR4zXLRpCcYMX/xf5Y12kXiFS8Ek4seQCZez8v/Ep/qu7TyCTXpRWW6LTtku7UjZlT4H0XmbIcy3a7GLu1VFcNRvTPjFXLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AhjvAXOU; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AhjvAXOU"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-36197b6e875so659355ab.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 14:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705616542; x=1706221342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0T98cpX+SULSpjNgtsPYqzkRNNaWj63ZWS5JTebEXY=;
        b=AhjvAXOUvWPO6BBmql9eMeehJ02BHCKZnAzPEH2htB2TYSAhKNJlLM8PIenxRnnHHI
         noycMAiMjLsLvy71HT9o3gL2YKf+nlkcSwHcMopcor2d7GJOrsXzkIMQ1l4xGHeNisYe
         Yg+AVGB1j7nePe3jPI4ITlZScWhBZ/DflPJ9Qdoh6YtOAaHeV5TxRkAAlJ/gChxLTKLe
         tPiiWHeX3nF5bwMkuaGhT/p6WvR9TG6jZn3JiNbKVvIhKpEpSw3XUtvmWj3j5fa8fhvE
         YiK5fcDygAlEDvW+9qbt5FxpsTME3TC7H8He2C+2o3qj9aKI5f5cIvJm66i3Hf+3SMH8
         oqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705616542; x=1706221342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0T98cpX+SULSpjNgtsPYqzkRNNaWj63ZWS5JTebEXY=;
        b=XNiwINiJDgchKFO5ipAhM40zRE1ZqKOXaVEoYrwbIrReXpoGSN52tFFViPbY4PW+vk
         yk7O2dLBO+SBxtXRXKDWeFnixBT/1eXAJRGeWni4aDwlDLh1MLM/0hgMv/TGE5/kUP4K
         QuTmpxnsRrOD6t84ZLveH1xJHQP08ch/x1c5VsQ40QuERvSDUACtdwcG8TwW1xlVinF9
         vTsMGlU3P0yn0TtU9xLTDUXZZtZPV4mlOeU7znOhhpJjsbEr3lrNubrBRPmQJd5yuufF
         gMJo0giJ+834WBHZro0RDBnpVOvXmloEC68NXl0MKHDmNM+rxTy6qyr2StOcNqgTGnQN
         2sHg==
X-Gm-Message-State: AOJu0YxqUJxnvHUUawWDbdKS4iHiowmxrmTBrOFj/csmhPVbSY1TjquD
	0g4W16lp05ZSUPl/ivFtT2B7d8xzuBZf2lm74O1W26hE2aRlKwDRF2OZLU6SdyIbQd8rvyhGjxN
	E
X-Google-Smtp-Source: AGHT+IGlPKlu2kdXNkTMeiemaK5KwMkc7BAynefIhrrtwhxn/LDegX2GgQDreG0TxMQNpJ7/MxkpxA==
X-Received: by 2002:a05:6e02:1d89:b0:361:a719:6024 with SMTP id h9-20020a056e021d8900b00361a7196024mr865850ila.30.1705616542047;
        Thu, 18 Jan 2024 14:22:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id y37-20020a634965000000b005ceeeea1816sm2137336pgk.77.2024.01.18.14.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 14:22:21 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rQamB-00CCGK-0V;
	Fri, 19 Jan 2024 09:22:18 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rQamA-0000000HMlj-2Z5n;
	Fri, 19 Jan 2024 09:22:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [RFC] [PATCH 0/3] xfs: use large folios for buffers
Date: Fri, 19 Jan 2024 09:19:38 +1100
Message-ID: <20240118222216.4131379-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XFS buffer cache supports metadata buffers up to 64kB, and it does so by
aggregating multiple pages into a single contiguous memory region using
vmapping. This is expensive (both the setup and the runtime TLB mapping cost),
and would be unnecessary if we could allocate large contiguous memory regions
for the buffers in the first place.

Enter multi-page folios.

This patchset converts the buffer cache to use the folio API, then enhances it
to optimisitically use large folios where possible. It retains the old "vmap an
array of single page folios" functionality as a fallback when large folio
allocation fails. This means that, like page cache support for large folios, we
aren't dependent on large folio allocation succeeding all the time.

This relegates the single page array allocation mechanism to the "slow path"
that we don't have to care so much about performance of this path anymore. This
might allow us to simplify it a bit in future.

One of the issues with the folio conversion is that we use a couple of APIs that
take struct page ** (i.e. pointers to page pointer arrays) and there aren't
folio counterparts. These are the bulk page allocator and vm_map_ram(). In the
cases where they are used, we cast &bp->b_folios[] to (struct page **) knowing
that this array will only contain single page folios and that single page folios
and struct page are the same structure and so have the same address. This is a
bit of a hack (hence the RFC) but I'm not sure that it's worth adding folio
versions of these interfaces right now. We don't need to use the bulk page
allocator so much any more, because that's now a slow path and we could probably
just call folio_alloc() in a loop like we used to. What to do about vm_map_ram()
is a little less clear....

The other issue I tripped over in doing this conversion is that the
discontiguous buffer straddling code in the buf log item dirty region tracking
is broken. We don't actually exercise that code on existing configurations, and
I tripped over it when tracking down a bug in the folio conversion. I fixed it
and short-circuted the check for contiguous buffers, but that didn't fix the
failure I was seeing (which was not handling bp->b_offset and large folios
properly when building bios).

Apart from those issues, the conversion and enhancement is relatively straight
forward.  It passes fstests on both 512 and 4096 byte sector size storage (512
byte sectors exercise the XBF_KMEM path which has non-zero bp->b_offset values)
and doesn't appear to cause any problems with large directory buffers, though I
haven't done any real testing on those yet. Large folio allocations are
definitely being exercised, though, as all the inode cluster buffers are 16kB on
a 512 byte inode V5 filesystem.

Thoughts, comments, etc?

Note: this patchset is on top of the NOFS removal patchset I sent a
few days ago. That can be pulled from this git branch:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-kmem-cleanup

