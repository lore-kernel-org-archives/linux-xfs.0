Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZL8b3CPx"
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EC51B9
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 13:28:04 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cf7a8ab047so26739495ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Dec 2023 13:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701811684; x=1702416484; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Of9j2vHhaRBkiVjW9IW/XiQ74OYXhzoZNMT/8wOc5M=;
        b=ZL8b3CPxo1FXgCHHLdKnFK9kwLXJsbR5wt/jbXlaXpexRF82UVOXleB0aKxXdICtYi
         boUoinem+FiBovflRPBkFk2OQwfZljFpRvcjl5wQrGnd9L+dzzouxVrE1IJjPxzuUSMx
         8rZL7gcmczdncTw5Pc7i+DlkS81QiAmHJmTpG623U7vn3sFUV6Xf3edE9Xtj8GWXOUOS
         ApVGXsjs9mxgSiftFJQPdejB5ewhh7MEuSOAPevYN96qhUsrlXFy/liB6bcjzYW0vbFs
         B0/1D2wWSjlAOcvwDdw/n1f3TQ0svUApVA9zLdNuNCPcKmmni2vbzrZO6kaJuFxwbxrr
         2qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701811684; x=1702416484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Of9j2vHhaRBkiVjW9IW/XiQ74OYXhzoZNMT/8wOc5M=;
        b=ZoIK5HaLyLtywwpKCy7La7d46cKctL9lo4Apd5ITaYMo7/Dh2xRC4JPqDQxJf3J+IJ
         o4yKCW/kGyx57ZvrVga3ik7V0sEWSrpoC6P5nrgckNg76zFl4BOUTJFSF7Ox/IVbiJRd
         +68hAerWklKOX/ltqs4tS5cGarQ2dJJdKTHEvF4oo8ZB44v66qijkEr7eyvrjvvwys14
         xB53X/716jE3EWOPP2Lp6AaNJu1cx0B5rT141R+lcAH7QFTVf5NFYBeU1+w/sncmuTve
         r2QMQAg4fwemd32rMi79YMITkvC9pslsW+znmti3l0bbovEbHtzrvbZf8uXi0u+gLfOf
         0fgw==
X-Gm-Message-State: AOJu0YymYjzaAaLHEazWk4jHHempFIb8yciVUu38I3ngrSMnpEjoH6Q5
	BRV/5fTXB7Bq1q6VmzoZmdFXsg==
X-Google-Smtp-Source: AGHT+IFGMNTxjq7pnruc79tXJxf5k+28baxIZrJiXleFZaKpuVTHLto4ZD7NHsNbazo6YbXsm6enXQ==
X-Received: by 2002:a17:903:32d1:b0:1d0:bcd5:90c with SMTP id i17-20020a17090332d100b001d0bcd5090cmr2486252plr.107.1701811683848;
        Tue, 05 Dec 2023 13:28:03 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id v21-20020a170902e8d500b001d0acd4e707sm3780674plg.176.2023.12.05.13.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 13:28:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rAcxU-004LVg-2e;
	Wed, 06 Dec 2023 08:28:00 +1100
Date: Wed, 6 Dec 2023 08:28:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 1/2] xfs: add lock protection when remove perag from
 radix tree
Message-ID: <ZW+V4N5KcBiQa6//@dread.disaster.area>
References: <20231204043911.1273667-1-leo.lilong@huawei.com>
 <ZW6ofJp3zRn/X3Mc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW6ofJp3zRn/X3Mc@infradead.org>

On Mon, Dec 04, 2023 at 08:35:08PM -0800, Christoph Hellwig wrote:
> On Mon, Dec 04, 2023 at 12:39:10PM +0800, Long Li wrote:
> > Look at the perag insertion into the radix tree, protected by
> > mp->m_perag_lock. When the file system is unmounted, the perag is
> > removed from the radix tree, also protected by mp->m_perag_lock.
> > Therefore, mp->m_perag_lock is also added when removing a perag
> > from the radix tree in error path in xfs_initialize_perag().
> 
> There really can't be anything we are racing with at this point.

I'm pretty sure that there can be racing operations. Lookups are
fine - they are RCU protected so already deal with the tree changing
shape underneath the lookup - but tagging operations require the
tree to be stable while the tags are propagated back up to the root.

Right now there's nothing stopping radix tree tagging from
operating while a growfs operation is progress and adding/removing
new entries into the radix tree.

Hence we can have traversals that require a stable tree occurring at
the same time we are removing unused entries from the radix tree
which causes the shape of the tree to change...

Likely this hasn't caused a problem in the past because we are only
doing append addition and removal so the active AG part of the tree
is not changing shape, but that doesn't mean it is safe...

> That beeing said I think clearing locking rules are always a good
> thing.  So maybe reword the above as:
> 
> "Take mp->m_perag_lock for deletions from the perag radix tree in
>  xfs_initialize_perag to be consistent with additions to it even
>  if there can't be concurrent modifications to it at this point"

I don't think it needs even that - just making the radix tree
modifications serialise against each other is obviously correct...

-Dave.


-- 
Dave Chinner
david@fromorbit.com
