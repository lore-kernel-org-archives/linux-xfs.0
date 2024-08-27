Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CFB1D31A2
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724795574; cv=none; b=vDDl2wJd7re4R1W1CqHxvCa0KWsNpx3uqtUEGf8x5Od34gRfJDLqTGqR3+xup78gq30aO8NanTsdjJmZUklj8YJwKgCYsCpjI+pKsEB49itHLYkMcqGbRtAMfkwnCzp+3So7Cv3wWgXpt34uLNVfxW0TzFWEz95+FRccNGBheKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724795574; c=relaxed/simple;
	bh=F9eJaJPfslQsABbYMPlicWG8jBGdvuszUyCNXzYbdWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vbe8PZKaUWer+MPuxwC/tFdcCSmpTvNvBxy1jgNdVKGyVDbEaTGjoG6SSmfznmtS2QEo1zzdGlFkY1322xO8yQFgLW7IwDTkvBKKVMKTB36wfQCBH1RKgEawonZx6usMYrXUERC044jFH9usjvkhVp/d4NHt0YGE1GLzJE/kLTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BwULrtU7; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BwULrtU7"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2020b730049so47328365ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724795572; x=1725400372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/M1fHpURSwwBqo8r/1p5kI4hufw1gAagcu4MW2tN+LE=;
        b=BwULrtU7VbjpwONFxW0lzoG+C60UAnjBOreHr7BHilW5qW05aRraqAHcoLncAa0Eyo
         Z2pYDRrtfJVusbU+XY2mAOjJXIeevLdy1vpZ/0crXmapaY0jmtRpm9Gyh87tqncsz1H5
         aldn1JtguK8fQEpvJ2M9fZ3300EcZHAefl2OmUh3ubQ0PMsa88wiRQc+oJ9rHo5lLwTp
         dC/YwYTScZTJ64PKQ63CAK7j3Z2eqcBDKt7rNGa4c10dSfwQprsmWNkOpZaBOpCO+FhY
         WaNiKMS5btEZhUWDLIrV8GYYUOFHcYfeILO1AfE2QEcSKhvmyQUDdekQmLOQAYJgq3rf
         WGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724795572; x=1725400372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/M1fHpURSwwBqo8r/1p5kI4hufw1gAagcu4MW2tN+LE=;
        b=vy+azy3gESeOpRQ+d02+rLSCChIFtOQni5iMWMO4D5KU/zbro8MRnsJB5cmF/7x81h
         wA7/DpFwnoxJRWthFkUu6GtiFR4klq03KXncrfjnjm0exRVivJMq/CkXGxIXzeNk4JEv
         TDdw8ddwtFYFhiIeIN3kFGEKTcUi9zXGJN+ipMJ1ZEe6GyzymKm0QBCFGkCyBNQOI+0Q
         m3SXGbWpnJ1aUKEQgsgs4AzKElmQnoHNK4DGlI9gOdWyzlZyGQAgCuYxVPGd+Xxsg3lh
         2YisBj3oc1EtFbVd+0yzWhiznfsnd3ewnYaOxpWAzhR3syksnVAP45oETO4+IZRTmIb8
         sHng==
X-Forwarded-Encrypted: i=1; AJvYcCUIQ5odTRfd5JxSMwVUMimocnA0l2c0TmOVjIqKv5XhuGUVx5IgTxcQjmhDZC3UHy6OLb1TrJa5cJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyT/vzlXp5S/bxCO4q3N1SdmO2MLbZfUwrc6IPlFIhk00/KRS4
	ZL1ZJ0Zi36l/F05LJPaW8AKoFGdnMUkReF4nx+CnPkVclWuQ3m6Wpvea2j1kX1g=
X-Google-Smtp-Source: AGHT+IF+l/Yr24UpWSDycaYUKuwZYtYB3TRi9xwhgAV0qI8D/eV7IxV5dcGydnob4/mD5VzxYhwKCg==
X-Received: by 2002:a17:902:d2c6:b0:202:2cd5:2085 with SMTP id d9443c01a7336-2039e4b4b90mr124965715ad.32.1724795571871;
        Tue, 27 Aug 2024 14:52:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038560a05dsm86950205ad.214.2024.08.27.14.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 14:52:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj47M-00F0au-2l;
	Wed, 28 Aug 2024 07:52:48 +1000
Date: Wed, 28 Aug 2024 07:52:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <Zs5KsPEBZFkzG2Pb@dread.disaster.area>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <ZslU0yvCX9pbJq8C@infradead.org>
 <Zs2jpYJHBtYqSMmD@dread.disaster.area>
 <Zs3G-ZrwPsOjuInE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs3G-ZrwPsOjuInE@infradead.org>

On Tue, Aug 27, 2024 at 05:30:49AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 08:00:05PM +1000, Dave Chinner wrote:
> > Hence the only cases where the item might have been already removed
> > from the AIL by the ->iop_push() are those where the push itself
> > removes the item from the AIL. This only occurs in shutdown
> > situations, so it's not the common case.
> > 
> > In which case, returning XFS_ITEM_FREED to tell the push code that
> > it was freed and should not reference it at all is fine. We don't
> > really even need tracing for this case because if the items can't be
> > removed from the AIL, they will leave some other AIL trace when
> > pushe (i.e.  they will be stuck locked, pinned or flushing and those
> > will leave traces...)
> 
> So XFS_ITEM_FREED is definitively a better name, but it still feels
> a bit fragile that any of these shutdown paths need special handling
> inside ->iop_push.

Agreed, but I don't see an easy way to fix that right now because
the shutdown behaviour is both item type and item state specific.

I suspect that we'd do better to have explicit shutdown processing
of log items in the AIL (i.e. a ->iop_shutdown method) that is
called instead of ->iop_push when the AIL detects that the
filesystem has shut down. We can then define the exact behaviour we
want in this case and processing does not have to be non-blocking
for performance and latency reasons.

If we go down that route, I think we'd want to add a
XFS_ITEM_SHUTDOWN return value after the push code calls
xfs_force_shutdown(). The push code does not error out the item or
remove it from the AIL, just shuts down the fs and returns
XFS_ITEM_SHUTDOWN.

The AIL then breaks out of the push loop and submits the delwri
buffers which will error them all out and remove them from the AIL
because the fs is shut down. It then starts a new walk from the tail
calling ->iop_shutdown on everything remaining in the AIL until the
AIL is empty....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
