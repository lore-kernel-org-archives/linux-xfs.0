Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E3153A7
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905893; cv=none; b=FxzUrigoW622MhhfSCGq8QVxkHNyxLANiC8x9bEJsC5kxzxzuDPTClFbtHrTIqFZVN3uriLyt0iREGS24UyItkLTEjtvJEdvjxS9+kzFB1MiH/FtPYAsoUvTrNFKnBSwoiyCgZGi4IdW72v+n3xIq4Bh0lyd0oxeZurX+TlY/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905893; c=relaxed/simple;
	bh=SJ5Q/dlicCbTYrHX6sJWWJ2g3LbKEV999Wx3LTWQm+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhVzXXgq2CIjCed4N9BtgIdsG9LkJb/MYzVytJw8lsIhSJpJYQs/JYtp0wkMm8Ci0FWuEtqrl2iDh+c97ZRNdd2CM+ZF5FQhA0dbpTGuGQ+cHoTcMVPlIs2br06vXN7G5xTq7tDhCTqx2AnLitsHBDbVd1Vuifq8EvbjPqpeVLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFovZPxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFovZPxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FA7C4CED1;
	Fri,  7 Feb 2025 05:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738905893;
	bh=SJ5Q/dlicCbTYrHX6sJWWJ2g3LbKEV999Wx3LTWQm+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VFovZPxPL7PADYxm0BbwdlySis4V4EytliyDJk/TpSz0MWpHrbk6lAoINZQPWRPfb
	 k5tKMGIQjwPGj6EVuaF01emEHXyOHLRGJsjRMvpkTfBgC6qIi2uV+zYwBCg0oNI6hG
	 ZEaaR0xFoQ2hV/2rSTiXeHLP1pCPbdz0GlB8LsGdQLzxmPQEBBAs+x8zqJICFhd3TA
	 Q1oSe63j4InQLpP1ib4c3KSOHX05QD5DkLFSGHZwbtNuxOsrFUBO0R7zEGg5o6e3wh
	 FUqK0f4QgaxgQ6hy8Tb9J0S7pnOU1h282k4oaQYNoZZt6K0Gv987WlDhKwg4EDdGLv
	 INtom6oLaOjrw==
Date: Thu, 6 Feb 2025 21:24:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/27] xfs_db: add an rgresv command
Message-ID: <20250207052452.GU21808@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088264.2741033.15457962498927616155.stgit@frogsfrogsfrogs>
 <Z6WX53R-pw979lxG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WX53R-pw979lxG@infradead.org>

On Thu, Feb 06, 2025 at 09:19:35PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 02:52:36PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a command to dump rtgroup btree space reservations.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, for rthinreit=1 file systems a command to dump the availale
> freepace and the data device would also be really helpful.  But
> I guess that's more a thing for the kernel as an ioctl that works
> on the life file system.

We could report the reservations via the existing ag/rg/fs geometry
ioctls.

--D
