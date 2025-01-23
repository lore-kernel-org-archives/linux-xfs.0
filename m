Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEA617741
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2025 01:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737595015; cv=none; b=NfqlO5ZTupGPEFDdiBBpFg6AHSLbXMTqWkMCjgD9EfBdRJqVTYt3NuGO3198sSvQ+pkJ4uBF7R4v/LY3JoSQK7AfV+KyoQePM/s4wMGG3HNiEL8e2OfgzaRW7RD7bId6iMcD8D6oD1SIeQyobdJz1uDeOsRtYorhe5DyX+PH/aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737595015; c=relaxed/simple;
	bh=D+/JKEUX4/Ti+zOWqlKUKxssxjCtUcI2akEQ1e9xGhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyR8vrtn4IRf7ZOPRQ0Ab+GtbxWjkmPZAp7uF9lhuJQ37HVkVEQ7rGaLaLjHQ8itvJ8WQjCRsdepX+Vt7X9edaYhRW7lVcMLKCNutqwuqEZ/SztWQaEifC2ncOOxinGAT2HcFiM9zJiXsZlz+8+xn+8Cw0YC4j/PrrDwIWkIsGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=itWR9YRi; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="itWR9YRi"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2163b0c09afso5582805ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 17:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737595013; x=1738199813; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uOySAqkA0Wj07XwpNX3LEIcrqbMjcIdSNbiLlCR+nSc=;
        b=itWR9YRiTTN18veAsycQR2RAc7GzDepYzSp30mFmDfV96UIW51qBjl+E43EKtY0hq+
         i/umJJgkbL0zURrRiKEGXTTXp6F/3qtGSTb+ylQ+PSBvcvvG+iODaAXb9KwaKzNgOs3I
         dwtNPYkuEmznxe0JlL2QJAHJqVbMJJyvwiqJvnSCbaN8aukH9e1/wDZeykG+I96WPV9D
         hhJNJv4fgu2tJiw8regJ/jnlsLpFLR0ncFgPGU3I+l+C3zK9bBISQ2WNniJhm91iUDTS
         sVNr+I2rKUHYCmQeNw7m3QlUEAWmmVSCHd6E+UooXZ+arcQrBWfi1QpLI5lcZhi24NSc
         d5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737595013; x=1738199813;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uOySAqkA0Wj07XwpNX3LEIcrqbMjcIdSNbiLlCR+nSc=;
        b=lhHQEmW4H1R6gQuWb5T/bK54paTIhnq8n468V5kHagULxvsNuIE4kVkTK99PDOjZ+j
         KCQWP6pJ1jdBt39hAvKAZEwjDMXPUBIn8HwbfnagcQMNCnXiVx2eYX9Gjfl0C5bw5bOF
         a5c2QkoY0YiCu39dVfoqkaWaMTl+hV2rV5p6QQE+NHzCMtXkDWm6nrsXwxZKd6gnuCXL
         C00BzrBZNZLs9HqUEwjGp6L2VsjCFQrpOD2NP9L2HoofBvHzhYjh98BUHJsErXaOMFWw
         GvT9EmxL3+cHnmdPMljfHG7vLxrft2I9dFGahTVgnPn8t1My+FcaB4t58UifaXHa6URc
         7AFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/jDcm+3wpFyw8ptoGmC5vbxY5SA6lT0lKWgTHy+QZZVQVT36JFngpqK7VX2SbYXkErct/E9VFdWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcHJPuf4SNHdMd6/4aUtlrzys3+8sS7O6xSQXjPU20wicjow2V
	x4QdwWvKg8iAONVv8QXGu+9EBpgPtKyLqoIoi9HO8AA0NLWwbgZUHvT8sD+G05M=
X-Gm-Gg: ASbGnctxP8cvE61hL3fowWsF2ITS1vdNClru+4CA34OXvNTVAjBmpiab+JKMCzJ51GZ
	5XxVAKtnvmmm/vp0usFIENDIh3LQrF4lrVeaBDfbIhfrlp7UCxqqFwkaT1OfrIcdocjPBnW8ZPZ
	4zxDxfLGQy6vnuKienAgVmPIemw+2qPks6GlbrNW2Bd/zDIRYv6oZIfbgkwp2KLhFDLIOPISM6m
	KBsvSDmJTW+LtbopAmy5ijyNXJlay2OlZVYNsNE/GpxQfswYwFMBPzJdJZa13VC9312AS7D9LfN
	4lTo9/JEwG5sRyw6UEzEzxj/WQSlk7QHj873EFsN9EfLKw==
X-Google-Smtp-Source: AGHT+IER4ZfGCCqw+AByljs1/V3/LXMmw8pSXA5FNZZ0ZK7tnPRvuefKLjmSeutk+0spkglhaaZe0A==
X-Received: by 2002:a17:902:f546:b0:215:72a7:f39f with SMTP id d9443c01a7336-21c355b78f5mr357867565ad.36.1737595013447;
        Wed, 22 Jan 2025 17:16:53 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3e0df9sm102798575ad.196.2025.01.22.17.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 17:16:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1talpy-00000009Iu8-0n1f;
	Thu, 23 Jan 2025 12:16:50 +1100
Date: Thu, 23 Jan 2025 12:16:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <Z5GYgjYL_9LecSb9@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
 <20250122070520.GD1611770@frogsfrogsfrogs>
 <Z5C9mf2yCgmZhAXi@dread.disaster.area>
 <20250122214609.GE1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250122214609.GE1611770@frogsfrogsfrogs>

On Wed, Jan 22, 2025 at 01:46:09PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 22, 2025 at 08:42:49PM +1100, Dave Chinner wrote:
> > On Tue, Jan 21, 2025 at 11:05:20PM -0800, Darrick J. Wong wrote:
> > > On Wed, Jan 22, 2025 at 05:08:17PM +1100, Dave Chinner wrote:
> > > > On Tue, Jan 21, 2025 at 08:24:00PM -0800, Darrick J. Wong wrote:
> > > > > On Tue, Jan 21, 2025 at 02:28:26PM +1100, Dave Chinner wrote:
> > > > > > On Thu, Jan 16, 2025 at 03:27:15PM -0800, Darrick J. Wong wrote:
> > > > > > > c) Putting test subprocesses in a systemd sub-scope and telling systemd
> > > > > > > to kill the sub-scope could work because ./check can already use it to
> > > > > > > ensure that all child processes of a test are killed.  However, this is
> > > > > > > an *optional* feature, which means that we'd have to require systemd.
> > > > > > 
> > > > > > ... requiring systemd was somewhat of a show-stopper for testing
> > > > > > older distros.
> > > > > 
> > > > > Isn't RHEL7 the oldest one at this point?  And it does systemd.  At this
> > > > > point the only reason I didn't go full systemd is out of consideration
> > > > > for Devuan, since they probably need QA.
> > > > 
> > > > I have no idea what is out there in distro land vs what fstests
> > > > "supports". All I know is that there are distros out there that
> > > > don't use systemd.
> > > > 
> > > > It feels like poor form to prevent generic filesystem QA
> > > > infrastructure from running on those distros by making an avoidable
> > > > choice to tie the infrastructure exclusively to systemd-based
> > > > functionality....
> > > 
> > > Agreed, though at some point after these bugfixes are merged I'll see if
> > > I can build on the existing "if you have systemd then ___ else here's
> > > your shabby opencoded version" logic in fstests to isolate the ./checks
> > > from each other a little better.  It'd be kinda nice if we could
> > > actually just put them in something resembling a modernish container,
> > > albeit with the same underlying fs.
> > 
> > Agreed, but I don't think we need to depend on systemd for that,
> > either.
> > 
> > > <shrug> Anyone else interested in that?
> > 
> > check-parallel has already started down that road with the
> > mount namespace isolation it uses for the runner tasks via
> > src/nsexec.c.
> > 
> > My plan has been to factor more of the check test running code
> > (similar to what I did with the test list parsing) so that the
> > check-parallel can iterate sections itself and runners can execute
> > individual tests directly, rather than bouncing them through check
> > to execute a set of tests serially. Then check-parallel could do
> > whatever it needed to isolate individual tests from each other and
> > nothing in check would need to change.
> > 
> > Now I'm wondering if I can just run each runner's check instance
> > in it's own private PID namespace as easily as I'm running them in
> > their own private mount namespace...
> > 
> > Hmmm - looks like src/nsexec.c can create new PID namespaces via
> > the "-p" option. I haven't used that before - I wonder if that's a
> > better solution that using per-test session IDs to solve the pkill
> > --parent problem? Something to look into in the morning....
> 
> I tried that -- it appears to work, but then:
> 
> # ./src/nsexec -p bash
> Current time: Wed Jan 22 13:43:33 PST 2025; Terminal: /dev/pts/0
> # ps
> fatal library error, lookup self
> # 

That looks like a bug in whatever distro you are using - it works
as it should here on a recent debian unstable userspace.

Note, however, that ps will show all processes in both the parent
and the child namespace the shell is running on because the contents
of /proc are the same for both.

However, because we are also using private mount namespaces for the
check process, pid_namespaces(7) tells us:

/proc and PID namespaces

       A /proc filesystem shows (in the /proc/pid directories) only
       processes visible in the PID namespace of the process that
       performed the mount, even if the /proc filesystem is viewed
       from processes in other namespaces.

       After creating a new PID namespace, it is useful for the
       child to change its root directory and mount a new procfs
       instance at /proc so that tools  such  as  ps(1) work
>>>    correctly.  If a new mount namespace is simultaneously
>>>    created by including CLONE_NEWNS in the flags argument of
>>>    clone(2) or unshare(2), then it isn't necessary to change the
>>>    root directory: a new procfs instance can be mounted directly
>>>    over /proc.

       From a shell, the command to mount /proc is:

           $ mount -t proc proc /proc

       Calling readlink(2) on the path /proc/self yields the process
       ID of the caller in the PID namespace of the procfs mount
       (i.e., the PID name‐ space of the process that mounted the
       procfs).  This can be useful for introspection purposes, when
       a process wants to discover its  PID  in other namespaces.

This appears to give us an environment that only shows the processes
within the current PID namespace:

$ sudo src/nsexec -p -m bash
# mount -t proc proc /proc
# ps waux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   7384  3744 pts/1    S    11:55   0:00 bash
root          72  0.0  0.0   8300  3736 pts/1    R+   12:04   0:00 ps waux
# pstree -N pid
[4026538173]
bash───pstree
#

Yup, there we go - we have full PID isolation for this shell.

OK, I suspect this is a better way to proceed for check-parallel than
to need session IDs for individual tests and wrappers for
pgrep/pkill/pidwait. Let me see what breaks when I use this.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
