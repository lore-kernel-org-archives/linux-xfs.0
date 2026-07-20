Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5803539A05F
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784543850; cv=none; b=euijcmk/jJuF1FZ6br61BxmjMZ0Kbk5V5VaeJJZKBWzlylIkdr2p3CAgOE5tuNY8u39J1o8V3q3DzLRt19YQrjFJ9OtMmVRC99/78DtlBf7q0muh74V0qChLPJubcjMzhtOVgFOe0slmEDwVN6CQIfQo0Fgxmec27w2Jq8wqIjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784543850; c=relaxed/simple;
	bh=HsXP1SOgYQKGRu4YP/BzK3zeihpC3V59WcJ9CVZ0944=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnuvSzkqGUdRs00JeV7JB28zY1/7Yu745m4CVN+BVl1/AVW6IcdFMa8e2I2A8zvBjE0b2cGHuhTkaeDj70HH2klecn/8eipypDTNc/eXq7eoYX/AmNinRzyAIv1gupyMe4fJQuOWzlnrDftB8efeumg7q5g+mrGZH1+Bk42AMBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com; spf=none smtp.mailfrom=readmodwrite.com; dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b=v/LWc+TF; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b="v/LWc+TF"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f7444576cso701916f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 03:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1784543847; x=1785148647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Ob60SlvDtMBq7kgwRG6216brqjU5lsAVw+EombhPOE=;
        b=v/LWc+TF3dHJ5iNfM/KrMQkku/7xqwBPwOgdQ07W+RXS7DvgyTAYPUW/6mcx1GsuRc
         +04cRzEaTxt8IOYhOlzu52hplodcbhjNqjoyb5QUCw4SgCrLh8GGQYLtOet9e36MzwXo
         BMjU0ZFBYaJm3miVqg/EOen+BxCrRVYdOWI20w51zm4UPrASqt2uaw+a+ZybdFM7iTap
         5Kxw29yPrnN+pzi8pHWa/VRTE6FfxIePhXnwEFI5xuo94mJ3e/xdLlPfXLuXi86oxwuu
         U4ugJ9zHreczmTh+UYyb4BiNIpK5u1RhleYhoeH3bv5yyXbuiITP5DtTtacybTg+IJw3
         DSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784543847; x=1785148647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Ob60SlvDtMBq7kgwRG6216brqjU5lsAVw+EombhPOE=;
        b=QAlZgDwWJKhiWarKfuIo57oubDR2xCG9h9lD4R6F8A78zO/24qM8KQC8N9eJ+LgC75
         Opo/04MPjXAxBXLEk1Zk80CWcs5WJN7snC8e6om0LMoOMFRtt7dOWnmwuoXOL3LGq4vJ
         QHIyTd61MHpDY65zryyxu6fyb+SwQkHYOWobycU4rs3He4JKSCbXjXAdYc6iOAyr8BIY
         lI8Mpa0NvTHkjijgqLAGXDGkUlrbxGpgBKDO/pViApWQWwwAf42l5GXtFgXWivEJEpWa
         A/3Eap1lgGd1GXNRK1IyXgCS8gK5ICssQ5KNUqE1P0/kkARrnX6i70yR3CW3tqvlCF2J
         as2w==
X-Gm-Message-State: AOJu0Yyp6FapZqIqX99uahBYGNrqC+XvKJ6ZLrsjjQnfsTJNYQP6RkOC
	/nFH/u5zAAS+X0qBBeTOSo0qjHr5qviQi5m1I9LSCQfzdRmPLqFYFmI1/A31neLQ1lc=
X-Gm-Gg: AR+sD13w1aBFziM6qmHWUkSyT+qXEUnE1W5TERSN0gxNCoRh2/uXUt2tHSkTrC56oHv
	CmuggAmVdykXV83UvkKI19vsK+vYtTK1VDJ/wOSiyK0HbMxo8jF4UnQZGAqM8Bu/JycoOkdJVSK
	PvunO46+KWgQlCjiub/FsuU5x8LZ84fHkhZ9yCNTHAYJOF6tjsv2UJLwY3nXUu0xdF+8Pdz9Buy
	QEEdG8sJDitcvsr/cWREh+X1G9OHGJY3KnPRaKYzjJxtYC6PkU1TBZ3ivGfK95mTR0SIa9BU/uY
	A5wMz1b5BSiDu2GtHt9B66tcF1vZp+FVR2McpYmAtI11y2N/vPFFxKpmbZTLa4z1koTRIKc/H0w
	wp4ZZdZuMVw6xN/ucxIGEGbqK61lP5NIAwWYVdjh7kbD/9YSi4IIVV5F4Ebn+eQJ6
X-Received: by 2002:a05:6000:1786:b0:46f:7d90:8125 with SMTP id ffacd0b85a97d-47f62305d3cmr15731928f8f.15.1784543847159;
        Mon, 20 Jul 2026 03:37:27 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:1cdc::2e0:ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ed2313sm28266750f8f.23.2026.07.20.03.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 03:37:26 -0700 (PDT)
Date: Mon, 20 Jul 2026 11:37:25 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dchinner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [BUG] xfs: sparse inode allocation can trip i != 1 after AGFL
 growth
Message-ID: <al33dUXS_8Yr5vEu@matt-Precision-5490>
References: <20260717130429.1838767-1-matt@readmodwrite.com>
 <alpsniDzp5kWl0xA@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpsniDzp5kWl0xA@bfoster>

On Fri, Jul 17, 2026 at 01:55:42PM -0400, Brian Foster wrote:
> On Fri, Jul 17, 2026 at 02:04:29PM +0100, Matt Fleming wrote:
> > 
> > The failure sequence seems to be:
> > 
> > 1. AG0 has no free inodes, so inode allocation needs a new chunk.
> > 2. Full chunk allocation cannot fit.
> > 3. Sparse chunk allocation can fit and passes the old AGFL minimum check.
> > 4. Removing the sparse extent from free space grows both bnobt and cntbt.
> 
> I assume this means we happen to alloc a sparse chunk out of the middle
> of a free extent, causing an additional record and thus splits in both
> trees.
 
Yep, exactly.

> It also looks like we set args.minleft = igeo->inobt_maxlevels in the
> chunk alloc path, presumably with the intent to leave enough blocks
> around for inode record insertion. I assume the above available value is
> prior to the sparse chunk alloc. It would be interesting to see what the
> same values/calculations are after the chunk alloc at the time of the
> inobt block alloc that fails.
 
Before sparse inode allocation:

   pagf_freeblks:    2514
   pagf_flcount:     8
   levels:           bno/cnt/rmap = 1/1/2
   reservation:      2505
   minleft:          2
   min_freelist:     8
   AGFL credit:      min(8, 8) = 8

   available:
     2514 + 8 - 2505 - 8 - 2 = 7

   request:
     minlen=4 align=4 slop=0
     alloc_len = 4 + (4 - 1) + 0 = 7

So the sparse inode allocation only just passes the allocator check.

After sparse inode allocation, at the failing inobt split allocation:

   pagf_freeblks:    2510
   pagf_flcount:     4
   levels:           bno/cnt/rmap = 2/2/2
   reservation:      2505
   minleft:          0
   min_freelist:     12
   AGFL credit:      min(4, 12) = 4

   available:
     2510 + 4 - 2505 - 12 - 0 = -3

   request:
     minlen=1

So after removing the 4-block sparse extent, bnobt/cntbt have grown,
AGFL has dropped, min_freelist has increased from 8 to 12, and the
later single-block inobt allocation has no available space.

Thanks,
Matt
