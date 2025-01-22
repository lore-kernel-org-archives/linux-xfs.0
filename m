Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B1A210184
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 09:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737538974; cv=none; b=h2pDWdpJYJY/fBFIyAukzc921vyaMuGe47cwExjg+xdcVbJgap6ca1f7iZfOYCnMw3OUEPWbweY40EU3XUow735t8n0472vbMGAoTUZnW3gvjFPDbRSvw0l3/fRSxQ5zLzlNyZuT77Ei+n8SWrbMznGYDeckCoEzmNgIb+swsHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737538974; c=relaxed/simple;
	bh=sZFS0ZSWBHcQTo2CvGCw2meTn9EZzO3AVbvsBzpr+08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEG1jRY5ELNg7reH/B0mLrliS+GlsD4gaapVv5W3ed7gmh3cW1n6bm/7fIdBibMaCu8lq68rYbgjoAMNijOKJydKjingoSN6DZcjt+rW1pCymz/kFG9ExtZsJDmy45UVmJrRoAWIfxrDDnQKoB4yNzYhieeSL3oqybhp3uX5gbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YyXPtLuc; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YyXPtLuc"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee46851b5eso8989377a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 01:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737538972; x=1738143772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D5na3VqqUg5r8j3fwyZazz2qTuzNv5otCGO7PnXAHGs=;
        b=YyXPtLucShGHOIYuVGSK/8KN2xg+4gyuYkaMvLds7v6pmZ2cVPq0KrfRfrbm8FqEpN
         c8l2MySgO0Mp1Iwlq8E1j5F4xPhAvZA5vWvHVxbSrd86HO318S3QtTC1QnA7h/J3EJfV
         r9IuYCvblw8RXWkHsoIsrST5icAPEeBL7xCDTXrsIZLiKAtlJskBcSFKUOnZ8mAz7k9M
         16NfULFsKonS5b9q0g4kf7hIn8pFd2jH2faea8w1bs1yu9bF9FLAVLt8B/qMm+G9JCfB
         CCW4ifZ66qElDKCiKTmCUOyJwrF/skAXa77ghdD3oXgPRvcumwtxKS0ZZJahRet3gau6
         jfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737538972; x=1738143772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5na3VqqUg5r8j3fwyZazz2qTuzNv5otCGO7PnXAHGs=;
        b=JupRP/QGujATYNeLgcX7RDIGSGLY/1rcGWPEAC2vCUUllvtwCiSSn+6cC53a6aY1h7
         WJYFkrt2K3ych7C0NGCs0TbvwbGKlwf3Nbz7MHckb2+elykGupib9kToQoNsyamFf65K
         YFOec7lfpb2L2VmNYxDBX8XuIpBCyYH8Qw4ThMhxxAjQBr/oacGw3W106b0gJsNN1th1
         t1cuKQFiQUTuoV19kVnLbBWW98dwOHkPDdLkeaTpqaqg3i6+D8e4eb9eDIJVm99crqrk
         z7uDRwS/oiCZNF1OA+odsKGMBZIWVwnTncsG7Ra3yHP12Zs2KWks5jgpPvbB2A+J9h5D
         1e2g==
X-Forwarded-Encrypted: i=1; AJvYcCVeKeNwUvfW6BeaPHE2wDMyktKfoDNMEk7mQhgCI+fLz8koFVjbTLskReA0qtOWeFLyeuUm71mlwgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGdyVWqjlXQu1OYEfL9NvIX2PJ5dS26hLoRfn2GvmHbNFHCM7y
	nOAikuvPjoV7LJwU4qKNVsejAvwGdQrPYgw9G3xcSbx7upAfIGcgPjQKMSGcigw=
X-Gm-Gg: ASbGncuy8nIQw3lAFeBabHZB5HHsk/YG8oUkwxBh9Rml2xJuRU3QjKBKBsaRkulLky2
	+xD3oXZMnrVFawWa2nAODkh8DSqPag6gsVTzs5612tJXPlkeOnZe6/wbsqA8xYD+rqBluXy3WAG
	409Ht7Ky1bF9cqqtmC1N77H4PiK9adf6j2CIc0X5xFu3pHEmPlGC26sONv1nvNxlIowG/zHbVX4
	8IZ5/SkOXDRdbrNNJDUndASaGyG7Lu1O0y8JvZSbgtDfgMphZtMFIIvgrvbAL3v+35SA82okfLm
	cJgLcfiadSfG7+ASUkuue6Z7SgbPmwI63ep0PX7gahDH1w==
X-Google-Smtp-Source: AGHT+IGVBB1rbn6pfySQ8altonFCZ413KkUydLD5vc3K3vg1akys2KNK7XO2hDJzh89YQnQz3WHELg==
X-Received: by 2002:a05:6a00:90a3:b0:725:e4b9:a600 with SMTP id d2e1a72fcca58-72dafb367d4mr30943232b3a.16.1737538972426;
        Wed, 22 Jan 2025 01:42:52 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab848b08sm10544500b3a.71.2025.01.22.01.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 01:42:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1taXG5-0000000929G-21ZX;
	Wed, 22 Jan 2025 20:42:49 +1100
Date: Wed, 22 Jan 2025 20:42:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <Z5C9mf2yCgmZhAXi@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122070520.GD1611770@frogsfrogsfrogs>

On Tue, Jan 21, 2025 at 11:05:20PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 22, 2025 at 05:08:17PM +1100, Dave Chinner wrote:
> > On Tue, Jan 21, 2025 at 08:24:00PM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 21, 2025 at 02:28:26PM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 16, 2025 at 03:27:15PM -0800, Darrick J. Wong wrote:
> > > > > c) Putting test subprocesses in a systemd sub-scope and telling systemd
> > > > > to kill the sub-scope could work because ./check can already use it to
> > > > > ensure that all child processes of a test are killed.  However, this is
> > > > > an *optional* feature, which means that we'd have to require systemd.
> > > > 
> > > > ... requiring systemd was somewhat of a show-stopper for testing
> > > > older distros.
> > > 
> > > Isn't RHEL7 the oldest one at this point?  And it does systemd.  At this
> > > point the only reason I didn't go full systemd is out of consideration
> > > for Devuan, since they probably need QA.
> > 
> > I have no idea what is out there in distro land vs what fstests
> > "supports". All I know is that there are distros out there that
> > don't use systemd.
> > 
> > It feels like poor form to prevent generic filesystem QA
> > infrastructure from running on those distros by making an avoidable
> > choice to tie the infrastructure exclusively to systemd-based
> > functionality....
> 
> Agreed, though at some point after these bugfixes are merged I'll see if
> I can build on the existing "if you have systemd then ___ else here's
> your shabby opencoded version" logic in fstests to isolate the ./checks
> from each other a little better.  It'd be kinda nice if we could
> actually just put them in something resembling a modernish container,
> albeit with the same underlying fs.

Agreed, but I don't think we need to depend on systemd for that,
either.

> <shrug> Anyone else interested in that?

check-parallel has already started down that road with the
mount namespace isolation it uses for the runner tasks via
src/nsexec.c.

My plan has been to factor more of the check test running code
(similar to what I did with the test list parsing) so that the
check-parallel can iterate sections itself and runners can execute
individual tests directly, rather than bouncing them through check
to execute a set of tests serially. Then check-parallel could do
whatever it needed to isolate individual tests from each other and
nothing in check would need to change.

Now I'm wondering if I can just run each runner's check instance
in it's own private PID namespace as easily as I'm running them in
their own private mount namespace...

Hmmm - looks like src/nsexec.c can create new PID namespaces via
the "-p" option. I haven't used that before - I wonder if that's a
better solution that using per-test session IDs to solve the pkill
--parent problem? Something to look into in the morning....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
