Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4761114EC60
	for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2024 19:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712949112; cv=none; b=BRG/nNvNXk1lrb3+dmZut3BnLVeR68bi8UCiIhHHPVPI2Ck/QpDzIrWUbSu3dGmUH6IGA6b9KCI9jGbfU7SgfyNDkZZSWPeC2cn7hmcEvxi9SSl7M9fdPc5lWqU4FjhAapF5N2eJpVg50loTMchpXP5UW9MislMRTTDf5+GcUks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712949112; c=relaxed/simple;
	bh=H5+Z366wKFm0NBKhaM7r10o+w2go1jg4s+i8Bg/nfW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovW7mjFFP54tyOTaQJGK8LRkRioB52xGP/m78e4PYR3n5QToULdCOUe6huLqQPRXH7DV84usFSpVmWU103mWb3ewvufoiCfdWw5vKWpbxLYxASOODzZ3D1wHSqxY85mH/B4sNyclVMFYcXtCMB1a8X0P+VVd9PCvIb68SDHbkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6962e6fbf60so9585076d6.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2024 12:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712949110; x=1713553910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5+Z366wKFm0NBKhaM7r10o+w2go1jg4s+i8Bg/nfW8=;
        b=nlqgaaOq6+DXVKUGXWG0q4/MEW0x+LKE62wHVmTTTPkKQ6jteIdsu/C7y9vLg0X/Io
         Vc8b5cNqPPj+9bgaz6pJ33DkKgbUNB+CunjG04RJnO87/wHOFWYQnPhlcXolkn7Ddvv8
         ZdELo17AcxH8J8wkUC9bhtzb0zZyWVwaaWuo0qz9qM6gcAGO3OMpNCOF/CeUKqyWGsq4
         PcDCgPVSBXDBTMQz55kV3V7ZBasbNbN37e+bcrgc8F1kKd1pl/JjRlU6jY0HybTVDRy5
         /UgQrSFpg7c8G82vC3jUtl3bSdfQEBTfjKK5oOh7Iy1y+TGCA73rkM+spOeZuhPgStRC
         7Msw==
X-Forwarded-Encrypted: i=1; AJvYcCU/pcBUcw6U6rxnnlyVAXf+6KhK+bacjqUeDw3m21hCTg2g9HULgrY+4PGBliWQoC3Tr1nS1HFd0GVCSzqKTmWeEV4CL4BByJ6E
X-Gm-Message-State: AOJu0YwfNeNuXtQMGK4Rs65TJmGszugVhEOs3tabX1eIhsuz1eFNTtay
	XMjZBUOhNexa/LsQbVPtvcU1U3AstE1dKLiAZBFi8XGFrxedIAyJlEk5EURsQTtywOZB4i9u08A
	Bq4HQyw==
X-Google-Smtp-Source: AGHT+IGeLin3taHlFSSUyXln284AJet9b+/a2Qcn+Ghx2lQ0DWoWRHuSus3v3xl2tUKwhypqZgUl2g==
X-Received: by 2002:ad4:55d3:0:b0:69b:229e:91f6 with SMTP id bt19-20020ad455d3000000b0069b229e91f6mr3530788qvb.52.1712949110132;
        Fri, 12 Apr 2024 12:11:50 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ph3-20020a0562144a4300b0069942e76d99sm2662096qvb.48.2024.04.12.12.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 12:11:49 -0700 (PDT)
Date: Fri, 12 Apr 2024 15:11:48 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: iomap: convert iomap_writepages to writeack_iter
Message-ID: <ZhmHdEhnmbxJPKIX@redhat.com>
References: <20240412061614.1511629-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412061614.1511629-1-hch@lst.de>

FYI, noticed a typo in the subject: s/writeack_iter/writeback_iter/
