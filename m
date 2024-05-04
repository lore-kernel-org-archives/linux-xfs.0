Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ED2134AB;
	Sat,  4 May 2024 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714814184; cv=none; b=qP0bxYMCSXVQ+jz84r25jY3pMkgIqhMnrZoeATCgddQJOUcF/jen/IBArBdygJPEruSTCJaplqk1th639f83W/2BTufSNPnkdrLaLccTQpR8eidnuP4gS0uijpuf9kdpVMoKWEBKLHgoIWidChhUSJHMNrV3Bk/7eRynGxcC+oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714814184; c=relaxed/simple;
	bh=ikg6wPY7h1+cJ3RMPUtRLemoY/g7UgC/XZUDf7slQ5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7/6tIhGK4vaObGfJeY/zwTXUHpIQHzHJCGSFpYxXLfH5vNehETQXbTiJ5Xf4ZHA82jqwuqxH4LiGLproHmQuHlJSOKrmgbjXFLb8xB7jHTySYg6Tq/LmcMUiiNton3gFAhBk8DbER1FWKkGUg6tEmdGzbq9gjrrVfP92l6XY78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFmFSLSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFmFSLSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A13C072AA;
	Sat,  4 May 2024 09:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714814184;
	bh=ikg6wPY7h1+cJ3RMPUtRLemoY/g7UgC/XZUDf7slQ5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zFmFSLSxsARG+b1B2UT0YZDjgfGuxwGXr3B04mA08Zvrat+iPoXv87QKJN8YbjADq
	 5zvXU7AgSH4OhzkUwxlXHQhnvy9Y1+e8BFoA0NcPLOtnVoXIULF6TByxdsVf3Yq6fw
	 Y/rEaZaiMLPZKHPL3m5fKmCsQbPSK8Ays/GGHlrk=
Date: Sat, 4 May 2024 11:16:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com,
	chandan.babu@oracle.com, fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.1 01/24] xfs: write page faults in iomap are not
 buffered writes
Message-ID: <2024050436-conceded-idealness-d2c5@gregkh>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>

On Wed, May 01, 2024 at 11:40:49AM -0700, Leah Rumancik wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [ Upstream commit 118e021b4b66f758f8e8f21dc0e5e0a4c721e69e ]

Is this series "ok" to take?  I've lost track of who we should be taking
xfs stable patches from these days...

thanks,

greg k-h
