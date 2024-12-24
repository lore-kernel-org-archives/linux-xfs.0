Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E08442C
	for <linux-xfs@vger.kernel.org>; Tue, 24 Dec 2024 03:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735011734; cv=none; b=t0ZyZ0hIw75TCMpGvVH7d9qTWiHW+J0GO40p9HtGFcASLYvk1c8aMSrifWfrDAf0edYtf8UTXfDIdvmOW5uH4aRqRY4nrVlAGqxhGM2fKFidB+ScY1Dke1qyh8JAGYxmXy2bVR9QzINGOFZTDPx6THYPdkcR6Y2hhEJwfIkEWTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735011734; c=relaxed/simple;
	bh=1fu8nfJm3IOWjAVpJ0n136lM1Kc+oPxZ0Rjb4eFmpdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2Fy/Zcr3VwsWbbTNqnwonTyndB74Hl7mKIdtN/RzydTf+USPvUzfGWM7Y+uFau6hb7X0khOfvilixaYZewQL9H0xZD9U9OP1C4+Wy13MBAXfu7OK2/dcOcijZAPzxznNIzZRz9wf8htrQSd30l8GRjQGqRlssiqLqm8TH7t1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=do8gruJD; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="do8gruJD"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216426b0865so45386505ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 19:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1735011732; x=1735616532; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nQedZNdDp/jBWVwlq8uCWbyifuEaOOrezI5x6ekQo+8=;
        b=do8gruJDcB9X0fan9qQqYzRKq98FxNUOxje3NnZQeWplR7fbQ3XV2x2EPeYTtVCo/R
         fHhtbWTEj4PZVGGbqJQOMxtqVhiC4ZxroF0sjBzNLyMSpslIrOlwcAJKqx8Q9+LQ8zSN
         71Rij19ts+pEPotqVSeaqTIrcnFz27iOFixkBrnTjbLz6ZvVbin7kDn/KmHoP4kwb7RN
         QpVI94DUZNjvqaJGj963S+HQ0wBCChLjO2DIkOCisait7Wfh92sO+vjt0h8kkkGMSRYd
         CX3tL5wJaUeK5rJFrP3LmGD01Y2x17zlKbK9oIzprTXRE8F+tApRrBBLkp+UOoJNORkc
         a8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735011732; x=1735616532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQedZNdDp/jBWVwlq8uCWbyifuEaOOrezI5x6ekQo+8=;
        b=Ypv/XIJoguVoqTvYAY1QYeNdlQhjQVeWPyGU/YJCAYmaW0Ft5Y8S1a+DymulhWkhv5
         eJw26W18LglVsvQsdId9U0Yu2G6QGy6CcRLcp+YsddGyiGC4ODgFETMzxA9yURDkDWyK
         Dlm+kcUAgGO/mOZ0zOHiC3sAVj6y60U27dguVWa6CwYfCpZXN/jBa+39DtK0/VGxQ+72
         dX36FesfnNlhsAsy90rpYcts7S6yu09kdU/O6hCxEYcydLsZ3Acz8i6HL8tXkPpgiSH7
         EuhgSuKlGn/GWPrtVT+InyBbWU5MQebDtyQlraOt7k6X6sycECoqa+QCWsruw2Ns153q
         vEgA==
X-Gm-Message-State: AOJu0YzOQue+ryiu21vZIwFaohO30wkskocfI/e22ueLV0DK55o868rt
	oEV3lMQeaxJl7888YrX7j3FiFhGsTWD6/rW1r72AhCrnfMzRgOGq3SBHDUquvlM=
X-Gm-Gg: ASbGnctg2KpKpBvS9hYm9bLBhVxoMEzEEmneMX7Xk6wbYkQvqOa7hBnN0hgjIacMo+t
	8e5zmh1HMChx9581lQ0XQ0Jdlzsj2kWOu2HX1cFW9zirGBC0BF0l0FDqSevRWWUsw13UstTB/UT
	Q2BWWnCzWcC+dULd4SqnGpbKDLBNeycEQSmFBzHr5ajDvKTAzu+4+PVS08aSb2wkhi0MeotHMo+
	BKgLieI/04nq/xXfL3bKl/qKu9Aq+T0Vc+nLBaBltSxUMOhnmBCgQNUux6IcA0rprCnm7ggo75h
	992LzKKx9YZkvTcQOzKPX28HLdc/Kw==
X-Google-Smtp-Source: AGHT+IHxxMz3A0NSCMJo3FWxOwFzvBBRD+0DmQCeEzAvSiTarTPuXc1XIPXWVbPhIizQ4O4FrWEuuw==
X-Received: by 2002:a05:6a20:2d11:b0:1e1:bd5b:b82a with SMTP id adf61e73a8af0-1e5e081c66amr23463719637.40.1735011732132;
        Mon, 23 Dec 2024 19:42:12 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8fd4e2sm8669941b3a.169.2024.12.23.19.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2024 19:42:11 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tPvo8-0000000EZGN-2JZl;
	Tue, 24 Dec 2024 14:42:08 +1100
Date: Tue, 24 Dec 2024 14:42:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sai Chaitanya Mitta <mittachaitu@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <Z2otkMAbTdrbtNFW@dread.disaster.area>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>

On Mon, Dec 23, 2024 at 10:12:32PM +0530, Sai Chaitanya Mitta wrote:
> Hi Team,
>            Is there any method/tool available to explicitly mark XFS
> file extents as written? One approach I

Writing data to the unwritten extent is the only way to do this.
Allowing uninitialised data extents to be converted to a written
state opens a massive hole in system security.

Go search for the discussions around FALLOC_FL_NO_HIDE_STALE from
well over a decade ago.....

-Dave
-- 
Dave Chinner
david@fromorbit.com
