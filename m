Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804462;
	b=gs40mCmgBX2EuEdHZaVfKeVyUcs6J36WkZGw0S5om/tAd2RWoJmToTLVDVEEVzRLPW9g
	 ys/F/icGBOvL5lu9I4p2aEOAYFs27DWXgX2XWvY6HaswBezKGJhuCGD8oOm7N8Hl04G/1
	 jjW3r2Epu47JoGoyeeEaaRzREX/qjjPO+/Ekj4mAQHiFIplC6I0wW4+FPK0XLoMBktUne
	 dyTp0RlCnlgHtQGDtVLdBgK5BAlrdyumF4s+DX1fAf02dkZbCnLqa3ysiV+xnQUm1PNwM
	 UNxPnSejcJ6Wu7JtNze4zAByCWvuaCOs7OlT6cnx4zQZLzIyGcixN6xOpr3CE5ZgSxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804462;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=q/g0jSRA0tpJ07tlLDQp7RalSmitHJ2ympqEL/aS1gY=;
	b=peCk0sLCbkNaZfhTygRLQZ4NnSml6pg/ewvq7s1LSNMGEM7uvB+dT30tT0/TwpWCuDtp
	 0ZV3e2VwzyGT6DRdUmw4w+G38jo3FddR5AXElsiLHiljcgV+EYta1TOsJWpxUti8lxhkI
	 ieZPixAIBvV4aIG+o4Jg4il/Du9fQx9/tzmS5RYgpFyT5Jubro1lr2tj5HOuhR1ViMVjR
	 olZjrBcjpTrtEKNsaVUFrwhJwM4qlPHYqPzJCYY7nbwb8MIxOv65cX7w/nTYfekm9NTqV
	 mpoikg6ghCh8QUj61v1MBK/sEedDSUFSR9sZy/cAwH1nCzzz6VCghRDLwwxv7iQy3jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkzEMOdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444DD606A32E;
	Wed,  4 Nov 2026 15:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkzEMOdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C99C1F000C1;
	Wed,  4 Nov 2026 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804461;
	bh=q/g0jSRA0tpJ07tlLDQp7RalSmitHJ2ympqEL/aS1gY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IkzEMOdu/cBdyzp1oI8OIrJ59Rh1DPOC3qGh5+l7zyb0KLfYnGDVxL2W18r5uUkrI
	 Fcaf9S/0akTsJn4y7seVhly0S0WUZGtXC39Apf2LG7g4u6ZJot/2v7LAAlLrIPnK62
	 yv4/2RJeWP8BrNz6uLwyP3reKF8KzD7yroH6NbLYNr7kIP4JmRgazlMqLCec4JAuww
	 9bJD5b/XlSXMibSYY+qgcMLiQNGTmoBK5ogz5g5778QHQvB+r8AO/pa8mobFqsvBmb
	 ahF37C3kM+SETKLcRKXONQk8/hL8Iam+vMlrBzjCo4fLMH8QKlgb0C1423CA7Ziicx
	 Ej+eEK0Zz2uZw==
Date: Wed, 4 Nov 2026 16:00:54 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Jianyun Gao <jianyungao89@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Eric Sandeen <sandeen@redhat.com>, Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>, 
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, Dave Chinner <dchinner@redhat.com>, 
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix spurious len double-counting in rmap three-way
 merge check
Message-ID: <autIEIDr0097CaNS@nidhogg.toxiclabs.cc>
References: <20261103144148.14430-1-jianyungao89@gmail.com>
 <aun6-mywXYg2VTL4@nidhogg.toxiclabs.cc>
 <CAHP3+4ChRtv5OCoRrF9-D2GYXJnu0kS4_3O7kXqYRbTtLAt8mA@mail.gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHP3+4ChRtv5OCoRrF9-D2GYXJnu0kS4_3O7kXqYRbTtLAt8mA@mail.gmail.com>

On Wed, Nov 04, 2026 at 11:27:54AM +0800, Jianyun Gao wrote:
> Hi Carlos,
> 
> Thanks for the review. To answer your questions:
> 
> How I found it: I found this while reviewing the merge logic in
> xfs_rmap_map. After tracing the left-edge merge path, I noticed that
> ltrec.rm_blockcount is already updated at line 1119
> (ltrec.rm_blockcount += len), so adding len again in the overflow check
> is redundant. When the real merged length is still within
> XFS_RMAP_LEN_MAX but the inflated value exceeds it, the three-way merge
> is incorrectly rejected, leaving the right record unmerged.
> 
> Testing: I ran the rmap-specific regression tests with this patch
> applied, using kvm-xfstests on a 4k-block XFS configuration with
> rmapbt=1 and reflink=1:
> 
>   kvm-xfstests -c xfs/4k xfs/236 xfs/578
> 
> Results:
>   xfs/236      Pass     6s
>   xfs/578      Pass     34s
> Totals: 2 tests, 0 skipped, 0 failures, 0 errors
> 
> xfs/236 directly exercises the rmap btree grow/shrink paths affected by
> this change. I did not observe any regressions or warnings.
> If there are specific test cases you'd like me to run, please let me know.

Ok, I'd expect the tests to be a bit more thorough than two test cases,
ie. I'd expect this to be ran against at least the auto group too. But
nevertheless I'm glad you at did at least some of the homework.

The patch also seems fine to me, so

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Thanks,
> Jianyun
> 
> On Tue, Nov 3, 2026 at 11:33 PM Carlos Maiolino <cem@kernel.org> wrote:
> >
> > On Tue, Nov 03, 2026 at 10:41:44PM +0800, jianyungao89@gmail.com wrote:
> > > From: Jianyun Gao <jianyungao89@gmail.com>
> > >
> > > In xfs_rmap_map, the left-edge merge path already executes
> > > ltrec.rm_blockcount += len at line 1119 before checking whether the
> > > right record is also contiguous and can be merged.  The subsequent
> > > overflow guard therefore must compare the already-incremented
> > > ltrec.rm_blockcount plus gtrec.rm_blockcount against XFS_RMAP_LEN_MAX,
> > > but it incorrectly adds len a second time:
> > >
> > > (unsigned long)ltrec.rm_blockcount + len +
> > >    gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX
> > >
> > > The extra len makes the check too strict: when the real merged length
> > > does not overflow but the inflated value exceeds XFS_RMAP_LEN_MAX, the
> > > three-way merge is rejected and the code falls back to a two-way merge,
> > > leaving the right record unmerged.  This produces rmap btree
> > > fragmentation but does not corrupt on-disk metadata.
> > >
> > > Remove the spurious len from the overflow check.
> > >
> > > Fixes: 0a1b0b3855cf7 ("xfs: add an extent to the rmap btree")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> >
> > Hi, even though this looks reasonably correct, how did you find this
> > issue?
> > Did you test this at all against any regressions (i.e. running it
> > against xfstests)? This is touching critical logic on the rmap trees
> > which can potentially end really bad.
> >
> > Cheers.
> >
> > > ---
> > >  fs/xfs/libxfs/xfs_rmap.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > index 14aef87837a9..c2b2f8e7502d 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > @@ -1120,7 +1120,7 @@ xfs_rmap_map(
> > >               if (have_gt &&
> > >                   bno + len == gtrec.rm_startblock &&
> > >                   (ignore_off || offset + len == gtrec.rm_offset) &&
> > > -                 (unsigned long)ltrec.rm_blockcount + len +
> > > +                 (unsigned long)ltrec.rm_blockcount +
> > >                               gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
> > >                       /*
> > >                        * right edge also contiguous, delete right record
> > > --
> > > 2.34.1
> > >
> > >
> 
