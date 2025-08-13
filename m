Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77736302750
	for <linux-xfs@vger.kernel.org>; Wed, 13 Aug 2025 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755123844; cv=none; b=JYoQ56XLFCGQSNRd5I07O07o5BiPQJp4T+tDssapH1bzDGyRdJ3dF6/VwalmwAskR4za1Pb3010ki5Ka9g0Js5hNfy6pfYljUt4LAE3tmhWqjn9jCSepl4z5O8gUSULSxV7vs7KyWhwtsmgSUm2Qh0G0Vg2N4TG6wKdnsK/qZR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755123844; c=relaxed/simple;
	bh=t+iaxS48bavZm7Vx1PdFbFYHb2gesBylSOt17isRlpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=foC6BaxqwImg7OSe+kjL01AU+810CUmQbnI+WEHp03pZfmhk1MHvvrxvCrxU63iQAIb8y3vln+2GXRsiAsszrMTfDyV/t0/Hc5GmRdbu5PQyNMeVtdVakz7UQGcIy/Jy70NH3vP3HiiXCOSr/qqDVaG4DsKSfryhXFWl7d/KS84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=U7FXo2lg; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U7FXo2lg"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76e1fc69f86so1146864b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Aug 2025 15:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1755123842; x=1755728642; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0L9MZd2C29Owk+tSwbubAyj7GAaQwkku4ZJfpEOS8FM=;
        b=U7FXo2lgELuUuAUpthSA+hzwOTyKsc4HJNzxDkY9qmp/AtA8Yp/XQvlc8F6x/jlUoM
         4tlGBD2nwYydz+AuP9Lmb1KmL7dG2zCOlaIU0K2nhW9fiOJF0cfgr8svie10lqfSzuGk
         H5GE/X5VQnyb/CDrkoGkhxmVMHxoSFOGZDDM/cfQAnnwfn/VojeRAI2PMrAS4rMZakOx
         3yCESrSH3rpxZwuA198CpMBFj00yLoKFzsyqnMUc5NqfHgfP0ga7M637GiqKiBdAnq8p
         nnpiVHZVN8dXenT30au0iBn47aQW3C9qW0O0tUPY9C6FP2tg8+J6zl/5ln/7QLSlyvik
         BZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755123842; x=1755728642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0L9MZd2C29Owk+tSwbubAyj7GAaQwkku4ZJfpEOS8FM=;
        b=FFIGAEhNuisgtCrPFHpI0FjQeS+bRTJcce+kN7FbZwjRcOhqvDhYcvJY+HESZEp6gn
         2m4k474l49hL+vaI8lXf2sSE+tGTeLSfn0hee7myl2oA9LftPYX9Fl3VC5/owqhebaGC
         fc22y2xMxMz+hVMEM9rMzb9qz0+ysc6CsQ0oKmkMwYxH+FklawBGYc/fxku55rGkrj2p
         65p0MAXAK6wZTyT7u4LDrsjlyFMFGK1s97x2tlsk8nQ/v9G9QrPx5bodBlHJtPyJccyt
         uy0Uhi59yEg3EwZUm6PGNzr21e7flqNdBPFCQOdonJ+exOWa+du/VwNZ2ndpWl4SGb1I
         yF7w==
X-Gm-Message-State: AOJu0YxvoUF2R+T+hOky5foevIgFjJSyVIMiqefDKVmYBuAOhfMoaBzG
	u3GIiiMRNQbUMYVkJRjx2bTnFxsZfHLZoip6mU02ueL0bpAnGQpOSFUIlyJqFj1zDzltLWPuvD3
	CU/DI
X-Gm-Gg: ASbGncsgfAM45Re2rf9l6oFM0ANfb5wudU4sGJo5YDtaIQ/XT2hNXz1htkjaFlnIboP
	1gRLPb0bgaqxwQfdpeyNDdw/qiiVFZlSoYP/cjeNp+4hwsWwxcIXrWhNo9FSeVH7ehCnALEa6kv
	D66snRi66K5UOZBOXv23RwhBCTqMwEZf2Tylwiz4OEEys1eXhQqeeeIPAdNDJ9r9KGnnyYNz/8N
	39EgIOTCU/rQeWlEE/nPUXDUqN25uQceiWUsIlFzUKq6yc4Y7ijnd/eV7nHuTiRhtBPPFs99Geo
	U9QfbZecZzlfd3wwfNyaSr3+icsu1490EaMw/IwKwKmv4WFF7OcsdFjaxa9sxvNjFyzbtGD2irv
	LsB/zixJas2bBBjy6xjZUzMCYhlVH4TiGMYdFu+SwiNrky+Up+HGE1qsnLOq+FHzUqkNLf8PEdw
	==
X-Google-Smtp-Source: AGHT+IH4Q3cxR0gd5uG0OyJTKtrFv+VsfevDd153NDQZu/EDBWJynY4REehHOy51YtsXHmSIQPJjzg==
X-Received: by 2002:a17:903:1986:b0:240:3245:6d40 with SMTP id d9443c01a7336-2445bc29896mr117445ad.0.1755123841663;
        Wed, 13 Aug 2025 15:24:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef7d96sm333976665ad.18.2025.08.13.15.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 15:24:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1umJt0-000000061aF-1yJh;
	Thu, 14 Aug 2025 08:23:58 +1000
Date: Thu, 14 Aug 2025 08:23:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Fix logbsize validation
Message-ID: <aJ0QfhQ1kPZRIVUq@dread.disaster.area>
References: <20250812124350.849381-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812124350.849381-1-cem@kernel.org>

On Tue, Aug 12, 2025 at 02:43:41PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> An user reported an inconsistency while mounting a V2 log filesystem
> with logbsize equals to the stripe unit being used (192k).
> 
> The current validation algorithm for the log buffer size enforces the
> user to pass a power_of_2 value between [16k-256k].
> The manpage dictates the log buffer size must be a multiple of the log
> stripe unit, but doesn't specify it must be a power_of_2.

The xfs(5) man page explicitly lists a set of fixed sizes that are
supported, all of which are a power of two.

> Also, if
> logbsize is not specified at mount time, it will be set to
> max(32768, log_sunit), where log_sunit not necessarily is a power_of_2.

log_sunit is set by mkfs, so the user cannot change that
dynmaically. LSU is generally something that should not be
overridden by users - it is set by mkfs for optimal performance on
devices that require specific write alignment to avoid costly RMW
cycles...

> It does seem to me then that logbsize being a power_of_2 constraint must
> be relaxed if there is a configured log stripe unit, so this patch
> updates the logbsize validation logic to ensure that:
> 
> - It can only be set to a specific range [16k-256k]
> 
> - Will be aligned to log stripe unit when the latter is set,
>   and will be at least the same size as the log stripe unit.

Have you tested what happens when LSU is set to, say 72kB and
logbsize is set to 216kB? (i.e. integer multiple of 3). What about a
LSU of 19kB on a 1kB filesystem and a logbsize of 247kB? 

These are weird and wacky configurations, but this change allows
users to create them. i.e. it greatly expands the test matrix for
these mount and mkfs options by adding an entirely new
dimension to LSU configuration testing matrix.

Does the benefit that this change provide outweigh the risk of
uncovering some hidden corner case in the iclog alignment code? And
failure here will result in journal corruption, and that may be very
difficult to detect as it will only be noticed if there are
subsequent recovery failures. That's a pretty nasty failure mode -
it's difficult to triage and find the root cause, and it guarantees
data loss and downtime for the user because it can only be fixed by
running xfs_repair to zero the log.

So, do the risks associated with greatly expanding the supported
iclogbuf/LSU configurations outweigh the benefits that users will
gain from having this expanded functionality?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
