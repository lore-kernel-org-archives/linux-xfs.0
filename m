Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B3C18E02E
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 19:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725564605; cv=none; b=V/qIGB5/XdSGh4cu8XiD/iszxwg4mFWrBipPcnIYkdk8S8bHrIA/FGcEUOE05oeSHJlmUIgdSAEqCgfcIbvlOnkUdgTrqgd86XOMkEWoJp4cRMYFBSGc/w3iIEaxG07lh3UWm3jI2DastAcfIlkwKh7GIBp1iQngGuMW2hhAL6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725564605; c=relaxed/simple;
	bh=h+GztmK06ua0ItOo5xyNb+uFSPQwlQl1O+khIF189xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oil4304a5H0yMUk8qZtRQ2PZmvfRZQASfuTOxJEZnkZnlLDTgSEbMQZ1XK6D/sbVeEJ+DGZp4oWCpA87brz67LlQf+zXjM/PS/krolbwyssffjBFxOa+RWt94jcRv5m3h7CD1FH61txHu4m4HL1SgxLk02hi7PyHKEULSocAhoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Z3/T92iC; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Z3/T92iC"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a802deeb9aso79140085a.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 12:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725564601; x=1726169401; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uLq88qKC5eEOv6jE9dMcoyRYpwT+k6ZKS0lrxy9sSsE=;
        b=Z3/T92iC/Fj+/Cia06bnr5Xwx1xqgKpVwu0CnncHmhc/EuaCDuXE1YbsTZT0gknmM2
         Ku1Y8gBvzZTsGRFAmeATiWCoh5PVX1h2cORqMX2Ii57fV4Juetf9BuPjEThIET2wV2Yb
         G7I+Wq+sLEpo2sd6hGboa45C3vYQP89JbLNlkKt+1p9bd0o9Pwq2g8eMSEtlMqwPa53Q
         e9FeFzxH3dJQoGNYjUxg7AH2jY4+W6nCrKVWACOQyH/QxpRZ0VEnh7sJnE0+9oeXQBNc
         hcwD83qYlCjnUz6PMtyk/iBJ2u0XNtRQeeBOWPNnI/pM3Dy0AbGtIR8eJGk4bBCy5jX/
         k3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725564601; x=1726169401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLq88qKC5eEOv6jE9dMcoyRYpwT+k6ZKS0lrxy9sSsE=;
        b=VGM/m0k8LRv2B00BE9yATKwCdheCXF+5nzOGJBkRG5UZ0lIIMX/Kxo9MqvbZeRiByB
         DrpBDoKJWGwB5RsLalRW9zMh4k6l2uVev+IfuyrAQ5TE235msolwvYEsKkpLUKr0KbcF
         vzWSSPufqIcxVp7VpiyhogcyaG1OATB/kKBAx0MGU7U4z0fGwdTpIU/h6LHAzC5eIqV/
         YEavl9M0zqzdHm7xOg0wiG0ykcjpaIzh5MO98i2Hh9cQShlwgv819/ijdGHn7o5leN/q
         1JF1kaVoY2+g+357lAnE50HkuK4h13RCIloMEJhAPFSURZZjLINirtgMoBubTeYJF9Ab
         y4zA==
X-Forwarded-Encrypted: i=1; AJvYcCUzC0+SK6g+rQImXj93hyOQy5BZ9nZdBDHwA93W1TsvYa1Zra7XAXuOWM8j6Zw9+34ebdwEkcYXK9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzG6//9yjH3T7aB5ZWdiIGcWvcjR6bG5337/SVxHfebJJdhhg7
	tp+AipzgS0DI2N9MdSO3sOohfO5XODEXiHVue3fq99iGqhQNRHtMm0/vaVkb06c=
X-Google-Smtp-Source: AGHT+IH/jKRTwmHj2A0Fw8hBIQQEYZheGvncMyz59vEBTim/gY8yU8p+bmOgT7GJ5npitcpK4cA+uw==
X-Received: by 2002:a05:620a:29d0:b0:7a2:275:4841 with SMTP id af79cd13be357-7a99733aef1mr14265285a.34.1725564601247;
        Thu, 05 Sep 2024 12:30:01 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a98ef1f9a4sm101960785a.2.2024.09.05.12.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 12:30:00 -0700 (PDT)
Date: Thu, 5 Sep 2024 15:29:59 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Jan Kara <jack@suse.cz>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 00/18] fanotify: add pre-content hooks
Message-ID: <20240905192959.GA3710628@perftesting>
References: <cover.1725481503.git.josef@toxicpanda.com>
 <20240905120808.7fcsnv7nslqsq4t6@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905120808.7fcsnv7nslqsq4t6@quack3>

On Thu, Sep 05, 2024 at 02:08:08PM +0200, Jan Kara wrote:
> Hello!
> 
> On Wed 04-09-24 16:27:50, Josef Bacik wrote:
> > These are the patches for the bare bones pre-content fanotify support.  The
> > majority of this work is Amir's, my contribution to this has solely been around
> > adding the page fault hooks, testing and validating everything.  I'm sending it
> > because Amir is traveling a bunch, and I touched it last so I'm going to take
> > all the hate and he can take all the credit.
> > 
> > There is a PoC that I've been using to validate this work, you can find the git
> > repo here
> > 
> > https://github.com/josefbacik/remote-fetch
> 
> The test tool seems to be a bit outdated wrt the current series. It took me
> quite a while to debug why HSM isn't working with it (eventually I've
> tracked it down to the changes in struct fanotify_event_info_range...).
> Anyway all seems to be working (after fixing up some missing export), I've
> pushed out the result I have to:

Eesh sorry, I updated it for the fstests and used that as the source of truth
for this stuff, which is how I validated all of the fs'es that got the
FS_ALLOW_HSM flag.

> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fsnotify
> 
> and will push it to linux-next as well so that it gets some soaking before
> the merge window. That being said I'd still like to get explicit ack from
> XFS folks (hint) so don't patches may still rebase due to that.
> 

Awesome, thanks!

Josef
