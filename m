Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5E160865;
	Tue, 23 Jan 2024 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024150; cv=none; b=mCb2aPthLwPwLy/MXIrsiF8uSyrMj/akgHeFRzk4V/18f69i3PjKHeAj8l7kZeE3bAulZ5cVoGTKTdhTMvLWmwCfZxPDAO37htorWCfui2PYhLbnCJ4JWyieN1TnbL04bXXqot2Cie1ELS53SZP8zlEdWgLUNJc3rSxic6TpovY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024150; c=relaxed/simple;
	bh=vLprw56u/DIFwI9llpsSYYgE1VhcBrLebclUs7gyNDM=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=MRho2KC46Mv9A8A8UPhQk8eN4hggc2PIWAFdjY81HNO3C4b7aQ+M/5ceeVPnUAIArYe7U6v13D3GMHuJvYzkdVaht0phyVGiO4wHhOMztm5snJ09FfD7+dghEQC6ZvygLIS2ze4LysEh06FbV66MK31yA3pitY/SL1MHFiKbbfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/Z5LbaN; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/Z5LbaN"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6dd839abbf7so390322b3a.2;
        Tue, 23 Jan 2024 07:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706024147; x=1706628947; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V14tWCuyFNJC28A1ls/RhtT29R1jMypCP3HEGwR15jc=;
        b=g/Z5LbaNcm7VPFqisJ28fzUUAFqjS0pvNF4TGBdCFr5yTwXQu9DaPePfo9wwNZN+yP
         cJfjvopvGQO4EuyhLu+M9llpC6KXikCIvFjCPNhu8qw+iY/Q4v2UYBgj6dTvRU59JnF8
         vSstB+3b1j1f8CjK5ktOv5VNFlIRYSzAS/6RU5O5Xav1GMZf9QHL5qsn8ANS3O08kU8B
         ORVzqQQ1c1LehotdTwvO1mwbRMDgG6O0HubqsiU2imavIU4DQHxpUGVJNoanvUw7MQ07
         xYxYqyzXYBjFaanMVRauZCPeouDlH1O/uBUCMDAXf2u/6JTarN30D05QAWn7ynxpOiNQ
         GkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706024147; x=1706628947;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V14tWCuyFNJC28A1ls/RhtT29R1jMypCP3HEGwR15jc=;
        b=m11konpmRZeT2TlnNMWjaYXJqeBbjNEnbXPK71zCNYOTBPokhWyFHrxPnamAA9kSVs
         G8h9vGZRoQkcV82qsttByeFdRTg2hsiDUZ3f5w5UFofXtxw66zlGCGVeQ+3w1d/TM3nj
         5+V0h1yDzmWQjNmhsJsX5fE6WFX+zdBtbS0B0pvOXAFgUUcj0VKW3m1Sxpc+98p2rpEU
         lzzboxpfcnqNYdYVry9VeqSFNSAJvAu2qRu0unb+9bSKQ+I+GtVx5nd5dSPIvKyxvBe9
         gLM3Qw64Qa/0kt4jT3DBAeEB52g2td+bCLvJJU+SZ9friIOnOUXJcgc/fP51v11xJKeA
         x/vw==
X-Gm-Message-State: AOJu0YyCdK4dg9h71BdWIvl/xNG6hm8qky+PsIJ0lik+ziDHcklGXEhO
	zJM1fLU88EB9f4w7odRjPmoJb6kZqHS/p/xMBxE9ygz80NNHcrWodgNbBRpi
X-Google-Smtp-Source: AGHT+IFSTKthGlJVshfS7hjTWt+Hxb2Trn2VBHrVtgJThy7ZnpjBz6MJyMgaSuYv4WKvQx1kqnbOmQ==
X-Received: by 2002:a05:6a20:4394:b0:199:c23b:7957 with SMTP id i20-20020a056a20439400b00199c23b7957mr7666847pzl.68.1706024146396;
        Tue, 23 Jan 2024 07:35:46 -0800 (PST)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id r2-20020a056a00216200b006dbdb5946d7sm4576650pff.6.2024.01.23.07.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 07:35:45 -0800 (PST)
Date: Tue, 23 Jan 2024 21:05:36 +0530
Message-Id: <87le8gjc53.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Pankaj Raghav <p.raghav@samsung.com>, Dave Chinner <david@fromorbit.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, djwong@kernel.org, mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstest changes for LBS
In-Reply-To: <69e73772-80e2-4cfe-a95d-d680d7686e3c@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Pankaj Raghav <p.raghav@samsung.com> writes:

> On 23/01/2024 01:25, Dave Chinner wrote:
>> On Mon, Jan 22, 2024 at 12:17:49PM +0100, Pankaj Raghav (Samsung) wrote:
>>> From: Pankaj Raghav <p.raghav@samsung.com>
>>>
>>> Some tests need to be adapted to for LBS[1] based on the filesystem
>>> blocksize. These are generic changes where it uses the filesystem
>>> blocksize instead of assuming it.
>>>
>>> There are some more generic test cases that are failing due to logdev
>>> size requirement that changes with filesystem blocksize. I will address
>>> them in a separate series.
>>>
>>> [1] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
>>>
>>> Pankaj Raghav (2):
>>>   xfs/558: scale blk IO size based on the filesystem blksz
>>>   xfs/161: adapt the test case for LBS filesystem
>> 
>> Do either of these fail and require fixing for a 64k page size
>> system running 64kB block size?
>> 
>> i.e. are these actual 64kB block size issues, or just issues with
>> the LBS patchset?
>> 
>
> I had the same question in mind. Unfortunately, I don't have access to any 64k Page size
> machine at the moment. I will ask around if I can get access to it.
>
> @Zorro I saw you posted a test report for 64k blocksize. Is it possible for you to
> see if these test cases(xfs/161, xfs/558) work in your setup with 64k block size?
>
> CCing Ritesh as I saw him post a patch to fix a testcase for 64k block size.

Hi Pankaj,

So I tested this on Linux 6.6 on Power8 qemu (which I had it handy).
xfs/558 passed with both 64k blocksize & with 4k blocksize on a 64k
pagesize system.
However, since on this system the quota was v4.05, it does not support
bigtime feature hence could not run xfs/161. 

xfs/161       [not run] quota: bigtime support not detected
xfs/558 7s ...  21s

I will collect this info on a different system with latest kernel and
will update for xfs/161 too.

-ritesh
