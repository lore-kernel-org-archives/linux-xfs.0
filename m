Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47965271834
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 04:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739335651; cv=none; b=l/ICDkN+/9xVnEg4h2H2NHxqMPSF0yzKHRrd6OpoAHr0hK8Iiyd3on4gMBioXUpSo8N9xn4v2jmmdFHBK8FuG4zjqQTJaLUf+chaEPKjItyPn3FYybRdjMyW7fbrmbrzSMPyY3QjXApAC96qiH2ZuA5xbVZasNEyrpYaLMe68Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739335651; c=relaxed/simple;
	bh=f27bNBT3p4HquuRq2LPQoRqtTkYqJ2yA6uH4der0q5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZvUQfWi9tg15oCe2UgNrgyJ4pgXamwqmTy0jHvOvZJDvhGb5oiygdTuvPtMQmmzQ0PJX57u4HtJZWbZShnR9NdhXUpLszCV6+cy6J4NiRW1f0Ox5J5nxTUtGfRWAIs71T0OYEkD8O4aMxSfnD/i9syA2Nxs7ozO9CDj9JVsPaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sXTJVDUk; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sXTJVDUk"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2fa8ada664fso4017247a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 20:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739335649; x=1739940449; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EkxBEfne5UM5tFA8NdjfKwYwgW332jJWCEY5tHZ0YcM=;
        b=sXTJVDUkyybWk7Nyq28YgLFqlnFAzfGJxjF4Aew+gaITS21QvICaEs6xTfyicAgc6l
         rF78Une64ypAVK+5bc0fwhJ2dhG3k1tWM/Z/HrT11+qDn9ZowvnmSEBnlMFpEg+a3egW
         60y70ucGyw8RubF3Yf6/nskutQTcZOJoJi138SSKRWaBlyztQrUorqAbdIITEU5VJ1Qv
         NuagulgmXhLX8FCv55/jvJoNweP+KMDN6WtrVqubed/pUFc60+CFVqRpnmWVKQAEfAZN
         2PQ0udtrtYxocqUroX2EsL8Gz+8uhvk3AfWy/lHyomgBaq4ODx8GwJ9bEYowQb866kAW
         mb2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739335649; x=1739940449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkxBEfne5UM5tFA8NdjfKwYwgW332jJWCEY5tHZ0YcM=;
        b=rLDMK7O1POxytOqEJVeGAddbtGmv2ZAr5uFP77prJ3pH/YbzEGZubCQoXOqRCjJ4qx
         iPNHls/tPL2PLae3fmq2ArJkVTLlGchIlbiDFzavlK7Jo2WiXrk0DZVtVaekEzEnEyi3
         R1EIdkdVc2PWUF/PLCn1KuYEEqsSySZsHrxcbPMv04Qwxopx6M7xWnTWzVmhmaKc2i++
         gYSBcgkAX2wx+MC0pQpTdlKpbkYG9ndVdEWjH4Yk5fvMwnJYEbEAPj5+qBdQ2itMOIMj
         O+psevZME7+dnQ90papwjUQdFnxW4TFDun5EqmScv+psrXW2l3M2rAufpAN8WJBPYO1i
         mtqA==
X-Forwarded-Encrypted: i=1; AJvYcCWeZ76qDB5+Ds9OuYKN7vuOGfAsHCc6HYX2YVYrTw9IGNI2EgY7lcCQxVq+A4i/RkE80oROk4Qng3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF+RdCXiPhN5eHClVYlyrRIapdciRelQbcrrhFi2rB3EIpttQE
	g7dONkW1AO522dFG+qmSxOTW3sIOQlowzyOnA4Xf+ISvFHj3iBR3FddVQ6NcItAH2edavKHbZcU
	O
X-Gm-Gg: ASbGncvDfyAS8/sDESwibmbohAqdYOYMp9YFCzgITTfE2XwuQHym17JL59qUIS19GRW
	lhQm1zzjVvtb4FWL7XNj6BjjwG7lDs07lFeZ80QI/UsbYuEpD2JH31eLCCTGklsGksk5YIRCA7g
	CIrrNBT5GD3eXBlE4I7Q48KzV9/DXCzKoAc8FOOWwob9lyL0Fh0d3t/onsjngNH4RB/RKqujdc+
	0U7ZGr0KzQg2aPorKcfXGxyAXVy2lDopKMfh1bw1r3CcVrtLXIfEEFE48rvTquWOevJcvZd+S/i
	3nPP/60crPVLrlNJGvRbWxQmfuAM3y4XdHH+s0z49voXHgcj89lnaN6Q
X-Google-Smtp-Source: AGHT+IGrlsIFPKBFanuiHBKlDgViUYZSu/xKvZk3p10Pq/sHkgP6fZDQnJuANfuU8HomnGcQPTYegQ==
X-Received: by 2002:a17:90b:56c3:b0:2ee:96a5:721c with SMTP id 98e67ed59e1d1-2fbf5c2cb7fmr2642786a91.21.1739335649436;
        Tue, 11 Feb 2025 20:47:29 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98f698dsm442497a91.28.2025.02.11.20.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 20:47:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ti4ek-000000009Se-1PAH;
	Wed, 12 Feb 2025 15:47:26 +1100
Date: Wed, 12 Feb 2025 15:47:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/34] fuzzy: port fsx and fsstress loop to use --duration
Message-ID: <Z6wn3g9TnZBZXnfY@dread.disaster.area>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094766.1758477.9477390850462245159.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173933094766.1758477.9477390850462245159.stgit@frogsfrogsfrogs>

On Tue, Feb 11, 2025 at 07:37:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Quite a while ago, I added --duration= arguments to fsx and fsstress,
> and apparently I forgot to update the scrub stress loops to use them.
> Replace the usage of timeout(1) for the remount_period versions of the
> loop to clean up that code; and convert the non-remount loop so that
> they don't run over time.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/fuzzy |   49 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)

Looks fine

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
