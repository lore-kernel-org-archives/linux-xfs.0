Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FA9824A3;
	Wed, 22 May 2024 14:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716387103; cv=none; b=SMBH6s8jEeBFfiC9GYAlUfhGWzlTLLRLzOa+99M/mcwDaAvn+uh/pCIcVxeClObUnrT47HbfUj8gdHd5zkNKXhZKcDm2ojy83Jae5HGG5HnwwhZUO1T8YjwqP0mueIn92IyCuq8G8dhUpWIuytaCpZcoVntGHp+svK5/WnMfDMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716387103; c=relaxed/simple;
	bh=G6CioGR1T6nYwLpMGws26Lml2/wV8jRNqdfuXs9RyFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecsKzZPFodkGTyhKQ/uYwRC+oS+qjhq+W1Agd5GDY1xB7ydZ0TOD3wMGehT5msZxFo/OQGgBAMWgtAzP54Ac/ngED6w2HF+uKaFHWi7GJs0zFCSTnGp45EK11eB6Uqqr0qiSyJvL/E6QfbAxtB50CbjCw8W+8fD4aMQSBHPaj+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmiK9CGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmiK9CGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305DFC32789;
	Wed, 22 May 2024 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716387102;
	bh=G6CioGR1T6nYwLpMGws26Lml2/wV8jRNqdfuXs9RyFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmiK9CGITyff1F3T237GOjN12HWy+YFJgGhvEjTEsB3YUvSYTgR+ghI6/8AMRcVfc
	 XRcm9L/aG7Rl9HMd/ZXu433HGq0/qTS0L9nO8QulnrMK4NGihiB6aoOLt2UasbdrFM
	 ehnWRzrI2Uk8FhGVs86kXBxAqgRg7K79oj7s6N90=
Date: Wed, 22 May 2024 16:11:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
	fred@cloudflare.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.1 01/24] xfs: write page faults in iomap are not
 buffered writes
Message-ID: <2024052207-curve-revered-b879@gregkh>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
 <2024050436-conceded-idealness-d2c5@gregkh>
 <CAOQ4uxhcFSPhnAfDxm-GQ8i-NmDonzLAq5npMh84EZxxr=qhjQ@mail.gmail.com>
 <CACzhbgSNe5amnMPEz8AYu3Z=qZRyKLFDvOtA_9wFGW9Bh-jg+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzhbgSNe5amnMPEz8AYu3Z=qZRyKLFDvOtA_9wFGW9Bh-jg+g@mail.gmail.com>

On Mon, May 06, 2024 at 10:52:16AM -0700, Leah Rumancik wrote:
> Ah my bad, I'll make sure to explicitly mention its been ACK'd by
> linux-xfs in the future.
> 
> Will send out a MAINTAINERS file patch as well.

Did that happen?

Anyway, this patch series breaks the build:

s/xfs/xfs_iomap.c: In function ‘xfs_iomap_inode_sequence’:
fs/xfs/xfs_iomap.c:58:27: error: ‘IOMAP_F_XATTR’ undeclared (first use in this function); did you mean ‘IOP_XATTR’?
   58 |         if (iomap_flags & IOMAP_F_XATTR)
      |                           ^~~~~~~~~~~~~
      |                           IOP_XATTR
fs/xfs/xfs_iomap.c:58:27: note: each undeclared identifier is reported only once for each function it appears in
fs/xfs/xfs_iomap.c: In function ‘xfs_iomap_valid’:
fs/xfs/xfs_iomap.c:74:21: error: ‘const struct iomap’ has no member named ‘validity_cookie’
   74 |         return iomap->validity_cookie ==
      |                     ^~
fs/xfs/xfs_iomap.c: At top level:
fs/xfs/xfs_iomap.c:79:10: error: ‘const struct iomap_page_ops’ has no member named ‘iomap_valid’
   79 |         .iomap_valid            = xfs_iomap_valid,
      |          ^~~~~~~~~~~
fs/xfs/xfs_iomap.c:79:35: error: positional initialization of field in ‘struct’ declared with ‘designated_init’ attribute [-Werror=designated-init]
   79 |         .iomap_valid            = xfs_iomap_valid,
      |                                   ^~~~~~~~~~~~~~~
fs/xfs/xfs_iomap.c:79:35: note: (near initialization for ‘xfs_iomap_page_ops’)
fs/xfs/xfs_iomap.c:79:35: error: invalid initializer
fs/xfs/xfs_iomap.c:79:35: note: (near initialization for ‘xfs_iomap_page_ops.<anonymous>’)
fs/xfs/xfs_iomap.c: In function ‘xfs_bmbt_to_iomap’:
fs/xfs/xfs_iomap.c:127:14: error: ‘struct iomap’ has no member named ‘validity_cookie’
  127 |         iomap->validity_cookie = sequence_cookie;
      |              ^~
fs/xfs/xfs_iomap.c: In function ‘xfs_xattr_iomap_begin’:
fs/xfs/xfs_iomap.c:1375:44: error: ‘IOMAP_F_XATTR’ undeclared (first use in this function); did you mean ‘IOP_XATTR’?
 1375 |         seq = xfs_iomap_inode_sequence(ip, IOMAP_F_XATTR);
      |                                            ^~~~~~~~~~~~~
      |                                            IOP_XATTR
fs/xfs/xfs_iomap.c:1382:1: error: control reaches end of non-void function [-Werror=return-type]
 1382 | }
      | ^
cc1: all warnings being treated as errors


Any chance you can rebase and resend it?

thanks,

greg k-h
