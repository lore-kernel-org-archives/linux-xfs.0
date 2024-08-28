Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827C51AED22
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724877860; cv=none; b=CkYWNo42psPxq3BfyoO0YpBtdOJaWSWLfkg2mpSv+N2pdc8rrwanRIcGu5pKy4jI7KckGkA29Ral9fZluj3A1McPCG39XaefZx2ihO3nKlLx5+7uctZrV3dZFBZuKD3uwIxHaq2FMZWLPOsO3hv67W5xeZI9H7lGfX+8k4zubuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724877860; c=relaxed/simple;
	bh=NOTT8tmQkGjOLEJiU0mtzQPp7eM+TLxM5wbO/HWBxA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thib43sNBOxemle7zJgGPTg2AGbvDlIWiw7FbsMisCwhfELys86xFnG5UGjwnqHfywMJrr6v/i8A3rZY8robTcRoajX8UkdHrnISXOm5BpxJANYdtMs8EPbEz2i0Mtl9cQmld4NcQM5/P4d3nYoWUQJwxVrszOe4n0Akiw+836M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=A5OPOK3u; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="A5OPOK3u"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7a5074ebb9aso436464385a.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 13:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724877856; x=1725482656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTmq2Kjl3J1CBYIG7oCGRuwVGDfx+TeLm+Z7747lKq0=;
        b=A5OPOK3uWZJji1nYhTVUq6MhrfEFjwx/4OZfTRcOxbAlkTSEuTOY0weXtIrCH+ymCC
         0yEpD87jVynaA4ZkdbkQuc+lc5FPhDasqDjMa8v12rUjxZ8bwZRz/YHrotiN8ZSamAX/
         8wGBsvtpyhlJQho+NnUJosJFXlIl87VRKIilr5+aNnGOrpTr6piFhMJSP0l+vagv7DOq
         0UXyhph7ELab792wF3wrXdTYdtNYvB3YdfO+5S2qcyyV5CydlrXOjBaKJR1UNSVyGgnq
         B8DV4TBrMg497g8XyKoNJLJ9nZsYyLj7IeQelV1fxu1FLDr9I4WgjBCuwg7EhQ1t1S4A
         fKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724877856; x=1725482656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTmq2Kjl3J1CBYIG7oCGRuwVGDfx+TeLm+Z7747lKq0=;
        b=MCQlSQ+QVHfmn+uDvcQbaebGbi0c6WLyog50UdI0Nir9c96Iwx6+/j86QAsR3dxXCF
         3jwELVUT5KQCv5vf5hacz6L8mQibjnNneybAjciQNcemxZKZpz6ph3+GAqQwb0HOHLKn
         bCNOOfm7pUc6Grca6r97TFonBBPykSmYe85oTWYHLjJe5GY+49Crmm5jmNKqAiY51MDh
         gJfmcWWtpUGiYX+o7iCF2xT0pKHoUBrUD6JJuaYGnBYGxGlogIoPg9sADBjV1lJLZzAT
         a0VklhHE8InW5NfM48hEDpI1DHUFURC1trvqpgWmmsmVY3hVbK/5YoXekhLqpPvWzXcy
         Q+yg==
X-Forwarded-Encrypted: i=1; AJvYcCU8o7ysFfXcuaLCsg005Bb/+pvQ4dSnuH2QTb/u+75Moh+40oDHppTJIyllVcmbQvC2YzvA9ZPMcuc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsLCC6ajro9s4exJFb1JlMmKk16NiF5WGEjW08s3zERWCfh0mR
	y4WF90n2nU/VEYgsKiLL7lsccwxeUzoIRbVo1S/GXRq67qkf3LNclToC4+lqUKo=
X-Google-Smtp-Source: AGHT+IFLbeNbhXPkGYOfWhqGJaAZwCh1ltke2SjMTXGvB0pfIrWn+ukMPp0XnCOt6dd9J9BRi0Sj4Q==
X-Received: by 2002:a05:620a:371b:b0:7a7:f8aa:4837 with SMTP id af79cd13be357-7a8041b53d8mr63206685a.22.1724877856333;
        Wed, 28 Aug 2024 13:44:16 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f34233csm669769485a.35.2024.08.28.13.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 13:44:15 -0700 (PDT)
Date: Wed, 28 Aug 2024 16:44:14 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 0/2] iomap: flush dirty cache over unwritten mappings
 on zero range
Message-ID: <20240828204414.GB2974106@perftesting>
References: <20240828181912.41517-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828181912.41517-1-bfoster@redhat.com>

On Wed, Aug 28, 2024 at 02:19:09PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's v2 of the iomap zero range flush fixes. No real changes here
> other than a comment update to better explain a subtle corner case. The
> latest version of corresponding test support is posted here [1].
> Thoughts, reviews, flames appreciated.
> 
> Brian
> 

Took me a second to grok what you were doing in the second patch, mostly because
I'm not as familiar with the iomap code, so with that caveat you can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
