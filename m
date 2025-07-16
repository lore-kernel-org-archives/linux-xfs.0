Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5A21CA1D
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 23:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752709930; cv=none; b=B/PsnsEV71SVvuYhYLJWOmRiW1DPv/7K0sfbHvRshw810QxV/9TK9/Xezp0letr2Z031Jns7Wk4S3WJN4z4Ly7522gd+S9Xbifl3tAoLRVJ0GPoKlVmAyvq5lwEcZ8gQ0/98QrZFP6a/qtiX+jnZUXL56ggU+vLGn5+hFRGfHfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752709930; c=relaxed/simple;
	bh=8cc2Nz87MAuzNDTFYLrAfgQhXEv/HRfUJbJCoQPND0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaEmviso9++qzpa1gFQj2wAtHqnUQCLlNYCeVoA7YuMdGbAQOm3Dgdjgrnk3gOpIkzWcWSRLE5RrwD0Ad2lj5SIAt3TxQn3vs9J96PkHplirqozgtLNja2vp8J/XAUP6jI6uaXfFcXXOc3jpqm0uJfBSYCnJHnqc746K1u6Hc9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Mu8WZV/K; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Mu8WZV/K"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7481600130eso551729b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1752709928; x=1753314728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9iYhf+TmOaeuGFTnHtMZsVUbgjznZbhmRqA/iiwsEQ=;
        b=Mu8WZV/K+dCgYDZ0EFvxwJn7z4YOXD1bsuHZqqP1V/kfTqca+1d9vqEio19KxAlG9/
         4A7Wo5tRnOOPZ8sniD+dy5ZWXsSBuw1PuErww259WISuPzaFOmB0ZjSUM6FqLXtwY1Ub
         N29af4gOqV6O5ZkyuhRJRNFX0BhKUnsDTVlCuMXQenDQG/jiic0NhuG5pJmHE3fyxnbQ
         /YMvVLmmSiV80vHWTkmSCy52sqdWNO4/PNVXO5zegR7ElrsYrys92d12xcR7I1p06VYS
         VPoYF2Fr532yc0OpsvCDLKUH9gBTBriWyBrV7KWNNv+O8nmtfJVUjvT1S5D5FzhF4sty
         oo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752709928; x=1753314728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9iYhf+TmOaeuGFTnHtMZsVUbgjznZbhmRqA/iiwsEQ=;
        b=aVAVcnr4CAbmrbtb70Z1PwT07pauC3v6Q3ALH2aU7E9raiz9FLerDOQ4jKvVKmPUR6
         aS5yWv0v3yBcQXUETo/oC0QbwLdvHZRLFa8B6FDaL6d+r2XIaBK5h76ngMn8Zh5nne4x
         8EWTdF31CJ8y0CpScnZkEVUwg6W9F/4HD+tqe6VujHCsBWU09M9xfteUUzPMXEmdToFL
         zi+JszPG9rapVT5UH+o2MGyhllMBM7kd6agYB+ki6uUPzqZeF826f8GR9+0CZqgkmvgC
         paYRq3fLxV/4SHXl2uMlJ1sYNXuSiS5MhxRqLHGBX9oji3+FH/oWCryIDuepnQLFgaUj
         sZrg==
X-Forwarded-Encrypted: i=1; AJvYcCVE34ht+mjB01ENJlF/ng9Wgyhkuda/HU+BNqgWaM50LsoCNOuZ+9cLQGgoFK721A8wmZl198rKUGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEZaRNBSBhRV3urO9TUvnTlfrWswdGCEEX1q/JFUYHz6L9j7xk
	Ua2p6tLdOsvprXmk/IX5TQdx/vrbWY3HPRvRiRzNCely8EiPh/q4rZmnARRPOQSJEwE=
X-Gm-Gg: ASbGnct12xCAMqwR414WFa85TIaCsJx7XCXQo5oX3d2rEdUHFO1S1LPq9cNR7urYn4g
	Jb0rgFsEtIkksyJtLmlTX/iM4UpXxid3mUEnfZCE7Nq7n3O38eCxAqZRR+HZDzW+KdjhkAjpBjA
	1Uy80xr7Deoop9XinDO6R2upf51KdZVLDyVTQSgLdWnj0p7zqfWCsVab48MlBysZ3NUiPlbuNdi
	07N7zdrLq3lgV/PTtDg4GtUv0CdlOa+ZAQFnT7obpABbphSKPY1+EeWC9lAcS8dKPrRtvpRxzvA
	ErOT5bKqVzGr8hPzDlEHjahy/wVCWEPlnle4mtKmaS/7TeVHeFG0k4kR+uZCZtkkdmUuciMwFC3
	WF0iRZupEVRQ+MFrgXP7pJz4SZO+42ABNps6VX08h/KmGPxKLNEfGlLS8I/3a9q0tOIH6mFYNqg
	==
X-Google-Smtp-Source: AGHT+IHUiw/cyohjV69lTrcKLCPTOr7ZJr1M8ncyo7AQFt9fgkchZHyM+/jOrI9YcMR1a/4YY9Pd7A==
X-Received: by 2002:a05:6a20:734a:b0:220:3870:c61e with SMTP id adf61e73a8af0-23810a5901bmr7838780637.4.1752709928032;
        Wed, 16 Jul 2025 16:52:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-64-170.pa.nsw.optusnet.com.au. [49.181.64.170])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9dd714bsm14430679b3a.6.2025.07.16.16.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 16:52:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ucBuu-0000000Bx4E-1rfh;
	Thu, 17 Jul 2025 09:52:04 +1000
Date: Thu, 17 Jul 2025 09:52:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
Message-ID: <aHg7JOY5UrOck9ck@dread.disaster.area>
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716182220.203631-1-marcelomoreira1905@gmail.com>

On Wed, Jul 16, 2025 at 03:20:37PM -0300, Marcelo Moreira wrote:
> The `strncpy` function is deprecated for NUL-terminated strings as
> explained in the "strncpy() on NUL-terminated strings" section of
> Documentation/process/deprecated.rst.
> 
> In `xrep_symlink_salvage_inline()`, the `target_buf` (which is `sc->buf`)
> is intended to hold a NUL-terminated symlink path. The original code
> used `strncpy(target_buf, ifp->if_data, nr)`, where `nr` is the maximum
> number of bytes to copy.

Yes, this prevents source buffer overrun in the event the corrupted
symlink data buffer is not correctly nul terminated or there is a
length mismatch between the symlink data and the inode metadata.

This patch removes the explicit source buffer overrun protection the
code currently provides.

> This approach is problematic because `strncpy()`
> does not guarantee NUL-termination if the source string is truncated
> exactly at `nr` bytes, which can lead to out-of-bounds read issues
> if the buffer is later treated as a NUL-terminated string.

No, that can't happen, because sc->buf is initialised to contain
NULs and is large enough to hold a max length symlink plus the
trailing NUL termination.  Hence it will always be NUL-terminated,
even if the symlink length (nr) is capped at XFS_SYMLINK_MAXLEN.

> Evidence from `fs/xfs/scrub/symlink.c` (e.g., `strnlen(sc->buf,
> XFS_SYMLINK_MAXLEN)`) confirms that `sc->buf` is indeed expected to be
> NUL-terminated.

Please read the code more carefully. This is -explicitly- called out
in a comment in xrep_symlink_salvage() before it starts to process
the symlink data buffer that we just used strncpy() to place the
data in:

		/*
                 * NULL-terminate the buffer because the ondisk target does not
                 * do that for us.  If salvage didn't find the exact amount of
                 * data that we expected to find, don't salvage anything.
                 */
                target_buf[buflen] = 0;
                if (strlen(target_buf) != sc->ip->i_disk_size)
                        buflen = 0;

Also, have a look at the remote symlink data copy above the inline
salvage code you are changing (xrep_symlink_salvage_remote()).

It uses memcpy() to reconstruct the symlink data from multiple
source buffers. It does *not* explicitly NUL-terminate sc->buf after
using memcpy() to copy from the on disk structures to sc->buf. The
on-disk symlink data is *not* NUL-terminated, either.

IOWs, the salvage code that reconstructs the symlink data does not
guarantee NUL termination, so we do it explicitly before the data in
the returned buffer is used.

> Furthermore, `sc->buf` is allocated with
> `kvzalloc(XFS_SYMLINK_MAXLEN + 1, ...)`, explicitly reserving space for
> the NUL terminator.

.... and initialising the entire buffer to contain NULs.  IOWs, we
have multiple layers of defence against data extraction not doing
NUL-termination of the data it extracts.

> This change improves code safety and clarity by using a safer function for
> string copying.

I disagree. It is a bad change because it uses strscpy() incorrectly
for the context. i.e. it removes explicit source buffer overrun
protection whilst making the incorrect assumption that the callers
need to be protected from unterminated strings in the destination
buffer.

This code is dealing with *corrupt structures*, so it -must not-
make any assumptions about the validity of incoming data structures,
nor the validity of recovered data.  It has to treat them as is they
are always invalid, and explicitly protect against all types of
buffer overruns.

IOW, if you must replace strncpy() in xrep_symlink_salvage_inline(),
then the correct replacement memcpy().  Using some other strcpy()
variant is just as easy to get wrong as strncpy() if you don't
understand why strncpy() is safe to use in the first place.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
