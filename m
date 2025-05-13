Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BC51F4E57
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747173421; cv=none; b=UN9QZ2tQnKCZ+swK9m7Pst6nAcsOKzkwnvF84jfo29iDU5GERJSC3eWLy2LpGJQ4RFBDsTmjJBF1k6691vdEjinFTcuoA0NmkJ7dT2VRR4NGZvDbZaoCFTHQvUAZ0vJnIz1katcuGV2yqj/bfkVaGj93JOrBaFrVAY9RoUyZ+0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747173421; c=relaxed/simple;
	bh=/zF1mYp+Qjw1mKBvyibCDQdFS3FVN2otdPIZy4zUN00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abWNdSDw+vhmwvZnXvzP0ZgByr1zDBjMfWxpSe2da5YBC9HavZCgTD45GMWOqnfv8pMTsObgzJaJqbnuiqvQ2m/3lnOeNUY8/Sr4YsHga5Qx34G9XhZ1hzVAo5/rHYEezOj1FbZMDxCDY56g2DEij3HScLH7ls3/DsgRDk6traY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=j1zEgH1+; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="j1zEgH1+"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-23035b3edf1so23944465ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 14:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747173419; x=1747778219; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZA5fGkDhuFz3dZTFRzP7MkkEHNqz8Evy7iH7RQVbCQ=;
        b=j1zEgH1+cXBmd8et8OxPHFA8BjOk7oqsRIjmzZPl5fBPTZti24PhyajqhsHhgq/Bxn
         Dhy/flxcfVkekHCXShDNWoKOwlQ9n+zMPbyIax1tT0/1BqQpdLo09Bg3dwon8u/+EjG7
         yLsEbV5oP+b7JnIJjwWaQ/tuwy7gsqypa2lyBg2eLeBk80gViwuJ1Oi2UZVJQ4woGP/6
         1yLahk1/2m/oVIRyiNmflEGkls3c3Ak1Rk5bVCKqQn4Zx5+NElIM2mvWX20UDa9P1aGW
         xlktSjrK1zx0kOrYhMd35DoPxV2LOZCqDmF7WVnoON+1iSgQyxA00IzmO3nDZ9aBujc3
         d2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747173419; x=1747778219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZA5fGkDhuFz3dZTFRzP7MkkEHNqz8Evy7iH7RQVbCQ=;
        b=vEG2tKZSJGiC355kLan9y17Plvauh4ahjWMbjEo57NvRlSMv9AJGRv7QQqOxyNslfo
         meFfMU8VqARWMV5gSBEBS6DrENp+vuZMlGUcTCI9qw9F8MPKSp7RfZFx/Mn5fRYghhzh
         bejY+u5MtWkU69i6//r/00sfd4stDvSiHDFmKhIdMqnC4WWFevvOzDmuvIjRQ8cJk1l8
         Wzhps3e7Ge2gWRip1NCUlPONVRtPimoVtjX+N/H6EUu6NiwZfUIipAwgCIqNd9Bsvhyh
         GO9Y5Wr1e631VaH87BCH1p4Ehn724vrvessqNuzz1/Sqawsi66QJV1vyAxNJh5ASxuQK
         J3gQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9AuBTx7KyLDEtDaw0RVuJXsD7EYBTQ8OMM7Pb5uk0vNOSBfjazwMidwFJxcNHNy9+a1tc+8/elWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YywqjvYwO0HKRjcJHzLRcmWS/XKW5/IHPq6o5fsA3DMqRM3voJJ
	p0bBOk0XmbJZwif7gMyjhkP9dHZFOL0FkUfRZ/ZUJKjwoOf+VgrTPDeKLOp5P7k=
X-Gm-Gg: ASbGncvnkoXYdvlX2rqwFIIpw+lWAEvJ7o4M59ACc2oGrTtpxbbbVljtnLJT9SwBN9d
	r+HPBK9N+0A/IFVMhTwNZXiRV//8NGu7EhT6n6WUPLsOcUhBVVeYRwlcl9Kg3WVrSxkwwVhaFhJ
	tSVi48I7DuDa5j97mP2bDgQQPRsxOenAO+pYl59I8RLa9SC5PMjWCBCx7QJzNSce0PJcvod0XHu
	CSJMS9yMEU0lpXL3VEbR3TzuMPi5ABVlnK9q/T10TUVg5LWy0+2Dsp+8caaJSg/fjAtn2X+UP8w
	aUTF88cgmpvRlcWlMHzj+ZW3Xgmp+yEffEPtLyy1Wga4v5wL8pOi0cC8ynWROwIi5RwLntl2hm8
	fxz5XMpQDe6eWFDtTdI9y6BG1
X-Google-Smtp-Source: AGHT+IFwcTKvJORimT5ASOuSIGOHxsEuSSyFah+YehraNrSSTWMKnHLpvk3NB/MeLAAPLB1ACpSogQ==
X-Received: by 2002:a17:902:da83:b0:22e:7e00:4288 with SMTP id d9443c01a7336-231983f66b0mr14677925ad.53.1747173419381;
        Tue, 13 May 2025 14:56:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc8271a7dsm86946075ad.153.2025.05.13.14.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 14:56:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uExcO-000000039yV-1X40;
	Wed, 14 May 2025 07:56:56 +1000
Date: Wed, 14 May 2025 07:56:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: cen zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, zhenghaoran154@gmail.com
Subject: Re: Subject: [BUG] Five data races in in XFS Filesystem,one
 potentially harmful
Message-ID: <aCPAKC7OeCIGtVMM@dread.disaster.area>
References: <CAFRLqsVtQ0CY-6gGCafMBJ1ORyrZtRiPUzsfwA2uNjOdfLHPLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRLqsVtQ0CY-6gGCafMBJ1ORyrZtRiPUzsfwA2uNjOdfLHPLw@mail.gmail.com>

On Tue, May 13, 2025 at 08:25:49PM +0800, cen zhang wrote:
> Hello maintainers,
> 
> I would like to report five data race bugs we discovered in the XFS
> filesystem on Linux kernel v6.14-rc4. These issues were identified
> using our in-kernel data race detector.
> 
> Among the five races, we believe that four may be benign and could be
> annotated using `data_race()` to suppress false positives from
> analysis tools. However, one races involve shared global state or
> critical memory, and their effects are unclear.
> We would appreciate your evaluation on whether those should be fixed
> or annotated.
> 
> Below is a summary of the findings:
> 
> ---
> 
> Benign Races
> ============
> 
> 1. Race in `xfs_bmapi_reserve_delalloc()` and  `xfs_vn_getattr()`
> ----------------------------------------------------------------
> 
> A data race on `ip->i_delayed_blks`.

Not a bug. xfs_vn_getattr() runs unlocked as per the Linux VFS
design. -Everything- that is accessed in xfs_vn_getattr() is a data
race.

> 2. Race on `xfs_trans_ail_update_bulk` in `xfs_inode_item_format`
> -------------------------------------.
> 
> We observed unsynchronized access to `lip->li_lsn`, which may exhibit
> store/load tearing. However, we did not observe any symptoms
> indicating harmful behavior.

Not a bug. The lsn in the log_dinode is garbage and not used
during recovery - it's mainly there as potential debug information.

> 3. Race on `pag->pagf_freeblks`
> -------------------------------
> 
> Although concurrent, this race is unlikely to affect correctness.

It's an optimisitic check done knowing that we don't hold locks and
it can race. The code is explicitly designed this way. Every other
pagf variable used in these algorithms is also racy.

> 4. Race on `pag->pagf_longest`
> ------------------------------
> 
> Similar to the previous race, this field appears to be safely used
> under current access patterns.

Like this one.

> Possibly Harmful Race
> ======================
> 
> 1. Race on `bp->b_addr` between `xfs_buf_map_pages()` and `xfs_buf_offset()`
> ----------------------------------------------------------------------------
> 
> Concurrent access to bp->b_addr happens during buffer preparation and
> usage. Since this is pointer manipulation of page mappings, store/load
> tearing or unexpected reuse might lead to memory corruption or invalid
> log item formats. We are not confident in classifying this race as
> benign or harmful and would appreciate your guidance on whether it
> should be fixed or annotated.

Impossible. It should be obvious that an object undergoing
instantiation can't have a locked, referenced access from some other
object in some other code....

As I said in my reply to Christoph's patch - there are going to be
-hundreds- of these sorts false positives in XFS. Unless there is a
commitment to annotate every single false positive and address the
"data race by design" methods within the VFS architecture, there's
little point in playing an ongoing game of whack-a-mole with these.

Have the policy discussion and obtain a commit to fixing the many,
many false positives that this verification bot will report before
dumping many, many false positive reports on the list.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
