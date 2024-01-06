Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB87E541
	for <linux-xfs@vger.kernel.org>; Sat,  6 Jan 2024 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O36C5j0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A020C433C8;
	Sat,  6 Jan 2024 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704567319;
	bh=UWFbEyo02qZ86WOLZbv/cziVowkxnEvfniUZLkHxfmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O36C5j0b+ICe9g0DcWYNvveHdnODtN3inJQLLkfAugzcxO8eCePf/1z+PPgWSyy6Y
	 unTAX16d61hKWb0Z8ESv7/roqho2EMsKk/O3Qw/T+WRUEAUfWWKapVBOsF2RmqejOo
	 8wvb96LG+dCRlIKqD5tCnNreV8WQ/L2cHqio89kQ0s2u5+K9l+pjsoWRrAnQawrKMI
	 VzJ/qNlzHfQz0Ht+5f0zeynvSusaTPzRKD/Jr70ZZATIdP/5PvwBX5q5qDlvjiNp2e
	 IBSDtAx+uqbzJNmzz3O7LCGs4xNP8wz/eCFhYOjmUoDzNYY+lj8N5NyosMvknom1FZ
	 QCvFOE/ScM6dA==
Date: Sat, 6 Jan 2024 10:55:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <20240106185518.GN361584@frogsfrogsfrogs>
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

Well in theory some day Dave might come back with his libaio patches for
xfsprogs.  After this much time it's a fair question if we'd be better
off aiming for io_uring. <shrug>

https://lore.kernel.org/linux-xfs/20201015072155.1631135-1-david@fromorbit.com/

--D
