Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB93219E0
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 23:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750809334; cv=none; b=eShpAI7v0ODN4YZDjq0Plno2W7kf4LrhR80DwTELI0CCtGIVy7unpqnsM/X0cQHbEBgCLWoVuxm7lIg4cGxK8nM8N++veHC42BIu82WDE5G7IKg2MwtPjD3zHIobjnRnoDtW2bGzeqG9WUftpYjM1ZjNfvPjDcVsnuZRBNThOrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750809334; c=relaxed/simple;
	bh=o39UYbNGREoEvwQ5LCvCmc9JyEp7Ua4BzvJZdwLxcIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWwFBGHWb1aYVtn0b4so48wJBa71MaLkHNDk45l6fnlJjhapAFFokGKfv7xVR8ZN2wFsF7XOAlV8akdjNz3BGvGShT/WtbKJ8MtYsb8jssqb3BrfMguFfKd18iE1NKAOa0l1QDYQZNzCimRfOf4+kKDEB27AHMs/85Hk4MA2lz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ekg+NZRS; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ekg+NZRS"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b2c4e46a89fso4902643a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 16:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750809333; x=1751414133; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RB7IYw0wmVk7yAC/oK2St5O+WDKYegZ2UCav/TcUCIc=;
        b=ekg+NZRSLi8f0I1blWvnbNwGwwI0F5S8meoYo6L/Xo9fba8ri+qtlHsX8vNT8WHM2Y
         r3r4Vvw+e+pBwiREvpqTBLU3pxQbHMaZhZl1NU0aKF8GaiRIO7GmkxH7ViJ+ydJ1JE2M
         ZcgHkX63YKGWcx3O9qrTM3WCfu81TpKe6/gB5y1vPrsSBzH6K2VK0Wfq2N4baycH3kZ2
         T8AjtMX4AanDEz/k/SWJWlBhkAgpUXFB0pJECVPV/TH4Gc4Jcm67HwyFrmwnMzBHFVY2
         ZZ4j9gdN3T+Wh/cWR5KNm95kCx7Q+ZLkQ9wTBDVEKImL1aYqJ6gFuvfn4jNk8/PkE/Wa
         ++nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750809333; x=1751414133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RB7IYw0wmVk7yAC/oK2St5O+WDKYegZ2UCav/TcUCIc=;
        b=VBeSDZKq17eJ1e/TWZ4eKfCuiDocsK71RD5jCyVPdtukHrJ8m9yVzvsMsIhaWWSh9h
         /MsNqETH98PhaaJPAP5ecCVEy0OISIxKkziv8571QKyCNxXVnbjjawJG+DMjH3p7ABtP
         pbh7/6BtccyJU699bVL4p1uZVf0H26OlAuVP9lCoKE3qZ8AgbPolnKtshiBebKkGH8qW
         GndtW3+isq3839XuXqK6bZ5O97ywr+kvRUmU/uH6NIzFrE/fTCs6tdnEK0R0x3oJWT4J
         ZBYP6PYBqdBUMm4N2ppg0ipACxcXsaEL1PX9AxZTUmhWW2dsN0nLfMilQQkgmk6qv/z7
         LzKA==
X-Forwarded-Encrypted: i=1; AJvYcCXC6kHwWgJ51b1mwA0vGiHuzbirWyc0qVTZioNeV+OFtWzCEIwwYRn5hnkj27z/k32bwcTzM3FFGas=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAu+d7fExW/OXArWQu2Z63EQxzA4wTqmv4MeJ+99u5YyxHhLQp
	rbRFCUnPjgutzSmrO72v5kscn/KNPw0pXglpIoL3FNnFPDgN6qhbZTcNdVLm764FJAM=
X-Gm-Gg: ASbGncuo9PbAxw+dRmSso/1l4HKUDhbCjDKbcUhYkC8Mp8U0Sw834MugVwgx8OVQHCs
	wbcelHUu9pK+8+brxXG3Ek3lplBqTlxISCp6efih021Kke8Gs74acO2V+CG+91WXEmC8+D2HZzL
	F6R79UyMUO1biaHYnKdsuNcpK/OGwRk5bxMOYUdwDgCW3UFxSesmJBgpih6zGTeAjv9eaBt2Rol
	lyUOfTS6LFvJwYg6l60nL5pxfH9tsigPF0HmZ2yuGuUa/yq2p9j78RiQPUeocv7hnprN/AfL5Q4
	HpXOcvAXUux5P3heWg95xTGNWqomhpKOPv58E8eDXKJ7JR054VuS89hrAUNPCqiJO6MQU2fifJv
	y9rvDJIpHMJsu9xCtZbMRpIGYqJNMIH9VRJyGOw==
X-Google-Smtp-Source: AGHT+IEfV4wDE7srLPQ4lPJFSnbZ9SDrQPSwGgIqQjH7XlG/0bvvHrH1rFC6jsj0gLgpFR9zMGLvGA==
X-Received: by 2002:a17:90b:2f0c:b0:315:9ac2:8700 with SMTP id 98e67ed59e1d1-315f269caabmr1077250a91.24.1750809332574;
        Tue, 24 Jun 2025 16:55:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f53a8c8fsm216791a91.20.2025.06.24.16.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 16:55:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uUDU8-00000002r6E-2ua5;
	Wed, 25 Jun 2025 09:55:28 +1000
Date: Wed, 25 Jun 2025 09:55:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <aFs68CkT5zQZBeSX@dread.disaster.area>
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-8-hch@lst.de>
 <aFH_bpJrowjwTeV_@dread.disaster.area>
 <20250618051509.GF28260@lst.de>
 <aFN5H-uDW5vxQmZJ@dread.disaster.area>
 <20250624141117.GF24420@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624141117.GF24420@lst.de>

On Tue, Jun 24, 2025 at 04:11:17PM +0200, Christoph Hellwig wrote:
> On Thu, Jun 19, 2025 at 12:42:39PM +1000, Dave Chinner wrote:
> > > > The external log device can have a different sector size to
> > > > the rest of the filesystem. This series looks like it removes the
> > > > ability to validate that the log device sector size in teh
> > > > superblock is valid for the backing device....
> > > 
> > > I don't follow.  Do you mean it remove the future possibility to do this?
> > 
> > No, I mean that this:
> > 
> > # mkfs.xfs -l sectsize=512,logdev=/dev/nvme1n1 -d sectsize=4k ....  /dev/nvme0n1
> > 
> > is an valid filesystem configuration and has been for a long, long
> > time. i.e. the logdev does not have to have the same physical sector
> > size support as the data device.
> 
> Sure, and I've never disagreed.  But you'd not explained how that is
> relevant for this patch.  The bt_meta_sectorsize is only used for
> asserting the alignment of cached buffers, and we place no buffers
> (cached or uncached) on the log device ever.

Again: I am not talking about the bt_meta_sectorsize removal being a
problem!

I will repeat it once more: this patchset removes the check that
guarantees the the underlying block device has a sector size that is
valid for the sector size the filesystem devices are configured to
use. That is not acceptible - a 512 byte sector filesystem device
must not be able to mount on a hard 4kB sector device because the
moment we do a 512 byte aligned IO to the log device, the bdev will
give an EIO error and we'll shut down the filesystem.

We check for sector size mismatches at device open time so we don't
get into this nasty situation. You are removing those sector size
checks in this patch set. This is an obvious functional regression,
and that is the part of this change that I'm NACKing. 

Christoph, I explained this in the email you are replying to, and
you have simply ignored it all. Please at least read the entire
email before you respond this time!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
