Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2761F18D
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708381032; cv=none; b=aRBOIuChCi07Mx1+Q8IVYvyPBTZQBlFWGr4ntllAyPpFO54nKJu+yHa2aQJ22D+04Ohmpq2Sn9LXuiLLWVNPGDlb+n6n3hfmohDxjqa6yD9UEJwGDhwW6EzDnL+Qz6ZIL3mbNwDfkii3MttzInhf98+Mj4tH82i4Wh9mFFS4Gnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708381032; c=relaxed/simple;
	bh=QqEECE7J9KzN04/aZSUGpwjB+2RUj7Mu2p+vi43L4Xo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CU4j4V9+Vz9mWIV6DOfY9nXcyYjeHfwMPKGGLDaEXMvClhfz3fQDgIi/02YAW8z7tiGDFDGTDEr99Tb57vFFNzSj/OiCtPEoT00peuaZbBTSBtru8HUkpRlTbQRZZ1U/uNyYDvgM8sumSYQtWqrU+MNzEEBp7pNmFqVaGdXtnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfYGMr7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfYGMr7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8ADC433F1;
	Mon, 19 Feb 2024 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708381032;
	bh=QqEECE7J9KzN04/aZSUGpwjB+2RUj7Mu2p+vi43L4Xo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GfYGMr7ZEJQfihP6Kke0iD18IunQdnASEZ7PBQ/W19M7ffbOlwzSXRyW5GVKIJq6t
	 +54VAIQ0s01xAJFyb0BhhFqE0hc7ynq2BqiLxpdd6zT3VZeImWHHt4foZEe9PBoKav
	 MVjo++pixnGQqJ+EwcR4IoDq0YW4W1TvhYdu1wLw=
Date: Mon, 19 Feb 2024 14:17:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, Hui Su
 <sh_def@163.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v4
Message-Id: <20240219141711.2c6d171069166f0923f49b14@linux-foundation.org>
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Feb 2024 07:27:08 +0100 Christoph Hellwig <hch@lst.de> wrote:

> this series refactors and simplifies the code in the xfs xfile
> abstraction, which is a thing layer on a kernel-use shmem file.
> 
> To do this is needs a slighly lower level exports from shmem.c,
> which I combined with improving an assert and documentation there.
> 
> As per the previous discussion this should probably be merged through
> the xfs tree.

The mm/ changes look OK to me.  Some are quite welcome!

Please proceed with the above merge plan.
