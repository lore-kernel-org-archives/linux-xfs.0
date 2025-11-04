Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313B347FF3
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 23:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762299610; cv=none; b=IyODe5eJaKNx7s6ccG/VikKuUgcHLn4neesXMkoeXcXG4QTU02mqxADZyyrypvLdN0UX+P98nI32B6ehgF5jaEQKMOJRRnsQ89OJvbgrPa/xmqoRKUDwVztQE1Uzi4PKOJJTVCJhFNC8kg3LPuFvTU8rfj/zqYTB4BmiYRgVpm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762299610; c=relaxed/simple;
	bh=zFuXE3mJ9p5xhmjjIpZKEjcC94xxumzUntqQlEQrOsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hl/ScJMHYFE18+BZDZ4Mq1KlWysxXMpEH3amPQ93Va7wA27entVmJvxj+vIrl1aeW7uoLVce+yF/5zopxSYKN81zm7yfKb7bDky/v6geeHBZi3aN4rOXRjKLKy2ZJwf3+OQWngk3DLCAKxZN5sBJz84b1VNWFHC8cYX0bZIxlY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4PVtr6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4PVtr6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5E2C4CEF7;
	Tue,  4 Nov 2025 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762299609;
	bh=zFuXE3mJ9p5xhmjjIpZKEjcC94xxumzUntqQlEQrOsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V4PVtr6G1agsHMGXhVdW4xohCRhKHvy/2Tiiy8wZ87xt3HeYj8BIdVpnquGqGynsj
	 Azo+wgP2/2fx5xmXZ965R8HH61sGGSvUcXTRssc2x8cLiXKMBsAsAK7VbZORX0ci35
	 gZtcxCUo6uuev2vlrlr30B2fi8YiL2W60FcSHMcrDtp3/F+mmsPEPdBWQJkV7DZNQr
	 kRQFsVFZkCMq/ZIL3ixoF38rDC/Ct3CER7xyKzTsiIUq6ntYxLUDoUf/sFpZsNbmSP
	 0j8sxVzFU2DrCeRM32ii/0qrVaybbirBAPE3E15Z7myit2yzsuoJ7w+4dwdktFWRkD
	 PDuhxKT44jkMQ==
Date: Tue, 4 Nov 2025 15:40:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: improve the calling convention for the
 xlog_write helpers
Message-ID: <20251104234009.GQ196370@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-8-hch@lst.de>
 <20251101032632.GV3356773@frogsfrogsfrogs>
 <20251103104658.GB9158@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251103104658.GB9158@lst.de>

On Mon, Nov 03, 2025 at 11:46:58AM +0100, Christoph Hellwig wrote:
> On Fri, Oct 31, 2025 at 08:26:32PM -0700, Darrick J. Wong wrote:
> > > $ size fs/xfs/xfs_log.o*
> > >    text	   data	    bss	    dec	    hex	filename
> > >   26330	   1292	      8	  27630	   6bee	fs/xfs/xfs_log.o
> > >   26158	   1292	      8	  27458	   6b42	fs/xfs/xfs_log.o.old
> > 
> > Um... assuming xfs_log.o is the post-patch object file, this shows the
> > text size going up by 172 bytes, right?
> 
> That one does.  I was pretty sure it was the other way around, so І
> re-run this with the current tree:
> 
> $ size fs/xfs/xfs_log.o*
>    text	   data	    bss	    dec	    hex	filename
>   29300	   1730	    176	  31206	   79e6	fs/xfs/xfs_log.o
>   29160	   1730	    176	  31066	   795a	fs/xfs/xfs_log.o.old
> 
> but yes, this grows the text size somewhat unexpectedly.
> 
> I still like the new code, but I guess this now counts as a pessimization :(

"Cleaning up the method signatures is worth 140 bytes" :)

--D
