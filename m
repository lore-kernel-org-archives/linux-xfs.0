Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4485A13D899
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727301654; cv=none; b=bpJsIqoxbiZofanJW32rIpQXPTZqlbZAWEZ1+Ebbev8TOTISQNZQ+Ka6Tmkg5hWXVRv/IKOSLBIoAGHIi6Vdal9csqW/mRqMM7luaJii9VLjtGR6SjirvFyK37WoqTG2muuDEiEMSClTDfvvB5hlsb8mN55Gf8pJzk48clObf4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727301654; c=relaxed/simple;
	bh=fhE7BbfvBWwJGpTOgFl+EiDQD65+INFtPIqW7ERur6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqHm0bj0G7ryUOWy2FqmeaCWscjFX3LOazxvHVICEFGnU98BIrcNPJIUox1UvVgFfOM5A+wOOVlUXbVeWtOgmiOkf9+QQc8MpGt1EN5gH5QqL8wEX57SAt9aGHgpFSeczV3HXgOJvXgEaqoE5HLQbpFi/AEnoVv3r8yTgdJ6Ff4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=he20TUOs; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="he20TUOs"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6bce380eb96so179642a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 15:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727301652; x=1727906452; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=amcmtWeUXTqhHAjKnSkVEoESHDD9VcT41jCkJGVSzkM=;
        b=he20TUOsZJJV26O5IqE3ynT+Iix4R6Djrvbx7kN316VA0d46fPHTDASbPI95J6a8Mh
         xhgTUhYE6+ngif/ow6chbgpuVEXNEPeXn8A6lzTeoLaRG1hbF410b5ShsnlanK2uMEp0
         0sXSmzC2Qa0IPahJv6wa9bh1QhKFnOq2bp1iKQMEvfhVrxpLmw5+4NHwSDKYA6C4l0IU
         YFBQMnP4Ts78bAHqqvWQthpoJzmBHpC4tNFoFaTMVi7Vr75YFKcUY8au+zQBro0N20/E
         64a2vx8bJXq+7X8Y6D6OhKOkEvulSNgmHkHDi1297gVm+aoVBNntZixqTe8XCDj/yNrz
         DouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727301652; x=1727906452;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=amcmtWeUXTqhHAjKnSkVEoESHDD9VcT41jCkJGVSzkM=;
        b=HGPacOrBUlS7gU3vT+aiVXPoKsJ+0YDiUkl0fqHHns3A198+emOzzvAWj2yUz9vP8k
         JnjVySx62YO4wtNDEYO2V6CxLjCjZJy4WVfKct8AMZtZ0e6wiEQeiEPMz+d1Nquo2B+O
         lseKmqdkPIn2VqOd6bZQV4X5Ly4RBxo5LwSC0M8hmnuploDR37TZYipAJl0lEZ4zLjKh
         sdz1Edb0Z+Przs92vLPe+fMOmJQHCaG//rDqTbYhSay3/0/dxBW/N0iieI3/N40Qa/Wp
         SnihiPtNRfHI1aOL30qDgN9YesbD1fOZcrPe+uKBmXGtFgV4SCX8+aEFqeJlYhTF+Kgq
         C34Q==
X-Gm-Message-State: AOJu0Yzyjb+lO9ltt4Kr4GjMs1FwwsxJEeRc2AqWDJcrYZxviMBRtPev
	my87oDQ4dcRxDRDijcHgUhVe6c1apu0EdQ4fi8OBavzgMg9ksNC0SUati6JnU0IzSS/UQkF0P5c
	Z
X-Google-Smtp-Source: AGHT+IHO0C1ziJd88G56DQvs+KhPPUGF8wQqR+C26P/RkaOmfcttvb9e30lU33EceL0ft71BfQHTMA==
X-Received: by 2002:a05:6a20:5655:b0:1d0:603b:bf76 with SMTP id adf61e73a8af0-1d4e0bd10aamr4854889637.34.1727301652422;
        Wed, 25 Sep 2024 15:00:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc9c798esm3159846b3a.214.2024.09.25.15.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 15:00:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sta40-00A2Y8-2j;
	Thu, 26 Sep 2024 08:00:48 +1000
Date: Thu, 26 Sep 2024 08:00:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Filip =?utf-8?Q?Stoji=C4=87?= <filip.taka@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Worried about XFS recovery taking too long. Please help :D
Message-ID: <ZvSIEJpoL9OpG/bs@dread.disaster.area>
References: <5f7e37d9-2376-46ee-b6db-d74e14948b61@gmail.com>
 <0278bb98-082a-4f08-8a68-2310807d1993@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0278bb98-082a-4f08-8a68-2310807d1993@gmail.com>

On Wed, Sep 25, 2024 at 08:56:57PM +0200, Filip Stojić wrote:
> Hi,
> 
> Don't know where or who to contact anymore. Found this email on
> https://xfs.wiki.kernel.org/
> 
> I got an almalinux server with /var on a soft raid5 6x8tb disks.

So a custom distro kernel - we're not really going to be able to
help you much beyond basic triage. You'll need to talk to your
distro vendor support channels for anything more than that.

> There was a power failure and now on boot it states this:
> 
> XFS (md3): Starting recovery (logdev: internal)
> 
> Eventually it times out and continues the rest of the boot which kicks it
> into emergency mode. (I guess because it doesn't have /var mounted) and
> mount continues running in the background using 100% of 1 core.
> 
> This has now been running for 215+ hours. Is this ok?

That's not expected behaviour. Maybe tens of minutes given the slow
storage and the possibility of thousands of inodes to recover, but
I wouldn't expect /var to have that much to recover in it.

> Anyone having any information on this would be greatly appreciated.

several repeated sysrq-l dmesg output dumps from emergnecy mode
will give us stack traces that tell us what recovery is doing. That
might give us some clues as to what is going on.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
