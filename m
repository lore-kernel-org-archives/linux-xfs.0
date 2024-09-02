Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F681A3A97;
	Mon,  2 Sep 2024 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725304109; cv=none; b=d9z6a8ilt9PmtJq7/nPFjnUUdDsloOByPYNgFtvFSxOqdkNjo079Ku8I7BV3+Ch9JbXhixzUoSa19iUpNhLhG1/3xW6m0uh/ldKVPGxPFg03hw75sCWif5lTA81ERzTUEZEwxai3ju8/Ad6fufzGwiP7DQnVtJtjJWQr/5PjtSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725304109; c=relaxed/simple;
	bh=L/v8ja7U3poGx/rL4/awxrsM/dIZpV15uF3Vk7OelJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFnJ2U44bs8EUnAloDN6/p9cNt6l2OevHlJa9SJtWCfKGg8STu627yTVNz6iL3PiOLACSxMYF+JYKGsNWw9VjhJfKYgblLC3i9hOmSjir1IUSYOwKVJflHAp46yzDuwMY23hKQcXrccqucyhiQ2mm0hlIX9/EdJlTk5t5SvLKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtxoRv1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtxoRv1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACEBC4CEC2;
	Mon,  2 Sep 2024 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725304108;
	bh=L/v8ja7U3poGx/rL4/awxrsM/dIZpV15uF3Vk7OelJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JtxoRv1q/aJlCtREh37W45BQfuQy6nS1jVgUCVYiWIGfw1ei5kQ+nKFUGljjj82mR
	 GxFDm2k5OF2yz+1z3EQoia7ATf8BoKJUIHgDDb/WN2ATF4Yg6BT1pGtOFq9YBLLuh0
	 0Os92Zxq/aFKrlngOEFeWnIwk7CnISLsCiigC/olD7yKrp8zH8n4cTjGLjBlm+orSd
	 O67sTYp6V2mFj4v3vhMKxFpwKanxb/nGEZwUwdy/Am6pciLaCArm74HTRDitQcP2tE
	 fGcQOqO8aoFAxPiHeURNV3vRPlUvTFxHbkY/ga7xTlCsLkxQRFH+dUzGWbLit00oAc
	 cPdWrH0jYqY1w==
Date: Mon, 2 Sep 2024 12:08:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH 0/2] Some boundary error bugfix related to XFS fsmap.
Message-ID: <20240902190828.GA6224@frogsfrogsfrogs>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <9337ebda-8e27-4754-bc57-748e44f3b5e0@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9337ebda-8e27-4754-bc57-748e44f3b5e0@huawei.com>

On Thu, Aug 29, 2024 at 07:24:55PM +0800, Zizhi Wo wrote:
> friendly ping

Sorry, I'm not going to get to this until late September.

--D

> 在 2024/8/26 11:10, Zizhi Wo 写道:
> > Prior to this, I had already sent out a patchset related to xfs fsmap
> > bugfix, which mainly introduced "info->end_daddr" to fix omitted extents[1]
> > and Darrick had already sent out a patchbomb for merging into stable[2],
> > which included my previous patches.
> > 
> > However, I recently discovered two new fsmap problems...What follows is a
> > brief description of them:
> > 
> > Patch 1: In this scenario, fsmap lost one block count. The root cause is
> > that during the calculation of highkey, the calculation of start_block is
> > missing an increment by one, which leads to the last query missing one
> > This problem is resolved by adding a sentinel node.
> > 
> > Patch 2: In this scenario, the fsmap query for realtime deivce may display
> > extra intervals. This is due to an extra increase in "end_rtb". The issue
> > is resolved by adjusting the relevant calculations. And this patch depends
> > on the previous patch that introduced "info->end_daddr".
> > 
> > [1] https://lore.kernel.org/all/20240819005320.304211-1-wozizhi@huawei.com/
> > [2] https://lore.kernel.org/all/172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs/
> > 
> > Zizhi Wo (2):
> >    xfs: Fix missing block calculations in xfs datadev fsmap
> >    xfs: Fix incorrect parameter calculation in rt fsmap
> > 
> >   fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
> >   fs/xfs/xfs_fsmap.c           | 39 +++++++++++++++++++++++++++++++-----
> >   2 files changed, 35 insertions(+), 8 deletions(-)
> > 
> 
