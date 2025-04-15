Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CB82DFA36
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 23:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744760322; cv=none; b=mFpmjqgZTHHoM6homGwRHZhGu0/BTALd8QpEArl6rSr50c4iER8134kTw6yAOjW3fn7A1JOz0IDIK4Bu5Nm0cboyoaAbUs9DFo9NSA+HzMNMPJg0wbBMXLiLgirikkvsfoBdzjOIy2T6dzzOnS3rLKRzEOmCGw4aHSHZYVIcY80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744760322; c=relaxed/simple;
	bh=R+EQXz9EaaJ5nmZF1v0kHrTrolPYealYIAsKGPLU6Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjlL0s3y6xf3fmwAPf06H86Z09d3ELUEyW1i+9fYWAnDGozLH0TQddkDOp62R010i8Q2Hu3A5BtsrCpSIXAgTLhkHDStcpQg9gex5Es8LkBPGlX7WAOLaXM35iMCi0st7aZQ08LwrJrspT2hhRwaSHP6kUhGEduLixxJ8yoOHYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sGwHcE/R; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sGwHcE/R"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-736b34a71a1so7146619b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 16:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1744760320; x=1745365120; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EpM4EYhinbZUnOqyrMXMayNGRnxZN7y4BbC9ozLOlx8=;
        b=sGwHcE/RQFxEif8PxH4a0Hq8nU6CUS4KKAFoWVz3gir2IPji8XEXJXlnMK5KYDjXF1
         k/NF0pyd7XOFgMLxF7nVhXG0eCaNyagvmf0TVnwf313H8XKuFEVVBhZ7k3F5wKtJCz3y
         AhWo+RJKbykig/TbxfT+lkmUaSWGVrGsUzH3r3uy2EelZcVKGbf8yHUU5g4pv/THzZP2
         0oaGmBQhOdFJ4Xe6vPlt4451bjk3vdk2NpKLwsMPG9dF2a/Vw1nvW0Nsmdg3cXj6MnHq
         H5rI1vx1lvVxF/BypjAD/hkA7sL9G0i/ryp8EzuYa1f+DvTCLWtPbGj3UoCqNwhdqBWf
         Azlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744760320; x=1745365120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpM4EYhinbZUnOqyrMXMayNGRnxZN7y4BbC9ozLOlx8=;
        b=FYejWZRrHfFXjqTc1LiTIwOWyEbXYSmObFWxan7iZWYPqrf7Lewj2nBAJ3+AbuMrWg
         oP9KOl4bcw/i/1QnpV2AseAGNhJxdChHYucVmz9JAeLQDnjr7iqVhWkFEYFOT+0e/Upu
         WBvzmZfgx+HCRdS7DSkWRByG/eHanB550v1pY/7Sf2JCRgRecxZa3I07gYUUqYVRBNQ1
         qxLIgo8HqtW363RA6Fmadw4MGvPyEMkgItV0w1EUUzNyDFBbHH9IkV0mRCcv9+OFGVZV
         lbGQUICvhoyZcRIdpNEAm8zSnAHaHKsrKw1+vSg2hVY6paAUHXClMcgly4t4ariSrJD5
         hTkg==
X-Forwarded-Encrypted: i=1; AJvYcCXIb7Ltuprr7j93AKYCcijYcUsbzKgvNJPz8bw7Q92OfXidp98CyqMnS17WlWWWjfjm0J0qREm/2mI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFWt8XnG0usWN/6g2T+lz+6YRmdQsFmcQKx5Itmq9o552hTlel
	cynG6z2wyeFcu/jciwf11vu9kvLfg1dzyU3uq/ECjqGoLZIh3Wi3JbNpisvQBsg=
X-Gm-Gg: ASbGncuTrBBysE8NcXXsPr5eC9Q1GQQgqBSHm3XG4gNCvOUbx7WR+1cMO5/MPcSPMwr
	o3zKaAGUD6H8aUeOJIAfltvEkhCWwimHwXENMqVQAHlu7ZDhUU8x31Kc+DTqlJY9Ph7lx2QQbDu
	OEjajpTY7jSkcBNznj2AclbCcV35zqYkL/CcmWtjrcsuYQAbRT/QWO/5n5bJ/hZfdD2kaOiM9wi
	Oi1ctjNXE/rv6JZz5Y0HOZNkePayvKIrtwsF6hsI+n4h/e8ssU10XF/UhuY99BPauwmY6ZPqV8P
	Wmd1Fw8RE1Tudh0PkXnE1Q9juoeEg/NgHMoINMDVBi91Xa7x2U696LxVworleUNn2tMjxreXAuC
	XyAweH+iwOXg6BQ==
X-Google-Smtp-Source: AGHT+IGNO2Ue2ds5cZZ5nqUeIMkjzsWEzJz65ELSNC02DEQ3gbhoOr1LcC6h7r5RennInGd6igBPLQ==
X-Received: by 2002:a05:6a00:1409:b0:73b:9be4:e64a with SMTP id d2e1a72fcca58-73c1fb48cdamr1709757b3a.23.1744760320344;
        Tue, 15 Apr 2025 16:38:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd22f1259sm9148215b3a.119.2025.04.15.16.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 16:38:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1u4prR-000000095N1-0pge;
	Wed, 16 Apr 2025 09:38:37 +1000
Date: Wed, 16 Apr 2025 09:38:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common: remove USE_EXTERNAL
Message-ID: <Z_7t_SKirTrStXEi@dread.disaster.area>
References: <20250414054205.361383-1-hch@lst.de>
 <20250415004452.GO25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415004452.GO25675@frogsfrogsfrogs>

On Mon, Apr 14, 2025 at 05:44:52PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 14, 2025 at 07:42:05AM +0200, Christoph Hellwig wrote:
> > The USE_EXTERNAL variable indicates that dedicated log or RT devices are
> > in use for the scratch and possibly test device.  It gets automatically
> > set when needed and generally does not provide any benefit over simply
> > testing the SCRATCH_LOGDEV and SCRATCH_RTDEV variables.
> > 
> > Remove it and replace that test with test for SCRATCH_LOGDEV and
> > SCRATCH_RTDEV, using the more readable if-based syntaxt for all tests
> > touched by this change.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I like this change, but it leaves me wondering why USE_EXTERNAL even
> exists in the first place?  Is that so that you could add
> TEST/SCRATCH_RTDEV to the top of a config file and set
> USE_EXTERNAL={yes,no} as a per-section variable?  e.g.
> 
> [default]
> TEST_RTDEV=/dev/sde
> SCRATCH_RTDEV=/dev/sdf
> 
> [rtstuff]
> USE_EXTERNAL=yes
> 
> [simple]
> USE_EXTERNAL=no

Right, that's the way I've been using for a few years, and it is
explicitly the way check-parallel expects external device
enablement in config sections to work....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
