Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9152C859;
	Mon,  4 May 2026 07:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777881295; cv=none; b=gs6QWghnXGu6txMiNnXIP8nLRolq6xHXPMBD4aoHnSQrzcvlvmUg3Xn5KyvGxoPn1QkO3tnIkg6vshmJaYAjJG7DE939t8O5hBhCAYXq/bXyZAQKo/NKgNiVAB5BhZ3R7iO9b5dKG02bZ6kNwkTtq3ZgK4NbEstC/LAtEnvqjM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777881295; c=relaxed/simple;
	bh=CAXj9xyWc1aE1Yll4TCnkoDiCPvKt/BnzayChhJOaOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tf0FEESHGfYGFTYHwW8F8CnPONurCPQQO2ECkZamSg9ipfyw44oUuOufk1B6zaYaFgxIOx3IlguGwANV1Un0pSY2TjT2A9OSwr+3aD8Q631Xe/yTCWkW8EFTq3s8Fb+dF+rVs5TckyIP/DtEAaMwJ6qSWRu68eRRqXWAwKdwHuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FB9/5zfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FB9/5zfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD09CC2BCB8;
	Mon,  4 May 2026 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881295;
	bh=CAXj9xyWc1aE1Yll4TCnkoDiCPvKt/BnzayChhJOaOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FB9/5zfH25uUjpjPPQ5zy01kmPmRxMrLyK4TkeIq+yMks5WTBAdv2mcc1ENE0vK1n
	 zawnJhdMMeUnS5GChe3IpImRPVlcKQygZtOAJq1t/e8fMcgGAjooOdwDLhswIvnxS/
	 s3VmIkgywraM64O/mGT7MBHWUeGHI/Bxi1kFYQbCC95q+ZXWCH5dR4/EsKPfuBRsWo
	 lMMrA0HQ8lJPy7kAV3iXDWWmox7tQ6y0PdV7t7jsy4W3B2ZohRIXI0HdR9mLwymqWV
	 Pz2NuP7atrMv4gMqs3mJXHD50JvtXzENrT1BFwsexkMDL/E5KScqbwhfudMkwkg0JY
	 umGAikf/4zy+w==
Message-ID: <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
Date: Mon, 4 May 2026 09:54:49 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
 hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
 Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
 p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, pankaj.raghav@linux.dev,
 p.raghav@samsung.com, Daniel Gomez <da.gomez@samsung.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> Hi all,
> 
> This is the v2 RFC to add buffered writethrough support to iomap and
> xfs. The changes made are mostly to get the writethrough implementation
> more inline with how dio handles writes. 
> 
> 

I gave these series a run with kdevops and fstests using the following
profiles: xfs-crc-logdev, xfs-crc, xfs-reflink-logdev, xfs-reflink.

Note that I applied all patches on top of v7.1-rc1 and xfstest-dev
patches from Ojaswin have been rebased on latest master [1].

Link:
https://github.com/dagomez137/xfstests-dev/tree/iomap-buf-writethrough2 [1].

In general, some of the results here seem flaky. But let me know what
you think. I'll try to confirm the possible regressions with another
full run.


Summary per profile:

* xfs-crc-logdev: no regressions or fixes found
* xfs-crc:
  * generic/753 fixed. This test failed on 7.1.0-rc1 run but succeeded
on 7.1.0-rc1-00005-gc6a39600d3c3.
* xfs-reflink-logdev:
  * generic/415 failed on 7.1.0-rc1-00005-gc6a39600d3c3. I tried to
replicate the issue by just running generic/415 (not the entire test
suite), and I couldn't replicate it.
* xfs-reflink:
  * generic/457 failed on 7.1.0-rc1-00005-gc6a39600d3c3.
  * generic/561 failed on 7.1.0-rc1 but not on
7.1.0-rc1-00005-gc6a39600d3c3.


Here the full report list for each A/B profile test run:


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc-logdev.html


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc.html


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink-logdev.html


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink.html

