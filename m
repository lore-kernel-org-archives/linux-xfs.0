Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2FC81741
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215436; cv=none; b=sn6KWX4w/AEyxpQvc0s4M2JYc15z2WuGOmxZeLBUU0EOJguajCSu6ehvz3q0TrIlRMzV69J9gNtfU5OcphPxxw4ZA3nZdTXfzF+pAc1iE2x8Qz0JeMTjASLOkTclbGDEFBd87AZiZJ9ikRsecDcg/Es8WBAd1AL+YDsLlQgMsBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215436; c=relaxed/simple;
	bh=Di3HHVeMmvsPvxJZ02RPKqpJDdCNdHt5T9u4XXK2OJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgOPsxD4mEczTxO76IjborZRAJzVAMJ4wjHw+7vX11usqRkmI9Mo7Nxl01nkTd9WVv8cwMbNl/vaF9BZBwrBjnPibFFTkXoPboNpIdgf/K3O7jRqRi0Wi+jpdjMM/94LAxN+dnY5oHvtDqT7rDdzf92gbr8WRYA9attiAH2UlcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kdzyzaWV; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kdzyzaWV"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7e6b738acd5so605214a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 15:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727215434; x=1727820234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GEs+9DP+HE2tK5M1HclRjQdhyaSyms1rELLomIrD//s=;
        b=kdzyzaWVuXKSTjbDfZF/3IMS820IIgL02WVNLfjxFk5VQVcjKbiJGXwlKYdBG8wltU
         Rz8K4sUMKTUq4VDst+tCEe4Oq32GZ+dZgcqK1XqnEFQkNbWe1EUMLn6NNvrLb+VeQROq
         N7QMod6PoUXEjjJDxcRrambAo6zcEeZvc60tKvxaQE44ZQ5Az/c0dbMoVYi07qcEYG9q
         RBpNkgvr77+J/On8aCwlPCiarGMJ/DY+LB8oV5fvYoRDEc3YuzBUZcuqRmapkXmXhmdr
         DbZotR4g3i92QLs61obu5H1ENQvzgArt5chcT7rYZ8bg3zYDxZaFAqq0JVxM7UEhGbp7
         1SjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727215434; x=1727820234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEs+9DP+HE2tK5M1HclRjQdhyaSyms1rELLomIrD//s=;
        b=el6b8QgSOw19k++o68GRGl/qj+sXKyLMzVdKYEODSkPWKTUklSdQZ3Q6sfaw66WwJb
         TiCikI+Xpu+Gak6nccU0gh6xZUksmqyZppOGjWFYsokuV+I4nDJd+SwslA4d7S1yYkBQ
         /2Zhmf6xTGKRGAD21xUcAw6CMfBV9sgM9ZFy6bZV1SqQ8EUBdFFUNHADrdkbhx2jRtEG
         x0Pqa6DtRMogd5pNK2asYxXBBvH1WRJn12EokAKmn/I37S1nakNEGbKQ+wRdFfzWRHdu
         1JNnev60q8XH7O9ya/o/uiEeHKs5Q0mnhnS60/JphLPBX+U6AX0p9R23N9sWoKXDMJCd
         NN5A==
X-Forwarded-Encrypted: i=1; AJvYcCWWrL75w9VcaJblE3qu16Zu0Ahs5q6TyPXkHQLxDPoVFSQvF7Cjyewb7WY8uGHaA3c+/I8bxV4f4vQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr/h1WKt3pCJZ9gla/2mhpRa3sdpnEFkQgV2QJ+lJFPMvFQX3c
	YJU9LpR/Z6KNHsRbGZ+adNlHLVPC9miX9EKnJvFopvDxRqWTFENLpboLLbua/U4=
X-Google-Smtp-Source: AGHT+IHr/pTSH7JQH7QpJpwhHbi24g03qWDkFXAfKmtvvfuiQsgnuZctfyMui+Rb0qd8IWWwkBBIJw==
X-Received: by 2002:a05:6300:668a:b0:1d3:4301:3c86 with SMTP id adf61e73a8af0-1d4c6f2c90cmr879386637.7.1727215434408;
        Tue, 24 Sep 2024 15:03:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc9c5a9bsm1611318b3a.186.2024.09.24.15.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 15:03:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1stDdO-009bHt-13;
	Wed, 25 Sep 2024 08:03:50 +1000
Date: Wed, 25 Sep 2024 08:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com,
	chandan.babu@oracle.com, cem@kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH 6.1 00/26] xfs backports to catch 6.1.y up to 6.6
Message-ID: <ZvM3RhJxJuMeARbV@dread.disaster.area>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>

On Tue, Sep 24, 2024 at 11:38:25AM -0700, Leah Rumancik wrote:
> Hello again,
> 
> Here is the next set of XFS backports, this set is for 6.1.y and I will
> be following up with a set for 5.15.y later. There were some good
> suggestions made at LSF to survey test coverage to cut back on
> testing but I've been a bit swamped and a backport set was overdue.
> So for this set, I have run the auto group 3 x 8 configs with no
> regressions seen. Let me know if you spot any issues.
> 
> This set has already been ack'd on the XFS list.

Hi Leah, can you pick up this recently requested fix for the series,
too?

https://lore.kernel.org/linux-xfs/20240923155752.8443-1-kalachev@swemel.ru/T/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
