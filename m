Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AC4F503
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600515; cv=none; b=jmfnfFzUVUDaur8htUo9cKpT3/xqdETB/VoqkStXEN4p2c3XgF5Q62mjH7wtX9+uB1NTwaYJtkaOpkb7VmrYnCoCpgz6D80HWcPLTOBm9z5d/qPf7+2g8AOtBEUC9jvhHhv9DxkOX5DMJ4Mq2Ezgalf0kMMIhIZNNv8M1OkJ7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600515; c=relaxed/simple;
	bh=PP7c3WJwAOmaTmTIfjxQn5lDdW0zc0ktjU03qie96Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NabtmjNSuOeaOKFAH75DB/4C6AB+Ys6kizq2OM0adxNhiyanoIBQqlqCWTMQKOtNMUNEMHRf9vo8mFIaO9aOWIJFxdDO8sHUJF+Xieh+w2LXJlCgGSLruuclUABwstXpKHEjwTSboWYHAkDpGZWNTV1YMGUPd5TSvBHu4OCxvfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=IGUONCh6; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="IGUONCh6"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e0025ef1efso4349255ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711600513; x=1712205313; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=niV3D3yRHFK8E+YZJsodRQDPwxifeC9z6zO7b3Q2mN4=;
        b=IGUONCh619K9pyPgkAFLPbilU4Xf5nl+FXfs3ftfvsOOx0NeyzqGyirWxxtwjeFR1r
         OeuONlrfaoaCtNABicz6O1HsgRzdGqcE2/SUxOfZA6+IVZpBreVfW/Dxw7K0waLPY/hO
         2hVzaRyFyptHRnSLlfNU6q0Tv9UNWeG2Lqe0jLXtpd8eQAj9xzG6XzS8EVMJdsSZ8tRR
         VS00mjRLO4xmZRmKVrP4gIzQUZHmusMZkLpt4DQAu14YG1bLAkFW5yt3CYzIkQxkp1ku
         MSA5ygP4lls5Bhkk6IQB2Ug2tLHw1Zfr90ioVBAQh/LT646roWhItQYVoG8woWaWfZkl
         6DRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600513; x=1712205313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=niV3D3yRHFK8E+YZJsodRQDPwxifeC9z6zO7b3Q2mN4=;
        b=RXmluVplLyHiqs0ZXbTC5GrpLxqXTtKLpj/kxuP5IXCRK6BGHjxxrKYExdJ6GW+UJ9
         3fv/RPjCx/CvnFAUQtc29rm7lyTJ6YQlXyq8QteUAe075Ug08y6/ZBmXrz5wZmZfTx+E
         vIb3qWRD90Oi1tDNs9hx+UDVRYTSgQ18dXhuzEq/dbE0TOQ+wjcoz97x7Ve5vP9ROZJH
         Ku0nMv/4oNM9VpqGo4wgGehXvIch9733iGssINjH0KK9IaR6aTjc+oOnC1Bsj0CFttR4
         s29eNi/gOpanGu7XczWG5GPocIp2WKjmKDPMl4Y1KcUNVQEs9kB+W9SwO/Bg5/xC+Q3S
         VJvA==
X-Forwarded-Encrypted: i=1; AJvYcCUBXuHKdhfnDk2BZgdh6606mYCJPcEHb0EgOBZdY8FI4meBoY0b+oHVvyxzQs2q5xObNFwZf1cV5MoqFmljbLMsaO9fglMGW0+s
X-Gm-Message-State: AOJu0YyvWOt2gYPsHfpKTUYXtkrlonn76UwTddF0qS1c94Cjbr3pmqlz
	FUcDnjYFhnin9guwTf7c/8CPOYVSYradT7B6ZDNpI7Fvbzs7dwZfFSnqXH/FfgY=
X-Google-Smtp-Source: AGHT+IEXyiNwqa3q1+dootxtxGr2H+ONyfIyFlVu0lr1bJX6Lg6mRpIftW48xP9Y19UdNziT27/9hw==
X-Received: by 2002:a17:902:eb87:b0:1dd:df6a:5e5f with SMTP id q7-20020a170902eb8700b001dddf6a5e5fmr2017144plg.10.1711600513378;
        Wed, 27 Mar 2024 21:35:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902dacf00b001dcfaf4db22sm417984plx.2.2024.03.27.21.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:35:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphTq-00ChDB-0o;
	Thu, 28 Mar 2024 15:35:10 +1100
Date: Thu, 28 Mar 2024 15:35:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs: rework splitting of indirect block
 reservations
Message-ID: <ZgTzfkeafmZNHaU9@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-12-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:16PM +0100, Christoph Hellwig wrote:
> Move the check if we have enough indirect blocks and the stealing of
> the deleted extent blocks out of xfs_bmap_split_indlen and into the
> caller to prepare for handling delayed allocation of RT extents that
> can't easily be stolen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
