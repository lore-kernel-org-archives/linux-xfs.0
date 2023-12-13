Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9802EB8
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 01:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOq4WJWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B9AC433C7;
	Wed, 13 Dec 2023 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702429471;
	bh=fEafDOjp+B/6TBxxkT2bPxOlvLbjn699AdJGZ/hK7WE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LOq4WJWw8+aJvLa/7dL3RZd+ruCOBs8RpxyjU9yY4eZX4fiKxWtSE7UPqkc9A/60c
	 NYGUCLJnsgao9yqFyVuuanxIoBzjrqKB5Xc8Uu5E1mdnlvusbVKl/Gx3L7P5H7cmx5
	 L4onlmf7eCXz9o983UmZuv/X5nAMzZljmeFpbrUAk7I/Ta9hom7geICA7wvvPWIKqc
	 Z94wcLQLAc0TJ5odsYZuqT5GJj7yiHN3l4T3bSqiIlep+EG261o/xoIfYdDekBe/b9
	 ztcIlgtbmoRmbSk3kP+kNOIovlvK/USFJmCOIMVYX/acFyEcEBmdHdCu3/D1WyDQDn
	 ft27Oi2MPEYcg==
Date: Tue, 12 Dec 2023 17:04:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: repair obviously broken inode modes
Message-ID: <20231213010430.GB361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
 <ZXFhuNaLx1C8yYV+@infradead.org>
 <20231211221926.GX361584@frogsfrogsfrogs>
 <ZXfxKX+eg/EeMeY1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXfxKX+eg/EeMeY1@infradead.org>

On Mon, Dec 11, 2023 at 09:35:37PM -0800, Christoph Hellwig wrote:
> On Mon, Dec 11, 2023 at 02:19:26PM -0800, Darrick J. Wong wrote:
> > block/char/special files... I guess those can just turn into zero length
> > regular files.
> 
> Ys, and I don't think that is much of a problem.
> 
> > Would this NAK remain even if there were external corroborating
> > evidence?
> > 
> > For example, what if we read the dirents out of the first directory
> > block, seek out parent pointers in the alleged children, and confirm a
> > 1:1 match between the alleged dirents and pptrs?  Unprivileged userspace
> > can certain create a regular file N that looks like a dirent block, but
> > it cannot create dangling pptrs back to N to trick the verification
> > algorithm.
> 
> That does look like I a good enough evinde as you said userspace can't
> fake up the parent pointer.

Yeah, and for non-dirs, we /could/ just scan all the directory entries
to see if we come up with any hits for the inode whose mode we do not
know; the ftype will help us set that back.

--D
