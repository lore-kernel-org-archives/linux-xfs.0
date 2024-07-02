Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267091DA322
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 23:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719962136; cv=none; b=MV71dC2JWL9hVFa6lByWLoahY4Q1fxBYXfvI9QXbVRN4tGgWgDROZq66SCuNgrbZn1uxlI60tcOgWtK0O31cq9bfzUOiV7sZ82bUPGu2JU9ITzxEXzlskNOPmd+PwcX35LN83jDqPS74R0r0R4ge6+jDASCzihbYET6M1MvAMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719962136; c=relaxed/simple;
	bh=CKjOFFunJqGNiZGXdI7kysYp9JZ60/5wkuh7Vdn0BoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlAuVu0ssH++Un4e+WAguqGO8XS8zDcPaVYDVOz1/IRifV+3vdY+cUPatbitpMPfNdMeGkKXnepLw1yROMt7d7iFp7FCVh1lBAjGwLfDFOfQJPNhTZ+WINuFbTvECnpZ+Hfzu4qqTWzU+vxO+penoDuUDLJcmBBs8tsHFtyvPk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BeZ2Z3AJ; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BeZ2Z3AJ"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-25957dfd971so2238293fac.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2024 16:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719962133; x=1720566933; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xSBo+zf7ftD/pzZ2ox3TeKzd33ehLitXIebgTtcS6h4=;
        b=BeZ2Z3AJuIg2hxEASGddk+HusK9DaUTt2zQVzEiOfznjTxSfs7v+rALXKtgRERC57X
         12uqYOXgjHT8zLvAU0z0hR/nECoDhrn1/PpfNlUlR43hj2HOc/bSKrGgVdumh7vZAQ/P
         G2gAPiDWZFpuqe1ru7AnePlqisMHPA92zaYuA5M7ZLlMlUGGkFqrWNojNa801JpT2cYW
         6KL5m3TSd8QBM8h3aPxmPUXiR2tJpRQWPzamvqxNjrwVnNdGbKcRclWqRLG9Qy9bZwFY
         PlAA0Mx9SE2vkP9wm/l3WF9QvhVU2IdbX34YwN3kCcrBKg0flhUZ4Wegy4OuMRN/BzDf
         3SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719962133; x=1720566933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSBo+zf7ftD/pzZ2ox3TeKzd33ehLitXIebgTtcS6h4=;
        b=C0sB0+cpoh5Cnx/iOMDDP7CWENLOLLudnr4qKTGALf8CDwL/aG4iovsgR1VFCE2jNB
         w+omxoh0QQxfAPcQI93wK3f2UxdGRWX43lUIAj2Uo5kRofd5QRnuwF3gK7ASJ7YgBWRP
         zNo6zPjlwDmOP5L+XwPKRPYLTyaWxVAYOHph4wI6W9nP32J2lCn0sH1F5+P2JL/nojv7
         I/kfsThfdBHm6NmrGlGwi2VBBoo/SuFlRh29SlNI5QzNI1R4SNA+Rc6ldYUq6/DMP9eG
         l9YXpeeOe3QXmJ2ltRL4WT0phalxn669Bneiy9DkKAcPKGF6tZTZUBEgOelMKrByk8Xs
         4kAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJkGK3qNlHQnmMFihVGgSRFY2BZ6kdv/g5O6mNwyF/C8+prXCuZhuAjmdhUYp7G2WUxIT2xWIfVqn7EHj9bVXN3MXZFGjrtMSz
X-Gm-Message-State: AOJu0Yzr7cBtVIN/m4GJoB78qtVkEuKprJyax22iuICfRNvgSqqHOmbV
	qqmT/wYb+G4ReH8q12ljW9CsMXBmzz290d6TzoQhCNvriJFeQmwOFDVhxChDjq0=
X-Google-Smtp-Source: AGHT+IHz3JIxliXKvmYwNvZYCPHJCGpk8RQcl1jar1bw/R9bTzqBYeUNz8fXDcSR4s9IfYiQgNa9dg==
X-Received: by 2002:a05:6870:4195:b0:25c:b3c9:eccd with SMTP id 586e51a60fabf-25db35d90d3mr10470699fac.42.1719962133181;
        Tue, 02 Jul 2024 16:15:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70802566511sm9121470b3a.75.2024.07.02.16.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 16:15:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sOmig-0021FG-0k;
	Wed, 03 Jul 2024 09:15:30 +1000
Date: Wed, 3 Jul 2024 09:15:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Trond Myklebust <trondmy@hammerspace.com>
Cc: "bfoster@redhat.com" <bfoster@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: enable WQ_MEM_RECLAIM on m_sync_workqueue
Message-ID: <ZoSKEvqqy3B4uxm7@dread.disaster.area>
References: <Zn7icFF_NxqkoOHR@kernel.org>
 <ZoGJRSe98wZFDK36@kernel.org>
 <ZoHuXHMEuMrem73H@dread.disaster.area>
 <ZoK5fEz6HSU5iUSH@kernel.org>
 <f54618f78737bab3388a6bb747e8509311bf8d93.camel@hammerspace.com>
 <ZoP68e8Ib2wIRLRC@dread.disaster.area>
 <d1af795e3aa83477f90e4521af7ade3a7aed5d4b.camel@hammerspace.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1af795e3aa83477f90e4521af7ade3a7aed5d4b.camel@hammerspace.com>

On Tue, Jul 02, 2024 at 02:00:46PM +0000, Trond Myklebust wrote:
> On Tue, 2024-07-02 at 23:04 +1000, Dave Chinner wrote:
> > On Tue, Jul 02, 2024 at 12:33:53PM +0000, Trond Myklebust wrote:
> > > On Mon, 2024-07-01 at 10:13 -0400, Mike Snitzer wrote:
> > > > On Mon, Jul 01, 2024 at 09:46:36AM +1000, Dave Chinner wrote:
> > > > > IMO, the only sane way to ensure this sort of nested "back-end
> > > > > page
> > > > > cleaning submits front-end IO filesystem IO" mechanism works is
> > > > > to
> > > > > do something similar to the loop device. You most definitely
> > > > > don't
> > > > > want to be doing buffered IO (double caching is almost always
> > > > > bad)
> > > > > and you want to be doing async direct IO so that the submission
> > > > > thread is not waiting on completion before the next IO is
> > > > > submitted.
> > > > 
> > > > Yes, follow-on work is for me to revive the directio path for
> > > > localio
> > > > that ultimately wasn't pursued (or properly wired up) because it
> > > > creates DIO alignment requirements on NFS client IO:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=nfs-localio-for-6.11-testing&id=f6c9f51fca819a8af595a4eb94811c1f90051eab
> > 
> > I don't follow - this is page cache writeback. All the write IO from
> > the bdi flusher thread should be page aligned, right? So why does DIO
> > alignment matter here?
> > 
> 
> There is no guarantee in NFS that writes from the flusher thread are
> page aligned. If a page/folio is known to be up to date, we will
> usually align writes to the boundaries, but we won't guarantee to do a
> read-modify-write if that's not the case. Specifically, we will not do
> so if the file is open for write-only.

So perhaps if the localio mechanism is enabled, it should behave
like a local filesystem and do the page cache RMW cycle (because it
doesn't involve a network round trip) to make sure all the buffered
IO is page aligned. That means both buffered reads and writes are page
aligned, and both can be done using async direct IO. If the client
is doing aligned direct IO, then we can still do async direct IO to
the underlying file. If it's not aligned, then the localio flusher
thread can just do async buffered IO for those IOs instead.

Let's not reinvent the wheel: we know how to do loopback filesystem
IO very efficiently, and the whole point of localio is to do
loopback filesystem IO very efficiently.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
