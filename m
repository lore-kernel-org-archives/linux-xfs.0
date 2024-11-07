Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FB510F9
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 05:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730958040; cv=none; b=Zw/wPqH6iJaz/DiEyIPm74B29x+tHshYiFOugejtSDDuXAyxvkibn5iufg3b174w8BmDcH+QXumjj7ke2ko2gdHXlIQ960Ib8ZUABBuk+6aK8e081ELJM2XFz+VjkSxjq+jxSsNhCc+0f7rDB8LLbdTn1wcaDmNDO6ZOcHiZEjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730958040; c=relaxed/simple;
	bh=OUG92BgId/jeFaQtWKpDw1h4BVF8COXmT+YiCgvWRZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urdVt4N1tVjj+6y5TwNXTt8n4BwUC29LJmmxAEv3uP4QaHoKlh95F7Crpjd0SHiAlcGxnf4hF3GsD3WC5gMoMmV/Hnn3Gy63jW4yhhZr5ePjk2IVJYnSpUgwu7G9dxW41Lhtj391uxCu2+qNvMQzDLKZgRrQRUDFHG5tehUvk1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gAkAI8gr; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gAkAI8gr"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7ea16c7759cso398705a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 06 Nov 2024 21:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730958038; x=1731562838; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=enXt8+1EaBKT8bXQIbFGDf4ztusypEGRe9kf0bX/Yxo=;
        b=gAkAI8grVO/CaWHO5GIaAmNPRA95S+aHEO1gkZsfsSCZKw3J6o8q3IlUGPwQiws5UK
         +qiPFPR9DEyMJpgvzdP+XB2HHo6xMnd0izwmjppW3wfqRGDas1w4bUue8BcRCbi3rn4E
         TIl4AERPZLGOpDxJ+dG/hMPJzaDRb1qVcSeImZ1YKCbFAl8z/cxgk0OftaNwo3Q+V7an
         0VWnGf0vpFPcGX4XyUbg6POHpgGaQEg9uzrcm5C+lKZpShl76VzhzdH92SYRC1To3v4z
         OFqrETDxGUtI4oEWT6ZTEQbVMjduh9LSaFtJcz7nk9NRHHkjVZUNRRF2Smbjv3h7zeCV
         TBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730958038; x=1731562838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enXt8+1EaBKT8bXQIbFGDf4ztusypEGRe9kf0bX/Yxo=;
        b=FDfSVZv8fjfTrwvEVwSSI4AH1Pk29mWG3ZCHHRLLitG4OATk6QkCx8ZtByK1tCp/GL
         vLVTNyws9K/XrpfCU45WRyleFSkcKwUMunIXclV9f65bWkv2rcfbRfAdpiN8I9D8oMx5
         1Ha7YN6DnvXjZ3WFkDVTv5bz5waRS3zxXe3zhzx0RaHErbt/S2vEzUBzhKeb4b02aY/D
         L237Zm5FDKP59bS1eh8e1Y/6XbrEPQbJ1i34AWNvJpfqulb/slep7Ll0u4hPokVEOSFD
         PxizmfoY8fVJipsm+HoeHOf+T5vvj/IZ9vQFinBTZEptJmf0r2tcMqmTLLShJOsc3+X2
         xmSw==
X-Forwarded-Encrypted: i=1; AJvYcCVU8+FuMM2E4wQMmvwQ++obY5PU4aHdcYTAHRGIuLJjxyf6paMua7r1WvW0zCEuAD8Rlsz6CbtLnDo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx/b7HaNyGk8igeRkWIWQVYNd4XYkJcSRhmAG65fpM8GUx48Tt
	9VQqgu4OY5KdAdQA1EPnNIFRQ07avtt5SfJGJ3RrlWKeBE2NbtRqle2gz21yf6Q=
X-Google-Smtp-Source: AGHT+IGn+B/wSPpND0jR/YeR/6zOfJvoIgxlHcXuQEhHO5E8iZF1hjG7NfxeMqYPKuTjjGHFS9rmlQ==
X-Received: by 2002:a05:6a20:4310:b0:1db:dedd:fcb0 with SMTP id adf61e73a8af0-1dc1296a02amr1108387637.41.1730958038379;
        Wed, 06 Nov 2024 21:40:38 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7240799baf7sm589947b3a.121.2024.11.06.21.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 21:40:37 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t8vFy-00BGTP-2r;
	Thu, 07 Nov 2024 16:40:34 +1100
Date: Thu, 7 Nov 2024 16:40:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <ZyxS0k6UWaHpooAo@dread.disaster.area>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241104233426.GW21840@frogsfrogsfrogs>
 <ZynB+0hF1Bo6p0Df@dread.disaster.area>
 <Zyozgri3aa5DoAEN@infradead.org>
 <20241105154712.GJ2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105154712.GJ2386201@frogsfrogsfrogs>

On Tue, Nov 05, 2024 at 07:47:12AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 05, 2024 at 07:02:26AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 05, 2024 at 05:58:03PM +1100, Dave Chinner wrote:
> > > When the two conflict, _scratch_mkfs drops the global MKFS_OPTIONS
> > > and uses only the local parameters so the filesystem is set up with
> > > the configuration the test expects.
> > > 
> > > In this case, MKFS_OPTIONS="-m rmapbt=1" which conflicts with the
> > > local RTDEV/USE_EXTERNAL test setup. Because the test icurrently
> > > overloads the global MKFS_OPTIONS with local test options, the local
> > > test parameters are dropped along with the global paramters when
> > > there is a conflict. Hence the mkfs_scratch call fails to set the
> > > filesystem up the way the test expects.
> > 
> > But the rmapbt can be default on, in which case it does not get
> > removed.  And then without the _sized we'll run into the problem that
> > Hans' patches fixed once again.
> 
> Well we /could/ make _scratch_mkfs_sized pass options through to the
> underlying _scratch_mkfs.

That seems like the right thing to do to me.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
