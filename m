Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A27329C60
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760630382; cv=none; b=UVIEo7WlPxoNCr8+xVL91Pj3BjqP/jsKFnMeoCzq2vGLa8QFA9wI0oFnPaKOCRMsoHK02I/vj7lD2MBjLpI9Radk3LvLGrY2Q2Vk6keQS+GbQyvB1limUYLK5JqisZ6VZEFP4VC8C2IYsPxuBHFdkug8T6g0oeyzCtqLJL52VD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760630382; c=relaxed/simple;
	bh=+g2I8tsu8n1lkpWRJ3NAFHcqozteWFOHRlWNvFcwfO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdLWi6atx7aQdj71gNDf71iH+WtI57hFp/6tpWIFC6Zj83EZVRsVoj2lDSgeHm2VtBgtMsthaCMvNw0dWrnfavRCCnl86/U42+zj5yac1RNL0IWRJwCEimhdvMmCO2X9dpBhw0olng7O9BjHZfqXLIp+16Mpp23Gdyb/usEPGLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjpZtte/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjpZtte/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EBBC4CEF1;
	Thu, 16 Oct 2025 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760630382;
	bh=+g2I8tsu8n1lkpWRJ3NAFHcqozteWFOHRlWNvFcwfO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fjpZtte/qYHeQg1HcxiVu4NfnvI6mLXAf+KjgK4buCJ749gkMDE3WTTG/si3H4Szu
	 ac9AT0N62af9NJXjEX8SwXwuFpaH0WWBM0ZRrPlsTjrltX510xXF0JlwbwExjCSZxG
	 ffSnnxqnS4HWk/BmpGwwEYaCBsK+T21Q9q+jR9K2wL3nhWkFks/aoltlcystFaV6EQ
	 Vf3qpgQdq9BMCL0tWKssXUXchpOpuvnGk2ifx8RflDRvXTz7PxfZ+iO3sNffb+w3el
	 IoZH3wo6vSizvYe60vRBgpw8o5dKHdlrNeG5auf8hoSLOcuEYoe8wDAYSltI8GVLn1
	 eGzRrVa+LUiOQ==
Date: Thu, 16 Oct 2025 08:59:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
Message-ID: <20251016155941.GA3356773@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-18-hch@lst.de>
 <20251015212707.GM2591640@frogsfrogsfrogs>
 <20251016042348.GC29822@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016042348.GC29822@lst.de>

On Thu, Oct 16, 2025 at 06:23:48AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 15, 2025 at 02:27:07PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 13, 2025 at 11:48:18AM +0900, Christoph Hellwig wrote:
> > > xfs_qm_vop_dqalloc only needs the (exclusive) ilock for attaching dquots
> > > to the inode if not done so yet.  All the other locks don't touch the inode
> > > and don't need the ilock - the i_rwsem / iolock protects against changes
> > > to the IDs while we are in a method, and the ilock would not help because
> > > dropping it for the dqget calls would be racy anyway.
> > 
> > ...and I guess we no longer detach dquots from live inodes now, so we
> > really only need ILOCK_EXCL to prevent multiple threads from trying to
> > allocate and attach a new xfs_dquot object to the same inode, right?
> 
> Yes.

I wonder then, if there /were/ two threads racing to dqattach the same
inode, won't the radix_tree_insert return EEXIST, preventing us
from exposing two dquot for the same id because xfs_qm_dqget will just
loop again?

[Though looking at that xfs_qm_dqget -> xfs_qm_dqget_cache_insert ->
radix_tree_insert sequence, it looks like we can also restart
indefinitely on other errors like ENOMEM.]

--D

> > Changing the i_dquot pointers (aka chown/chproj) is what's coordinated
> > under the iolock, right?
> 
> Yes.  i_rwsem in the VFS to be specific, but they are the same actual
> lock.
> 
> 
