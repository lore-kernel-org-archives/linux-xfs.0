Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC238B;
	Thu, 12 Jun 2025 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749750458; cv=none; b=bxlWRq2AW5gN+XWe3eq+S91w9UhouMYnnCqW/IyOxdLBBXx3Kiwqp65BSVGf75hTKOWNNIqM5s/WXcS7KE0W06LlcEXM7vrLuTEjt/K3hU6UghZQ24wN4tyPNRK9kGIg6WJid/JyBkpeZvXmum2zn7UNyaLU0y+6lh45r8KbT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749750458; c=relaxed/simple;
	bh=I0MWwy01kc71VyFwu5AedVAUVllM9vfvOAklw7dP7wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAPpUkci17WvGaqp2j8gvxr+vn22QIFJMdDYiHb+rbFZGsjP2TR/CmCGeAsw5aGYlBbCgNmAm7nwZkbsdwEeZvtJOo3RlRK2n00oortMd1cdNt0cdf15WbVHZGuz08zD8FlB/qYjGHhh2D3qZ/ouX0zXlnqRdBdKS5/NKiI6PTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLGwxmfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLGwxmfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A2DC4CEEA;
	Thu, 12 Jun 2025 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749750458;
	bh=I0MWwy01kc71VyFwu5AedVAUVllM9vfvOAklw7dP7wA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLGwxmfmI2BUsKkBdErlRCGI0VO9aB3F5JD41Ho3XD6xKL4KZaDZNc96EFZjjToOZ
	 A+OT5IiFnnvRWuMwEYXsQqSKzCa9BF81+RjVdJCNrqTljjp5U3rTS25igXijnKmDcG
	 wXsvFwV3MqeG+1cemSKmixkeKgw6zwFnqHtRVjuwnDDkQraWqlzXySItICdccZk2gp
	 SNbd2sNEb8bexswT5is5fHAW7+FWy+4WM1A2WqeTz7cgrnQQVJrFM47oGgIX0BufHF
	 o3EAH8+JQ5TwMmoppA2yn2oMOfpK0dntLtd4LXhC+weueIp3YAtkyrpjOlGyWz4UbX
	 VGvULMhBewKkw==
Date: Thu, 12 Jun 2025 10:47:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250612174737.GM6179@frogsfrogsfrogs>
References: <20250612131021.114e6ec8@batman.local.home>
 <20250612131651.546936be@batman.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612131651.546936be@batman.local.home>

On Thu, Jun 12, 2025 at 01:16:51PM -0400, Steven Rostedt wrote:
> I also found events: xfs_metadir_link and xfs_metadir_start_link are
> defined in fs/xfs/libxfs/xfs_metadir.c in a #ifndef __KERNEL__ section.
> 
> Are these events ever used? Why are they called in !__KERNEL__ code?

libxfs is shared with userspace, and xfs_repair uses them to relink old
quota files.

--D

> -- Steve
