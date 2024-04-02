Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A5E2260B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712101496; cv=none; b=FLO1ChM2NA6dIkfdWHex+BYpI2e1s90j5V4H6zNl7hOBqUggAgXTLKNwsGGSio7KtEXyc1dLNAh2DfsQ4wccZFrpDJr6h5myOdh3mygKz6s2lNBimM6ysLtufakgb7WsqrMnp/P6Umla90lO7MBI+VRnVu5IWCfsWLINoBnwNsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712101496; c=relaxed/simple;
	bh=XgXx5l7xBch9FND6YUN58/j+pUnfvAUzLASaxvt7DIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eobuFKl19qE/JB/1GTBnbHPBjP9P3pDghsD36YBMeV/2fne7nx2viWqy5KbPkvRJJcdIwZ5Cjkw2lVVGZQwWk9C2ZCG7rDzCCoP28YBsUIi9Mu8jJHNP2c/rzbB/Xym8QEobfvAB1LmkUXl15bvWlWn3KJnOfz49qjH2v24IlCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QgLPdoQs; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QgLPdoQs"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5ce6b5e3c4eso2799194a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712101494; x=1712706294; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gmXJDhnLUqGXlQb1NpVSVFi1XoZJFS9VjjCDvCic/QM=;
        b=QgLPdoQsgVGAefgZ6aLGwwewebK2ncw39RRq7aAbkZQc3BxV2bhmU9eo3OBDFcpNFD
         wBdxueUr/3JWGoaiOQoo0qu+VQJOm+01exSQF+4/uXlodvZdN8kdVLb0RtPYRm59KO25
         0J0s5NVHXX91zsFSpqxjSK5O2R/uzmlviza2c0BVAzNv9mUG7GXaApvm6Y73PknydzI8
         262tsQ3j1UwFC3PrjwJim+QT+9b61MpQGqxkCipxnJYXRsEg9lSE4cND5vKZYDLIYkb5
         M7VXYLjjW2ORoxVMVhl7YLFesCiJkgET2+57HSwflxKzbbPKNNShVAKoUH6VcEEvqA+j
         LUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712101494; x=1712706294;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmXJDhnLUqGXlQb1NpVSVFi1XoZJFS9VjjCDvCic/QM=;
        b=SzkF4eHcp9McVuRvff7q3Qs5ZZIVaJXqIPj9zldxMVNyA6sdHUfYBhygTOkiOt5+XL
         7r+Q/s75iY8Clk2wbwN1SCo0DzY5yoxqqxdSF54BoE0pzKy8GiidlsNAxKR0sFJhQtwA
         hDVkP7TGYCC4ZjOjnpB34MZJdwzFs0MunJ1aT7r23V+HBGDjObFELN84O0Bcx1lWNun0
         74ZCrtPb7JxseN2DgVQGc2/y7CsL7XOmoqzLLJGknhKe3pRlOLtzXf4+COxqLcStd+pG
         WoCwWP7A8ebKwoUq+wOdoGmpyDqNfU+vqJgDjkKKIXXWFid2lrkKEYCUim0d01aKcsN/
         Gb/g==
X-Gm-Message-State: AOJu0Yxuh+ygS9w/trzigaeZ3N0qXltjadzpKZBU0/4/rR79v5hJtpPA
	xX1AysvFPWfcczqi/QmBp0ZndlseMqFSo57fbD7S2CTgxImmuOdTK7hy8gZCb6QiCSSbY7EkJ8u
	B
X-Google-Smtp-Source: AGHT+IGmaweiWpTyQUGhRsdbC/SsWvYfOHf7/oe68/X7L42Xn8aXnRivfKUP0bvb+7VUGbSrdk2dag==
X-Received: by 2002:a05:6a20:d90c:b0:1a6:fe01:5497 with SMTP id jd12-20020a056a20d90c00b001a6fe015497mr12099488pzb.26.1712101493774;
        Tue, 02 Apr 2024 16:44:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902f74700b001e24988b99asm6947704plw.250.2024.04.02.16.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:44:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrnoA-001tah-35;
	Wed, 03 Apr 2024 10:44:50 +1100
Date: Wed, 3 Apr 2024 10:44:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
Message-ID: <ZgyYcu7pzsGJzxGX@dread.disaster.area>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
 <ZfpnfXBU9a6RkR50@dread.disaster.area>
 <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>
 <ZgueamvcnndUUwYd@dread.disaster.area>
 <11ba4fca-2c89-406a-83e3-cb8d20f72044@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11ba4fca-2c89-406a-83e3-cb8d20f72044@oracle.com>

On Tue, Apr 02, 2024 at 08:49:09AM +0100, John Garry wrote:
> 
> > > > the problem should go away and the
> > > > extent gets trimmed to 76 blocks.
> > > ..if so, then, yes, it does. We end up with this:
> > > 
> > >     0: [0..14079]:      42432..56511      0 (42432..56511)   14080
> > >     1: [14080..14687]:  177344..177951    0 (177344..177951)   608
> > >     2: [14688..14719]:  350720..350751    1 (171520..171551)    32
> > Good, that's how it should work. 🙂
> > 
> > I'll update the patchset I have with these fixes.
> 
> ok, thanks
> 
> Update:
> So I have some more patches from trying to support both truncate and
> fallocate + punch/insert/collapse for forcealign.
> 
> I seem to have at least 2x problems:
> - unexpected -ENOSPC in some case
> - sometimes misaligned extents from ordered combo of punch, truncate, write

Punch and truncate do not enforce extent alignment and never have.
They will trim extents to whatever the new EOF block is supposed to
be.  This is by design - they are intended to be able to remove
extents beyond EOF that may have been done due to extent size hints
and/or speculative delayed allocation to minimise wasted space.

Again, forced alignment is introducing new constraints, so anything
that is truncating EOF blocks (punch, truncate, eof block freeing
during inactivation or blockgc) is going to need to take forced
extent alignment constraints into account.

This is likely something that needs to be done in
xfs_itruncate_extents_flags() for the truncate/inactivation/blockgc
cases (i.e. correct calculation of first_unmap_block). Punching and
insert/collapse are a bit more complex - they'll need their
start/end offsets to be aligned, the chunk sizes they work in to be
aligned, and the rounding in xfs_flush_unmap_range() to be forced
alignment aware.

> I don't know if it is a good use of time for me to try to debug, as I guess
> you could spot problems in the changes almost immediately.
> 
> Next steps:
> I would like to send out a new series for XFS support for atomic writes
> soon, which so far included forcealign support.
> 
> Please advise on your preference for what I should do, like wait for your
> forcealign update and then combine into the XFS support for atomic write
> series. Or just post the doubtful patches now, as above, and go from there?

I just sent out the forced allocation alignment series for review.
Forced truncate/punch extent alignment will need to be implemented
and reviewed as a separate patch set...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
