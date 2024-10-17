Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C25D4A0F
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 00:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729124995; cv=none; b=mx8WerpW9/fVINm6IYC1mAV53F/lfohig/iuTJO07XybE9cZKPjUhi3IDSRubcsC2GyyzVOrDOnX1oFazVZuOBgBbcpdDuIm7tXEyNsxzaGHe9LkXiXPKi+AAFSN3LUdwxnZTUJeEDUdqaxc4ruXcZvs550oWWQXzKlotlshVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729124995; c=relaxed/simple;
	bh=CDT0XC42KA5kDFs8w7hrAge7hVDbt3kWQB9W64z5KD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2Z+FUJvAocW3OnSYOqOR813SpNb49l8HRjsrYFrruMAPJB0LRPn+pmFotSRj3xzXAGMqHdJpL9rI87UTVHrAdy036+Cu3d9GPutgHMbj9urhXsy1FxBh+s0csKzf7LD6B8AnfR60hdV0082kwJiYTKN6eerpQUFIHjVb33z8gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xcq5NkuB; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xcq5NkuB"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7db908c9c83so242272a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 17:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729124994; x=1729729794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1wptyjhT3IFmslFEr7REugt6yoC6NkBMTWfaUPoWYo=;
        b=xcq5NkuBaKv5OiWVApSSXaBz7DbpkbJUE/66Mk3Flaw4TRjQ7fsjHTwWPyPoj32dHM
         HeTNrMqjxD+sXbJ8YEJGsYVzYHta4En4LhaVxYZsOoKl2cyw67r1kDOkdBT1lSmQ2oT0
         mSDpBLYcMTWX33g6lpA4ANHOTwya+1Tc+FdoaOK+PwW5GCd3FBAw3/Au5kXNrRAbzWUF
         pHBCIUIi/1qqhD+hjKIWYtcHrAt1Sosfpu3dwBojJ2ZMuVDdeHbRWYfAJoHTyuF6JNlX
         kjLCxkQHw91ukNrJN0gzZCVbPvbEWppZ9b9d1Wn3rPiQh8yVRPWOlb/NkDrSuoI/cWs7
         aB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729124994; x=1729729794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1wptyjhT3IFmslFEr7REugt6yoC6NkBMTWfaUPoWYo=;
        b=ZILqynU5IxxoEO6fIWZTpKF2/lP19eAUPNzFeb/vRdUETKKJlFPpEpCzpFgNAdJGHM
         8eec8kN5GjOuHFdS38KpN+GdqFtiBqEPr9Gbp7zHp+Aty6vlr5nz0MmEF8qmzAH+uPlX
         6somguxwLqPnZtFTu3SwK3yHpzDa0GugCVB1oaSYXx1tF5ei1lWbF7gZEkaLIqkXAsS/
         Qomc6QcTunlLf5EnOvPl9ZDwwGfWKx6/c/U8gWa2Ee3Px9pTqI0JYET/iB3wBMqy13xJ
         x2+pz0Y6IeEITbvfbMuLGBiUkUWyX2Fd2SMOFDqIXaURCGxAm/byYfXMfk5RoGhMjETG
         gKEA==
X-Forwarded-Encrypted: i=1; AJvYcCUbmKGxEBFxjRwCf2VQnxFQ4n1h2jKiXAfWpwBGk4rvkJEPd7/whCHzj0MsPdFuyqF7XEGIwTXHYpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjMZGTHnV0SzArQ6HCEGwxeJGpvGE0O9l3iHtzKEeSZdBndkTc
	Prswktf+C1SQaXd/Zu7hWMwIDzP/4D3QdChpEmglo54Y366EbNSa5YJA27ptTMk=
X-Google-Smtp-Source: AGHT+IGUGyt85bsnX8/5grRTTn+LbgbFmLULv4/fW2j0FdiTvsodajpT5FkWWCl6tVIuG8LUNy65tQ==
X-Received: by 2002:a05:6a21:164e:b0:1d9:f5d:b502 with SMTP id adf61e73a8af0-1d90f5db650mr4313437637.15.1729124993709;
        Wed, 16 Oct 2024 17:29:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea9c715dbfsm3361295a12.87.2024.10.16.17.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 17:29:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t1EOj-001nfB-33;
	Thu, 17 Oct 2024 11:29:49 +1100
Date: Thu, 17 Oct 2024 11:29:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Xiongwei Song <sxwbruce@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: XFS performance degradation during running cp command with big
 test file
Message-ID: <ZxBafdsU6ioeTBmQ@dread.disaster.area>
References: <CALy5rjUMnocsh80gPB+4UgaFS-Gsz5KAFnAN8Nj7m_oyohFfvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALy5rjUMnocsh80gPB+4UgaFS-Gsz5KAFnAN8Nj7m_oyohFfvg@mail.gmail.com>

On Wed, Oct 16, 2024 at 07:09:29PM +0800, Xiongwei Song wrote:
> Dear Experts,
> 
> We are facing a performance degradation on the XFS partition. We
> was trying to copy a big file(200GB ~ 250GB) from a path to /dev/null,
> when performing cp command to 60s ~ 90s, the reading speed was
> suddenly down. At the beginning, the reading speed was around
> 1080MB/s, 60s later the speed was down to around 350MB/s. This
> problem  is only found with XFS + Thick LUN.

There are so many potential things that this could be caused by.

> The test environment:
> Storage Model: Dell unity XT 380 Think/Thin LUN

How many CPUS, RAM, etc does this have?  What disks and what is the
configuration of the fully provisioned LUN you are testing on?

> Linux Version: 4.12.14

You're running an ancient kernel, so the first thing to do is move
to a much more recent kernel (e.g. 6.11) and see if the same
behaviour occurs. If it does, then please answer all the other
questions I've asked and provide the information from running the
tests on the 6.11 kernel...

> The steps to run test:
> 1) Create a xfs partition with following commands
>    parted -a opt /dev/sdb mklabel gpt mkpart sdb xfs 0% 100%
>    mkfs.xfs /dev/sdbx
>    mount /dev/sdbx /xfs

What is the output of mkfs.xfs?

Did you drop the page cache between the initial file create and
the measured copy?

what is the layout of the file you are copying from (ie. xfs_bmap
-vvp <file> output)?

> It seems the issue only can be triggered with XFS + Thick LUN,
> no matter dd or cp to read the test file. We would like to learn
> if there is something special with XFS in this test situation?
> Is it known?

It smells like the difference in bandwidth between the outside edge
and the inside edge of a spinning disk, and XFS is switching
allocation location of the very big file from the outside to the
inside part way through the file (e.g. because the initial AG the
file is located in is full)...

> Do you have any thoughts or suggestions? Also, do you need vmstat
> or iostat logs or blktrace or any other logs to address this issue?

iostat and vmstat output in 1s increments would be useful.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
