Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807BE18BC0C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 23:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744760209; cv=none; b=Db/GAQKVR3bqlFrJfrZ+Uiw/peRmK8ORbYkIBctKvspb7SwHvXQ9KY2+ACXrPVGt9JLplcdhlpxkKkwAB9fvcJPe5LuXdd2faSKX3oAVMZrGlUCY78k/bKr1BxKZOVKfE9G/izJoz5rtBVR3rpNtcOy1MyT3BSnFV6oXMK/3NWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744760209; c=relaxed/simple;
	bh=2eD+e+Gkgfa3+iC+m53ODqWHhNzh+/uSSsCY3/smqRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WKrL6F65PPDmRtExp/Zr4u7oWCH4ePtPtoGzYO68Tn79LyS8Cr/gj4LChncJCVPbzLj6pyuIV+0syQdpczAMSEwnyzhYEvhkC1V7d+FtIfjEiltGJdzCPWMFcISLgiup6fG43atq06P1Wpiz76HvvH1MDHKGNSfov13w7h1OYbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=agkioEpg; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="agkioEpg"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ff6e91cff5so6273290a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 16:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1744760206; x=1745365006; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s+OMw6IT7RHvpGFrBvPfdlWEgNAsFgA/CYElM1NFdIY=;
        b=agkioEpgNE0F/jK+MRIoqx0NAVYTeoUPUJKQRlODSQy3AFMPuZMB73xKd2/RxQLxKK
         Y0niKFsBmw26KPhqcuwteAzlGVzzMcFD5KaYNVVnui1OqIEMvOvAC3aQMWwbJFD6PAym
         lHGP3YdG7MPAxfAt+TvDxoSG2IxY1cdjJ2S/2Kivy42UMED9elnThDNRSmwjE8LOJyP5
         sIcGZTYxBXFgBZp6za8L59mlUNpp7nrBK5oIVvvY13i/71crxwf9oIGWjXH+GVkseFg4
         zP5y0t4esMXcBtAHcwAHBMujuOnI3A5mqSAOafCzwRiz+uEbeuzCZ+NIC1hvwHYbmTkX
         /gFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744760206; x=1745365006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s+OMw6IT7RHvpGFrBvPfdlWEgNAsFgA/CYElM1NFdIY=;
        b=uWTL3oLN11GSGy0i9x7z9f/HktQsnFf8iAYwPCNjsWcscUGfffC96cGSdz0o0scNt/
         n0OAE/puiyTw9EXDsTZ4MCKYWaFryDJcQN4n94UzyNhHTX6gaa39V0LKsRR6x6YiZDPZ
         TOsRychO1uxIoxiqNqZaHac1SCbSE0WeHtjD2KosIU06Jt11li1/bwKvxlJfw2VBJeDQ
         wgB1eNWLT02XIBOt4O7KychNt/WADGaov+DGp/PIdZM7+L0qouKk36CXpUjFFcz4LI7D
         9xnBHR60UVaU+e4OoRf1lQkpYd4xnWwCw+gNWjBUN7PHrRMnl+45a2UaZu6B7KWoK67z
         yGNg==
X-Forwarded-Encrypted: i=1; AJvYcCVqAAq7WGPdAXVw9twbH6Ba2qcefp1f7cyEv/WRFtoFIWGyo1Vep+wdeeGOeViYEbatnlSaTZP8x2I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmp6t+Aqwl/F6ejRynUknOMyveLtLCMKczsyniIPiBZWdCIDU6
	U6LFIV+1ricEPq6CaXdjMbCQfWu1BzS84o+j/rZTKAMvjpVq+q5RiNIWSG0lQ0E=
X-Gm-Gg: ASbGnct0jNUZytmoTG/a6PUYfIb470F/mfOhfvfzcCUUjDor2xBgHKqNql3N/bIVgUn
	su3v+iZkbGD+kmlepLe+VMtioqtqwlidhp0IjqhIFWPjSEQUZLWSnUpCIBrEkH7jXxgqWa1kMOl
	Iw6Njr9PjGVDwzVGSXPjrRurfRwWKojunAUjmJrThVmzXMyvFx/pGRcPj2xRFH1yVdaRL8Jv/vm
	uBZOgDUPADKVor7MO2meHiG6uZFH2ST4/oZRef4AsQ1BJCEiJPtMYz8CPaA6qxyw+3UVSGO4dMA
	9vuKp9VhFMYCosZD4WLelR2Ur8EEiCSbC6pU4F6GD/9+/audSSx6Wej0dBHLGYp3X7t/QXPBRJD
	SEFWK/PfDK9+1bg==
X-Google-Smtp-Source: AGHT+IGT6/zZzWQq7U30e4Mav9AFMxOMf9Upt4/koNxvykTkSnfdOa8SPwd7SKuV1um3ZKHXSwIMTA==
X-Received: by 2002:a17:90b:3c90:b0:2ff:5ec1:6c6a with SMTP id 98e67ed59e1d1-3085ef17d3dmr1638762a91.18.1744760205808;
        Tue, 15 Apr 2025 16:36:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-308613b3849sm173097a91.38.2025.04.15.16.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 16:36:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1u4ppa-000000095Ld-1az4;
	Wed, 16 Apr 2025 09:36:42 +1000
Date: Wed, 16 Apr 2025 09:36:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common: remove USE_EXTERNAL
Message-ID: <Z_7tirRVx9Bt60si@dread.disaster.area>
References: <20250414054205.361383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414054205.361383-1-hch@lst.de>

On Mon, Apr 14, 2025 at 07:42:05AM +0200, Christoph Hellwig wrote:
> The USE_EXTERNAL variable indicates that dedicated log or RT devices are
> in use for the scratch and possibly test device.  It gets automatically
> set when needed

No it isn't - it's explicitly controlled by config file parsing
and/or config env variable setup.

> and generally does not provide any benefit over simply
> testing the SCRATCH_LOGDEV and SCRATCH_RTDEV variables.
> 
> Remove it and replace that test with test for SCRATCH_LOGDEV and
> SCRATCH_RTDEV, using the more readable if-based syntaxt for all tests
> touched by this change.

This breaks the way I've set up check-parallel devices. I always
create the external devices, and then trigger where they are in use
by config sections that define USE_EXTERNAL.

Hence changing all this code to check if SCRATCH_LOGDEV and/or
SCRATCH_RTDEV are defined instead of gating them on USE_EXTERNAL
breaks any test environment that has those devices defined but does
not set USE_EXTERNAL....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
