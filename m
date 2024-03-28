Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BEA20DF7
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600944; cv=none; b=GKTqLlTg8RimUlt692yWhCk/KikLTT8D5ICW1VHECw015LsfVE/GsjB9xStJETVL21wtmXelIjvNNzWg9QhSBbJFbpF2LsbqgTDsFiE1r1288kgP2UsH4/uTfKaXJ0C8v5aTDmT7TuZbvr2q4tN8zK/n6l07XxeTrMsMVkP9SyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600944; c=relaxed/simple;
	bh=cypJMzDNM9aQ0yAfTDp5MH7UeOIywZsQRCVP2UAeUTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOhiZH3xSWUw1X8AMkGex4QOp9BgAYCYcE5nPVnKyqpePgyLscuESxFh6nQcyFbVLSezKxARjaiOSvpRe98uVT1wdCAR/Nfi22FS4JfRASR2xdigTcboEhN7F7u444XJL04uJBPRzMOwIZHuo4IlwA+FjUh30aLY7b3z825xJTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Hzn3y2R6; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Hzn3y2R6"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1df01161b39so4894435ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711600942; x=1712205742; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvimWRuTcnfaCDmPxW4Q5Hwc/6PlFWVF8uy1t42rRjo=;
        b=Hzn3y2R6Vx04zZD2hqjkI2sY8cNKHKdypTtzB8hVSzZBospPjq0lefBF2GdanpwFD3
         6RL2BajQ6gKj4DI+Wwh2U6iX+/AZjUph1YcHvTyzL8RM8TSieeOizekY1hCUvGpK+hyZ
         dVUGbLyEIvH4u0RhgiCkRPZO7b/qjUTlW8KNFBr0+d2S3erz6B1si6yAVXly/aOLWNv+
         WIGrnMFrGHgAC0EWojPk3dxDjf5UVKP1QCodc7MJK23vjM486IdQd6yrVLDuQTR/fZuG
         SsnR3Mp5ZBtvVxKoE/kJukdiY/BlcIhsC48sq5zwU2qTh8ATt9h+FK9n4Myb+tQ9+s7P
         pyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600942; x=1712205742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvimWRuTcnfaCDmPxW4Q5Hwc/6PlFWVF8uy1t42rRjo=;
        b=Wfjs6xwNIpW0758J/prsFJYvA8gT6mr/iiaNuoROX3kA5W2U1y8jUvfkpRvx9N9s+o
         WID7f5kZ7ad5kUh3+knlcotXfLpe9097/qFf0kG6pFIY8N1ctJFsOBoBzRJy+PQmvVj0
         VkFtqIa3Ix1lKForAyPeWeC+Xj7SH6m9nvR3S9jHFMXjnwGo0oaEUbV61dcGWymD5JvW
         4RMS7SzRuSNH7GF91aA1p1cwyQrYcWtb3btU26OTHzJzZBG42OjtFKrkk1/ukGju6A+G
         r8k0Esjo0BB2Renhbsaq35aTk63JRAl+IIp6aeEDV3H2Nvk7taYocu2QSLq/1fefzn/t
         chaA==
X-Forwarded-Encrypted: i=1; AJvYcCUVh0GgM9SsKQHKSbNYz1i7ZgB566DXOKjRTWF0iITPKjsUUY6tp0sFH9DJchHSc/QEeOvB+zXQBogf3gq9m/H2eY64x810Lj45
X-Gm-Message-State: AOJu0YxD8DtDcNu9c0JgQJjnvRfzSAl7oNwORnZWyUZJsQzdfKLkn6mx
	vA1M5aFs+FBaF+Oyg5+dNkoW6JxnoJe68g1TKdJLvCgLroe+fOC30Nm08L+w9gU=
X-Google-Smtp-Source: AGHT+IEtlBYA2OP49vNj8DN/wqPsbOKbwNlzwE1qNqFMvseQqZavPoKRpeUqLFI88yR3+1j7FvbiOg==
X-Received: by 2002:a17:902:f643:b0:1e0:9da6:1763 with SMTP id m3-20020a170902f64300b001e09da61763mr2152951plg.4.1711600942194;
        Wed, 27 Mar 2024 21:42:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902bd8b00b001e0c91d448fsm428472pls.112.2024.03.27.21.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:42:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphal-00ChWO-1r;
	Thu, 28 Mar 2024 15:42:19 +1100
Date: Thu, 28 Mar 2024 15:42:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <ZgT1K2OH/ojXqcu2@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-10-hch@lst.de>
 <ZgTxuNgPIy6/PujI@dread.disaster.area>
 <20240328043411.GA13860@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328043411.GA13860@lst.de>

On Thu, Mar 28, 2024 at 05:34:11AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:27:36PM +1100, Dave Chinner wrote:
> > >  	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
> > > -	percpu_counter_set(&mp->m_frextents, fsc->frextents);
> > > +	percpu_counter_set(&mp->m_frextents,
> > > +		fsc->frextents - fsc->frextents_delayed);
> > >  	mp->m_sb.sb_frextents = fsc->frextents;
> > 
> > Why do we set mp->m_frextents differently to mp->m_fdblocks?
> > Surely if we have to care about delalloc blocks here, we have to
> > process both data device and rt device delalloc block accounting the
> > same way, right?
> 
> Unfortunately there are different.  For data device blocks we use the
> lazy sb counters and thus never updated the sb version for any file
> system new enough to support scrub.  For RT extents lazy sb counters
> only appear half way down Darrick's giant stack and aren't even
> upstream yet.

Can you add a comment to either the code or commit message to that
effect? Otherwise I'm going to forget about that and not be able to
discover it from looking at the code and/or commit messages...

With such a comment, you can also add

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
