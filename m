Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793038780;
	b=uXXTn4o22yj+KcNBz4kXobDDPg9WeJBk4IVeQZckm6P7caTAkfEqzVDYWKxVSwbBW2iU
	 6dR5xYGbnJRvEPFduXrib5hy+n72yxWB+23gzZZ4aL9pq0HK6paISE8pyPdPhb7vZaCmN
	 gY48qmbyF6BiARk7xgwf2eDG95L+IfTU9qHD7VZK2d/clIMH9vh6lqyy4nGSL04CW+VUa
	 PBngXlV2Qa52w7B429boxN91Tn1n6wk+LIkhuivjkqMUQ9RVG+1O6VXM0fIK6pCSJTLkw
	 VyGLaNUBK6zUedoaLG68t5pUfEzMpwQykaeQ7kmbdkzc/05QLFB458QsyQoar1bnOKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:
	 MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ArunF3JyHzPDJjIHJyEibRPONwhw56eILbBtpNH+onw=;
	b=XEanPlfdwT0CNAhmKfzu1svbyY/N5P/66r7+t0W9CHEha/3+a0TCBK8FHpB10qSg+r9x
	 jRsJqk1ADne4+IGedwBvFnmW5adSLj415FQIRfKvD6Taq732dSrtTsMcDocn/oQ474eft
	 ZFXvbxbHVOBtxtNV3IIJFARF+gYQgXdVECvJh+jk/PB4rqm+it7CYRGfSKxVK4TzL5dMz
	 7RTtx/K7LUQtHba4hhGj/LIMedBRBVOcnOrv0t0V6fwnmn316JnOT1Wc8LYuKd3jSho15
	 Y2tBv9IEnJHDK/4+mUWpPwP3WH6IxmM0tGyvGq3wtgG7k/3HgLMmp/+K2o6J0ZjI3uA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YGjzFdL+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645E4606A31D
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 18:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 645E4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YGjzFdL+
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so5267748a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 11:19:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793038779; cv=none;
        d=google.com; s=arc-20260327;
        b=psG1gq2PKrJXxOSUgurXFb7Xr6CCPxOUw3v0+5uNxHJqnHSaoVMCQ0tPBBwxpfE5Gn
         oatV+HGkH/o5HtCjasHphEBcgxj2Z1xvKAeRWVMWdg9k5xjAtX1CELnqF6EUSFrRZwpe
         ZX5gR/1nJIcH/fuQ4My9hHDPGnYMu/6xx4sgqu51+H0l3CCA5jOdLDXsa17/bkg/kIL2
         k3RYdWCybTZzCkyVpnapI/vrPYphoiyl9FMxp3R9kQRcgcB9920Wt73M7OmAD+msEyur
         qUA9I9K0euLxtEh0nZsQ6+QxHCTkgtOVgMoxItcm+19sl5Sx0K+QDshvW+hkkc3Gd7kv
         1r6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=ArunF3JyHzPDJjIHJyEibRPONwhw56eILbBtpNH+onw=;
        fh=IUFjyOxQ8OJIO78EyT94P+Aa3G0FBWUejX3+sZaLmq4=;
        b=FtgIVYPbJc19FLFuP/l9ExgXUw2lYf6p5w7wzIK7BxKYttpiUYVhiOsI4OC2duVhpl
         Ydcq1WV6kbaE656KpuQApVnl4D9vo4TEoejCgasg1+X6+KYe9Fu15pQcLm5ZLMf+r832
         rn3+DEuEM9hLooxilHTMWb9SaJu6syPUYRYfg9Hx4WZGVpmNu6Wf8sp5Bifm91O4PXxr
         bCLT3ei15lpyh42h29/3rLX2pH31LZo6R1kC0bj4rQD1zzpj5i7Y+Bbu/Jg4/t1yl1La
         CfgUlKsmkNBbb2WlBw/xs1fAYIRXMOAZhZQurDcd0vtcy5GhvwvDKdygDNxp6gvLTv6K
         t0PA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038779; x=1793643579; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ArunF3JyHzPDJjIHJyEibRPONwhw56eILbBtpNH+onw=;
        b=YGjzFdL+jOpAqPYLKQLXeowDdiBFXp9xGOEftbffQ/DcSmk0zUxfGxF3o5ybWmoagY
         BheMMIiwKYmjHf/yBW51rXPN+MfqwjhZnRahC9oSJyUtP2dK6t+Pl4CZPCcwLnhgVxgs
         l5AMBUWqhpuZHnxt/YBxWKxMu+vBzz6+8LFyETrnvXZs2BHT9Re+QBsdLITP3lQWkJGh
         XCNqxOQOlxZASsZmn5fGvvLpYcP/y49GXIX233Vz63YbY3Uy1gWkU7xgRZUcOLl5UbJJ
         KAjD3anj6GrHleTFwHwIPUlKooN7xu6APIBOnXZKpA3dowFn1jYA3rWN4Eq3SPUR/6c1
         O/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038779; x=1793643579;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ArunF3JyHzPDJjIHJyEibRPONwhw56eILbBtpNH+onw=;
        b=IMjTcEVM+dxs4xe6OKG3u24RcRMGOFnLdgenH/qTSg4s6Q09uKEBsIQhHD+UA9aJyH
         YcFciGtlhlqhpZ2yZAKAyYxBnWFUzEWkaFq5f9oGXB1Bzz4vxeGG61amwPm0jhZcaZ+8
         FMF41ykJvK2NX96No+zJljjLPXpcE+TNVkHsDAVZTXEa2jY3rHOQtcgF99totf9Xi11y
         pwfs1/w75XzsudXg6DgDGAQEpClzbJxC1Vn15fqc8fSr9Ixl7NQI1Y8neR0V3e/epccC
         32qfn4VE6q10sdKd8IDFL2Zkqc0EmybL2+b6/IzIEpjpNdkUnPPw6He0pCT/LPFel0WA
         PDeQ==
X-Gm-Message-State: AFq9FYLUxbB+zExpRdiYw7W5EmwMx3FeRxNHXydNo/npcxhXsiuMM5tx
	p7mRmQ1Tb2/G3Ra7ev1Y2pPlEuuO8LfPAzHj9BlkWpYZcaPqnWGAFRDoAS7gMJ57faVP0EWjkjl
	9Nsfu9GkUBRNnbmu7t/RXOfc7joBrxHiATozB
X-Gm-Gg: AYBFou2aGGR02ztUjSYjr+oyLxd8o7tNOGF4rFA45LrZYGuE81mYC/vYSVFETsgcBPZ
	/qD9+LTaCV+5alyY7kXf+DSiaUoytty1uDs3NER197QIDJHqLsHQVyp++io+G70XdDTNq8OXGvx
	YOUc7/Nh1GhNa7JAD+n1oreF7L5gaR44Kei5G7UF9MukAR5Zpj4GLdMqQnIRDsfGJrq0KuT5mWo
	2xJYGpQ7A8osRHVTT21jBl5E1O4e/ZOx4ecFFkNJnOs4e4w+JRAZ0StDaVNcegtyX6SWob1Xy8N
	+uotZOl5GZZaET3h2EZOgXGr06NEViL3OK5mInnd+xnSFkVGsarkotwWbsFpb6Kb3SsemarSAt1
	PZKvR7av9Bf3/DQUnQLnngnpD/+2eVtIntA==
X-Received: by 2002:a05:6402:404:b0:6b1:b5b8:b696 with SMTP id
 4fb4d7f45d1cf-6b442fe421amr6628563a12.23.1793038778619; Mon, 26 Oct 2026
 11:19:38 -0700 (PDT)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 11:19:38 -0700
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 11:19:38 -0700
From: Ivan <ivan.vin.ctf@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 26 Oct 2026 11:19:38 -0700
X-Gm-Features: AclHuK8-VKJdch5JGSdLR7HiZAxRhyNLKRo4wOVMpFlALXVFs8xNG5yVrpTkgZA
Message-ID: <CA+hZKYK7M9EB2HmVTQtccuztYeSSrygnN_20g07e7C+mQPRMnA@mail.gmail.com>
Subject: Re: task hung in xlog_grant_head_check - still reproducible on
 7.2-rc7 (2018 report went dormant) - and on 5.15.216-stable, with a cascading
 inodegc victim profile
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, yangguikun@tju.edu.cn, syzkaller@googlegroups.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Picking up Yang Guikun's August report [1] with independent evidence from
our fuzzing fleet -- we agree with the analysis and would like to help get
this unstuck, because the history of this bug now looks like the pre-history
of CVE-2026-109618 (PHP2Shell): a known issue sitting on hard trade-offs
until it becomes an emergency.

INDEPENDENT CONFIRMATION (5.15.216, KASAN, syzkaller):

Our focused XFS campaign reproduces the same hang with a different image
generation and an extra victim profile:

  1. syz_mount_image$xfs -- crafted V4 image (small log)
  2. one setxattr(...) with a large value

  -> xfs_attr_set -> xfs_trans_alloc_inode -> xfs_log_reserve
     -> xlog_grant_head_check -> xlog_grant_head_wait (xfs_log.c:256)

Unlike the August report (V5 image, single victim), our logs show a CASCADE:
the first task wedged is the xfs-inodegc kworker in xfs_inactive_truncate
(D-state >122s), after which user tasks pile up in xfs_trans_alloc behind
the grant wait. All victims are unkillable. So the blast radius is the
whole filesystem, not one unlucky task.

Same root cause as described in [1]: a transaction reservation larger than
the usable log size can never be granted, so xlog_grant_head_wait() is an
unbounded wait -- no amount of log tail pushing can satisfy it.

THE RECORD (why we are pushing now):

- syzbot's main tracker: first report 2018-05-21, open 3079 days,
  1471 crashes, 0 of 29 patches merged, last crash within the last day.
- Sister trackers all open with C repros: linux-4.14 (2450 days),
  linux-4.19 (1412 days), linux-5.15 (1311 days), linux-6.1 (1302 days,
  394 crashes), linux-6.6 (Dec 2025, corrupt-fs images).
- August's report included a concrete, low-risk fix direction (sanity-check
  the reservation against usable log size -> clean -ENOSPC instead of an
  unkillable hang). Neighbor fixes over the years (integer overflow in
  xlog_grant_head_check, the nowait case, ioend log exhaustion) never
closed the unbounded-wait itself.

WHAT WE ARE ASKING FOR:

1. Either accept a reservation-size sanity check (we are happy to test
   patches against our fleet and provide before/after traces), or
2. record an explicit decision (even "won't fix, requires crafted image")
   so that the dormancy becomes a documented choice rather than silence.

We would rather spend our cycles testing your patch than re-reporting this
for the 30th time in 2028.

OFFER:
- Full syzkaller reproducer package (image + prog + C + logs) from both
  campaigns; can also provide a hand-minimized C repro on request.
- Bisect/testing assistance on 5.15-stable and mainline.

[1] https://lists.openwall.net/linux-kernel/2026/08/24/265
    ("task hung in xlog_grant_head_check - still reproducible on 7.2-rc7")

Reported-by: Ivan Vinichuk <ivan.vin.ctf@gmail.com>
