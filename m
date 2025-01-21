Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BCD14900F
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 05:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737435809; cv=none; b=UbW6jajq8zY2/fC3A6GB0tOh5g4fAgJsQZIsLtwaxikMnuURPOgItaLzDqrzzWHTlShFYafa79FG1/jVWUC8nAurUibU/A/ao9Dm22I++q2OynRv0qpxyYf/p6DRFINLrueXRB4/1bXRiI2XaXHCEz51lKv8xea5njlr2J0Rf00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737435809; c=relaxed/simple;
	bh=ZMcUWLe2vhiNFzMxYYrp7vY0tQ7cIeyVVzNL8Yl8xLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1Y6GfAKoz8qyy32UTCZmhp+8aCNBAK3FwpfSxg2R2ksUuPhLzzZ0kDTEduUy4r6rzGXDdFcoMmT25njwodM6FIvmbi1TNPs1xGmbm0Hit7gySjbaroODgWCCPijz4oQmHjrvsbm5QD8Om+P9OQMmjFLlXRUgrdck0xkByE8O38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=E+k7Q36F; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="E+k7Q36F"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ef760a1001so8927519a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 21:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737435807; x=1738040607; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vq0/pZFHEMm3bw50HzyaxJ8uHJSIqPuVE2JnMstXwJw=;
        b=E+k7Q36Fj9X2k8VwCgZr4+aPb+ojEGnFiz1GL9VZ2biJpONlY14QTgwYqbePAOuDnp
         BDEkXAjYPy7XQg9cbD5Z+d3fso8DIof4VAspCdu3XH4SDd9iEuW2Ky03TE2JIaBzgmRI
         vXt55s6B7q2/aGKPR4bJVie9szT1ZH1fL3P0xdGTlLVvaHHzhJEky4bEI2PHBX7uoDok
         +7FsVS6OXP5SmGWTBE2qJUbwZyJgDfXfE4Ek6pGuizb4io0oJG9ABeRHlHzPGLNde3lr
         2VlOfv/Ie2xjyFa7n0abTdAcN6RyXksKF4cIZKofD5OhZVylNVzsg121atb78yfTKuEL
         0Zfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737435807; x=1738040607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vq0/pZFHEMm3bw50HzyaxJ8uHJSIqPuVE2JnMstXwJw=;
        b=RYjo181sGxFqZi83WP7ZDSP9ZV2/TSyzGSz3UBXLQb8DUpEQfdR5XPKoA0zo+tUTL9
         ysKvN0ngtuq3PuA0gcGm81wLkXvuwLddE69NU4MigA/OGWxemfFmecIqkLKR6DpZTZAJ
         NFhaLODsxB2qI+OzK85Dw5wj8+aXoWwxFSYJ2PF+m0BW2oSSwiquNu4ABmKpqJtDUZdF
         4c9cdN3yDP82hMwgan6KHRo3QHfbmMIVNQ7i9GXuNog6/o0vbd2pQoCYrIpmvjqXSdrE
         0jBsZqq1XCoc3Z0c7jwY/BCoaaYuIppCw8LJUwf9OuLHM8mwobs33sEynmRqhfQ/V8pk
         sXEg==
X-Forwarded-Encrypted: i=1; AJvYcCXJz6oripolqAv/kojCPHetHfN4IIp1LOXK0+CNsex560kNxfHxd1PNPTLmE1POhjTvdN58fT7vLZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyib4/hHv6Oi877w1AFjwPg9GBN6PjuzyLCCNroWDZz0fX/5lo8
	IShnDHhIJcpfpt5gO7zlYwlUiXvShgTcTcZH7ZtSzBOrz8NrC1/JptkH9SirxBg=
X-Gm-Gg: ASbGncsJwKVH0XSXghLa992IdsvjsER8aBkInZN0YpMbRrVIhcA7/c38j6LuJ1lO4BR
	mLQMP4nbZcg+f5wxjbshbrZKafoy0JlEER7bxpJzA1OvJD0H5NpeNj67N39K36vcvEB5Cd1v8aV
	JLX6M6zoCH/xkIU+q5utCo6y0GkARQk4keVSDeUY15GONFVXQkQ2qjWfU7WgVLwTym1u1Ec/ABs
	RaF3rZYVAiF8TnsfGs+hriZB4EBpQznnzbjxEpeEYw+GujZJ7PbnRmM9xnMy7E0gHGhXdVz48jy
	sxayCw6nqXk0evl8NkNBpON8gqODR5YniLs=
X-Google-Smtp-Source: AGHT+IG0/nKAnyugvvljotZMVPOKeoU5aIIa4D0875uQI2s9T8aJYIrHpWjV1MYZ9gjdjP52Jmv6OA==
X-Received: by 2002:a17:90b:3d45:b0:2ee:c91a:acf7 with SMTP id 98e67ed59e1d1-2f782c4bddfmr22980234a91.4.1737435807021;
        Mon, 20 Jan 2025 21:03:27 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f77611a162sm8765220a91.2.2025.01.20.21.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 21:03:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta6Q7-00000008XHo-42md;
	Tue, 21 Jan 2025 16:03:23 +1100
Date: Tue, 21 Jan 2025 16:03:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/23] generic/032: fix pinned mount failure
Message-ID: <Z48qm4BG6tlp5nCa@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974288.1927324.17585931341351454094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974288.1927324.17585931341351454094.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:28:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/032 now periodically fails with:
> 
>  --- /tmp/fstests/tests/generic/032.out	2025-01-05 11:42:14.427388698 -0800
>  +++ /var/tmp/fstests/generic/032.out.bad	2025-01-06 18:20:17.122818195 -0800
>  @@ -1,5 +1,7 @@
>   QA output created by 032
>   100 iterations
>  -000000 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  >................<
>  -*
>  -100000
>  +umount: /opt: target is busy.
>  +mount: /opt: /dev/sda4 already mounted on /opt.
>  +       dmesg(1) may have more information after failed mount system call.
>  +cycle mount failed
>  +(see /var/tmp/fstests/generic/032.full for details)
> 
> The root cause of this regression is the _syncloop subshell.  This
> background process runs _scratch_sync, which is actually an xfs_io
> process that calls syncfs on the scratch mount.
> 
> Unfortunately, while the test kills the _syncloop subshell, it doesn't
> actually kill the xfs_io process.  If the xfs_io process is in D state
> running the syncfs, it won't react to the signal, but it will pin the
> mount.  Then the _scratch_cycle_mount fails because the mount is pinned.
> 
> Prior to commit 8973af00ec212f the _syncloop ran sync(1) which avoided
> pinning the scratch filesystem.

How does running sync(1) prevent this? they run the same kernel
code, so I'm a little confused as to why this is a problem caused
by using the syncfs() syscall rather than the sync() syscall...

> Fix this by pgrepping for the xfs_io process and killing and waiting for
> it if necessary.

Change looks fine, though.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
