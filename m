Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5BE2676CE
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739550109; cv=none; b=I1YPZ9PWC6HdzHBk6nR7obTygwgWCkqsD0keZBvJUJGxn3sJouRz45akZ2tbYhjFDR841PfI56bRF9E/hZQtiJR43/hpiRHjmgd7VBt8OL2wgEeP7g5rSsZ7IFiHux5HLZxVRDF4OFNXfBx31Pa5pXusCuMUc5AIyMVmMXnVV+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739550109; c=relaxed/simple;
	bh=60GgobfHDf/5R+SgutGhf6v2nrkSXTTckBjGNoKDnvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cr5maKAOReoa4Y3HG1SHtcAHFmOi7m4PqGGlKoq+m4TjMWt+JFTYXXtTop2EqkmqHWQnY57pn3pMtwC7fisPoSZ8pbmunJZw5olsi2aUZtdKPmeOQ54GgFrAe6wugOBPJD/OppJ2VjTmmTyZheVkMUbdWL/2n93nt/+eVZS0BxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWKuV8eg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWKuV8eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE23C4CED1;
	Fri, 14 Feb 2025 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739550108;
	bh=60GgobfHDf/5R+SgutGhf6v2nrkSXTTckBjGNoKDnvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWKuV8egpRBz9yZd4Q4izwmP0cp7tFKK0/gj3G9S1M2VfcBPBlRelT1ZIOET8mlUi
	 aefvAjMj1eQF5X3tXIRa/4UZzconJwEQTahjDXDe08TFuY2sPQOdjskQVgIIPTrvP5
	 XMvRev5dkzchR4N1VzqYOGIKYNCwrHfqDQZO4516LFQQASaNb9lVv6rrg5j13AGHRa
	 VP061vR9G+o5FZuWB4kgim+18sBU2lRw2R08G/IR5Ok2yXYEvmG8qVBtFjl901R8S3
	 q6v3I7EZ2HM0X51LFm/0lkwvz5KX5xicbmZUTw7gyGhR+stwFKZZDcyJ2Lok4dcipn
	 XwCYFC9DIAukQ==
Date: Fri, 14 Feb 2025 08:21:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch <hch@lst.de>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Message-ID: <20250214162147.GM3028674@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-40-hch@lst.de>
 <20250212002726.GG21808@frogsfrogsfrogs>
 <c909769d-866d-46fe-98fd-951df055772f@wdc.com>
 <20250213044247.GH3028674@frogsfrogsfrogs>
 <25ded64f-281d-4bc6-9984-1b5c14c2a052@wdc.com>
 <20250214064145.GA26187@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214064145.GA26187@lst.de>

On Fri, Feb 14, 2025 at 07:41:45AM +0100, hch wrote:
> On Thu, Feb 13, 2025 at 01:03:31PM +0000, Hans Holmberg wrote:
> > That sounds like good idea. Christoph: could you fold in the above lines
> > into the commit message for the next iteration of the series?
> 
> It needed a bit of editing to fit into the commit messages.  This is what
> I have now, let me know if this is ok:
> 
> fs: support write life time based data placement
> 
> Add a file write life time data placement allocation scheme that aims to
> minimize fragmentation and thereby to do two things:
> 
>  a) separate file data to different zones when possible.
>  b) colocate file data of similar life times when feasible.
> 
> To get best results, average file sizes should align with the zone
> capacity that is reported through the XFS_IOC_FSGEOMETRY ioctl.
> 
> This improvement in data placement efficiency reduces the number of 
> blocks requiring relocation by GC, and thus decreases overall write 
> amplification.  The impact on performance varies depending on how full 
> the file system is.
> 
> For RocksDB using leveled compaction, the lifetime hints can improve
> throughput for overwrite workloads at 80% file system utilization by
> ~10%, but for lower file system utilization there won't be as much
> benefit in application performance as there is less need for garbage
> collection to start with.
> 
> Lifetime hints can be disabled using the nolifetime mount option.

Perfect!

--D
