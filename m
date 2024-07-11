Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F4E145B09
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 22:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720737878; cv=none; b=stLUfearMk9yTUkSgnyXZyB3RolfPu4q4EQioQsiB/DdCXNL3PaAnSXelS9MnkRT1TkDqCnRzzLJyDQMbShnf116K5wJYl6FqbEmBKhIKxRpDLBOsTu5OALBYRoPKxV6r8PP4fWrjvWmP2wzV2h0UcZHsSSUzmJLf6oZz5cjcxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720737878; c=relaxed/simple;
	bh=1RaTGBZt8aLbbKkWaZzBVbxwwOpp7O3z17eENHCunFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdWNqFfX0U4OvI9DIoqDPpWxUZQQQJTqxBObEfqqHfLvcdez1Fzznpa4ZQ6Nw4d/2ydC2p7gkERbz3+gVI8DdZEQ7OqG+Pczeaq7mLNfq/CvZeGn6dgKM15o7fR7BdIXDWaY0IYpRY5lJ9y0HOTmtS92OpIHchvjGb/pYnfxGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=P1QvVvoQ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="P1QvVvoQ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70b0d0fefe3so1179218b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 15:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720737876; x=1721342676; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EH3y+9BqqbUFAQm6DnVnWjQAH5ruhcc02kLgBPcMJec=;
        b=P1QvVvoQ27GGu6Hvbdbmoc6ngNRo2BN7uqZTLHyZUC6TEkYGEGa8ZSXaadGLsuBS4p
         QGJ0s68DM3+trWKHHkBjGAtqSE6e8a1BJgv6rDFKELQzsFrlsyeSOGdAL/GqSw3JRG+I
         ZZ0bxaMbqXGw+mQB5ma/fdy7tJov2F4q7zLW8Hrgb++jqd9AVe1U8U0AFxJELUT2PplF
         FBzB+P7uSufrke87cV0W/SsR6Bj2tSImjrTaGEo60djOBFESm2M4+PZUO5QlvlPncKVE
         1PzP4CyA5pQp3w0Gelz2QVBSAVwXaDNL43Gqqqm4zQCIA4rYVayYbS1xxFxwE+wwEm/K
         PZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720737876; x=1721342676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EH3y+9BqqbUFAQm6DnVnWjQAH5ruhcc02kLgBPcMJec=;
        b=esbVo9cNReEmxBc5y7hdcR9Bwb2PzO9UqiARenM/0Okf2muBjaJRL30nWE8ZD6v6Ut
         2c3evn4F59Sbdk7ATzLiP97uwHFsEGLAPwavOyozh8biIrVjev+V8rQDJGquQdkmpB5w
         wDnYK0De6vYn28ReRJ2H8w9pyaMX0s9L61TeyhC1iLJxVFJXQpfDmRpvP7ZGZqAu0b6/
         vG46dGj1Gv1Um/6mGFSVMKbXV+qPMD6mTv9wQ50wi4WhxNhircLnf5agULE3V86F6cQb
         e3EN36cT02mcBJA6ZvQa2Txr9CNgs1XtgPiifTrnzIkokfK6Hpsr1ETW/V+IBo2aePjx
         ZgKg==
X-Forwarded-Encrypted: i=1; AJvYcCUadzUnDxY2j5cr8MUn6yRaxn4NDfzJrtCiLpi50POdfAFWs/W972WOJrEi2oGQZXkPEpYq+q5tP0mYzs3QzRMGQ3chTKxRvnMx
X-Gm-Message-State: AOJu0YwIm4qAh1JU7hqVj2+rMA9Y4SbjdqIagTPYh6D3rAgHFzsXJXe9
	rF1XP+XU71oVm+rEEpTH+kQM7u+ZJR0aYxV1FdoJKC1ieR5qtUNFs7jYpr3S7UU=
X-Google-Smtp-Source: AGHT+IEXxxtYqB92HOvmki+1kEuUsZbRH2VZZzneXsqz1sVdMg08C3QUb+ctnFfqsnAbNNjAUTX/6A==
X-Received: by 2002:a05:6a21:7884:b0:1c0:f23c:28a7 with SMTP id adf61e73a8af0-1c2984c8729mr11550663637.44.1720737876076;
        Thu, 11 Jul 2024 15:44:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b43967443sm6170293b3a.113.2024.07.11.15.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 15:44:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sS2Wf-00CXDi-1a;
	Fri, 12 Jul 2024 08:44:33 +1000
Date: Fri, 12 Jul 2024 08:44:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use xfs set and clear mp state helpers
Message-ID: <ZpBgUZcWXWQEXg34@dread.disaster.area>
References: <20240710103119.854653-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710103119.854653-1-john.g.garry@oracle.com>

On Wed, Jul 10, 2024 at 10:31:19AM +0000, John Garry wrote:
> Use the set and clear mp state helpers instead of open-coding.
> 
> It is noted that in some instances calls to atomic operation set_bit() and
> clear_bit() are being replaced with test_and_set_bit() and
> test_and_clear_bit(), respectively, as there is no specific helpers for
> set_bit() and clear_bit() only. However should be ok, as we are just
> ignoring the returned value from those "test" variants.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Nice cleanup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
