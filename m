Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA7A158DB3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 23:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719962992; cv=none; b=CXgdlCnBhYn0SsT8bmiV/e06RBxPqLUme0b0p6P/39OEFshpt5qwTPpXSh2SCGKgiVI/YkThbIvGIaQwTIxG7sFx8T4OY7PtTYAHKCmslQP8sSQ7pte/p+PN5oQhtp6c23UvCqAHdMS+trhb6SuAj7mGb4LhVi7o2VIABj8Yx8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719962992; c=relaxed/simple;
	bh=8s8qx7JCSl2JYveeahiI4lXD+T3Kd+Us2HLlXrWV0a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qay3SRIPStKJToK6dpif4VPc5MmiKOGLDtu3tPDF87TIlyz038bJa8b9ircdw88FftFc8V6Jksf45KTxSpBL7zGmw98Pmk/dYik7YVB7xEm+WeyHzDK5CRYqde0/TS8Fb7L3YAWnksE/I1rTjPiQX7UaRUZypeZQeqD0TgQReaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OMNivxKP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OMNivxKP"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-70670188420so3318807b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2024 16:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719962990; x=1720567790; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRDj6iqOEgCNFgUc2BG++nyEKcuOuuuTQsCxg8vR83s=;
        b=OMNivxKPlOBwHWBJrs1BjLvtUpi8Tdaii8+qNjex8WmC0QN3dtyFBOKCF4UKQhjf+Z
         knv3xFw/klnQX8xunpbeL07oWNdzs00xMTQY6kvvAheNw3BOo658YJbeHRfuVkrbx1ib
         TC8GLpjLrM1dTq5LLhE8/Z5ZT8c8jJFT2JnS11nTyyCI2PJ+5XxWwM7h1MF1lnb1IZyR
         QoghtUh5n8s5ZLTHtlm/aNJbHng/Vmgj5fJJDwj4R7btB+1QHFlgo58Nnivbphn2aqff
         nxa8L45/gt9KBYB5C5EbJA3HLPcbS9B+TUUaK5ZAVsY05LVMOoAro0p4Gfj8r4xi51Oe
         fGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719962990; x=1720567790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BRDj6iqOEgCNFgUc2BG++nyEKcuOuuuTQsCxg8vR83s=;
        b=X35J9BYMI2FV9zc5DPTw6jQosJL6uZ35NNGq7GcQsPjIdRqcmjD9kPo23qUUEmaDrH
         +Uy/OVX07nCKUpDWEaOkwR7kRFdRafpiYigbny1xZwF3tquLZJ2Jne6WbjaxOubxOyLn
         WB80EocjS6+lZMRN/4Lk8BFdEx5Fq5pOrZGFNqyBsRpP3sRFMkAJC1Jptt6nYIWImv9t
         rvlUZ78O5jSPulBKZGYsXW6AhaBdRSem6qKPoBKWqaEVxVpDE8RR+zh4sBFltT/tR73/
         1M9ACLvbOM22prMWLj1Lsrz7sC/H2CrRWQNXVuN/+vA2hYTNUvXcnCZ2odd27MEkg2sK
         WrrA==
X-Forwarded-Encrypted: i=1; AJvYcCWBDHTqrdv9VKByw8UkdP/wc698VfMLY6iq05lXikc3eAMpQ85+A8QDjzFYZpAIZ6RnHDRkNhAE0bu9q/+Na4VnJeq5lUmbqsgg
X-Gm-Message-State: AOJu0Yw5MbaDCcdWXDupcim/P4bvh6UaxjpMjSzstaKqJjmJ6mexcJtt
	Nxag3M6qhjPmDlSflV5DhmSNf16FX6eVeVPupZmUyLyrBw8Pcg4P0NVj75dQWKlsHMKBR5e6ndE
	j
X-Google-Smtp-Source: AGHT+IG7i9ZMuKLjBYxWpHibyH/CA7xxXaTPFyqaj9161HoryL8UDr3uwUtb7U010eP6kkIYUU4Nqw==
X-Received: by 2002:a05:6a00:1388:b0:705:ccec:5eb2 with SMTP id d2e1a72fcca58-70aaaf08de8mr10207275b3a.31.1719962990268;
        Tue, 02 Jul 2024 16:29:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70803ecf652sm9404031b3a.99.2024.07.02.16.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 16:29:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sOmwV-00225S-0V;
	Wed, 03 Jul 2024 09:29:47 +1000
Date: Wed, 3 Jul 2024 09:29:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: skip flushing log items during push
Message-ID: <ZoSNa2NkSVKb3ecl@dread.disaster.area>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-12-hch@lst.de>
 <20240620195142.GG103034@frogsfrogsfrogs>
 <20240621054808.GB15738@lst.de>
 <20240621174645.GF3058325@frogsfrogsfrogs>
 <20240702185120.GL612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702185120.GL612460@frogsfrogsfrogs>

On Tue, Jul 02, 2024 at 11:51:20AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 21, 2024 at 10:46:45AM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 21, 2024 at 07:48:08AM +0200, Christoph Hellwig wrote:
> > > On Thu, Jun 20, 2024 at 12:51:42PM -0700, Darrick J. Wong wrote:
> > > > > Further with no backoff we don't need to gather huge delwri lists to
> > > > > mitigate the impact of backoffs, so we can submit IO more frequently
> > > > > and reduce the time log items spend in flushing state by breaking
> > > > > out of the item push loop once we've gathered enough IO to batch
> > > > > submission effectively.
> > > > 
> > > > Is that what the new count > 1000 branch does?
> > > 
> > > That's my interpreation anyway.  I'll let Dave chime in if he disagrees.

Yes, that's correct. I didn't finish this patch - I never wrote the
comments in the code to explain this because I don't bother doing
that until I've validated the heuristic and know it mostly works
as desired. I simply hadn't closed the loop.

Please add comments to the code to explain what the magic "1000"
is...

> > <nod> I'll await a response on this...
> 
> <shrug> No response after 11 days, I'll not hold this up further over a
> minor point.

I've been on PTO for the last couple of weeks, and I'm still
catching up on email. You could have just pinged me on #xfs asking
if I'd seen this, just like jlayton did about the mgtime stuff last
week. I answered even though I was on PTO. You always used to do
this when you wanted an answer to a question - I'm curious as to why
have you stopped using #xfs to ask questions about code, bugs and
patch reviews?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
