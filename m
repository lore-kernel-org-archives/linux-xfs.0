Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA77C194A43
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 05:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009438; cv=none; b=irECXVQhjF/3CHxJsqC1oYZ/ZwcZEkvtwGBztjnk5w/el9uh3zujzIsTT85FtzBWTxXngVWY3aVgXcXl3wP/ODvemiw0Sy2uFT8xhvxK8bHx/1VzhvKUDzoUjD/bn2zJpUyeH2TlyTbyK9hyRY4RecqxHPcEvFjKfRbRPxI/eP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009438; c=relaxed/simple;
	bh=K53JidPzoTG2jAa4RC/tPxKOXVjiIBRayYpK8wPOLps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1GrnD23amcRJcqRo0Mz/9QqJrCEZYZq7m6bS2EwM6ZVIcpX5KlIOETqnPiSLD7+N7kuiqXaUktLffpdLCEWTKT9RGpfw9TzStpHLg4NxryHijyUUS2z3TtOJfG4bpHRM3JBgFKN9OrnqAlFtL+m8XFygtv2Gt/aXq/q0BFTtSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BlxPQ3Y8; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BlxPQ3Y8"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d1cbbeeaeso1045099b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 22:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723009436; x=1723614236; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Itrek65YgYL2+sOFSw0MGsHjiShaBFE9dci9J6CCwPg=;
        b=BlxPQ3Y8m1W/WUojFQzu6VVIowL5q6I8eM/GqJ3n9zVllt0OcnsUCTAzTe/KL0L3Yx
         95m9NOsy5tbWib7GoTPxoGhC/tW374LUizE5FVGPzNPTg/NN7dRzLerzrUI6nERhwfSv
         KJNYAF74cw1vEGsyXkOp6UuTotAgQT2f/oIQP1a5czJLiZijN1nd5/eehTZmJYUP1Blw
         l6qpTBVKVzmQGjX9VrtbVGfZZ3iofa+n66rugtGxImBJhWDUIAW/4Q5RFxa1p9D64wNY
         AWehHhicd00HRckeZHpX5Dq31UvBoDx/xnINMgDiTVZSlJjvBxNb6rvbTY6+S9twyYq2
         urRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723009436; x=1723614236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Itrek65YgYL2+sOFSw0MGsHjiShaBFE9dci9J6CCwPg=;
        b=pqCrnP48nwiPjg5ZsZnHI/d6lji6DiBLUGjYSaVyZ+kfjIASer20vzEac7lx9l5c31
         AiO0d11CROlSAWZsmAKwNK8/OZ6l0JX1Cm5GpAMaAwp1jQMgBWVKnb5A+PXNoV8sJcW5
         gi8uWoFk/RYUWLI1CmRZGBpe0KKAxcYZOZM8HKGJii9o5+VfprMoh8V1Q0wJVZ/DKFQT
         BjgtqTpF2+0gIgH4QWGq9ViC9y6FLtcVZ+RMhxfWKzHTVFBYApINd3N2LrnY/eSK/Umx
         KdfWdtAjyM3sqV2Xg23MPWB1NHVam3XeAxLgWFInpskvGzrhhNn4qxaM889Hm6rhREFD
         ev4A==
X-Gm-Message-State: AOJu0YyxHcpfU3xrmUEva/BftlGmAO9z6RC5ny8EkSzKobRpO8OIQpyO
	oPTde6wuNgbd3FpgN/D55ENY9XYHXqPZ2VmnJBiQNpv23iT1cLTWLwW4Y2yWj6mlcCQ0mgcM0Ku
	z
X-Google-Smtp-Source: AGHT+IEaHMUOwUrmy1rrlIa4V4cv8RiQlIeIO/vnIbIOIIEXbUQh4bdc5znBkvYyh7P3TrnWc7HMLw==
X-Received: by 2002:a05:6a20:ce4c:b0:1c0:f677:e98f with SMTP id adf61e73a8af0-1c69964b40cmr16410558637.46.1723009435899;
        Tue, 06 Aug 2024 22:43:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1b36baef0sm551080a91.14.2024.08.06.22.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 22:43:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sbZSj-008DEP-0v;
	Wed, 07 Aug 2024 15:43:53 +1000
Date: Wed, 7 Aug 2024 15:43:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: xfs_release lock contention
Message-ID: <ZrMJmfYfaT4fxSNM@dread.disaster.area>
References: <ejy4ska7orznl75364ehskucg7ibo3j3biwkui6q6mv42im6o5@pzl7pwwxjrg3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ejy4ska7orznl75364ehskucg7ibo3j3biwkui6q6mv42im6o5@pzl7pwwxjrg3>

On Wed, Aug 07, 2024 at 06:27:21AM +0200, Mateusz Guzik wrote:
> I'm looking at false-sharing problems concerning multicore open + read +
> close cycle on one inode and during my survey I found xfs is heavily
> serializing on a spinlock in xfs_release, making it perform the worst
> out of the btrfs/ext4/xfs trio.
> 
> A trivial test case plopped into will-it-scale is at the end.
> 
> bpftrace -e 'kprobe:__pv_queued_spin_lock_slowpath { @[kstack()] = count(); }' tells me:
> [snip]
> @[
>     __pv_queued_spin_lock_slowpath+5
>     _raw_spin_lock_irqsave+49
>     rwsem_wake.isra.0+57
>     up_write+69
>     xfs_iunlock+244
>     xfs_release+175
>     __fput+238
>     __x64_sys_close+60
>     do_syscall_64+82
>     entry_SYSCALL_64_after_hwframe+118
> ]: 41132
> @[
>     __pv_queued_spin_lock_slowpath+5
>     _raw_spin_lock_irq+42
>     rwsem_down_read_slowpath+164
>     down_read+72
>     xfs_ilock+125
>     xfs_file_buffered_read+71
>     xfs_file_read_iter+115
>     vfs_read+604
>     ksys_read+103
>     do_syscall_64+82
>     entry_SYSCALL_64_after_hwframe+118
> ]: 137639
> @[
>     __pv_queued_spin_lock_slowpath+5
>     _raw_spin_lock+41
>     xfs_release+196
>     __fput+238
>     __x64_sys_close+60
>     do_syscall_64+82
>     entry_SYSCALL_64_after_hwframe+118
> ]: 1432766
> 
> The xfs_release -> _raw_spin_lock thing is the XFS_ITRUNCATED flag test.

Yeah, these all ring old bells in the back of my skull.

> 
> test case (plop into will-it-scale, say tests/openreadclose3.c and run
> ./openreadclose3_processes -t 24):
> 
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <assert.h>
> 
> #define BUFSIZE 1024
> 
> static char tmpfile[] = "/tmp/willitscale.XXXXXX";
> 
> char *testcase_description = "Same file open/read/close";
> 
> void testcase_prepare(unsigned long nr_tasks)
> {
>         char buf[BUFSIZE];
>         int fd = mkstemp(tmpfile);
> 
>         assert(fd >= 0);
>         memset(buf, 'A', sizeof(buf));
>         assert(write(fd, buf, sizeof(buf)) == sizeof(buf));
>         close(fd);
> }
> 
> void testcase(unsigned long long *iterations, unsigned long nr)
> {
>         char buf[BUFSIZE];
> 
>         while (1) {
>                 int fd = open(tmpfile, O_RDONLY);
>                 assert(fd >= 0);
>                 assert(read(fd, buf, sizeof(buf)) == sizeof(buf));
>                 close(fd);

Oh, yeah, I defintely sent patches once upon a time to address
this.

<scrummage around old patch stacks>

Yep, there it is:

https://lore.kernel.org/linux-xfs/20190207050813.24271-4-david@fromorbit.com/

This would completely remove the rwsem traffic from O_RDONLY file
closes.

None of it would address the XFS_ITRUNCATED contention issue, but
that's just another of those "test, test-and-clear" cases that avoid
the atomic ops by testing if the bit is set without the lock
first....

Hmmm, I thought I saw these patches go past on the list again
recently.  Yeah, that was a coupl eof months ago:

https://lore.kernel.org/linux-xfs/20240623053532.857496-1-hch@lst.de/

Christoph, any progress on merging that patchset?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
