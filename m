Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3511F237E
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733958679; cv=none; b=t+68ad7QQypEDurZrD0OACCYI0yMLmppy1X5BunNV2R6nZnxiHbr/thAkUsBBa5edKp/4M+g0JjJy8GsXZy8TUnLYffcUIh/JrR5E2u4OvnkpwRBW9qswe9nzwt8Klk1m29/YG845JmYlsVzB4rX43akMDfqlT6wLdsaDJV7trY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733958679; c=relaxed/simple;
	bh=psVmGeeg0n7RVxiczhCqGqOFpNNo+GLWphU/k4sH8ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8KMfGENdYWwwXnvDW84IsYSAmwy/BaCfUFB9JBotJcd2s+fPsgxyWCyUCSwf3gCTU8roLk0FpAojUHPWj66tFjeUj/hfVAWDHRnL0KiXqu7vGHG+h/4I1ifEDPiJIDEOXZIxEC6deCV4ml8OVMm/LuoSvvKLpu9XwoivIeLcU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FxpQnYjJ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FxpQnYjJ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21631789fcdso8540125ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 15:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733958676; x=1734563476; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8+EG/7WO9rnxk/UMBYPJNbuOKya+G3HT2A1S4Lm93oc=;
        b=FxpQnYjJPrzOz6AZPzU8TIkBwkMdI5X8KhMLEcK/63ErMf2pqXczNrSPTwARnpkjnr
         S3lj81gjWc4LbEmyDPH6xfnpH+kBJkDhPIQ6uil7CtmESbMSFwU1AuiBwbNcXoZh+I9j
         NBnaGTFwRqLyVszgWGPdkHXFvnL510M03rBr9m2QgPgTuthOVSqz9tmAHFR9wG57QDxx
         +9x6rPzUq5mzOJe3zjqXW8XeAWeyDH5j3P6h3QZTmOM6nz+snkQwdbigjaSBrSEoh8hN
         VN9sa46cdGg5tmalsUYRCUCH0/5CYgtoEYTSWfYghf23R/z0MLiDx/oK4y1O62w6Hj8p
         ogzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733958676; x=1734563476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+EG/7WO9rnxk/UMBYPJNbuOKya+G3HT2A1S4Lm93oc=;
        b=CXjQGzwswle846tPo+cTUIxG/COPT0cQdv37lJ3EYiBlBScoLFTRje4wrclC7NBHTB
         ZYz36P7A7xkthWfMqUy0IqYSGSr4EWeedn176AA1f89pcesrZrOVzSo3I7I2BYmJpMs1
         x+LMN613TM+KZ2pfOHYhFg11mnnouX9LffitH3LYWfoyYWXAcPAYkk4WxBhSCFXuQFUg
         CawRZ+CiFtMivntNbrwXjm+J8m0AIw0HiJZjUcgjBzw0q/3QWlQ7kCjzzz47QJEvIOPr
         i/jrg1GA5/fvpNU785ZGjNd4SzO4F5Xa+N88rbNRjeZi/K+FhuCzYKbjeRR2LwgcZX9F
         KJdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbffEfQYOg7jISXtCRFLN6LzkLD/CDFx9XAbhPdujiBaDQFYTVG21J7phVC8RSP/4r5AOw6W25j1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwQEfsghOeXPQdwj5fUPHd5qHx0d5XihteLbkL2raOSBGnWLyh
	7Tz3iti6NMv0P5A+U0bKhVYaUyF97vz3TLUhAv1HNfgzg0UFOjv5EE4cvibM7Hf6cD4hKqL6rCu
	3
X-Gm-Gg: ASbGncsu54QHwmPTLyHr3MiwVmGqCTdf8AHNjyxFk0G/22T8rlaCYqKxMYoaC+QjihY
	ITDU/p10guq2uaW0/8U/V3nmtg6XlvdakU7TZy4G36zIPCo37fsxxbBtjWl8niyY9va54NPT/ly
	pjqshENoksPTTnOo0YrQL1QS62DxEOj9xeZQ/SLfPZZyVBGZo9JTeyhhdYRjLFGZuH2EkwWpnBG
	zaHT/OnFhPsA1qlVmmjGb4eJnNGltTFb2eLVR0IYTj6bj7WfZtV/90+Mja4VlIggUFWkqU3E213
	XOpshLqSTzEXMYe/YdxZZYYSYEY=
X-Google-Smtp-Source: AGHT+IHFkgcUiHAeKnVBbP1gE3ZyLIcHA/HyCyo9PcJEeIzeOwLROaeZQdHBUaQJg8wms/xI5OCDzQ==
X-Received: by 2002:a17:902:f60e:b0:216:39fa:5c97 with SMTP id d9443c01a7336-2178c7e8221mr17913415ad.11.1733958675715;
        Wed, 11 Dec 2024 15:11:15 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8f0ab8fsm111999735ad.190.2024.12.11.15.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 15:11:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tLVrM-00000009ZwN-2aTK;
	Thu, 12 Dec 2024 10:11:12 +1100
Date: Thu, 12 Dec 2024 10:11:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [6.13-rc0 regression] workqueue throwing cpu affinity warnings
 during CPU hotplug
Message-ID: <Z1ocEDhfwJ0Q-WYm@dread.disaster.area>
References: <Zz_Sex6G6IKernao@dread.disaster.area>
 <Z1oY1qk-eWU8IcH3@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1oY1qk-eWU8IcH3@slm.duckdns.org>

On Wed, Dec 11, 2024 at 12:57:26PM -1000, Tejun Heo wrote:
> Hello, Dave.
> 
> Sorry about the really late reply.
> 
> On Fri, Nov 22, 2024 at 11:38:19AM +1100, Dave Chinner wrote:
> > Hi Tejun,
> > 
> > I just upgraded my test VMs from 6.12.0 to a current TOT kernel and
> > I got several of these warnings whilst running fstests whilst
> > running CPU hotplug online/offline concurrently with various tests:
> > 
> > [ 2508.109594] ------------[ cut here ]------------
> > [ 2508.115669] WARNING: CPU: 23 PID: 133 at kernel/kthread.c:76 kthread_set_per_cpu+0x33/0x50
> ...
> > [ 2508.253909]  <TASK>
> > [ 2508.311972]  unbind_worker+0x1b/0x70
> > [ 2508.315444]  workqueue_offline_cpu+0xd8/0x1f0
> > [ 2508.319554]  cpuhp_invoke_callback+0x13e/0x4f0
> > [ 2508.328936]  cpuhp_thread_fun+0xda/0x120
> > [ 2508.332746]  smpboot_thread_fn+0x132/0x1d0
> > [ 2508.336645]  kthread+0x147/0x170
> > [ 2508.347646]  ret_from_fork+0x3e/0x50
> > [ 2508.353845]  ret_from_fork_asm+0x1a/0x30
> > [ 2508.357773]  </TASK>
> > [ 2508.357776] ---[ end trace 0000000000000000 ]---
> 
> So, this is kthread saying that the thread passed to it doesn't have
> PF_KTHREAD set. There hasn't been any related changes and the flag is never
> cleared once set, so I don't see how that could be for a kworker.

....

> > I didn't see these on 6.12.0, so I'm guessing that there is
> > something in the merge window that has started triggering this.
> 
> I tried a few mixtures of stress-ng + continuous hot [un]plugging but can't
> reproduce in the current linus#master. Do you still see this happening?

I don't know. The machine that I was using to reproduce this has
been down with hardware failure for the last two weeks. I might have
it back up today, and then I'll be able to start exercising this
again.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
