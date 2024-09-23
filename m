Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C982E419
	for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2024 22:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727131989; cv=none; b=qSFDGggk8PObzfldEREK5fVsGEorfovfFrtp8b+0ynABwLkqsygcHolzWwllaVo7twLz7zbkwF9dhm+C7eHMDFh4MR00UitOF+ORsTXfYuG0xgQaQpv27BA3qMVaq34s+IxVtC6nWCBTbO8Prd2/oafrYJt4Jk4CIh7L02eStow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727131989; c=relaxed/simple;
	bh=FsNCQM/RwOS08qx2KrsG0GEIZhW5WfuJ8AV3HIg0AnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyWMQaAKQc74JYktvbCJLrXomRsRuXggnjG7T8WVLgvj+H3Hxre/HwC3VVBoiWX6D71frR54OO3cBLDdhBpWJKxqmIWrh2U1CRCaqBVj2VShG3T5juYeULrELAJfc8XOCdHolfPCojgHEXrjIQYneHyIkALVjNY0P1P/jyZY6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FzYrDavk; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FzYrDavk"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20696938f86so38042005ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2024 15:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727131986; x=1727736786; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O9P5XLC60lNK/p8dfMcbHXQIRSzTU85TV2a/v1O9tY0=;
        b=FzYrDavkG1W5pnq60r7GF9Vf71nuFi9iM+p7r+cV5hj4Ilo8zsj41ixjuvY4xSLfXy
         fKPxKhdrQNmemZUBpqFFqC+nDH8wjaPpyhJfjqIvC6NSWOvChB/7Ma5MVNMftMSguMik
         USqcCYz78dvL1JlsKjHyNeb+/DLrQ5sj/V9MO4+dZ9BUn+gFU1ZuvTd0ysIcwl3K0aqL
         vZXIrdDQawTfthYwpgHesG/1gpYKP0X2g5RbAIHpkViaNVxXL4Md4sJc97ZBOtR+sdpe
         1BgX2wP2QYMZWfKLpWoi9aQeAC87Vcs7/vj9BsVL1+pdu7Ztl2c8+wJOgtLk1VX5ZrnE
         mc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727131986; x=1727736786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9P5XLC60lNK/p8dfMcbHXQIRSzTU85TV2a/v1O9tY0=;
        b=aIWKgQrudpB3vvl8/zvorTvJdgRg00A3ti5gKsLzBkfB7vq2t0hRVQMuH5a2ZWRMMl
         cfHPYdIzQIsa3xARsEgNvI/NurH4ZmSjLFLpGCin9caPHaUOSwFJ4OKNhZNJIDS18kic
         Vq2hkykc6UnNYHOLmB/9z1Y185ccZ7hsMPJNs4lrmg/Gh3qCW6Vhi0KQnP3r0rvk0cFD
         XjKw5TkJMX9/udwtmJt3sHEuDQ5h9wmcKvc1UJ/inVm6eFS640MVQXuyA92L69YWEQMc
         gPM8rUOSQu8jarc3dCYmf2Sj+V5XU4OjkzfzNnjgN/nxxw6Ee8Hpho3ZCrBICnUwEy6z
         +EBA==
X-Gm-Message-State: AOJu0YwYxFRUOke8iHqpZrD8zk/EaDLFLYYWEcesqaTc7BMUr/emauZ1
	IJhxDSo8P96IpufB2Zx+GwYT6wZwTrVVbI4qnGUxHN+5XJCrOnjnXuw/M/o/ywU=
X-Google-Smtp-Source: AGHT+IGqFdL5QL1D3D/7v1BdqTwc7J8Riov7Lafb0j7972QRq9FLgl3e08r+fjrZlt9IM1YhdwTlsA==
X-Received: by 2002:a17:903:2305:b0:206:9693:7d5b with SMTP id d9443c01a7336-208d988d398mr197241855ad.55.1727131986385;
        Mon, 23 Sep 2024 15:53:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af17ee05dsm673315ad.123.2024.09.23.15.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 15:53:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ssrvT-009ArR-24;
	Tue, 24 Sep 2024 08:53:03 +1000
Date: Tue, 24 Sep 2024 08:53:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3] xfs: Use try_cmpxchg() in
 xlog_cil_insert_pcp_aggregate()
Message-ID: <ZvHxTyS79BZSAYQf@dread.disaster.area>
References: <20240923122311.914319-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923122311.914319-1-ubizjak@gmail.com>

On Mon, Sep 23, 2024 at 02:22:17PM +0200, Uros Bizjak wrote:
> Use !try_cmpxchg instead of cmpxchg (*ptr, old, new) != old in
> xlog_cil_insert_pcp_aggregate().  x86 CMPXCHG instruction returns
> success in ZF flag, so this change saves a compare after cmpxchg.
> 
> Also, try_cmpxchg implicitly assigns old *ptr value to "old" when
> cmpxchg fails. There is no need to re-read the value in the loop.
> 
> Note that the value from *ptr should be read using READ_ONCE to
> prevent the compiler from merging, refetching or reordering the read.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
> Cc: Chandan Babu R <chandan.babu@oracle.com>
> Cc: "Darrick J. Wong" <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
