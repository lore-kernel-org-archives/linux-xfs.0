Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE69510E6
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711070123; cv=none; b=nJmRFVzHnWKIF48jdlk+i8u391nF6TRGeG+f0cSh4QZC3aIH6mGkWLOOEE4dI92nq66kfi5U96WOFRbAYdmPw/FXNplHVEHl/r6NKuhmnBNsA7Z+ddhPvbqlcdgepBte/FUkLykL3j9IenUODmH3qB/SHA3ArHWqk149s790LH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711070123; c=relaxed/simple;
	bh=bKtQoCwA2jESY2ZF45BVbs4aZixjtmVpg+mj858DjeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZomWBMP6SPCdNQ5QXoxGx5xWsGar5N2JPF7NJxyPWKZR/aZ6trtvXuynSEH7XPK6PW3AMsBPwksIlQIdljKRclkaCUkPe+rnYtsltZiRroWYtM7Hl47Ur8DudSKQPjFGTvjpwcgcz1sZ2q8MInKFQ+FcQWHhKjAwbGsGJWDSSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=k4PKch5r; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="k4PKch5r"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7dfacd39b9eso1342031241.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 18:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711070120; x=1711674920; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=flzjosSIm5GxWlF0u5PYpcfzh3pQZRKtjfFwe81lFlM=;
        b=k4PKch5rVZg2Fn8sDpsJjXFmRMrdZwCjHUcUuSglCa0NdqV8wMie76za4/JJaeZYIj
         T2OjW+2rtf8tGAUrAMim07RyV5a1NXQjAdzl9Fttqw4rth5qMoL4sloT26yVxnEbubo6
         2+AEsNOwMlZI8OVnbDoAqmx4KN/FVVfak/BFw3STWjcxXAEGZk1u/zDSe2H7AtH7U4Tm
         vWRuKt8kNvYal5WTwHqvHEyJDaeCZGRw9Wbdd5iGarp5+aMdPfIiYjvW7+TH1IQvSsPl
         Gz41eT63bZZ2WfpnInaOw2Uw0ItsVUiaSImq1RDv5JvhHaqPKJ+j1a3Ik/yRJMekFaKL
         utTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711070120; x=1711674920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flzjosSIm5GxWlF0u5PYpcfzh3pQZRKtjfFwe81lFlM=;
        b=mjclzS21Y+mqKojH6YSgiUP2Df5ZkQT9mlxnkqpVw3GN3NOxqVjrhjr7bnXY/6J9F9
         QEuwCduZ6baOOjAwVbukJinA9kigoXfqB565ORWq+cdd9Ip/907mVkznkN6gdFxf2xIc
         xShO7EQBwEQERdvBbno6Zcgqwl0MoFg7VmBkZnOzNTLr2XArWIm5iB1R2dgqTpIeWj/s
         7J1iGgXAQ03K8mzf+vLEgBtFHegsA8SJbKuLDlOPoczXL8H62E2AbnUlvXuZ8l6ecMaf
         tjOdMM04aj3EZNDUFvTrBKrl34/Rzwo1cuLHCYzIefo7ksLHfAJ3UtGeUJQ3CA7MfqfZ
         a9Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUi5/3IEfp4wdlvViWSTDpGBiZcHkyeFiryvwPJgF4pqIH1+T0H3XsH1IV3TcSEpEnOoOLMlJbPYCbAzXwfavrGG74sfJZIiGxa
X-Gm-Message-State: AOJu0YzilbrTgaJsETP5GrjR/7e674ecdWjAvPfWgJ/VdNvnAoebaZK/
	Zcc8Jr9EDafB7ziaXVba7TVG5lPQTLsvSasqJDICuVbvCUv7/AC289i15vOB+z4jkeEeRpN3UMm
	6
X-Google-Smtp-Source: AGHT+IExMG2312IViWymkphq3FPhi52t+tConJQW41HUEeqgGL8CpeDGy+LaSwSFerrXEtIxSNZV8A==
X-Received: by 2002:a05:6a20:8f12:b0:1a3:4639:dafe with SMTP id b18-20020a056a208f1200b001a34639dafemr927758pzk.16.1711069754762;
        Thu, 21 Mar 2024 18:09:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id j7-20020aa78d07000000b006e6288ef4besm466217pfe.54.2024.03.21.18.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 18:09:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTPD-005UQX-30;
	Fri, 22 Mar 2024 12:09:11 +1100
Date: Fri, 22 Mar 2024 12:09:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <ZfzaNzlodfh/fWew@dread.disaster.area>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
 <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
 <20240320145328.GX1927156@frogsfrogsfrogs>
 <ZfsVzV52CG9ukVn-@tuebingen.mpg.de>
 <ZftofP8nbKzUdqMZ@dread.disaster.area>
 <ZfwE-k0irgGBfI5r@tuebingen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfwE-k0irgGBfI5r@tuebingen.mpg.de>

On Thu, Mar 21, 2024 at 10:59:22AM +0100, Andre Noll wrote:
> On Thu, Mar 21, 09:51, Dave Chinner wrote
> > I just haven't thought to run sparse on XFS recently - running
> > sparse on a full kernel build is just .... awful. I think I'll
> > change my build script so that when I do an '--xfs-only' built it
> > also enables sparse as it's only rebuilding fs/xfs at that point....
> 
> Would it be less awful to run coccinelle with a selected set of
> semantic patches that catch defective patterns such as double
> unlock/free?

Much more awful - because then I have to write scripts to do this
checking rather than just add a command line parameter to the build.

> > > > (Doesn't simple lock debugging catch these sorts of things?)
> > > 
> > > Maybe this error path doesn't get exercised because xfs_reinit_inode()
> > > never fails. AFAICT, it can only fail if security_inode_alloc()
> > > can't allocate the composite inode blob.
> > 
> > Which syzkaller triggers every so often. I also do all my testing
> > with selinux enabled, so security_inode_alloc() is actually being
> > exercised and definitely has the potential to fail on my small
> > memory configs...
> 
> One could try to trigger ENOMEM more easily in functions like this
> by allocating bigger slab caches for debug builds.

That doesn't solve the problem - people keep trying to tell us that
all we need it "better testing" when the right solution to the
problem is for memory allocation to *never fail* unless the caller
says it is OK to fail. Better error injection and/or forced failures
don't actually help us all that much because of the massive scope of
the error checking that has to be done. Getting rid of the need for
error checking altogether is a much better long term solution to
this problem...

> > > > ((It sure would be nice if locking returned a droppable "object" to do
> > > > the unlock ala Rust and then spin_lock could be __must_check.))
> > > 
> > > There's the *LOCK_GUARD* macros which employ gcc's cleanup attribute
> > > to automatically call e.g. spin_unlock() when a variable goes out of
> > > scope (see 54da6a0924311).
> > 
> > IMO, the LOCK_GUARD stuff is an awful anti-pattern. It means some
> > error paths -look broken- because they lack unlocks, and we have to
> > explicitly change code to return from functions with the guarded
> > locks held. This is a diametrically opposed locking pattern to the
> > existing non-guarded lockign patterns - correct behaviour in one
> > pattern is broken behaviour in the other, and vice versa.
> > 
> > That's just -insane- from a code maintenance point of view.
> 
> Converting all locks in fs/xfs in one go is not an option either, as
> this would be too big to review, and non-trivial to begin with.

It's simply not possible because of the issues I mentioned, plus
others.

> There
> are 180+ calls to spin_lock(), and that's just the spinlocks. Also
> these patches would interfere badly with ongoing work.

ANywhere you have unbalanced lock contexts, non-trivial nested
locking, reverse order locking (via trylocks), children doing unlock
and lock to change lock contexts, etc then this "guarded lock scope"
does not work. XFS is -full- of these non-trivial locking
algorithms, so it's just not a good idea to even start trying to do
a conversion...

> > And they are completely useless for anythign complex like these
> > XFS icache functions because the lock scope is not balanced across
> > functions.
> >
> > The lock can also be taken by functions called within the guard
> > scope, and so using guarded lock scoping would result in deadlocks.
> > i.e. xfs_inodegc_queue() needs to take the i_flags_lock, so it must
> > be dropped before we call that.
> 
> Yup, these can't use the LOCK_GUARD macros, which leads to an unholy
> mix of guarded and unguarded locks.

Exactly my point.

> > So, yeah, lock guards seem to me to be largely just a "look ma, no
> > need for rust because we can mightily abuse the C preprocessor!"
> > anti-pattern looking for a problem to solve.
> 
> Do you think there is a valid use case for the cleanup attribute,
> or do you believe that the whole concept is mis-designed?

Sure, there's plenty of cases where scoped cleanup attributes really
does make the code better.  e.g. we had XFS changes that used this
attribute in a complex loop iterator rejected back before it became
accepted so that this lock guard template thingy could be
implemented with it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
