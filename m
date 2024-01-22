Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E513C6AAB;
	Mon, 22 Jan 2024 06:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904974; cv=none; b=CCg/tNwed2pMJQptYB+bOq7xfHD8pxVbgYCQZvXvhHQK6Dc/GVkrsbjldoqiW1kGUl7g/+66RHK8oJ2GgseDPiacaNu+upeUnCpVOOu3/2ZBBcfzjbnn8RvQVDVtck9jMkcqPVHMBAQ8YIBJhVeTgqzp5Ler6RFzq/G3GtYjcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904974; c=relaxed/simple;
	bh=u5yL144NsaBrxan/LdePbS96uEBl5AjnUNqDt6feW8k=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=BBTPwflMGi0PTrdT3inOSBJ6BJHwMYesu/WaVMFA09B2W/m25L7Vs+Z8o5IHoGzOrq2m3YF+hmxTamAXTy/2PSdhDmQvjgWc2FqZohJ3kQbPXHUuk4PoVYWOqUFBP/DHc0sNcRbEdh61kPaukcV4hZALYKaSA0E0mIAbzCTEdfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Loxdxc/y; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Loxdxc/y"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6db599d5cb8so1922335b3a.0;
        Sun, 21 Jan 2024 22:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705904971; x=1706509771; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u5yL144NsaBrxan/LdePbS96uEBl5AjnUNqDt6feW8k=;
        b=Loxdxc/yPwmc6SsJNPRj8paEHv7SH+PNagb85QK4OTjjHekwAkercb27TEWpHEzj4t
         tQP5KSsvgH+uCkvd3VZXyR9tJ/lXLyc/Nj6F1KmZZkTx94/47Lm4W4aLKGABk2bJx8zl
         aX53vDqFasPZkPFH9qhxFOc9DD+BU/nP3fk8geV4X6sctqZ7rQ378+YMgJdmY9YnrCa2
         RZpYLcGm10gZRqZFBVwPDPDOkdoRAgECPmujt3k8U84bij5as6MMg4HPrKaW1UBE0dmj
         6TGYjLminPnnI7t4sMuVNTctDsb19KLneyKhsAZR7JxcqNzM7M67i1j542H41PVEIttP
         +i5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705904971; x=1706509771;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u5yL144NsaBrxan/LdePbS96uEBl5AjnUNqDt6feW8k=;
        b=Ajblq9/s+in+yvVcseExoNzo7DljQsKiFxvkZnAFUSL5UsNhaBmuI9KGuvwWMh86ww
         B9nJhYdmJ8s8I4KuuvMbg9w/SjJ86P5guSRaR93S3rAB74O7MKh+uZOp7BOp7rstLzVT
         bDDl7tcTd+GCOsHWS2/WwQKyWM+xRbMXLBvhMXvG8EvRJoGF8eO6d/2PetsdSLawDSWu
         ZRspsmuJUUGKXQx1aXeWCW3W3nPI+X3NWvEmH8/MfMKJbQzCCF7jjVDOlAA5MlZS8sS1
         dgY/UkBidcUvpXdyilSYpJBLQsg0UJzpM70gLBXUbGi6rgon0YLnh5b1/tNHoKczTaa6
         AkSQ==
X-Gm-Message-State: AOJu0YyIQ8V9icW2VFf73SYl8BtgmdEVq25HuVF1iIDOsli2NwIgQ5H8
	EVBTDyeNLxo519fXIFlDpfpkYfZabP56axLICjMRKbGl5mx+mLPMS6nf2i4k
X-Google-Smtp-Source: AGHT+IFk4DHVaM6Dq2+sfHCNHT/ZSXipHpiSHegM2AZfkD/B4R52gf1SPGF8trRu7tR887dyJSLEKw==
X-Received: by 2002:a05:6a00:2d95:b0:6d9:ac71:3b52 with SMTP id fb21-20020a056a002d9500b006d9ac713b52mr1877798pfb.54.1705904971329;
        Sun, 21 Jan 2024 22:29:31 -0800 (PST)
Received: from dw-tp ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id x21-20020a056a00189500b006dbd890c5e0sm2082679pfh.97.2024.01.21.22.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 22:29:30 -0800 (PST)
Date: Mon, 22 Jan 2024 11:59:12 +0530
Message-Id: <87cyttc24n.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/604: Make test as _notrun for higher blocksizes filesystem
In-Reply-To: <20240121045636.GA674488@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Fri, Jan 19, 2024 at 02:57:45PM +0530, Ritesh Harjani (IBM) wrote:
>> If we have filesystem with blocksize = 64k, then the falloc value will
>> be huge which makes fallocate fail hence causing the test to fail.
>> Instead make the testcase "_notrun" if the fallocate itself fails.
>
> How much space is it asking for?

~5451.33 GB for 64k bs v/s ~1.29GB for 4k.

Let me modify the patch to also print the requested falloc size in GB.
That will be much better.

-ritesh
