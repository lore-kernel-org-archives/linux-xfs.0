Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0360615DBAD
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716811075; cv=none; b=OtJUc0aHB62+nOPL8Up10c1PNZWrgp3kf4wW4K4NooOLGpqX1ImHL3pGf1Nxo8aVuOgM2vXwiuvi4y4lAHy/w5GMrwW+3FgKUoujs452fVLN6mOs+N704uBb/7T9/JcbLlJZo9upqjLF8sLZ9U2t1DSmPwv0906y7JCfawJLAHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716811075; c=relaxed/simple;
	bh=p/uV2wyUVBgUzO/cKFvOhjfU2IF6kq/HLTWGg/mk9gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFEL466UDddMWs/hr2UjVydZixKz69cRwmi2z+qJtbBEL6uVM58sjApEfEfxHjIn+QlmBUrEtPcOnqQOlQAsVznRAADAcrMmXcvyibg8fHcYBw0+XMFHMp5ZdkWJAFe+OAPMzGBm3CaEgxUIj/my2oOuXV4ScE9/1bjPZONzSBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=K0oBOPWE; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="K0oBOPWE"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f44b45d6abso25392755ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 04:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716811073; x=1717415873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w9OERdqv8FRy5QgUXxcfzexbSiwWwcwxq77Qp3MCBZI=;
        b=K0oBOPWEdtl1kkz4EiZRvTotuBPdrsSEXAm1o5TCRnKhqtouRBjOa8lD7AjwKvjC/h
         udTB85FQLWUa7VLCJg1Up/x9g9XFFjQ7DwA+yLzDVE59Q/xyNWEMZ2tWAk22JFpsQN5b
         pImVme7RPZlF4fMZr/wUXS3EjqboqWFH2PpPnLlg7EWLSVgT1ZS/Z6ocq9laMv1D19uk
         Z8alURi1N24ti1w7vtqiUJb/4K75fZncYyynSA5ZTSP2PwXOdrD3gB91qlmGeUlV8r9s
         L3ZwSzn9HR9GoMuA37Pln1jv825/M1PA9aGOCmZ0PPYjfLRWlIJrdNufkEUHvqofuZBF
         bItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716811073; x=1717415873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w9OERdqv8FRy5QgUXxcfzexbSiwWwcwxq77Qp3MCBZI=;
        b=ipwpJm/sqW8P076LtZ9GQZI/R0huz3gMOFj3MuOy3BO76KIB7kaqmAS1hoXrgsag3i
         AyTeVP8H2La00IvbdIcmxVsXPJAj3+rJh9vabCwLK6VRl2oHq7szZ8itqm2p4nnw/alY
         SuXErslodZlIsYn5wO3YWJdH5tgEkAQSbZrW7lhOckbds1DA2JtMk9mrTKKdvHpBGHGz
         OP4xwVWVaD/Ejim2e6JwME16ZMG6QwI06icH+Zhi16FZWtJ0Lq+x4LefJGdezA2X39bN
         leOjlJwMlOguX0UD95sHmtEMN42aies6tv+I2y9Z/vq7GJBc9z6HtsB6zmO97qXJ5I0K
         toiw==
X-Gm-Message-State: AOJu0YzFJ6RdHyaInWSE4vUpTbDwr0mhVOG9CIAz/1RVDyNbIfrKArh5
	5ZQ1v2FzMUf4PbrWasoVCDrE2DOUatYu56uOk+L3P5PKAvydtDb0WBY1DT+VCYC2+s4/L3rnYVk
	+
X-Google-Smtp-Source: AGHT+IG48zDjdCJlPPMp6IEjFkbezlCePOE+OPRCiTcDxm5XUWp2DCO/6grfNTayu0GfZPnzsYErkQ==
X-Received: by 2002:a17:902:d2c2:b0:1f4:7d47:b89a with SMTP id d9443c01a7336-1f47d47bdbamr57879045ad.1.1716811073096;
        Mon, 27 May 2024 04:57:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59e0sm59288045ad.103.2024.05.27.04.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 04:57:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sBYz7-00CHDA-2x;
	Mon, 27 May 2024 21:57:49 +1000
Date: Mon, 27 May 2024 21:57:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	djwong@kernel.org, lei lu <llfamsec@gmail.com>
Subject: Re: Fwd: [PATCH] xfs: don't walk off the end of a directory data
 block
Message-ID: <ZlR1PQ01EkD5nrUv@dread.disaster.area>
References: <20240524164119.5943-1-llfamsec@gmail.com>
 <87ikyz7tvj.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZlRQ6W8BlfZ+3rWs@dread.disaster.area>
 <875xuz7dcu.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xuz7dcu.fsf@debian-BULLSEYE-live-builder-AMD64>

On Mon, May 27, 2024 at 03:59:07PM +0530, Chandan Babu R wrote:
> On Mon, May 27, 2024 at 07:22:49 PM +1000, Dave Chinner wrote:
> > On Mon, May 27, 2024 at 10:05:17AM +0530, Chandan Babu R wrote:
> >> 
> >> [CC-ing linux-xfs mailing list]
> >> 
> >> On Sat, May 25, 2024 at 12:41:19 AM +0800, lei lu wrote:
> >> > Add a check to make sure xfs_dir2_data_unused and xfs_dir2_data_entry
> >> > don't stray beyond valid memory region.
> >
> > How was this found? What symptoms did it have? i.e. How do we know
> > if we've tripped over the same problem on an older LTS/distro kernel
> > and need to backport it?
> >
> >> > Tested-by: lei lu <llfamsec@gmail.com>
> >> > Signed-off-by: lei lu <llfamsec@gmail.com>
> >> 
> >> Also adding the missing RVB from Darrick,
> >> 
> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >
> > That's not really normal process - adding third party tags like this
> > are kinda frowned upon because there's no actual public record of
> > Darrick saying this.
> 
> Ok. The patch was posted on security@kernel.org with me on CC. Hence, I had
> decided to forward the patch to linux-xfs for any reviews from the wider
> audience.

Ugh. More "security process" madness. Please at least tell us what
context you are forwarding issues from so we aren't left guessing at
what happened prior to the mailing list post...

Regardless, this issue is no different to any number of
syzkaller bugs that have been reported over the past few years.
security@kernel.org should be reserved for real security problems,
not for reporting issues found by filesystem image fuzzers that
require root permissions before the kernel can be exposed to them.

> > i.e. patches send privately should really be reposted to the public
> > list by the submitter and everyone then adds their rvb/acks, etc on
> > list themselves.
> >
> 
> Sorry, I didn't know about the last part i.e. rvbs need to be added once again
> after reposting the patch.

I'm more concerned more about having an open, verifiable process.
sobs and rvbs that stem from private discussions have no actual
value because they are not verifiable via the archives of the public
discussion on the issue.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
