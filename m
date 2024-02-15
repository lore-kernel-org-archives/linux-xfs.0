Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1698ADDD1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 07:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707982763; cv=none; b=Rn2ZKuWy2rfyoPtoq58q5sWzD2SAoaCVV86SC2TDdHiQiVa61P33GUmu4bA2TkHSsnV1Rr7MgfleeyciVtbovGR6k56pa/DpibqroN2h7qoa0yFazSsnE8u5XWDpcAmUKzqVRnCkztn4SNvshAnuKg2tYtOHUzQPyRni8na1BWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707982763; c=relaxed/simple;
	bh=IPAlCPpBbqKxlt7ubKS+75Nse25V51B/t7TitWNUarc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oy0Jd2RLAUFQjNkSnZjKWN57WPrd3lR6pVpFB5wyd4tNqNszkyiU51u6cIDMtsw478dN9DmspUwbdwr56dLAz6zo5DC1SktheK0j/jRHVXxlL+Cw0zJ2ElISnirZumcRvFNwaWgNwQFGezMuPCXkdcntKpmhKN5aqEuRv3Bek0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aeyLgxeg; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aeyLgxeg"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-607c300ad0eso5770947b3.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2024 23:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707982760; x=1708587560; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lvJlWsd/NQxCH1izVZxHrsZRRs5iE+uF6tjR6/N+5QE=;
        b=aeyLgxegAKeFIkAPT+kHlx/N5OC/BOnizI4cmVwJQMe/lMVjYFmJ1r7QGHRY2oA5a0
         mRcR58X1p7Bv9K5LkwxlwFU0jupZ6/hmheoTedCJQ3LFH+y5FT/cxYcRz22FsWUeBR7n
         NsLSVwi7BebR9nE4OxRFidgfcW/v2YGMhJRmeRb0GJGsn4XSxVpRyIpKUpwCAHlYhQMK
         8GhjKiyllSKi8hdk1daAy6UkqDtBzUeHj7WkVspJq5xqqgLKhm+sfYKUdpuzVWSa9f/L
         0+wcM4j/QPxNfAVmerSjwhqZjZlGQd3RnM/eACZ2xXQCdKAbd19fPNLswOaMRj0YY/6A
         CvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707982760; x=1708587560;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lvJlWsd/NQxCH1izVZxHrsZRRs5iE+uF6tjR6/N+5QE=;
        b=JoDL9wC7rI1N8MwGRSPdiupYhdQ0hN5r2JNjj4S0agmSxLXA+rFSsEn2qhQ5/Kbp8i
         p1ZbviiQFIenTnlsjFH8RU8EUJLE/6tXMiUDmDSuuJzkKEg8qlqaAi3gXBqs0I3Iv0Cn
         sYwfcED3AEevKClRYOp5viloBYt5C6TaQj4Snoj6fH3je6Aj3Dj5hZLZ42NHkQi7aKTi
         Wfp3ED2Nxh0ZxXFt4GNGbTJ5nKBfWmDTMf+lHWz2yewPjH3amP+wjfC760YHEuUOH1G5
         4bEhZudJbzh7yj7lz+B9B760BT0+VkOv27V+iOzIYi/yqdGirEV5K4piXMCXjtD+RF39
         GV1w==
X-Forwarded-Encrypted: i=1; AJvYcCVYtjLKyGZ2jFzdDSuBJ+HRjiiKfGOFaqkJVXcvWvpjz+gCiPTalktTOjGAqEKh83C3kkc795UN/Rkp21AGdDoyYTJheVyDhtgQ
X-Gm-Message-State: AOJu0Yz0yjWFKUCzG8kYug0NR60uIqYXumh/LZ2zJlfN8XjHQpDXtMEA
	gM0yHhzddchdQDCAKXZR+yYmRqODLlNLpeIfkNTlyONy1HaGKoHufePUda+oqc3KSpEoUDBQ9d5
	cMw==
X-Google-Smtp-Source: AGHT+IGcYcBPrH10ttvRmnWegNdswQwGFHrHDio5h0KEnV4SJOUS/RSKIpCLL4mdZMd/zrWiGOaEtg==
X-Received: by 2002:a81:8341:0:b0:5ff:796e:481f with SMTP id t62-20020a818341000000b005ff796e481fmr907128ywf.11.1707982759906;
        Wed, 14 Feb 2024 23:39:19 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id s7-20020a81bf47000000b005fff0d150adsm142378ywk.122.2024.02.14.23.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 23:39:18 -0800 (PST)
Date: Wed, 14 Feb 2024 23:39:06 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christopn Hellwig <hch@lst.de>
cc: "Darrick J. Wong" <djwong@kernel.org>, 
    Matthew Wilcox <willy@infradead.org>, 
    Chandan Babu R <chandanbabu@kernel.org>, linux-fsdevel@vger.kernel.org, 
    linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    linux-mm@kvack.org
Subject: Re: shmem patches headsup: Re: [ANNOUNCE] xfs-linux: for-next updated
 to 9ee85f235efe
In-Reply-To: <0e8d50e9-4254-7acc-e9b4-9b6ad63a25da@google.com>
Message-ID: <38716bcd-f26b-a7f5-2ef9-1ad554d42357@google.com>
References: <87frxva65g.fsf@debian-BULLSEYE-live-builder-AMD64> <20240214080305.GA10568@lst.de> <0e8d50e9-4254-7acc-e9b4-9b6ad63a25da@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 14 Feb 2024, Hugh Dickins wrote:
> On Wed, 14 Feb 2024, Christoph Hellwig wrote:
> > On Wed, Feb 14, 2024 at 12:18:41PM +0530, Chandan Babu R wrote:
> > > The for-next branch of the xfs-linux repository at:
> > > 
> > > 	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> > > 
> > > has just been updated.
> > 
> > <snip>
> > 
> > > Christoph Hellwig (17):
> > >       [f23e079e024c] mm: move mapping_set_update out of <linux/swap.h>
> > >       [604ee858a8c8] shmem: move shmem_mapping out of line
> > >       [8481cd645af6] shmem: set a_ops earlier in shmem_symlink
> > >       [9b4ec2cf0154] shmem: move the shmem_mapping assert into shmem_get_folio_gfp
> > >       [36e3263c623a] shmem: export shmem_get_folio
> > >       [74f6fd19195a] shmem: export shmem_kernel_file_setup
> > >       [eb84b86441e3] shmem: document how to "persist" data when using shmem_*file_setup
> > 
> > I would have prefer an ACK or even a shared branch in the MM tree
> > for these.  But as it's been impossible to get any feedback from
> > the shmem and mm maintainer maybe this is the right thing to do.
> > 
> > Andrew, Hugh: can you commet if this is ok?
> 
> Each day I hope to reach looking at it.  I sincerely believed that
> I would get to it yesterday, but no.  Later on today?  We shall see.

Christoph, I'd better give you a progress report, to avoid another mail
as foul as was sent after yours.

I wonder what the fuss is: Matthew (thank you) has been giving excellent
reviews, and mm is a cooperative not a dickinstatorship (but I was upset
that he caught that GFP_HIGHUSER, which I had been eager to point out).

I haven't finished yet, but made good progress and it does look good:
a few very minor comments so far, nothing that couldn't be patched up
later if that suits you best.

mm.git contains no updates to mm/shmem.c yet this cycle, so I expect
that Andrew will be fine with the series going in via the XFS tree,
unless some awkward conflict in one of the mm files appears.

Tomorrow,
Hugh
