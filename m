Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B2347A88D
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789680014; cv=none; b=cgfRgwX8/HMy7CWtRWpTiOtsr4lM4Uauu+iK4nlsLSH+UoLSHaTYUte3ZsdeaAQTXwZKs3PlPlMuf2SQ1WcKgof9h19aTHOJzLyhc0BAP62XI0UEa9RPHqaUblMDs0HAsaNOkp2VnVgQehXWrBhbev+uTShw6C6n8+GDS2Fdhqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789680014; c=relaxed/simple;
	bh=x+o5eBZt2ZV78DM0xb7yNywHu1y454YXoZuJnIfLvj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt+5BZjlCGPUe8GYD4ReCqpr1zGHNwceDa6XVPv6a++jMIVWRy1iR8RdMaDl6mljcwejjFjwK9PxdDPA2/uKQw8kzTsVxUKkWFH/+CXvo9ia4aM1iEQS1q7iqwvxCtMwBffurouBv+ZwydaxRIM0sUCq41bOZOQMR1Xm828B3uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUQSI/Lt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUQSI/Lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCFD1F000FF;
	Thu, 17 Sep 2026 21:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789680013;
	bh=InzmcATY8KaFEsmAqxSpocH/9yhRBeMf+E7+BoppHZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gUQSI/Ltmfo/R04pm8Ljsai5htbE5IHasUE6R6IIKDAlNF8/NWgetr+pI/zPTwqXw
	 N3B15z2YNwLuYbdSf2ifmiLfTprUJRvPE452A1Q5a93YuTVALFYuxUL3uvVldE/chq
	 vnkMDnCxYhIKTLeN8ExVVwzvOceZ+BUiVOTCh5zI4if2ubD819sZYbgVfxIHTkNq1A
	 THmorLkHVU1u/w2ZE0Q2rNzFdwrPLU3g3NZt4TWEoAcw5bwzWOKd0dQ88+IDCD2I3O
	 L/ZMPr3Tjg4vJTB65Q77QadOkpP33V//ESTkEyTrOs1EdLQbu08HqXBpxn4bc6xrsd
	 0ckehgBUqweLQ==
Date: Fri, 18 Sep 2026 07:20:04 +1000
From: Dave Chinner <dgc@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqxZhKvsHFAyUM5k@dread>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
 <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
 <20260915145046.GC2705364@frogsfrogsfrogs>
 <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
 <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com>
 <aqsW_iNwYAjYldVf@dread>
 <e651832b-75bc-4520-a45e-b79cd986d175@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e651832b-75bc-4520-a45e-b79cd986d175@linux.dev>

On Thu, Sep 17, 2026 at 09:28:15AM +0100, John Garry wrote:
> On 9/16/26 23:23, Dave Chinner wrote:
> > On Wed, Sep 16, 2026 at 11:23:16AM +0100, John Garry wrote:
> > > On 15/09/2026 16:41, John Garry wrote:
> > > > On 9/15/26 15:50, Darrick J. Wong wrote:
> > > > > > thanks
> > > > > > 
> > > > > > About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for
> > > > > > CoW-based atomics could help avoid this issue as we seem to be
> > > > > > bogged down
> > > > > > in lock contention.
> > > > > Which lock is being contended, anyway?  It looks like the ILOCK?
> > > > 
> > > > Yeah, I think so Re. ilock. I had some perf data illustrating this from
> > > > last year, which I can't seem to find, so I will re-generate it.
> > > 
> > > Here is perf call graph snippet when running fio with 72x threads issuing
> > > 4KB atomic writes on 1MB file:
> > > 
> > > --50.46%--xfs_file_dio_write_atomic
> > > |
> > > |--37.19%--iomap_dio_rw
> > > |          |
> > > |      --37.14%--__iomap_dio_rw
> > > |           |
> > > |       --36.50%--iomap_iter
> > > |            |
> > > |             --36.49%--xfs_atomic_write_cow_iomap_next
> > > |                  |
> > > |                  |--27.34%--xfs_ilock
> > > |                  |          |
> > > |                  |      --27.34%--down_write
> > > |                  |           |
> > > |                  |       --27.28%--rwsem_down_write_slowpath
> > > |                  |            |
> > > |                  |            |--24.65%--osq_lock
> > > |                  |            |
> > > |                  |             --2.35%--rwsem_spin_on_owner
> > > |                  |
> > > |                  |--7.62%--xfs_trans_alloc_inode
> > > |                  |          |
> > > |                  |      --7.59%--xfs_ilock
> > 
> > Where's the other half of the lock contention?
> 
> I was expecting xfs_reflink_end_atomic_cow() -> xfs_ilock() to be a point of
> contention as well, but it does not show up. I suppose that it because all
> those threads at completion stage are sleeping.
> 
> However, there is this which I omitted:
> 
> --13.21%--xfs_file_write_checks
>    |
>       --13.18%--kiocb_modified
>          |
>             --13.17%--file_update_time_flags
>                |
>                   --13.16%--xfs_vn_update_time
>                      |
>                         --12.99%--xfs_ilock
>                            |
>                               --12.98%--down_write

Fair enough, I'd expect that from the all the threads blocked on the
lock there in the hung task output.

....

> JFYI, I have another log for a similar hang which we see one thread deadlock
> for log space, below.

Looks very similar. So, same questiosn about log size, etc.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
