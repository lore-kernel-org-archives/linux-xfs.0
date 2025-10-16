Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3443DDD2
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 04:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760589527; cv=none; b=cIwzGxfFh7k/zQQSnWqdh37hIQrAyJ7VGfMwkp0YzOSFDnAOha9dBDa7fzkAzWzvkJUhPXBUKkVqxChVkzd6QFuSp6a+VpKFEcZuFqo3Z9b2XckJ28kHDPOEdEdTE3GjFOXFOUozwIIpB2VEx5X8w0hhuti5gS/BW+fuTGpJbto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760589527; c=relaxed/simple;
	bh=TnUHu2GiGjHo5HuT52qgNav/qYhpc62R4HWB7PILJJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeP6NHkmGu26Ze4ac1wPuGa4fIzbaCctWTWecxTNqRNOWBUN7L7aT9Drkq3KSwIWY7Zm78KWW80JhAE+YNwzlBi/NleHMrJ+REm6Gor56VtziYpxJ4UiqEimfF3Xu2qHeE2y5tYLe+Okbh8Deo3rcFL+EcMIQepsqPnk3wU6+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fghz+Gqk; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fghz+Gqk"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b609a32a9b6so141078a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760589525; x=1761194325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sSRpjEmQwt7ou/9XYa0U/hfageOcCN9NyR+eTw+NRGI=;
        b=fghz+GqkFOx85YVASn9somgR2dJywSlZpyx/iZW2rFtwhOOn6xjGbEgm2sWXw6gJ/t
         7Lb5PtoT7ypyxeYHx0W1w/oSk/NOo1VkKmOuaxM/dPvFH9LCebxjuiXP2rqBPl2rqtj3
         ygTIjE5RN0JN53T1lCgk8CVXk5ma8HeHRzk8qWi1nmP7iLGxuQZG6wR3QHvD0PiKsGvF
         YVI0mV0A++99byjQrA7NNuaoh2C7GYH02Q8xH730vikuZJ1kqCYg3ap1eMym4rx7owRT
         n4ralAVAqsnhwFAlXbKfWqUNPXHcgh70vJ7r16IWBJBFdSaXtPOam5+yR+6I7R3yuDts
         Nqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760589525; x=1761194325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSRpjEmQwt7ou/9XYa0U/hfageOcCN9NyR+eTw+NRGI=;
        b=Si3DWcPBrPlVcrwALxl4wKx/ThgWFXVHd8kxgk3t1r2kGhyt7tNjFNTDtyv1vZYQaj
         QY1ITsql56hRja3waw3EfKA+iBISPMYjBp7sqVFvdcBKxqhxeb7IqVutwgM4X1lDndyo
         pn/UkYsXzSmV79SKXakypIaIW1gqfUEctp55MdvKnOK45MCRHpNkY0+EzjOzXi+4R9/8
         tOO9t3wbdL37FP3MLoV5pBWF/DIl8XmUyaR4rT1VCqw7yP+yWf0WaKS0u6eKQ3zKHXra
         gA0IGfnLceVqBbAAoATFtE5/opwZP+I827KBib4X+DsWo89ELRkYXo0XVYIe+Q6u4imI
         Ze/Q==
X-Gm-Message-State: AOJu0YyWYg+8zimp9OZfJfXusQhdQlAWvmAd1yRepZKakPoPLO+yVmkF
	4OXp8cIVKrPSEuNRi9M7UP06fhFOSe3HHwCi1grlG4LIlaw668PAg/3+p9eyspZSvP7zYGI4JZJ
	VinHK
X-Gm-Gg: ASbGncsnaAokzBYOHJxGHoef/AsW+RvBQ5dOtyYGxHExrd3orsV2dC0ovkdRKz3wvQq
	SNxG9lqBHzV9MvOzqsJLJwT8KacYdTAOqJi+mBu6i5vHdJp8NkDnvvUZSYW8llo4CKI24u82MdB
	WnWUSrAf32bY9k+EPLEaczwjPl2slsdgEtOekXRKF3vtnqvxl+oDsMD92qMuZhzBa/gmvdGWT/h
	hXjYtUSdQkJOaYi4r5Mv4iB5Am+6sC59eMIAvDL8VVSdiDDXc0Ei6JuKO140ib5jDqSMlA67bsk
	BsXbhiWqAI4YtVaUxgFjg1ziG8pNr39PuH//rpD29YdfnasrtSA97acx1CF+SlMnMpv1ZayGOOm
	fJeLkNZZZlvljdCEoyfGlGssYGVihNKCSKwn3R8T5gJgDXZq2P97z2+e/BosueUIYp22hlZOCqK
	GGHVxlMEtKcFMVhRuAiZE0v13fPsfLkte/LKtOIETWvWvk2g0J+z6EVd5bsC9PWw==
X-Google-Smtp-Source: AGHT+IEVbne16G8hJLaRFP7amd80K3EEiojCoYNtXA0LIymRNNBDbCsrsl3zgNbYCQanqhBE5mjtjA==
X-Received: by 2002:a17:903:1b64:b0:240:9dd8:219b with SMTP id d9443c01a7336-290272e6eacmr415252005ad.49.1760589524797;
        Wed, 15 Oct 2025 21:38:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bb6522faesm145676a91.7.2025.10.15.21.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 21:38:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v9FlB-0000000FS4o-1Qab;
	Thu, 16 Oct 2025 15:38:41 +1100
Date: Thu, 16 Oct 2025 15:38:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 220669] New: Drive issues cause system and coredump and
 reboot
Message-ID: <aPB20Tg3ROqz4UQo@dread.disaster.area>
References: <bug-220669-201763@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-220669-201763@https.bugzilla.kernel.org/>

On Thu, Oct 16, 2025 at 12:10:43AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=220669
> 
>             Bug ID: 220669
>            Summary: Drive issues cause system and coredump and reboot
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: bshephar@bne-home.net
>         Regression: No
> 
> We have a number of drives across our clusters that don't present as failing,
> but seem to have read errors that cause the system to coredump and reboot.
> Failing drives is obviously not the fault of XFS, but my expectation would be
> that it doesn't completely cause the system to hang and need to reboot.

Fixed upstream a couple of months back by commit ae668cd567a6 ("xfs:
do not propagate ENODATA disk errors into xattr code"). You'll need
to raise a distro bug (Rocky Linux) to get them to back port it for
you.

Please close this bz.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
