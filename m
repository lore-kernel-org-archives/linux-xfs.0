Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3BA19F41C;
	Wed,  8 Jan 2025 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736357748; cv=none; b=jqwiLfT56VavHmYiWob5ouZzeWIQ21Xn63jgocIUJVKxdZQKV2obc5tip3bj0wJbkcWznkeSRGLUn3+7Y3oObX/eB8EGUEQTA7Vu502yNoU8wk2rmGKkGCg9IroT3qpPE+GXiah83mldzyQe0UxKbR77PJJAMOHim/6a1aXd01A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736357748; c=relaxed/simple;
	bh=s7tVNRIZ/pzF0FFT5+/di9Ul6YLOgmrVOoLboYlZa7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbWwbpxqbhgbqj2hCb/15tFrkom+Dy8WnbiegTZpI3atHOOd6zECcLuxcPV0BkzyGfcku8ejERIB49i4qJ1BuGXxkvLZuJvh7f39GYDBffzTYfnSWH5++qFHiCBI0TWpa3Rms5QMWFULVQ0U6sgq153C2gobRzbZ87uAzZCtqx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwGy4muJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwGy4muJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5A6C4CED3;
	Wed,  8 Jan 2025 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736357747;
	bh=s7tVNRIZ/pzF0FFT5+/di9Ul6YLOgmrVOoLboYlZa7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RwGy4muJZXakdiboB0jHrfJMlCYjJWeCASYLlQWd/oHGpGWPwk9yrkhGDMuPRcdPH
	 nH+6r0sQsZjxDrmSQe3nsHsXbdexEodwTEVTnoHXTOzbR54tJMK/RJq7mysYnM2Gks
	 FVNN/E0bRLHR1uwLphwe5V7U+xZtSNxtb64Dax3APLtDAtRn1YMpi/lXwimHMX05+J
	 frcGqVsMm65Dvrq0oCQbScChXDd1JgBrhgC8oeKqvKN4tDWBWAGgz1FnC1Ny2bJcUP
	 tOa2Mj3y8/h0i1cZaJlnfIXB4uBv8+s4wdWh9rd59edXMIX7QnF3wYPJm5FHMB5R2P
	 /OGrMR3Ma1RqQ==
Date: Wed, 8 Jan 2025 09:35:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <20250108173547.GI1306365@frogsfrogsfrogs>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <953b0499-5832-49dc-8580-436cf625db8c@163.com>

On Wed, Jan 08, 2025 at 03:43:04PM +0800, Chi Zhiling wrote:
> On 2025/1/7 20:13, Amir Goldstein wrote:
> > On Mon, Dec 30, 2024 at 3:43 AM Chi Zhiling <chizhiling@163.com> wrote:
> > > On 2024/12/29 06:17, Dave Chinner wrote:
> > > > On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> > > > > On 2024/12/27 05:50, Dave Chinner wrote:
> > > > > > On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > > > > > > From: Chi Zhiling <chizhiling@kylinos.cn>
> > > > > > > 
> > > > > > > Using an rwsem to protect file data ensures that we can always obtain a
> > > > > > > completed modification. But due to the lock, we need to wait for the
> > > > > > > write process to release the rwsem before we can read it, even if we are
> > > > > > > reading a different region of the file. This could take a lot of time
> > > > > > > when many processes need to write and read this file.
> > > > > > > 
> > > > > > > On the other hand, The ext4 filesystem and others do not hold the lock
> > > > > > > during buffered reading, which make the ext4 have better performance in
> > > > > > > that case. Therefore, I think it will be fine if we remove the lock in
> > > > > > > xfs, as most applications can handle this situation.
> > > > > > 
> > > > > > Nope.
> > > > > > 
> > > > > > This means that XFS loses high level serialisation of incoming IO
> > > > > > against operations like truncate, fallocate, pnfs operations, etc.
> > > > > > 
> > > > > > We've been through this multiple times before; the solution lies in
> > > > > > doing the work to make buffered writes use shared locking, not
> > > > > > removing shared locking from buffered reads.
> > > > > 
> > > > > You mean using shared locking for buffered reads and writes, right?
> > > > > 
> > > > > I think it's a great idea. In theory, write operations can be performed
> > > > > simultaneously if they write to different ranges.
> > > > 
> > > > Even if they overlap, the folio locks will prevent concurrent writes
> > > > to the same range.
> > > > 
> > > > Now that we have atomic write support as native functionality (i.e.
> > > > RWF_ATOMIC), we really should not have to care that much about
> > > > normal buffered IO being atomic. i.e. if the application wants
> > > > atomic writes, it can now specify that it wants atomic writes and so
> > > > we can relax the constraints we have on existing IO...
> > > 
> > > Yes, I'm not particularly concerned about whether buffered I/O is
> > > atomic. I'm more concerned about the multithreading performance of
> > > buffered I/O.
> > 
> > Hi Chi,
> > 
> > Sorry for joining late, I was on vacation.
> > I am very happy that you have taken on this task and your timing is good,
> > because  John Garry just posted his patches for large atomic writes [1].
> 
> I'm glad to have you on board. :)
> 
> I'm not sure if my understanding is correct, but it seems that our
> discussion is about multithreading safety, while John's patch is about
> providing power-failure safety, even though both mention atomicity.
> 
> > 
> > I need to explain the relation to atomic buffered I/O, because it is not
> > easy to follow it from the old discussions and also some of the discussions
> > about the solution were held in-person during LSFMM2024.
> > 
> > Naturally, your interest is improving multithreading performance of
> > buffered I/O, so was mine when I first posted this question [2].
> > 
> > The issue with atomicity of buffered I/O is the xfs has traditionally
> > provided atomicity of write vs. read (a.k.a no torn writes), which is
> > not required by POSIX standard (because POSIX was not written with
> > threads in mind) and is not respected by any other in-tree filesystem.
> > 
> > It is obvious that the exclusive rw lock for buffered write hurts performance
> > in the case of mixed read/write on xfs, so the question was - if xfs provides
> > atomic semantics that portable applications cannot rely on, why bother
> > providing these atomic semantics at all?
> 
> Perhaps we can add an option that allows distributions or users to
> decide whether they need this semantics. I would not hesitate to
> turn off this semantics on my system when the time comes.
> 
> > 
> > Dave's answer to this question was that there are some legacy applications
> > (database applications IIRC) on production systems that do rely on the fact
> > that xfs provides this semantics and on the prerequisite that they run on xfs.
> > 
> > However, it was noted that:
> > 1. Those application do not require atomicity for any size of IO, they
> >      typically work in I/O size that is larger than block size (e.g. 16K or 64K)
> >      and they only require no torn writes for this I/O size
> > 2. Large folios and iomap can usually provide this semantics via folio lock,
> >      but application has currently no way of knowing if the semantics are
> >      provided or not
> 
> To be honest, it would be best if the folio lock could provide such
> semantics, as it would not cause any potential problems for the
> application, and we have hope to achieve concurrent writes.
> 
> However, I am not sure if this is easy to implement and will not cause
> other problems.

Assuming we're not abandoning POSIX "Thread Interactions with Regular
File Operations", you can't use the folio lock for coordination, for
several reasons:

a) Apps can't directly control the size of the folio in the page cache

b) The folio size can (theoretically) change underneath the program at
any time (reclaim can take your large folio and the next read gets a
smaller folio)

c) If your write crosses folios, you've just crossed a synchronization
boundary and all bets are off, though all the other filesystems behave
this way and there seem not to be complaints

d) If you try to "guarantee" folio granularity by messing with min/max
folio size, you run the risk of ENOMEM if the base pages get fragmented

I think that's why Dave suggested range locks as the correct solution to
this; though it is a pity that so far nobody has come up with a
performant implementation.

--D

> > 3. The upcoming ability of application to opt-in for atomic writes larger
> >      than fs block size [1] can be used to facilitate the applications that
> >      want to legacy xfs semantics and avoid the need to enforce the legacy
> >      semantics all the time for no good reason
> > 
> > Disclaimer: this is not a standard way to deal with potentially breaking
> > legacy semantics, because old applications will not usually be rebuilt
> > to opt-in for the old semantics, but the use case in hand is probably
> > so specific, of a specific application that relies on xfs specific semantics
> > that there are currently no objections for trying this solution.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.garry@oracle.com/
> > [2] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
> > 
> > > 
> > > Last week, it was mentioned that removing i_rwsem would have some
> > > impacts on truncate, fallocate, and PNFS operations.
> > > 
> > > (I'm not familiar with pNFS, so please correct me if I'm wrong.)
> > 
> > You are not wrong. pNFS uses a "layout lease", which requires
> > that the blockmap of the file will not be modified while the lease is held.
> > but I think that block that are not mapped (i.e. holes) can be mapped
> > while the lease is held.
> > 
> > > 
> > > My understanding is that the current i_rwsem is used to protect both
> > > the file's data and its size. Operations like truncate, fallocate,
> > > and PNFS use i_rwsem because they modify both the file's data and its
> > > size. So, I'm thinking whether it's possible to use i_rwsem to protect
> > > only the file's size, without protecting the file's data.
> > > 
> > 
> > It also protects the file's blockmap, for example, punch hole
> > does not change the size, but it unmaps blocks from the blockmap,
> > leading to races that could end up reading stale data from disk
> > if the lock wasn't taken.
> > 
> > > So operations that modify the file's size need to be executed
> > > sequentially. For example, buffered writes to the EOF, fallocate
> > > operations without the "keep size" requirement, and truncate operations,
> > > etc, all need to hold an exclusive lock.
> > > 
> > > Other operations require a shared lock because they only need to access
> > > the file's size without modifying it.
> > > 
> > 
> > As far as I understand, exclusive lock is not needed for non-extending
> > writes, because it is ok to map new blocks.
> > I guess the need for exclusive lock for extending writes is related to
> > update of file size, but not 100% sure.
> > Anyway, exclusive lock on extending write is widely common in other fs,
> > while exclusive lock for non-extending write is unique to xfs.
> > 
> > > > 
> > > > > So we should track all the ranges we are reading or writing,
> > > > > and check whether the new read or write operations can be performed
> > > > > concurrently with the current operations.
> > > > 
> > > > That is all discussed in detail in the discussions I linked.
> > > 
> > > Sorry, I overlooked some details from old discussion last time.
> > > It seems that you are not satisfied with the effectiveness of
> > > range locks.
> > > 
> > 
> > Correct. This solution was taken off the table.
> > 
> > I hope my explanation was correct and clear.
> > If anything else is not clear, please feel free to ask.
> > 
> 
> I think your explanation is very clear.
> 
> Thanks,
> Chi Zhiling
> 
> 
