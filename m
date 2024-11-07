Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CF71DF72F;
	Thu,  7 Nov 2024 23:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731023491; cv=none; b=kJskznQBJbuEBUEZMQXegIZ68/tCG/2A0Wd+HqzqP1vBCuT4NZjdVI9cKH2yz5bp+czOh6txYYaUw0JtNUwvWii5U12/AHe8uITs7fNEzQSmFL+VuGMCJ9ndm3w6yxFDkdlBA5QdVBqoXHnEW01TuEVJeo13jVl2FySaVNt4lzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731023491; c=relaxed/simple;
	bh=/J3LOfo4neOonnUB4AaevkNujk1hY0MQr0eSnloxajk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szQJQ/uFZxNJqa1HuvYzV1Lr26We4HgXP7pJb+o0yGLq2jfK3J7YJW+GuecFGxybrfRgQdIkoQYOJPXVEVN29HwEyax+k6153Gn3wUF9m+oKOVsbN1dBOpwBTrlY0DHRs1owwZoG3/E3Y/RXIrl2lvTZKVuBtaUZTy1x1ZVAZeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktpVomDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktpVomDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11638C4CECC;
	Thu,  7 Nov 2024 23:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731023491;
	bh=/J3LOfo4neOonnUB4AaevkNujk1hY0MQr0eSnloxajk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ktpVomDgN0kPrabMmo6dj+JCZa1NSvvxsZSBWj8TTB+6g7jZrPCUbKIVdb5L7ouAc
	 ShzAftZ+Kh5stVIe/Xe1tpQyEDQo3KzvnJc6/43rCi34cg0AYRxcnNw8Wj1jdLx86T
	 VaioiLWF+IZCvgN+vepCbMOTcQ4Jc4ES6wazD7yHsHQyuJ2oT2w1u5H2Sh3o4nIAM7
	 qrWpPyEdgZ/cpF2Q6dJCKkUXUD23uBcS8wM6wGEe5GZzeeo128/AafjGa0RHbLObw3
	 0/8QApmT5k9uQew5alP5CeFU74+O0bSjGbpCfI1Bz2ONAjciyzTz4azIH6r8qwAyK1
	 Y3do5BhAzEUhw==
Date: Thu, 7 Nov 2024 15:51:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH 0/2] Some boundary error bugfix related to XFS fsmap.
Message-ID: <20241107235130.GW2386201@frogsfrogsfrogs>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <9337ebda-8e27-4754-bc57-748e44f3b5e0@huawei.com>
 <20240902190828.GA6224@frogsfrogsfrogs>
 <9ab7ee3d-cf97-47b0-91dd-c5451911b455@huawei.com>
 <725e972f-2014-405b-a056-611c13e95f20@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <725e972f-2014-405b-a056-611c13e95f20@huawei.com>

On Thu, Nov 07, 2024 at 05:21:55PM +0800, Zizhi Wo wrote:
> 
> 
> 在 2024/10/9 21:01, Zizhi Wo 写道:
> > Hi!
> > 
> > Here are two patches that address fsmap statistics errors. I sent out
> > this version in August, and I hope someone can take some time to review
> > them. So friendly ping. Thanks in advance!
> 
> friendly ping again（￣。。￣）

Oops, sorry.  Will go reply now.

--D

> > 
> > 
> > 在 2024/9/3 3:08, Darrick J. Wong 写道:
> > > On Thu, Aug 29, 2024 at 07:24:55PM +0800, Zizhi Wo wrote:
> > > > friendly ping
> > > 
> > > Sorry, I'm not going to get to this until late September.
> > > 
> > > --D
> > > 
> > > > 在 2024/8/26 11:10, Zizhi Wo 写道:
> > > > > Prior to this, I had already sent out a patchset related to xfs fsmap
> > > > > bugfix, which mainly introduced "info->end_daddr" to fix
> > > > > omitted extents[1]
> > > > > and Darrick had already sent out a patchbomb for merging
> > > > > into stable[2],
> > > > > which included my previous patches.
> > > > > 
> > > > > However, I recently discovered two new fsmap problems...What
> > > > > follows is a
> > > > > brief description of them:
> > > > > 
> > > > > Patch 1: In this scenario, fsmap lost one block count. The
> > > > > root cause is
> > > > > that during the calculation of highkey, the calculation of
> > > > > start_block is
> > > > > missing an increment by one, which leads to the last query missing one
> > > > > This problem is resolved by adding a sentinel node.
> > > > > 
> > > > > Patch 2: In this scenario, the fsmap query for realtime
> > > > > deivce may display
> > > > > extra intervals. This is due to an extra increase in
> > > > > "end_rtb". The issue
> > > > > is resolved by adjusting the relevant calculations. And this
> > > > > patch depends
> > > > > on the previous patch that introduced "info->end_daddr".
> > > > > 
> > > > > [1] https://lore.kernel.org/all/20240819005320.304211-1-wozizhi@huawei.com/
> > > > > [2] https://lore.kernel.org/all/172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs/
> > > > > 
> > > > > Zizhi Wo (2):
> > > > >     xfs: Fix missing block calculations in xfs datadev fsmap
> > > > >     xfs: Fix incorrect parameter calculation in rt fsmap
> > > > > 
> > > > >    fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
> > > > >    fs/xfs/xfs_fsmap.c           | 39
> > > > > +++++++++++++++++++++++++++++++-----
> > > > >    2 files changed, 35 insertions(+), 8 deletions(-)
> > > > > 
> > > > 
> > > 
> > 
> > 
> 
