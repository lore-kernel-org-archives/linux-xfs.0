Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BB863DF
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 06:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hw74Gx6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE275C433C7;
	Tue,  5 Dec 2023 06:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701756550;
	bh=UlSBErGQbp7zR5VzGjT1w0tgZMm2a/YcTUm8GuHNhAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hw74Gx6aCLm04YbhDW5Sc1rPeO5p2Q5dL4Pv2Tfy5ZGPfMbX81YCeMuWVBACZerNu
	 rmc4RSykwu1IMeMcREUS6hJNSoDjUJaxQDzVk0P0LGjTOqz8jiEZObv9GjWn/fcDMS
	 Z0PzOl5mcYwbCf+ZnrSx2UXSDI0iuAgzv4p5YU3CEJio3Kbv5LcfzE7XMnX8UbOiTr
	 fAQYosvGuqO5QHZlTJ+5MuQzAkfnSR6/XFEV7sXt+NHNEQfIrFrm2rjCpJxJAj+nTp
	 gIPX4gspORu08JXM0Srrcj0Ec50Q0LKILt7Z3bshTDOixom0XyDyP+c54xHtfvtsJ3
	 K3Z4dA0bfseqw==
Date: Mon, 4 Dec 2023 22:09:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: document what LARP means
Message-ID: <20231205060909.GN361584@frogsfrogsfrogs>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
 <170175456779.3910588.8343836136719400292.stgit@frogsfrogsfrogs>
 <20231205053842.GA30199@lst.de>
 <20231205055028.GL361584@frogsfrogsfrogs>
 <20231205055642.GA30465@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205055642.GA30465@lst.de>

On Tue, Dec 05, 2023 at 06:56:42AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 04, 2023 at 09:50:28PM -0800, Darrick J. Wong wrote:
> > How about these last couple of sentences?
> > 
> > /*
> >  * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
> >  * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
> >  * V5 filesystems.  As a result, the intermediate progress of all setxattr and
> >  * removexattr operations are tracked via the log and can be restarted during
> >  * recovery.  This is useful for testing xattr recovery prior to merging of the
> >  * parent pointer feature which requires it to maintain consistency, and may be
> >  * enabled for userspace xattrs in the future.
> >  */
> 
> Oooh.  So all the logged attrs work is preparation for parent pointers?
> That makes a whole lot of sense, but I've missed it so far.  Yes, the
> above comment is great.

Yep!  And that's coming in the year end megapatchbomb. :)

--D

> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
