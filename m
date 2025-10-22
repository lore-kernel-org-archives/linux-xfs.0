Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC53B23BCE7
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 16:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761149134; cv=none; b=pCEcVebH8OMNowkL68PeOEgU1hHoHJAGUgunR7rDD1FmfYogiJegvNxp12OrrjI6sZtcBECING1IOpGnRn2YaC1TIjYoh1HZ3o3tmeezizC6OgWJp9JIdxjgOD/FlAxuGfaRkIi6NhtHUeN51txS4VvW8sGuQhxDWvZcWN9/xqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761149134; c=relaxed/simple;
	bh=VTTzVCJzSCJNWtzD9mNKIxLN15XxZS+xWBBaaX6J2rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSzt8f0Roo0Ra6u2wMbQ85YoyT3Rno1eqa14isJ/z+hT7+UunT83KyI3RQgdYGuVy+aN6d3LrZag29XSaBoEcOARyaiAThIddKhFzq7yY8k+5ez8DWcZ7drmVO9qrWtRIx2Uvw8XCPS4EfmDGF+Xvn8o2S46ehby40WZqLqu2Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tPxpM6bV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tPxpM6bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD0DC4CEE7;
	Wed, 22 Oct 2025 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761149133;
	bh=VTTzVCJzSCJNWtzD9mNKIxLN15XxZS+xWBBaaX6J2rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tPxpM6bVkn6lQk7rcshGw1fsge1B9v9bhiioczzLShByCq/YpzDGeAXEPVhn+KjON
	 oXJi20tk9slrtlXoeLzEimQ+aFj8HYV1gWVMQ0ZT4/x8Y//qWFbu9m2j5FcOKZE2ZQ
	 TNWQC4Qvm24MFwgIUzQ289BXp3VZB6uZal4ZGlnqwksWPtHyGwJTSGpEOvfuAdDHRA
	 wWUonxQfrpP1ysacxnU42uK9v54RqhImXSjElVPArvJUSIZMh4lXHFVIpuM/5+bkCI
	 pEGcnmRgoKiDo1wsqKk0CHzdBDFe5tS7v6GE/X/bHPOpmKfnufWom5nfCsE9G5vo0d
	 7cFxoZZV8t7ug==
Date: Wed, 22 Oct 2025 09:05:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Message-ID: <20251022160532.GM3356773@frogsfrogsfrogs>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPiFBxhc34RNgu5h@infradead.org>

On Wed, Oct 22, 2025 at 12:17:27AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 20, 2025 at 09:13:41PM +0530, Nirjhar Roy (IBM) wrote:
> > This work is based on a previous RFC[1] by Gao Xiang and various ideas
> > proposed by Dave Chinner in the RFC[1].
> > 
> > Currently the functionality of shrink is limited to shrinking the last
> > AG partially but not beyond that. This patch extends the functionality
> > to support shrinking beyond 1 AG. However the AGs that we will be remove
> > have to empty in order to prevent any loss of data.
> > 
> > The patch begins with the re-introduction of some of the data
> > structures that were removed, some code refactoring and
> > finally the patch that implements the multi AG shrink design.
> > The final patch has all the details including the definition of the
> > terminologies and the overall design.
> 
> I'm still missing what the overall plan is here.  For "normal" XFS
> setups you'll always have inodes that we can't migrate.  Do you plan
> to use this with inode32 only?

...or resurrect xfs_reno?

Data/attr extent migration might not be too hard if we can repurpose
xfs_zonegc for relocations.  I think moving inodes is going to be very
very difficult because there's no way to atomically update all the
parents.

(Not to mention whatever happens when the inumber abruptly changes)

>                                 Also it would be nice to extent this
> to rtgroups, as we are guaranteed to not have non-migratable metadata
> there and things will actually just work.

Seconded.

--D
