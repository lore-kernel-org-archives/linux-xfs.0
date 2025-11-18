Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168213A5E7E
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 20:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763497179; cv=none; b=dRiZPm57wUhie9Tbt8kxQhRRuCjEM3UCs8bk7sO1z3mQzK7hVTyFTQpnCFL1z2HVGgI/nQVIHKs88KVXTaCMSMqsKUT/bQ15cAp6+bBukvvf7MBim3ct4oFkrTgW5eTBCLX620zdLZoc/SxNAsh5gMxsmsk+PPbHA1KCCDsVUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763497179; c=relaxed/simple;
	bh=Ixijsl8O436KeNnwf/g23Dbfs3V/W+Tg0u6rruwj4Lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rw+s5Fb25eOYUYW/RmalnYdum3f/gTXP0Szzj1yq0Xr6YWEJb3EvKsUROPLd2hNwWBtEAzD1kFfUXDvHzfVBidpZ5O+33+ooRGUBpQCkTlEUpWG6CpEd6SszhIxbZD0XU0pvoouXgMoLBytY6EWxozK2hqQ7zp6cIRxoqDsZRko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zox0NrM5; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zox0NrM5"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3438231df5fso7007926a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 12:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763497175; x=1764101975; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzKumkvqU5hskAJwpgGJbTlaAZ3Hn/6Z9FfXQJe/xJw=;
        b=zox0NrM5lJgr0xc8MxrNhW2uF51VWPZBA7qsOZGHRoLHgZR5g7r+/ZBkT32ORGCYNT
         638Cs1ow4spUnA/sPxDdrgNoMga/lMflPFH5kR/qBFqLJXW7+w33L/VdVVfBcTLgKbsF
         sbTiJMOIGywFEjGbFfuwk7djptbOG9vYfuQdq/xST/cFSvACW+OTFjP3XcPJh9u8c8W2
         f6l8UDHXiqMQiVxDs6glFiypW/jBw7LJs1KOz7limlm13KtmiVZFop/ux5iOplv+vBcx
         o+QYrdFuaM+o/Fxbcjf9d4XWqLLeHxUrJmPwN5gK5esySrZSho8NT8NK1sBFRlKI0c69
         /0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763497175; x=1764101975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tzKumkvqU5hskAJwpgGJbTlaAZ3Hn/6Z9FfXQJe/xJw=;
        b=s0jP92MwadCPo49zUvsZVXUKrM/NG7jcel+NEMYedZ+6XuFaEPTHQsFgDqdinGfiMo
         HT0wuoAyXao9ZS+yTneUqqa8uAK9UZ/FA7O7+mxK3Maswn2MpBtq/2kqpFGDU2Y9bObR
         UyVywda/CFtMUp1u3TYH3hwtV1SvlBu8NiJweIldSOXJ3gKqMJRZTkxnnmmwSlzFZNE4
         a0WSRQRs8STN6/LrWFnCWJXCo4xMYHFRCzNYh6QwXg8daReMD39LfSoHxgVWg37ViqoV
         GlKgYY5HKk5Q2OnsKk48df5MV42KZ8HH4kasaF88HUqb8n/7ufr8BrbtjJNAbFvL4vUC
         8l/A==
X-Forwarded-Encrypted: i=1; AJvYcCVo/EeRHmpywYA0dLe55wvz7xDgYRA/zM5OgVIe6kAjH5Jz7oWSLbhG3yz/IKzKKjC2mtZ5WylpGS0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Vwbm6w1EZOsuJrmgPZISTm1DQQWF5UWVZQRHxiK7ljU+/Lb9
	6VBLnKMZQdR2DePKGAfCpVw0doZ6MP9L6+r1x/eKSwtiCC1LT6/u5HAEyJdtK5WxbMk=
X-Gm-Gg: ASbGncu3J61Iy1mDOPxrbzhK21aQ9V1+yaTaypdYGAxSOPYMQsN3N+VRKycdaOU83H1
	fJulGIUaCn8z1M9OwW2ek48AMa+uMvOYoyNiltl1LTEbA866d+pJBQwpa+7E5m4awg+atSYzB0A
	ozChulNvEeg8TShvfX8P2DXCRjZZPDFtJ65xmUF9Z6Xjm6+1rJJ56V2OqQZ/gluRF78GsCDHABA
	PufMIEYmM6wS1jtXYHptWTnUscr+VXnQkNtqam379GtoLaNkxCsS8nTeUGqensPn0Q2sR89r6O5
	Hy38zGztsrF6rf1H6aCl54RDL7LNvp56FwiDiUi5EJ2ILBrhhojfFJXvrZlFUJvu5M4EfTy4k1x
	gruxk5Yr5l+oz12Lq9/jF1eLXYQXJtdtRah5cI8QNvLO7mgg8VKFX/arD648iYTeEHSjDgDwt+/
	K6PZCd4tE22P9tH2+PksVPlvR0yVLJCmmYCdkYZKJ0XkTvKD6IDyAJV4Ogx76gKn469QMovI71Y
	39K3H7k0wg=
X-Google-Smtp-Source: AGHT+IF19nMPiRln/9HkpK78ETc3mwJCTgf8j9eJisPorvTl1oiMCTpg06Eoc682+wd37BUudqW2DA==
X-Received: by 2002:a17:90b:498c:b0:341:194:5e82 with SMTP id 98e67ed59e1d1-343fa734f5bmr19748591a91.30.1763497174421;
        Tue, 18 Nov 2025 12:19:34 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345b04771e6sm1277033a91.8.2025.11.18.12.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 12:19:33 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vLSAl-0000000Cb5L-0lh5;
	Wed, 19 Nov 2025 07:19:31 +1100
Date: Wed, 19 Nov 2025 07:19:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	bfoster@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] xfs: validate log record version against superblock
 log version
Message-ID: <aRzU0yjBfQ3CjWpp@dread.disaster.area>
References: <aRUIBj3ntHM1rcfo@dread.disaster.area>
 <20251113190112.2214965-2-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113190112.2214965-2-rpthibeault@gmail.com>

On Thu, Nov 13, 2025 at 02:01:13PM -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> A file system with a version 2 log will only ever set
> XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
> there is any mismatch, either the journal or the superblock as been
> corrupted and therefore we abort processing with a -EFSCORRUPTED error
> immediately.
> 
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
> ---
> changelog
> v1 -> v2: 
> - reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> v2 -> v3:
> - abort journal recovery if the xlog_rec_header h_version does not match 
> the super block log version
> - heavily modify commit description
> 
>  fs/xfs/xfs_log_recover.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e6ed9e09c027..b9a708673965 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2963,6 +2963,14 @@ xlog_valid_rec_header(
>  			__func__, be32_to_cpu(rhead->h_version));
>  		return -EFSCORRUPTED;
>  	}
> +	if (XFS_IS_CORRUPT(log->l_mp, xfs_has_logv2(log->l_mp) !=
> +			   !!(be32_to_cpu(rhead->h_version) & XLOG_VERSION_2))) {
> +		xfs_warn(log->l_mp,
> +"%s: xlog_rec_header h_version (%d) does not match sb log version (%d)",
> +			__func__, be32_to_cpu(rhead->h_version),
> +			xfs_has_logv2(log->l_mp) ? 2 : 1);
> +		return -EFSCORRUPTED;
> +	}

Looks ok, but I can't help but think the validity checks should be
better structured.

At the default error level (LOW), the XFS_IS_CORRUPT() macro emits
the logic expression that failed, the file and line number it is
located at, then dumps the stack. That gives us everything we need
to know about the failure if we do a single validity check per
XFS_IS_CORRUPT() macro like so:

	struct xfs_mount	*mp = log->l_mp;
	u32			h_version = be32_to_cpu(rhead->h_version);

	if (XFS_IS_CORRUPT(mp, !h_version))
		return -EFSCORRUPTED;
	if (XFS_IS_CORRUPT(mp, (h_version & ~XLOG_VERSION_OKBITS))
		return -EFSCORRUPTED;

	/*
	 * We have a known log version, but it also needs to match the superblock
	 * log version feature bits the header can be considered valid.
	 */
	if (xfs_has_logv2(log->l_mp)) {
		if (XFS_IS_CORRUPT(log->l_mp, !(h_version & XLOG_VERSION_2)))
			return -EFSCORRUPTED;
	} else if (XFS_IS_CORRUPT(log->l_mp, !(h_version & XLOG_VERSION_1)))
		return -EFSCORRUPTED;

This avoids the need to both repeatedly recalculate h_version and
emit log messages to indicate what error occurred. It also, IMO,
makes the code cleaner and easier to read.

This pattern is used extensively in on-disk structure verifies in
XFS verifiers, so it makes sense to me to update these on-disk
structure checks to follow that same pattern whilst we are updating
it here...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
