Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A02432D0E6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762537805; cv=none; b=eNnelRMYsdluoR8C8EsAo2B4Q0dtC7lGCHPnpj40j1avO0K6bNEJVawtM9/JKi3xH84qUks2FYZa/io3LODGTxOeixgq6VGtGKZR+O2OVEHp7ClgZgN6GzYMkm4wx148TGnnbgm8il7jocRS0oCyVkdks4XiXGiiZq+roh+S7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762537805; c=relaxed/simple;
	bh=GtiLzC7FyrkNXTeFSkMvBNVgqKfecKUDohCXRmYzYIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WYjQettlxAAHNBxeGVFeist1LV5sMwKrTPh5jI+monnKhtTV9C8ErvaZQul48IjdO6hCTRkZnEX06lkNhCuFq/+6DYt+CwaXp+p+Br67wMArS9V9H9MDO14WHf3JaPTNGkTQuXXr/waFQ71rQbGpNAhWIda2foFbGOMs0uwgcr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAwVo4xZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAwVo4xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F9CC19424;
	Fri,  7 Nov 2025 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762537805;
	bh=GtiLzC7FyrkNXTeFSkMvBNVgqKfecKUDohCXRmYzYIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TAwVo4xZ4+IJ/6yq5hiMOlrSD+o1rwDJIitnOHSR0B7H10MsfIiu/6VZLErp9Lx94
	 G1VDnSvCxoXDHeGmuB0oS/kkb4RGnDM5vJTYqyK0/vbB7Gte8h4WYUhs14ZqsdAe5n
	 Q8CP0gJbcCJyA54eGZFa2vKYV3GcTNTGH/TydzYtzolebHbuCw1aNku5PCBXaOJT5A
	 2SmTMcutqg6zv/PEKEYgDb50UR98YEzJ1dAaFs+7bm/n5PqcqXtDvbgWGS51ssnSWd
	 ya3XYWjhVJpyXCuVFaGycNqkJ4hqW9JAmbJwO+KkxFTP6IXgLHGVjjk6p6WlheKIrR
	 5t/gPU7gm3DwQ==
Date: Fri, 7 Nov 2025 09:50:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Message-ID: <20251107175004.GL196370@frogsfrogsfrogs>
References: <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
 <cc5yndgo6enxwtnwvcc26wdoxg3wdnnzie6lvn2mttrzkeez24@6sk5qlhlrozp>
 <20251107042840.GK196370@frogsfrogsfrogs>
 <raxwda5jgqm463olshbx5q32iy3kpfayoj7xaj5yl5dlduiv6m@szrvfmnxeant>
 <5e3f6b82-1e8c-4cd1-90a6-e1612f76370b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e3f6b82-1e8c-4cd1-90a6-e1612f76370b@oracle.com>

On Fri, Nov 07, 2025 at 12:48:38PM +0000, John Garry wrote:
> On 07/11/2025 05:53, Shinichiro Kawasaki wrote:
> > On Nov 06, 2025 / 20:28, Darrick J. Wong wrote:
> > > On Fri, Nov 07, 2025 at 02:27:50AM +0000, Shinichiro Kawasaki wrote:
> > > > On Nov 06, 2025 / 08:53, John Garry wrote:
> > ...
> > > > > Having a hang - even for the conditions set - should not produce a hang. I
> > > > > can check on whether we can improve the software-based atomic writes in xfs
> > > > > to avoid this.
> > > > 
> > > > Thanks. Will sysrq-t output help? If it helps, I can take it from the hanging
> > > > test node and share.
> > > 
> > > Yes, anything you can share would be helpful.
> > 
> > Okay, I attached dmesg log file (dmesg.gz), which contains the INFO messages and
> > the sysrq-t output. It was taken with v6.18-rc4 kernel with the fix patches by
> > Darrick. I also attached the kernel config (_config.gz) which I used to build
> > the test target kernel.
> > 
> > > FWIW the test runs in 51
> > > seconds here, but I only have 4 CPUs in the VM and fast storage so its
> > > filesize is "only" 800MB.
> > 
> > FYI, my test node has 24 CPUs. The hang is sporadic and I needed to repeat the
> > test case a few times to recreate it with the 8GiB TCMU devices. When it does
> > not hang, the test case takes about an hour to complete.
> 
> Hi Shinichiro,
> 
> Can you still stop the test with ctrl^C, right?
> 
> @Darrick, I worry that there is too much ip lock contention in
> xfs_atomic_write_cow_iomap_begin(), especially since we may drop and
> re-acquire the lock (in xfs_trans_alloc_inode()). Maybe we should force
> serialization in xfs_file_dio_write_atomic(). After all, this was not
> intended to provide good performance. Or look at other ways to optimise this
> (if we do want good performance).

I don't see how that helps.  All that does is shift the lock contention
from xfs_inode::i_lock to inode::i_rwsem.  At the end of the day, this
test is starting up 2*nr_cpus threads to issue large atomic directio
writes that take a long time to complete.  Stall warnings when there are
a large number of threads all trying to directio write to a file whose
blocks require a metadata update upon IO completion are a long known
problem.

I altered my test VM to have 24 cores and enough RAM to avoid OOMing the
machine.  Setting up the mixed mappings file took 27 seconds, and the
aio writes themselves took 3:15.  Validating the contents took 4
seconds.

Maaaybe we should back off on the file size.  I don't see why it needs
to create a 5GB file for testing.  The verify runs at 2100MB/s whereas
the atomic writes plod along at 25MB/s.  That's why this test takes a
loooong time to run.

(I don't see the lfsr complaints, but I'm running fio 3.41 from git)

--D

> Thanks,
> John
> 
