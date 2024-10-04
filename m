Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411D713D89D
	for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2024 22:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728081998; cv=none; b=MJa1XgvmeKaghcHaXsaVmjj4DtgpxYHA/BoNBeY3ahVGzLlc6YzUeqbMy6tzVaAbU+4P0Zq9OhDelm9HcmChEAABKRHVHdeCQkv62lR/ZTXD1DPHi+OQAvZS35M3lDHsqI2b6DrPIMwuk/FMnT+S89mqiV5vAD48KuWk38a2eOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728081998; c=relaxed/simple;
	bh=KGDBW+VzICTuok5HmgYwSc6Q3qKxP7NeiQvuKpfuJj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zm3zmBznfjm180QbgfdAnBn4bGI3GfmxCPfuptUWFJbtJ0YmmoygWcsy6DboJiLaYGRFlYnAOqhfYO/bx7ko0B+w9sruCV6MqzBqzXhZFZa1GFlRzeh5bXhxDvfbv0avzkGwdrLFLhpq0ely2t5PEPtTK61BnlYm66S+TPbuOXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=iNcLVTFV; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="iNcLVTFV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71ddfc61c78so1471974b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 04 Oct 2024 15:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728081994; x=1728686794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mfPYWu0zoQuwrp1D6VKi5ike7t96l9DXCZP1d6TBs20=;
        b=iNcLVTFVEhfPpmJZiXGLhSTr6HJNAURf1G6aOa5qkkUggoVAu42F5VeraclLkx2sBg
         oA8T/zD7Gp2PcY/p84c2darNZGHnCFo5KXMA7YkLdVot4SNYl3fpkJowKl84piJAUFga
         NJTfVB3Tz94sSGh3EN2J1sxvjdzqjKQVBYVWjk5+h1mq9HHWpaf384ZrOujuD1X0+oOQ
         xx88+wtYtElrZ/UzuCy7N7j4EFVtmlLp2ZrQ9DDMXt1mcijzMAf3uqDQ0PMMpI60yzt4
         awXGt2+DRMuPZlkeS8pE44Tk5D/IXVaTcsXfF2lK1seORExX5N65iK6xyaesurDnYQH1
         etYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728081994; x=1728686794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfPYWu0zoQuwrp1D6VKi5ike7t96l9DXCZP1d6TBs20=;
        b=s0uQSx2qBUzAA1XRXm8A9koOfNOyuVicvM2xr9q1Es4zIT0hRAgW2VGxZKrDz+J6w/
         DH6mlmqgsuen1xtBWJmKvetuAQjoURUb4Y/onmArTrqehMSlNBxK2X+e2bazMr7WeX+U
         FHhLgq/c/csRMhJjKQGWujL42RDSMHYhnlyDN2I8H2FncLTo26mXyl/CpXAwi8N4dK/Z
         cuaRAKDXSHI6+37A/15Vi00XgAMtUoQGZAQMnR8S4I9LPukEr/c26ZTkJRWj9BeBoAOt
         1NLMtH476KFhRyovfr185ZrnUfilQqxsKtNXehRoJKxn2NkJr7SYbLzYyd9N7zwb2jlH
         kBAw==
X-Forwarded-Encrypted: i=1; AJvYcCWuQa0iK0XCwBSqNvGc2Vdqt+LhX/lz3QqpSIhhRh1TQS3SNT2pCvOIGWlnSNe+Fyg1Nd3uHxiHgdw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUczn/EfWafHr4nRanSHqMfJuMUrGuULjZtVCNmYJNDzvBAPOo
	HUXDux1vF27a+D2D4Sy8Q5om1h61mGyltO+HWsNsS5syuKYUzNZXhKv6nr+ifNBqWd1+llAt73n
	X
X-Google-Smtp-Source: AGHT+IHH6D+mR+kPDuhUqfvHx3wFJkWq0SHSNLLQousrnyeEieGnCefv4dnbkilmvTDOj0X5j+GnTQ==
X-Received: by 2002:a05:6a00:23d5:b0:718:dc55:728a with SMTP id d2e1a72fcca58-71de23b5e95mr6803811b3a.8.1728081994552;
        Fri, 04 Oct 2024 15:46:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d47863sm384166b3a.119.2024.10.04.15.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 15:46:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swr4A-00E116-26;
	Sat, 05 Oct 2024 08:46:30 +1000
Date: Sat, 5 Oct 2024 08:46:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Hannes Reinecke <hare@suse.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.11 14/76] iomap: fix iomap_dio_zero() for fs bs
 > system page size
Message-ID: <ZwBwRqGRwoDd2eT4@dread.disaster.area>
References: <20241004181828.3669209-1-sashal@kernel.org>
 <20241004181828.3669209-14-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004181828.3669209-14-sashal@kernel.org>

On Fri, Oct 04, 2024 at 02:16:31PM -0400, Sasha Levin wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> [ Upstream commit 10553a91652d995274da63fc317470f703765081 ]
> 
> iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
> < fs block size. iomap_dio_zero() has an implicit assumption that fs block
> size < page_size. This is true for most filesystems at the moment.
> 
> If the block size > page size, this will send the contents of the page
> next to zero page(as len > PAGE_SIZE) to the underlying block device,
> causing FS corruption.
> 
> iomap is a generic infrastructure and it should not make any assumptions
> about the fs block size and the page size of the system.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Link: https://lore.kernel.org/r/20240822135018.1931258-7-kernel@pankajraghav.com
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/iomap/buffered-io.c |  4 ++--
>  fs/iomap/direct-io.c   | 45 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 41 insertions(+), 8 deletions(-)

For the second time: NACK to this patch for -all- LTS kernels.

It is a support patch for a new feature introduced in 6.12-rc1 - it
is *not* a bug fix, it is not in any way relevant to LTS kernels,
and it will *break some architectures* as it stands.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
