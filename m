Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZhGZC36q"
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577741BD5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 00:46:18 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6cb66fbc63dso525045b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 00:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701247578; x=1701852378; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZKM4U35noERGcY1ovETgfkyHKzxojpfXxj8pJoYn48=;
        b=ZhGZC36qeM4t2enk4yUmEs22fambWvct/lno4TkeV9D4zfNadw3mXf0Bdvm5lDToSt
         4S6NUyIOhQoabp+jQX7TUuqH9qUrjNmXg5jp70vAQKtLCWmmt3foXGCr13poI7Z64gKL
         ROUcITOoL8DfFdRtsgDtLja+05DKv4u0Ofsvd46ilsYPRHFhw5dfvltIJtuvy77f8N2M
         U8TgT0GUk9alKQiFa2tr1EZUcCD7clnCIHYjaLG+H9cMilUjVKUhap5ihZoH7ZZAcVqS
         fGPrgrSoUC2lT14m4amukiHmpagxb3w4SgM7nc4/E+ylyY5dn9rigu8z6QBhxXZF/Biw
         O+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701247578; x=1701852378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZKM4U35noERGcY1ovETgfkyHKzxojpfXxj8pJoYn48=;
        b=Bz5FeidX53o6+MDikUdL5S93n/sgoOSmBh1TrpUaCBW1Ul6WQA2fF8x8uGbfJsYYw+
         rIYxyZ+vZn+e4QrNZ4xGg9AKBMQAMUpDpoRU+S/apLfvklqRj7Qx+VdMvT8S1io8JhRQ
         mjG1nxtBxZUmfA5WdFpWgSR+fYTH89n8gFQYU0/sGNpUWJ5IZNuVEAPD2qr2BWs5jyhD
         hbYxVSkND4B3d3SNwtBSvx7O1dVH4tA5tUqsod6nlg0E28Xh0Jy3XKb3BEz8apjZGQIH
         XEUt+lz0wntPnNpGdNlpEydgS6a8F1FogkXT53T6d2TbuXFGUP2UlcnYT+yuYchgNJwz
         rvog==
X-Gm-Message-State: AOJu0YyxzX2iPzdkO57bNB7U3ZVKyUE25H0m0+6lF27Ve8kvEh2SbPtO
	ZsHlId7GQh1d5Mf1eQ9QTzmc2g==
X-Google-Smtp-Source: AGHT+IEc8wF1VGyhEynP5TlEMzVCySl8Mf/fizHtJzQpmr9TiVDAMdNmoXgl8vd9MiTBm388hpeplA==
X-Received: by 2002:a05:6a00:3986:b0:6c3:415a:5c05 with SMTP id fi6-20020a056a00398600b006c3415a5c05mr25465361pfb.14.1701247577726;
        Wed, 29 Nov 2023 00:46:17 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id fa21-20020a056a002d1500b006c33ae95898sm10221200pfb.78.2023.11.29.00.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 00:46:17 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r8GD0-001RDE-0s;
	Wed, 29 Nov 2023 19:46:14 +1100
Date: Wed, 29 Nov 2023 19:46:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com, me@jcix.top
Subject: Re: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
Message-ID: <ZWb6VowUBY2eE5IA@dread.disaster.area>
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
 <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>
 <ZWZ0qGWpBTW6Iynt@dread.disaster.area>
 <ZWbbYTKUYaGOo86O@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbbYTKUYaGOo86O@infradead.org>

On Tue, Nov 28, 2023 at 10:34:09PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 29, 2023 at 10:15:52AM +1100, Dave Chinner wrote:
> > > +	/*
> > > +	 * Update the moved block's blkno if it's a dir3 leaf block
> > > +	 */
> > > +	if (dead_info->magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> > > +	    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
> > > +	    dead_info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
> > 
> > a.k.a.
> > 
> > 	if (xfs_has_crc(mp)) {
> > 
> > i.e. this is not specific to the buffer type being processed, it's
> > specific to v4 vs v5 on-disk format. Hence it's a fs-feature check,
> > not a block magic number check.
> 
> We have these magic based checks in quite a few places right now,
> so I'm not surprised that Jiachen picked it up from there..

Yes, but that doesn't mean the magic number check has been used
correctly here.

That is, we use the magic number check when the code has a
conditional on the type of buffer being processed (i.e. what block
type are we operating on? e.g. DANODE vs LEAFN as is checked a few
lines further down in this code). When the conditional
is "what on-disk format are we operating on?" such as when we are
decoding headers or running verifiers, we use xfs_has_crc() because
we can't trust magic numbers to be correct prior to validation.

Hence we use xfs_has_crc() to determine how to decode/encode/verify
the structure header, not the magic number in the block.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
