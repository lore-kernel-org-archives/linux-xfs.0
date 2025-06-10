Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ADD185E4A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 00:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749516464; cv=none; b=t/IzQ77oDO8IUnlEwmHIPmMiPYSG+ne2SZ70vv/wih0lGZIMFe6InotJ/qc/F0DdR2eGogKdv60jEw7WgdBwNThp7CWZa5JL6mjRL3+m0xY8batTrWHCvCKtok2tdpXYKasgQgOEM/JORB0DDxN5niAK/gTHa51XwFzwIIQuPDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749516464; c=relaxed/simple;
	bh=wzCk96ikWwU44bte0lQ98/7tlYNX7MGlFlWnTbV3Q3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0DVoE9TgXyfBWLeoCxMYjeruYp0fANu2eo7+EajMpaN4rETD260E1OER0zGLo3oDMUI/Le19ltqUmO0ZWSHhic8BBE5OBMIHVqbcyyXgbC3NuoVC+6hZZrX7wLGhqTTWAzzUnNO0CIncREd53RhF4/GiK0YpDzpjg7uUo+TPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uMIybKf1; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uMIybKf1"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3122a63201bso3998234a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jun 2025 17:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1749516462; x=1750121262; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3HFQjv+s6bpttilWu2xjAJePsr0RPP9RK118a+zBXU=;
        b=uMIybKf1b//Z5997zuzeoGNpGaNsTam+DaY+5pDAPutrDYI+enowiFpR6bUi4QUWDY
         K/zQGdKcwdhV6FjeJOpJWhbgI9Y0kIjZcCMP/nsdu90G8wbq/BtHvi75t5OnaXVhD/zm
         1xbn1tw6uitcP/yNju6laDVve3ZBg7vIMav4KGUYw7LDi/+Ge+x8uk8MKGUOrfUL+GFq
         QDIBCWfE/ig4qvbYEJTBigz0T9vOKbem1ynktoTiKa+/I9DGKklebYQLEKRMvAOSA0ne
         c4sl0QlJA18L5yE6+uISuW+y0dDXXak9nC4RsAvWQysjAk02nEUBeItLm7Z9fQ1lo2YO
         LcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749516462; x=1750121262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3HFQjv+s6bpttilWu2xjAJePsr0RPP9RK118a+zBXU=;
        b=IIecWGlhDZfqb1LCPAOVp6qB82VFuNB0xSI0cp3hyJs8sfJ0Wq2frusY/bkfu91e5A
         uk2uwDXddfQT4q43IRPzv1tKGlhjX5B2iYE7nIX0c6jTdu1m4ekP2ZvfIlsJjzmAZZcH
         Mx9PSr5YD+gI9eFgNnJcLoU3yxeNmgjPhMgZwo7nt/hV5T37JB0+JVD8mFzorwv+kJMK
         dmwmOoNU0qUk5hy1GZWvY+Bbn7DrIqqpVrOt4VrLW/WoG2o7qXqiwHnwfY95YS8BkmQh
         e/+PaHRaDhxotYZ5SHIDN1y6eUV9AKDYgcyTyOYAKu19g+sOjZFWNcxnjrgA3dvVux5a
         Ey4A==
X-Forwarded-Encrypted: i=1; AJvYcCVI6XzDIVfYWX1ReGGihithBYiXgFmZ8ULcLLOAoKPuFWl4Sq7TprtiWweDqQEHDKEE1lk0girhkX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCOFF6DMDbxfPcDY+S7oOIDnEcIAI3TOlud+7Dl1zDXR0KMsmS
	+4g1aOE3K3WorgeJfdszOTTPWgU8j7TmsWqjXqCj04nx4rARHnmhaBwsmKZEdtKgw7I=
X-Gm-Gg: ASbGnctsCs6n/7xYor5tIsk3D6hLGDWmfABJ48m2X2nB2bhahD4p0095pchJaOX2Jt2
	EOlmjjuMvZlgbFDmlcZmeS35i8WISpPCmYrr8a+kdLhfZNW1mZ3EgBTE5c07ipi1h4LzQUH8rG2
	/00Vabz/43UMzJsZuhIvsgSrejRmgP1Wk7r8tKaegb6Of/CSRsP3WzMY+MniPa++yQW2WLiUrNp
	9QLiLaiCG8k+Gm3N0D6sR8+hoA4KQuRhlFK3rYLuOgzOABRdvU9ayGWBiNgbjxEqZgLWgTDt2Th
	EPOEMQpbS2DXyEEYFoI+4304hLXFhIFSSuWb40h9S5hC4kGfdQO7ISAom9poOPTYIvQB+zWFkDD
	AVp7W2STlYsu4lpCeWNy8uB1bXmdIB4cEZDbZgA==
X-Google-Smtp-Source: AGHT+IF+GE/zQiGzNIgbWcPCTdnSM7Z+WH7gcF6pxHsgZod9kavZI1l2guNjvkN7v2RhFEDFr+ZVDA==
X-Received: by 2002:a17:90b:540c:b0:311:c1ec:7d0a with SMTP id 98e67ed59e1d1-3134768fa6emr21220493a91.25.1749516462202;
        Mon, 09 Jun 2025 17:47:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3134b13b45dsm6829912a91.37.2025.06.09.17.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 17:47:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uOn9P-0000000ERff-0bxu;
	Tue, 10 Jun 2025 10:47:39 +1000
Date: Tue, 10 Jun 2025 10:47:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, djwong@kernel.org, brauner@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	bernd.schubert@fastmail.fm, kernel-team@meta.com
Subject: Re: [PATCH v1 0/8] fuse: use iomap for buffered writes + writeback
Message-ID: <aEeAqxUfFxepmQle@dread.disaster.area>
References: <20250606233803.1421259-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606233803.1421259-1-joannelkoong@gmail.com>

On Fri, Jun 06, 2025 at 04:37:55PM -0700, Joanne Koong wrote:
> This series adds fuse iomap support for buffered writes and dirty folio
> writeback. This is needed so that granular dirty tracking can be used in
> fuse when large folios are enabled so that if only a few bytes in a large
> folio are dirty, only a smaller portion is written out instead of the entire
> folio.
> 
> In order to do so, a new iomap type, IOMAP_IN_MEM, is added that is more
> generic and does not depend on the block layer. The parts of iomap buffer io
> that depend on bios and CONFIG_BLOCK is moved to a separate file,
> buffered-io-bio.c, in order to allow filesystems that do not have CONFIG_BLOCK
> set to use IOMAP_IN_MEM buffered io.
> 
> This series was run through fstests with large folios enabled and through
> some quick sanity checks on passthrough_hp with a) writing 1 GB in 1 MB chunks
> and then going back and dirtying a few bytes in each chunk and b) writing 50 MB
> in 1 MB chunks and going through dirtying the entire chunk for several runs.
> a) showed about a 40% speedup increase with iomap support added and b) showed
> roughly the same performance.
> 
> This patchset does not enable large folios yet. That will be sent out in a
> separate future patchset.
> 
> 
> Thanks,
> Joanne
> 
> Joanne Koong (8):
>   iomap: move buffered io bio logic into separate file
>   iomap: add IOMAP_IN_MEM iomap type
>   iomap: add buffered write support for IOMAP_IN_MEM iomaps
>   iomap: add writepages support for IOMAP_IN_MEM iomaps

AFAICT, this is just adding a synchronous "read folio" and "write
folio" hooks into iomapi that bypass the existing "map and pack"
bio-based infrastructure. i.e. there is no actual "iomapping" being
done, it's adding special case IO hooks into the IO back end
iomap bio interfaces.

Is that a fair summary of what this is doing?

If so, given that FUSE is actually a request/response protocol,
why wasn't netfs chosen as the back end infrastructure to support
large folios in the FUSE pagecache?

It's specifically designed for request/response IO interfaces that
are not block IO based, and it has infrastructure such as local file
caching built into it for optimising performance on high latency/low
bandwidth network based filesystems.

Hence it seems like this patchset is trying to duplicate
functionality that netfs already provides request/response
protocol-based filesystems, but with much less generic functionality
than netfs already provides....

Hence I'm not seeing why this IO patch was chosen for FUSE. Was
netfs considered as a candidate infrastructure large folio support
for FUSE? If so, why was iomap chosen over netfs? If not, would FUSE
be better suited to netfs integration than hacking fuse specific "no
block mapping" IO paths into infrastructure specifically optimised
for block based filesystems?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
