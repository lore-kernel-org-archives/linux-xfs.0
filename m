Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209F54F90
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 23:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708386964; cv=none; b=ZbyRES5YZc4Vz44UQw8xgGarWE/PFrD0glRSRWI0fidg/V0LvTFUmi9Sl3VvVC6LEcYXFWDaoMuHcGXQweAaUp/aH+547djz8VUU7EmIz3kTH839Sxs2iGKi40gWadqh+LcJziuXfNOChAs4Do1ZGORA1BYJaUORde9kCB+R3Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708386964; c=relaxed/simple;
	bh=PyisBXT+VPBkjhYsCGwmiBZxaFWuvR2VKu4XcA6coDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uh7Z4NH7ypUuOqsifIWOlQVp25iL7WSwizB0g95/Dt2OrerF371D7KHWGhTRVhlz30Oz20N/SIW8TkqLBWwYA/A2b9lORMwZd2QV17goKCyZRkEruclOjPV83L6UGxePxa1FZzShfsJW6j526LE7trtjKWwnzCePGe9QqVTWad8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=w8wEvbOk; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="w8wEvbOk"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e09143c7bdso2439674b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 15:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708386962; x=1708991762; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KaP5kgSGcMzF5vr6150GjgKI2EWs4XaJkSfDeaGk3GU=;
        b=w8wEvbOkw1kOWhzVFkwkYzKvSCytq+aEimmQTctGu79CMr8AImGN3cM569mOkNhA0z
         wsb9bNtRWMrD694x06aLXLo0UnWlW7FZN+dV2yFpegHpMQ26Tsxo1ycdpTLwxNQTTKrA
         ov3gcDo7KlVDAPWEZW87/xvVl5tdQjxhDy0M2WKAGyxeiknfpQ0r2oRCwjKT9pW9M4w8
         Ms69s+QIb51Fqwb6Qz0GkQ3V/1bBFW6CSQqgdA7gjcl8ffmfBuyHvcP7ps5Fr+wd2VWq
         Db1CKFggqJXV92vSqN8wmo/drXUBhkPYO4UrXJjpoH9lj0B6RObxbcUFi83VPtyl/spS
         4z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708386962; x=1708991762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KaP5kgSGcMzF5vr6150GjgKI2EWs4XaJkSfDeaGk3GU=;
        b=CldVO2RC0c5hz5LUms/vXwGByrQmDjlzKkbJO34jSAwP0j7omUBuhEeJ1ktV2HOhdq
         +FquE9/EjKs5ru0vjWwqTIaHIt9BKHYcRje9NOaat5ta5yZkxyz3xsSTBUPcXiB5z+8T
         NFxXV9SWpu7Q0d9cusitWnAmu7RUB/8oM3HPufhvztjvCgDz3qai/NJoyM604fCJqjHg
         0FpgYvgqDYmISs1U/9sNC/TsAYJiYaBWfA7++NK58tarCP2qbuiQssNLl4TuclQR8in8
         6K/yKm84imT/SgjLH/qfs1Zl66ThUbXVYn5ToKNLYDXkgqE3Kop0TA3sgqIdixSMRr4x
         BgVA==
X-Forwarded-Encrypted: i=1; AJvYcCU64zGT1G0pUD+hckRJqwDDuY4M/b6CzcS7oej3eHOLOJg4AGAd/3tzFzfKTNP7DtvkPMg9FEeHWGXXuXdxBIEoBncqg4eDsOaD
X-Gm-Message-State: AOJu0YyHmpfl/Ew9LOfbjbUhB/6nJEfdCokAnWd0FD/hFdvKX0n3uY2G
	OR1hibr/qq5P8mECb1PTDgLrip/HXTtSeuYDs1NtJaomw0L34B98MSLHtZnbP5U=
X-Google-Smtp-Source: AGHT+IGH9JvhlvBDd2YZQ3EisEV+5N7OqW+knXzdmdAE6FBXBsvupRjG4tDtfkJnsFNGueMY5ZfVjw==
X-Received: by 2002:a05:6a21:1583:b0:19e:cae4:7c07 with SMTP id nr3-20020a056a21158300b0019ecae47c07mr12953997pzb.45.1708386962341;
        Mon, 19 Feb 2024 15:56:02 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id pd6-20020a17090b1dc600b0029930881068sm6094522pjb.49.2024.02.19.15.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 15:56:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcDUN-008phz-15;
	Tue, 20 Feb 2024 10:55:59 +1100
Date: Tue, 20 Feb 2024 10:55:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <ZdPqj0gJhBekH+Kg@dread.disaster.area>
References: <20240219063450.3032254-1-hch@lst.de>
 <20240219063450.3032254-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219063450.3032254-3-hch@lst.de>

On Mon, Feb 19, 2024 at 07:34:43AM +0100, Christoph Hellwig wrote:
> __xfs_bunmapi is a bit of an odd place to lock the rtbitmap and rtsummary
> inodes given that it is very high level code.  While this only looks ugly
> right now, it will become a problem when supporting delayed allocations
> for RT inodes as __xfs_bunmapi might end up deleting only delalloc extents
> and thus never unlock the rt inodes.
> 
> Move the locking into xfs_rtfree_blocks instead (where it will also be
> helpful once we support extfree items for RT allocations), and use a new
> flag in the transaction to ensure they aren't locked twice.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c     | 10 ----------
>  fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
>  fs/xfs/libxfs/xfs_shared.h   |  3 +++
>  3 files changed, 17 insertions(+), 10 deletions(-)

Ok, nice cleanup.

I'd also like to see the rest of the rt-only code in __xfs_bunmapi()
lifted out of the function into a helper. It's a big chunk of code
inside the loop, and the code structure is:

	loop() {
		/* common stuff */

		if (!rt)
			goto delete;

		/* lots of rt only stuff */

	delete:
		/* common stuff */
	}

I think this would be much better as

	loop() {
		/* common stuff */

		if (rt) {
			error = xfs_bunmapi_rtext()
			if (error)
				goto error0;
		}

		/* common stuff */
	}

Separate cleanup though, not necessary for this patchset...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
