Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E1F12C54B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 00:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726444826; cv=none; b=IlNsj2Tc+MEB2yKZ0fkRBh6uyl1etFVDIKe45D/KdDJxQ2vUsPyM/GLOsk35e7E5yxCGQ88/SVeSJgZ/Fl0bLODB0iM9uQk2OxDCgmQHOGDnNHwhPECWfmI85ElM0qDCNrlf2XsHNdoxCOxiqzfXICa+3HuQOIa7309faI+lM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726444826; c=relaxed/simple;
	bh=Bk6VaLA8U1o7y/shFK8tVIvvxwhrWjMjA7XJdgB4N/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLEQv0Q2qFhZwYriRa5yy+tfsPLMejka9ARN8ZeGxtDuHIE2ZephL8L3vR5+tG0vj5nljnid/4C0HdeFFQW/IwAe2xBu8zHEywC1zLRM1SyRws/hP0vQ4pI4z9O3BLPda9bukeP5n7VpmSkye930Axvw/lP3ywSmsljKjbTIjvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=vzqR1C31; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="vzqR1C31"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-206b9455460so29063935ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2024 17:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726444823; x=1727049623; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yiTneBRUQz0c7oUx85pbwoHLabaV+URnFTxx3H0XSE8=;
        b=vzqR1C31Sg/hV/NjWigbAilwrJmsR5cWrqtjxhcEV0xyDmEm8cO/ObzAmNkKZmVLrp
         Zqd/GIe/AANdpQuocF9looSLsZxMxxrgImVK4jawbg0uYlTMDCx6yWddS1L+7LoMbBqh
         X2MQX+m5tGMUjyOrzDxA5m21JiiAUvIDEan8lZJKYss5RN1nT8GLN95OmLr586jiNA4c
         cvxbgOhs0nxZBJSqvuHOWd+TIKPWfSNk/mhlpMYC4pgYPxIAXqHlokgd3tZbzCVNAVfz
         Um5smzbm87vsfOcmz/lqiA/GWbl9P5Uz+xC/BdWw83Q4jPFMlvcVxjvcZwgKbktJJFaf
         qUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726444823; x=1727049623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yiTneBRUQz0c7oUx85pbwoHLabaV+URnFTxx3H0XSE8=;
        b=rO2cKmYgP/1EUpdkreReHjGL/qd+3lbXBpmgvIb/Nrro3iRarnVATCR5c9z5nEOiW8
         2JSNcqiNwx2u5PUXJc8llkjmIUWvEVUr8e6U0XpKYm8B+lnrIXs1CXJvNDo9VGOebgod
         gdsmvSnN4zktcxucfj8BwfItE/P0VadeU1eY7eIB+UcQdSqAZFO/FAyt5K98s7fL8xIF
         IheqLuVSb/OS3tdqE+vlijbb0NpU/lxM9E5L9xZAGaZIfS6qRizN7wZhE/TsrfL3pLHm
         Tdas6azJeGdZa1tLuLd63bc5MrLfvEb0SqI9+wUFZs6f3aWxCWAkMhUqHCa8PHm5lox/
         9g2g==
X-Forwarded-Encrypted: i=1; AJvYcCUbhSjVxwb2kLmAghmjzyplBgE0gKCwi4jhsaS8mCxto3kHz4Oo1rYiLXfhCGzZUjnDKyucUTm+kqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxpDwlwK9PwSCGNRdi+qXx1Eb0DKa0mVeAe20Ca3DcYY9mzBvj
	AYuf1qglj5dHxJy2OfQ6ZsG2iPYTTbNCRxcz3nXsU1OfKjBcL2VIZgOnS4dADXE=
X-Google-Smtp-Source: AGHT+IEL1eQKv3NuUXB18zqkV0UW1Ie5TJSdwTXsRLrQ2G5lCXlhwJhgyjhFRZZ66d6/+lADVVDKkA==
X-Received: by 2002:a17:902:ce92:b0:207:6d2:1aa5 with SMTP id d9443c01a7336-2076e591737mr218814085ad.13.1726444822748;
        Sun, 15 Sep 2024 17:00:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207945dc76asm26908985ad.42.2024.09.15.17.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 17:00:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1spzAA-005hUa-2C;
	Mon, 16 Sep 2024 10:00:18 +1000
Date: Mon, 16 Sep 2024 10:00:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Dao <dqminh@cloudflare.com>, clm@meta.com,
	regressions@lists.linux.dev, regressions@leemhuis.info
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
Message-ID: <Zud1EhTnoWIRFPa/@dread.disaster.area>
References: <A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io>
 <ZuNjNNmrDPVsVK03@casper.infradead.org>
 <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
 <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>

On Thu, Sep 12, 2024 at 03:25:50PM -0700, Linus Torvalds wrote:
> On Thu, 12 Sept 2024 at 15:12, Jens Axboe <axboe@kernel.dk> wrote:
> Honestly, the fact that it hasn't been reverted after apparently
> people knowing about it for months is a bit shocking to me. Filesystem
> people tend to take unknown corruption issues as a big deal. What
> makes this so special? Is it because the XFS people don't consider it
> an XFS issue, so...

I don't think this is a data corruption/loss problem - it certainly
hasn't ever appeared that way to me.  The "data loss" appeared to be
in incomplete postgres dump files after the system was rebooted and
this is exactly what would happen when you randomly crash the
system. i.e. dirty data in memory is lost, and application data
being written at the time is in an inconsistent state after the
system recovers. IOWs, there was no clear evidence of actual data
corruption occuring, and data loss is definitely expected when the
page cache iteration hangs and the system is forcibly rebooted
without being able to sync or unmount the filesystems...

All the hangs seem to be caused by folio lookup getting stuck
on a rogue xarray entry in truncate or readahead. If we find an
invalid entry or a folio from a different mapping or with a
unexpected index, we skip it and try again.  Hence this does not
appear to be a data corruption vector, either - it results in a
livelock from endless retry because of the bad entry in the xarray.
This endless retry livelock appears to be what is being reported.

IOWs, there is no evidence of real runtime data corruption or loss
from this pagecache livelock bug.  We also haven't heard of any
random file data corruption events since we've enabled large folios
on XFS. Hence there really is no evidence to indicate that there is
a large folio xarray lookup bug that results in data corruption in
the existing code, and therefore there is no obvious reason for
turning off the functionality we are already building significant
new functionality on top of.

It's been 10 months since I asked Christain to help isolate a
reproducer so we can track this down. Nothing came from that, so
we're still at exactly where we were at back in november 2023 -
waiting for information on a way to reproduce this issue more
reliably.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
