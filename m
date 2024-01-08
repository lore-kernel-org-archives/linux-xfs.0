Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B065465E
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jan 2024 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHal+sLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C82C433C8;
	Mon,  8 Jan 2024 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704733933;
	bh=ZctbNcUDGR6VPL9Rfez2RXP1UwEGnOg5HKkM+ocAMxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHal+sLjiRTjmkezWPmBcys29PEOAdFOp2daKZJw5lgwA/VDz3Fc8F7SecN1WbCib
	 JW/2saVRQ77+C3+RoLATDRM8ydV0jCCLKUUpJFZQD2cWFaWTcBuIydq2iYEGZYkfo4
	 nRlxyArXbHV8tkKbP+2hrKC8NQ9X5DIR1YQZdF8cU4ZO45n5plTeSptUewzukyHl1H
	 joG1KutROm5B5ilC+lL3UduJW9hca0OCLJQGzZ9k7s6Hn73Lf2VC1kCpzVK4dr27f9
	 /sjuCKnmvjnMgX99tz4YdYRbQWVQR7IfchQHrrdeMUHZ0EuXxR8WCYma1eSzOyU26h
	 I8dEBL6WrDJQA==
Date: Mon, 8 Jan 2024 09:12:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <20240108171213.GA723010@frogsfrogsfrogs>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
 <170404835229.1753315.13978723246161515244.stgit@frogsfrogsfrogs>
 <ZZeZXVguVfGz+wyD@infradead.org>
 <20240106013316.GL361584@frogsfrogsfrogs>
 <ZZj2OZooCt8QWnTB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZj2OZooCt8QWnTB@infradead.org>

On Fri, Jan 05, 2024 at 10:42:01PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 05, 2024 at 05:33:16PM -0800, Darrick J. Wong wrote:
> > (Unless you want to sponsor a pwrite variant that actually does "append
> > and tell me where"? ;))
> 
> Damien and I have adding that on our TODO list (through io_uring) to
> better support zonefs and programming models like this one on regular
> files.
> 
> But I somehow doubt you'd want xfs_repair to depend on it..

Nope, not for a few years anyway. :)

--D
