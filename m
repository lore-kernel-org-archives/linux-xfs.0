Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F91524C
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714504; cv=none; b=dSUSBgLXdUsR7mp9zIvMQYC+jxCkMouZCnua6Dl8krROGkE8xqIxByiHqiiaCy3pNPOIHNkjFj/5ZdwnVHllFjjjnqg1hjEsEIDjBRMpO+2LmTs/5mtuDfwrjLIl7siUE8fOgET+krKh/rRSYASl69zE2PBeQZM1NthpDWLfa+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714504; c=relaxed/simple;
	bh=uLQquXgmTssOR68eJsMIs4FDbJ6qba0cuODYGCF5aSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZOORSfl4cyW6ymbEBw6sVvctTGE6KlW26wrEAoPhvFLzEbQRdAyKgGbuXZl1YQIx9dxHPUUEg6f0Swo0SsYmVFxl2V6tcCxDdXuLEfFAFXMh3y/Pk6avm1PLE1lxLcWstEmcP4yDN1ZH2uQLoCZKWrr/GTdioA2dwk1QIwPhGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=olIQVgtP; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="olIQVgtP"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-215770613dbso85143435ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738714502; x=1739319302; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xla1eyZLhS5EmFBfiSNE0Sv70/LRGJRczxpfK7Flbr8=;
        b=olIQVgtPlGxl+YruE5kdMEvqrkEGWaL/9lKArVrxjFcBuynEOCy8f1AgL5nHCDFYR+
         MDREpcno65bvhDado+OabQ9h2G7aA2XI2mPQ9LX/ofydmy/00xCuWNi8smDx2XI8EVYF
         VW2I/2hKhdGV3D3Y1hoMpDowt8BCDKIIiDSRhJvNvUYUd4jZCmUVCxsjN3ts2v8kwO0v
         HJ50JKPB9ZJhJII/0CZk5gSSBtnCG+BdQJjMJV/Blyn+Ri80+pAdmU4r+nwtRfGho49/
         uPpzqOoXTCVGonEdGgL4DkUG4iKLxeBdbLuUzbnmIm4T5UaVJKLAk9StcX3bzpkE2eOJ
         YoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714502; x=1739319302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xla1eyZLhS5EmFBfiSNE0Sv70/LRGJRczxpfK7Flbr8=;
        b=qxD+ISp2WzLKJXAvuvu7l4PLrEZd2z0j8kZzpAxLoOwIjxZLjYLCFVUluNDxI5fEs4
         ucWH7IAqIPSyemtRm/39NbBppyaFxLv6HkbyFkZL0an11xDUtELTZlCTSbQPQZcgvRH1
         o6lMSRg6CFTrFigKu9rIpNE8lqgErqr+qBony+rq3KiChN7CX7GwY25evwG29AVw50zR
         hBHTuiaSw2OBCBE2DhidhbEhLPHowi1QTnyfmfJGdFte5jmQ1PPGI+BGOfqnleg1FswK
         3okMZwoX4WHBI4UF8vcQQqjXsGERFoIcUKJjS5+CgeK9So4KwtJdVS6gNdV1GYfTG+Hr
         fJ+w==
X-Forwarded-Encrypted: i=1; AJvYcCVC4UjmBs3FZW8LEAR8iXNzcTPojbkiPiz+ZLm5fpdHRArK//Qn/+MzK01HM6FZblMDtJ3cHAiw6NA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBcOjjZDoQtD77+fStasDBqsBUyWusOwwhbrAg7itK+J0fd7dN
	Ephk2iW9ChqvME/Xdv+/uHOVXvHUEVQT/ERSpDuIOw+hMoDe/2wWF1ZdImLCDfA=
X-Gm-Gg: ASbGncveLgEEZkGSkKGclUlj4rNDNZZb1rlKqaKHO8AqfIVZT6v/0IYHCbKzpHDTkYQ
	MnMculOttehYOB670fhXnnUVDCLQI2azPNmh9UeXyVv40CO9EQ2Qxep9SMIO+95yIwUW7GY33J6
	oOQiUzmreOtPnaNkdKBJ9WB9JsMs4SqMCA617DQ5o8rLQtgecx90UneUXNmmyr57L8vjnJo/YNx
	mtl1l/PvDL2OI2z7RCvfixJ/SXA8E6uv8pStrc531r3zv+JcGrdDSmfbxt9UFusvcKyHf3wKgqW
	+YlD0JW393QEQumJMb7jQbVTKGr9QuPTiM+f6P2LFlpJKWyqhjPaFrvF
X-Google-Smtp-Source: AGHT+IG0ZMWlZfOgtD5/49DBQQ8c4viEqaE/OcUlkg2Uk2pkVUFdphB5Zr5X2zfwoyulKwav1rtDHA==
X-Received: by 2002:a05:6a20:43ab:b0:1ed:a80e:932 with SMTP id adf61e73a8af0-1ede88ad49dmr1573766637.34.1738714502409;
        Tue, 04 Feb 2025 16:15:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe6427abdsm11619259b3a.59.2025.02.04.16.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:15:01 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfT4F-0000000Eip8-27QZ;
	Wed, 05 Feb 2025 11:14:59 +1100
Date: Wed, 5 Feb 2025 11:14:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/34] common/rc: create a wrapper for the su command
Message-ID: <Z6Ktg3-oudF2wxJw@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406275.546134.6082485989827844416.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406275.546134.6082485989827844416.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:25:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a _su wrapper around the su command so that the next patch can
> fix all the pkill isolation code so that this test can only kill
> processes started for this test.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
