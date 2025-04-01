Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514AF2144BB
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 21:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743543459; cv=none; b=FFtHNHltUCeipwC7Namrm3k9eKgj52ZKpLWWWkgFfjAm7nvbogOp0u8gmX1AYYEHlge5RaS9OW1RZ4L5ksfcoptfEhrZR6JR2daEZ4gokoeP0++VOP7gbBlLLlm9vgyxPSl7UrkD4xS5xpXYqGwJVaL8lRPsOBr8zuTzsUf7IhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743543459; c=relaxed/simple;
	bh=Zfq+e90kIJYmWlLbfTBqcfsN5jfJzfqB3zrpKTonHg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U414xdZqhS8nuTujmX52v3uhP6PjTm5fKJ8OjSJTBwCULxlvmICPRTea49XBr/cimzzJ4PBzcpKdpgE9pjI+QsHbWnxKX8o9P0S+mk2TZ0zQSx1UNOGjOF3K8Rbza9JAC6yOB54kIxmtcr5m8bfdvqjMIQaMYkRUFiSF2tSp4Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wD9VTKdw; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wD9VTKdw"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-224341bbc1dso103038235ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 01 Apr 2025 14:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1743543457; x=1744148257; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ULn61q6MozZnynxCXcCepY0O1QeWkpcYUhiO0MIBGX0=;
        b=wD9VTKdw0Ess2HUvGuruaCBIiZrgjqSIxm8qfA0Ufb2SUJxTUft2tZQp4rcDsLl/YA
         k4nh+VklUgxRLszhSgLXOBBdtTe5xjmBDsTP7CPCNBh4pdd4rQ/3XGGlOc1Zzg+tI/Aa
         os43+2e9QZFi0+q2H46wjnkjDjTK4B5H04vSnmfJWAB4ebrnB6oPBJFk0UfQ0A0COY+x
         mGJHLcrfJrOFEXMoveE3bAj0fzz89J4EuQ7yZdDL6jgk1YXP7jzTljjRkN5Q40l8yTZd
         SIA6sbZC01SIYhVEYDjZNmpNBqtribAxWxOTEiihLu9m3mW0cT72Po6U3uHre+Nlcov/
         OB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743543457; x=1744148257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULn61q6MozZnynxCXcCepY0O1QeWkpcYUhiO0MIBGX0=;
        b=PJXep6ao7Vki2FEh9gjkQTWvWoIwZUztVRupzbRzlgZqhh5RQ2akZkeQ75O7UgBePB
         waF1/pOAj/xbjEyvEnCdM/Djwql0rQZ70Qz0jdh+I9m8nw3+CBAtkh3J8g+iIbTPskky
         C8mbsmo1M/dp2FqonCmxCyIhY0kGLRR4RM9bx1d55eD3om5/0t0DL3UyYj/ZYpjjy9oD
         nX7Av6e7qV0K22AYs4pRUTemtU6IyazA6VgZNravcCC57EG65pv+JzEpZu8Q1kEe8vDy
         BPQsyxDvdLPdBJhpddYx/zx/qszTE2ZLzRxmBNA6aiIh1aqKXuYj1JPlb9JfjtoddJVn
         6EsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWldB1DXlFZExE0rNeUUmRDfUCu3SDFbZQulmlNlsqKHv/xDBd4zbAPZEUsDWsW7djnOWQDTnVPmRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUtTO99EqTXNZiX7Z/BHe7BomdzbWtDmVv8m0miuc2wrmkp2KX
	rrJ8E00mp+fmt14B1ci7XluZ/e8n95ELLHySHZeqNW5kOfanihIAkS5yy/udFYc=
X-Gm-Gg: ASbGncunbE1EiQnNLWqbgG5jG6B906h3kYulx+2AvGZcpXUuLZ/iNZole/LA8YlKFjr
	fJkcUWvPYbp3ij0/X0B+d1/11zUd6x2Qb/FAWPZMgzcFGixSKy0PwpZDK1sboxYX9pwvMbk46aZ
	ELH3YL3fkPOCTyjEsD7uQAmOwJMO/n7CisAtml2lM20hLdYHko+6OaYlW+wRM8GbNyhppFa6A25
	xCH9R+bX1Ggube3NOcP52nYbpiMH27O0bK+4IqQ2R1do+2ejT9aAqQjYDepcUa4G/VeVGxxKw/Y
	X8KDW0F2dWTN5EqVvTrUdAm8rQIlbFvMhY29PSUN14+SQQjRmzgij+Gp0MJCFAxk00Mx0wy7sGX
	K7a3deo7pfpAdbr18IQ==
X-Google-Smtp-Source: AGHT+IE3QYgeXg6/2MlJM1fZCmUe7aBtYQAosAh70NXGSZ1t+mEm/dDygBcG4sqjQ9ucj+eb0t4h2A==
X-Received: by 2002:a17:903:19ee:b0:223:4d7e:e52c with SMTP id d9443c01a7336-2296c60537fmr719425ad.5.1743543457550;
        Tue, 01 Apr 2025 14:37:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291eec533csm94712635ad.36.2025.04.01.14.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 14:37:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tzjIb-00000003GtN-3ov3;
	Wed, 02 Apr 2025 08:37:33 +1100
Date: Wed, 2 Apr 2025 08:37:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2 0/5] Minor cleanups in common/
Message-ID: <Z-xcne3f5Klvuxcq@dread.disaster.area>
References: <cover.1743487913.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1743487913.git.nirjhar.roy.lists@gmail.com>

On Tue, Apr 01, 2025 at 06:43:55AM +0000, Nirjhar Roy (IBM) wrote:
> This patch series removes some unnecessary sourcing of common/rc
> and decouples the call to init_rc() from the sourcing of common/rc.
> This is proposed in [1] and [2]. It also removes direct usage of exit command
> with a _exit wrapper. The individual patches have the details.
> 
> [v1] --> v[2]
>  1. Added R.B from Darrick in patch 1 of [v1]
>  2. Kept the init_rc call that was deleted in the v1.
>  3. Introduced _exit wrapper around exit command. This will help us get correct
>     exit codes ("$?") on failures.
> 
> [1] https://lore.kernel.org/all/20250206155251.GA21787@frogsfrogsfrogs/
> 
> [2] https://lore.kernel.org/all/20250210142322.tptpphdntglsz4eq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> 
> [v1] https://lore.kernel.org/all/cover.1741248214.git.nirjhar.roy.lists@gmail.com/
> 
> Nirjhar Roy (IBM) (5):
>   generic/749: Remove redundant sourcing of common/rc
>   check: Remove redundant _test_mount in check
>   check,common{rc,preamble}: Decouple init_rc() call from sourcing
>     common/rc
>   common/config: Introduce _exit wrapper around exit command
>   common: exit --> _exit

Whole series looks fine to me. I've got similar patches in my
current check-parallel stack, as well as changing common/config to
match the "don't run setup code when sourcing the file" behaviour.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
