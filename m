Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006F62206A4;
	Mon, 10 Mar 2025 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741598607; cv=none; b=PdoSt3WQaRScBGkJg6figwS5X3cwGvYspCMRPH79pDqa3gzJUyPC5vUuwaX++qxeXESjnyAYri+foocUy5MDQ4Ld09vFiZDYH9mGwaB/ZlOAGVfWiTPhGskOMZySYzP2uP+uqd/+GuA1h7MSwJqugkk2cP9JJvfNkM1nleo8yFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741598607; c=relaxed/simple;
	bh=w3W63P7Y44D1lCiCcRIpMQhR2JASEaHu1S0suZWydFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgVIMtesOIOmjjjfkoMazPsSgEAWfDamlk2CXwqHnp43vI05WurTBNxrK9zJ1D2xvo1EADhacLGDyDSADhDM2Fqbbr5giU/zwrd22kcmFgDcOO/kKZh1Q2mNlcfponVPN2YcsE3S9hj4DqUl3k5rljEcNsQV+QxYliqLZSk2Eso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSdDow2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSdDow2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F29C4CEE5;
	Mon, 10 Mar 2025 09:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741598606;
	bh=w3W63P7Y44D1lCiCcRIpMQhR2JASEaHu1S0suZWydFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tSdDow2KMRuc59IChh6J3xEYkhpf3ohIKISXmf4ChbemGD9eZB1GUZBfXEXFYsDlF
	 7qlMHwknOq0kKUUXIVhqZHL81OSNCgsnPjuKghIX59e8xvaLJTpuW3nxpE4meFtqt3
	 a5l2DTLK3gJ9Gb9faSPF+hpz/DPvKSNE2iZFcbJxthOE5PPhu5uuTVWg0GYbGRKJi1
	 lQThgj4Fjfu/EaAbCv648tubrlqJl30WWwd7iU4bPDS1DO9JahF6rAyNUakJNozTWC
	 G/DRbHn8CQlawxM4XoUpZqNjm8xv7SpMx8mmOsygrTYUh4L9Zcpx4W6Ccok/VAe9Oe
	 SQgLvUAotSymQ==
Date: Mon, 10 Mar 2025 10:23:20 +0100
From: Carlos Maiolino <cem@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:15: error:
 too few arguments to function 'xfs_file_write_checks'
Message-ID: <5kyqahqmufx3zbacsq7t3j35fwiiphx3kbvmpmk6s3sznex5wn@nav7453wf6hw>
References: <202503090042.CWpAx3iG-lkp@intel.com>
 <-snKkUpXKLf6d34AfSaS0n5bb6CB1Lvo1pjfXIlmUp0gWycw1DVpA_QvioQtUAP_57GkYOu6_cHm3TNdPVTuVg==@protonmail.internalid>
 <7ade7fb1-b48d-4ee1-b9b5-2aff9c1c9622@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ade7fb1-b48d-4ee1-b9b5-2aff9c1c9622@oracle.com>

On Sun, Mar 09, 2025 at 09:11:50AM +0000, John Garry wrote:
> On 08/03/2025 16:46, kernel test robot wrote:
> >>> fs/xfs/xfs_file.c:746:15: error: too few arguments to function 'xfs_file_write_checks'
> >       746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
> >           |               ^~~~~~~~~~~~~~~~~~~~~
> >     fs/xfs/xfs_file.c:434:1: note: declared here
> >       434 | xfs_file_write_checks(
> >           | ^~~~~~~~~~~~~~~~~~~~~
> 
> Christoph's zoned series added a new arg to xfs_file_write_checks().
> 
> I think that we want to add a NULL here as that arg - assuming that we
> won't support atomic writes for zoned devices now.
> 
> Carlos, please advise to handle.

I didn't know the bot was monitoring all branches, I just created this branch to
open a discussion with you an Christoph. Well, I'll do that on my personal
repo next time :)

I'll figure out what to do with this today.


> 
> Thanks,
> John
