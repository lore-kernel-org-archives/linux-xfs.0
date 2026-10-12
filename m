Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB1E4DD3B2
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 19:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791833887; cv=none; b=P0eDyGOYWMRH+0fHuU7PaA67pgLlLicLLeCjBuqPn2TlvaBG50Jmm09P05163G1V2yifksEvbkExER5JWz13lqo9B1A3ujzcE0BCLK70ER5MRLBn1QkKsi9vlfOp2eXwnZUPwnn9pAhtrHpUAsULCo9piGtMcT6boVirRjJiQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791833887; c=relaxed/simple;
	bh=4AAbT+K+T6zTqmjne20UCGjVWaUTWTCY5QOg3496Wl0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nSNlPfJmWcjT91ThH6qrwaXFEvFNNx4GvVez0ynqOupIRp1grghEu7pDQmrh3honAnORi/XLxhIwqp/weJfi9IYqfLLTnfpTFOrEuM5L11kpd8tRk+kwtqF8YdvJjURJgNHUshelnHpdUUMY0/0mmunugkdmK3IrrqFzPNoa9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WxVunCFc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WxVunCFc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d05d51553so14543065e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 12:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791833884; x=1792438684; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EYnk6kaWgOjOEuVohmHy/bLvgbNPnuZwZ/OkC208Uy4=;
        b=WxVunCFcgKPVxLGSmMv4OYSNKGO7stOCKreK1MMwT1N6AO3CNWOZO4gZQBfTscSOtX
         Cn9Kz7Ijsa/oYFgcCu5Q2gPa7qLvbg1Uo3aHR41AF90xe918uvigdA8ZJ2pfKwQ7f/4u
         hgZfPYoD8C2MYBvaRiZaSe0+eDUcXZsYZp+VTiN40Fxj3kDuVsWZNLo0Gnfbnkhz8IeV
         14DHtF8TjsXAZLjsd9fvp4l6nT9DpPxKT/eiaEjn4fmGnOmrVgNsCAsR6TZK3BE1m2kA
         Age67xuzEc3Sr+f3kl9wyTp8dKWoltDcnjrEiWvvx4uMn9rRhDQu7WDWA5z0SKe9lw/A
         oZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791833884; x=1792438684;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYnk6kaWgOjOEuVohmHy/bLvgbNPnuZwZ/OkC208Uy4=;
        b=ZNUOLKSiH2axpcUay+ZVb/rZMo84lJivwz2qHXGk2KWt5Toi9qkyrnhU3qTFJkpQXk
         3/W4eLjXW+IgYsvNyU9MWxnpPQsqtw30CdiCFn8e4xYrqDQHdbmclG7uZEyfa8z98tCK
         yeZDq71WU5YCChP/EJ0cJrJ++kJ44JiMBDi38aKbq0J4twLPtXXREAbBzAiAbSLBoTaN
         Zq96iYB5TH5MaoeJ/RCVKet5hOBgLTBcMwUEYGMFXwJz5ulNAj4po6hG1h33nWbNO8Sy
         Qi06jesRu8U/3qB8ETRcOqbZWTf+uEDos5BCkZA3AG7ltjvnZ126WRQt9hYwV8B3+vNS
         hJaw==
X-Gm-Message-State: AFq9FYLfstq579aOWG+sIktOnGMcaxoW1JCSZslZna8huU/BsR1FORdT
	F6i09Dc6x2i3guawtqSiGN7XGX/mWobhM4fOhOGtS1EK/KQkWbjyqHKBY9i1it9h
X-Gm-Gg: AYBFou1z3U2J1hhWZYvsEQSE6dgYXPOjTR7qpfmyqKpfDaY1m2ntcWys9YGPZy4yY72
	/2JewtR8pXwxMGTqfQF+4hcQYtKTOjGfDMfI1yl5UIiHTkP4bX6dm0i6HMXdVVOlZq7RIu816SA
	F5CvsNM1i8SW+lZFOANYgqU+rvJQAf1gUOwWPt/Uii94uas5l1kGNBh3RB3De82AlZ1yLSYhbTN
	7spwVYYQSrOY0MvfeRuIQjKRtKHzsEj5ODva7J08hY+LnBb10SdzKpDRR3r2GpnMNZIddAVTmyU
	RBZ3n1Fdc8BuZGq14gHcidI84kd/KMw+Yy7D+hCwlpR4lI0wkHgn9abBBdVSz9G3nHgmSVMG/6o
	STeTb4Px5F/ARFk5FF7DN71oqDP6w/8AVdtrgQMpW0hMCO2qSFhpbIMiVOfL3O6vT3cm1lBDUOm
	UsQ20arYqPzKkTkcf3ByvWu8cL6kftGViyzi9r/Bk4zGnd/KY5GujU
X-Received: by 2002:a05:600c:3f0c:b0:4a1:6517:ccf1 with SMTP id 5b1f17b1804b1-4a18e47a844mr215261365e9.9.1791833883952;
        Mon, 12 Oct 2026 12:38:03 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2caf4sm337593655e9.10.2026.10.12.12.38.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 12:38:03 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: Really bad I/O lock contention between non-overlapping reader and
 writer
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
Date: Tue, 13 Oct 2026 03:37:47 +0800
Cc: linux-xfs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5985D8D0-2411-40E0-B20B-8622F156AF90@gmail.com>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
To: Vitali Lovich <vlovich@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

On Oct 13, 2026, at 01:47, Vitali Lovich <vlovich@gmail.com> wrote:
> 
> I think I encountered suboptimal locking behavior with concurrent
> readers and writers on a file, which resulted in huge latency spikes
> for the reader even though the writers and readers are touching
> unrelated ranges within the file. The writer/hole puncher hold an
> exclusive lock on the inode while forcing a flush of outstanding
> writes to disk which creates huge latency spikes for reads.

IIRC, there is no fine-grained concurrency control on the same inode.

> 
> I've observed read's taking >> 500ms even though none of the writes
> could be overlapping and traces seem to indicate it's the shared inode
> lock contending with the exclusive inode lock that writes / hole
> punching is holding. In my real-world test case traces indicated that
> the cause might be inode_dio_wait while holding the exclusive inode
> lock.
> 
> I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
> general VFS challenge. Generally, Btrfs seems to have less read
> latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
> which in turn has smaller and fewer tail latencies than XFS  (~2x more
> at 0-1ms and extreme is smaller) although all filesystems exhibit the
> issue. Starting with the XFS list in case I'm way off base that this
> is a problem.
> 
> Attaching a simplified reproduction of what I'm doing with one writer
> appending data to the file, a separate writer punching holes in
> unrelated ranges, and an O_DIRECT reader that's reading data. Reads
> are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> 4kib holes in [64MiB, 576Mib] and writing is always appending after
> 577MiB of the file. The directory the anonymous file is created in is
> CWD by default unless you pass a different path. I'd expect read
> latencies to not be impacted by waiting for writes to flush yet it
> seems like clearly there is such a serialization.
> 
> cc -O2 -g -std=gnu11 -Wall -Wextra -Werror repro-syscall.c -pthread -o
> syscall-repro
> <pessimistic_locking_between_readers_and_writers.c>

