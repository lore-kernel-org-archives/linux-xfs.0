Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E7C430794
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785416784; cv=none; b=dqmvecNh2wI6ORw0wYoy4eRy9yGCSrqBs4i8vdQ1pjtSaCPNW331qRTfF9G7Xptl3gmj/ljLf6KQxP2lBNEWjMX262UkXPc8qsHfrSnSxDhuA8uTpOM3WWvtf3e1qU0F2t6B8GuzLQU4E6cvVnZqc0j/dlWZssnmj6ijSs/fHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785416784; c=relaxed/simple;
	bh=r4K3ZVt18WAGvJtyk/TPvennSIuJFefaDJtGXcRDTjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pi10tF+ptpnslQF97fMLaxS6B9bQR6mm29CgKtW0ipkkxqi4xvfziqAq4djdlNA2hyJY8iHNTmHp3ybJ7EkdsMTv1J7+YtM23cE9iLsoBNFnIrrhSo2fM6FRu3vpQx3nCV9I5S1uhWPSa3YKfDdBCJJA7wsABZYK1/LiK7/+kn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com; spf=none smtp.mailfrom=readmodwrite.com; dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b=qJMJYVjX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b="qJMJYVjX"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so12597965e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1785416781; x=1786021581; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sxXEd+HzJtwi1wb5EKcD7k+cVu9vp/hmZ7y5pUznXvs=;
        b=qJMJYVjXUHnjicG7z7fH1ka+sksga/NP0pOe7FFngqlI+7GH+vt9ZXpzbQQtWYynTX
         JShA0VOGVLBLxFJlKaghABdTsi2tnpLWYxqulr1qAFazGgv5nEGP1GYvjsae1Z4r0Fhq
         f21ZRTEvtF613bKxXHtl8xW1fCYAkFdYuw2u2cfRnPuItvB9YLK4iFEr8ix7rzd4dZJM
         vKxCq6yhz3t3tCGVzD9z3nGUIh9bMd6yryJtvrgbUF7rtpSHfMaP6m9McATMki78dzEC
         oNOxsynM4DsmCokAYKXLpisJqe/jt0/zJSir771QasP31BBldusQt9quiuDbBxFKiPmI
         dHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785416781; x=1786021581;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sxXEd+HzJtwi1wb5EKcD7k+cVu9vp/hmZ7y5pUznXvs=;
        b=gYhbdTMUqY82xAoM0Vmg6hAr8T19e1EVd5/056McPBlc7MwGO1XX3aoeVHpxhyBwxo
         dH9xf6HtE3p3vDgYpZ1FHrReQ4qWgU66PZaaZx0mbeHsy1lJKJv4+6qWWVJxvjhfHrAW
         /LKUcf30gzxwFVgCuMn7V8V8N7IAXobe23f9ZfkzAiuSbD9+yf30u8oW44evFD32Mpex
         ZmmHqCkxs0ucM67FYhgDCo+NFAk1qup0Epk0RWtOULZ7g1CS5pILzsBL2LA+hEATeVl1
         xUhW1rrxBBMHQeNJSUZpfeMZekkqeJ5HP+jr8g4xGoEg5id6gZByIZcFdEkQKa+t+9d5
         ENoQ==
X-Gm-Message-State: AOJu0YwRTxNoMRYTE8EzJqKwoTRKWiA8pHk31Hfi1CB+wZr1pTzXkOOd
	aHj0hjVSvRlBmwzOO6+ONsLCAJIGpKa8X/oIh92psx87O4LoFeI71rmTJMbaTQ02S+M=
X-Gm-Gg: AR+sD1152AGbKS3153NuJtNtskBZAOoJ62K1TK7aAFzFqxurT9/aILHqWIxE/FL2BG+
	UBh10ZONNIkaQLHhPYnq6+DuB8uPRoC4v+6qKVBjf4biJn6Gkd0rhG8XECfYCjn4tmfkjUoBhW1
	a268qvVjO4MesNZb58pwVp9+PYrLtKCwLjR4/JtWu+ibPcPwyQUg0PezenpiTMoZHzZZNhtyit0
	mOy4VFO6UFJ9w25GdWckOQ48yu7qr9LgNP5qCtQlijFUKbmmvynPGbr8FCVzf6AQLJOeVrfHUVH
	gXbTicGUBSqXzEUd/TwIRPqXFmKF8juXPAY+v2EFcMN01+M+3E4fo8jCKfn3FE14KGfhQGLYvc5
	YDPmQi8W1QLuHqNZ5ebonlFyvllodxynT744a3J2z2g+iDGmBnMWgdihmkX5c8S3+jiVVfoUJWu
	avZrbXOdeOGXsnOQB8EEguqcN+RPEZig470YoE3eZdINilpRk=
X-Received: by 2002:a05:600c:8209:b0:495:6b8a:5227 with SMTP id 5b1f17b1804b1-49800ebed12mr33012005e9.23.1785416781243;
        Thu, 30 Jul 2026 06:06:21 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:ebe::178:11c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc892cdeasm6356992f8f.22.2026.07.30.06.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:06:20 -0700 (PDT)
Date: Thu, 30 Jul 2026 14:06:19 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dchinner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [BUG] xfs: sparse inode allocation can trip i != 1 after AGFL
 growth
Message-ID: <amtFONut0xhq8qTP@matt-Precision-5490>
References: <20260717130429.1838767-1-matt@readmodwrite.com>
 <alpsniDzp5kWl0xA@bfoster>
 <al33dUXS_8Yr5vEu@matt-Precision-5490>
 <ampLZcB3CAzLPKV5@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ampLZcB3CAzLPKV5@bfoster>

On Wed, Jul 29, 2026 at 02:50:13PM -0400, Brian Foster wrote:
> 
> I want to think about that a little more and need to run more tests, but
> unless something better comes along I'll try to post that soonish. BTW,
> I had to make some tweaks to the reproducer test to make it work on my
> fedora based test vm. Is this something you plan to post for upstream
> inclusion?
> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/tests/xfs/842 b/tests/xfs/842
> index 9e694a56..5455998f 100755
> --- a/tests/xfs/842
> +++ b/tests/xfs/842
> @@ -293,9 +293,9 @@ inspect_unmounted
>  read -r free reserved used <<<"$(ag0_reservation_state)"
>  reservation=$((reserved - used))
>  outside=$((free - reservation))
> -bno_level=$(agf_field 'levels[0]')
> -cnt_level=$(agf_field 'levels[1]')
> -rmap_level=$(agf_field 'levels[2]')
> +bno_level=$(agf_field bnolevel)
> +cnt_level=$(agf_field cntlevel)
> +rmap_level=$(agf_field rmaplevel)
>  flcount=$(agf_field flcount)
>  bno_recs=$(alloc_root_field bnoroot numrecs)
>  cnt_recs=$(alloc_root_field cntroot numrecs)

Thanks for catching this! Yeah I'll submit this upstream.

Thanks,
Matt

