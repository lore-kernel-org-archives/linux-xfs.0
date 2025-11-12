Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE1E2EA490
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762985995; cv=none; b=TqJ+7Am+o4El8LD0m1ntP8BSvadyTpgN/nyXRJ4gkRF5qTeRuKwzVL9TRNX3E1lhdl12YEv73yny+L4ZjoIMgDAI2YejFV2ON9sNOyL0ye+het5HMJWT2qI63H/XOGnlBfGVu++qtjHJJLHE7IJOmHyQUjnPUcnp7HNmIfZR4vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762985995; c=relaxed/simple;
	bh=unLPp2rzYuoxWbtv89S5pYlQJKMZKA9scZeJBdGlmIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmGJrdU1BRfTYdUwtN9L4qLyHN7MzkereguYACNWy66yjG3Xiuf+j48Dzq6qAiWyxnOE+C3QCwrSDANv3dog6Kw/ihMwz/CdsjSRMgtN4hjfS7f0/At48wNoAkvhUJ/q6uxVGBjcaNRBjQCilHFhgH489aKz77REgf6jBGN918c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=h21Y62F3; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="h21Y62F3"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-793021f348fso106291b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 14:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762985993; x=1763590793; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4g6kCT4s+7bhT0JH0DcrOQKdbv70N4aP0FSpxYAN3OU=;
        b=h21Y62F3TnPoT/SDuFCnWTWTVK5Uu/nh99+qyYrQ2kunM8H3u509FyAKpj73lkndQH
         tcD1D5yGnsUcoaT6BWyoiT1P7BZg4j8nN7K8fdTEQo1lH39K24JREqRXeGjDNa3L7kf+
         S8RftXpP6jMMUCNqY+2mPAE3ox3W7tASFudljD8jy849myNUfVE7SjDLx8VkTwdif+JH
         hVG+Rf6l6YOpu77Gts5RgKvK61aqspAOSSfU1GpO2h2i9vTcDxgzu/iF6s2y5chQ9kkK
         3JxczHuJL4+5nTJC+zhlkj50x1ZxiTZ2Gnng3MYlHCx8dwVEeBJmU53K7KHGLz3/UU64
         Kl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762985993; x=1763590793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4g6kCT4s+7bhT0JH0DcrOQKdbv70N4aP0FSpxYAN3OU=;
        b=KEiyDFjAGSq9M8GwkZGUPKvpMPpR8yU8ahBWCZUVDSf6Mv6twRssTR9+pAJnZ7iHYA
         ACKSseYOVG5Ht3hmBHAO4XBuZOwuNK9/Ah73nN5K3/RVb0huHG3dI6rIxml8d7hVpwa9
         UtXVIX1peYx18KDVZfhhUBZGwX+oiAj/ChpXfmnAYJxn6N7YPNO0VuEaRXhzZ2jjhBoA
         fe3kN8uUMGpvYgcenaqzXlMQ0i+/94bLQodEBmvyr1JK0DJE1ASRjOvMTaBoJ2uAMv//
         j3b+YuVczysLFJ+dKshzVQKtgRGh+XmWEEIk+iYAYTtf4TJPPWpQhn0rMMrOX52iMOb9
         QQWw==
X-Forwarded-Encrypted: i=1; AJvYcCWxz06BeH8tCPHFftj5DEUK9TY2tqE6grN2WNz3M3DajuT10ouHH8hm4COpemC1qvd32LfBTN4l2zs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxrvOWEsFDHP+Tj/hsC/U3xnYT3Tj3zrEj3Pw1pdI6qmhr87FL
	7qtpiiYlV8ML3MpSskpoxhKHrmFz071/a6qVrOhdq1aepMrpVfVzeK9MEg/zjiZVn5M=
X-Gm-Gg: ASbGncth1v+zDRtxkhvpZ03NycUA5xiTrVHJJrorW3ixvzyj9vRZBi8xphod7Upemod
	rmNgzsUAao64QlFh4VzBX/T6p+3SsvLnC107bAYUuT+UjSOuYMiKr8y+EOdOa7x8P7Ynfh0I5zb
	KPzK/4hJr1YVQMV5ZzYNvQOMT0KQVyFUSFL+lV39kCQVKbt6W3Mh/OjzOtZ4stzHt9KZWiw6doe
	MtmpgCO+PIWaPNAPb98jf5pTqizUeVOaMHyLHuEdkKTQZ3Y6FM5iQIXuq7MERBckCGnl4TziWbU
	ZoqX/LKQoIZhfjIFIdY4auDnbTCNSQB9knhxmoLEdsG4NqvhIfJIxebsimbF8uD4vvTFHTVQFEb
	DTHcO+CPzDNc2obmyI/7rfcFzuN9p76E742I4PjyqDvzBUSllE6CPevFQ5uHtLxAg0nkHIiTW3W
	HUgOWXNPZMqds96p+tP9IfiE/nQpFc8DTTkGNf7ve615/cY0kK6ko=
X-Google-Smtp-Source: AGHT+IHAa8tCyfwo4LnzmXlglXEr2HrToLcPw7JFbhkznGZRRLapV1K3KjrEoN6EGIup6pNwE09Bkg==
X-Received: by 2002:a05:6a00:992:b0:7ab:2fd6:5d42 with SMTP id d2e1a72fcca58-7b7a48f6387mr5692995b3a.16.1762985992953;
        Wed, 12 Nov 2025 14:19:52 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924aea005sm80341b3a.3.2025.11.12.14.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 14:19:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vJJBu-00000009zUN-0VHA;
	Thu, 13 Nov 2025 09:19:50 +1100
Date: Thu, 13 Nov 2025 09:19:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	bfoster@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: ensure log recovery buffer is resized to avoid OOB
Message-ID: <aRUIBj3ntHM1rcfo@dread.disaster.area>
References: <20251112141032.2000891-3-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112141032.2000891-3-rpthibeault@gmail.com>

On Wed, Nov 12, 2025 at 09:10:34AM -0500, Raphael Pinsonneault-Thibeault wrote:
> In xlog_do_recovery_pass(),
> commit 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> added a fix to take the corrected h_size (from the xfsprogs bug
> workaround) into consideration for the log recovery buffer calculation.
> Without it, we would still allocate the buffer based on the incorrect
> on-disk size.
> 
> However, in a scenario similar to 45cf976008dd, syzbot creates a fuzzed
> record where xfs_has_logv2() but the xlog_rec_header h_version !=
> XLOG_VERSION_2.

We should abort journal recovery at that point because the record
header is corrupt and we can't trust it.

i.e. A filesytem with a version 2 log will only ever set XLOG_VERSION_2
in it's headers (and v1 will only ever set V_1), so if there is a
mismatch something has gone wrong and we should stop processing the
journal immediately.

Otherwise, stuff taht assumes the version flags are coherenti like
this...

> Meaning, we skip the log recover buffer calculation
> fix and allocate the buffer based on the incorrect on-disk size. Hence,
> a KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().

... goes wrong.

....

> Can xfs_has_logv2() and xlog_rec_header h_version ever disagree?

No. As per above, if they differ, either the journal or the
superblock has been corrupted and we need to abort processing with a
-EFSCORRUPTED error immediately.

That's the change that needs to be made here - xlog_valid_rec_header()
should validate that the header and sb log versions match, not just
that the record header only has "known" version bits set.

If we validate this up front, then the rest of the code can then
safely assume that xfs_has_logv2() and xlog_rec_header h_version are
coherent and correct and so won't be exposed to bugs related to an
undetected mismatch of various version fields...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
