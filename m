Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B141AA3C5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 19:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722366116; cv=none; b=M4BAbH2ejnVe6KI3kQ5N2KYAtMRqNS8CEUGpQGVRV1WlDPrSYraVbrPSM8F9y0cgGFE4lkR2UP3rIMPDwz0eclehlGAJzn8y9QEZaXl2gZyglY0JHYbNMU5U0tFWAVyqfy9R7CbKeOhrU41QHernewEvZ8QwyPMNG0/FE1kWa4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722366116; c=relaxed/simple;
	bh=Q6dSRDAc1syYHrQ0hjokNVuaIori+jGRXzvM2ZFSh8Q=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsMAZsP6rM2O9I5M/1BRGgmwPxs5oYeZXAGWvRBiv7glbUHO19PbHVWV9WqNnKp7v2OpXXarXKPwg+ODlNp+xkVZdOrhnAn6o0zgEu9RV06LbfJ0+ypawE3QjlFneyQZNGHhNZ/Y92/Y7OrlgCVTy/nvT4+9ou+KG0ekVnVvhxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIv2y4Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIv2y4Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058BCC32782
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722366116;
	bh=Q6dSRDAc1syYHrQ0hjokNVuaIori+jGRXzvM2ZFSh8Q=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=jIv2y4GcKjkHIC3k3CHNyWKlUNyITxqYnxyiN/kiOMYH4FsOkJr3OHDRrYVbsOUDp
	 Qmun3D9F2F+azhVYOVf3Rh8wpDRKOG50XvYe8NOrvtbKAgQOqGt/i+MdgUniWTl3YH
	 3VWtNP1ftPa8vFz3f1+YhtOfMA+0YBxLjIwtRlM7GQ0ZtpluS083d75RHjsnvvnoPy
	 hPG3Z6PyIquvJLowgSSyA3SwwFAwVU8/pzmm28BKH3nHpBwdlWH3g7W3iMPB89hBhA
	 Q9xq6E6AgjzLwOEb0Yxn5ZakHbNgFbmsegHhEDp3Ktb9I6+JchSLCE3S865PpJUDcD
	 9Nhw8KhPFqyeQ==
Date: Tue, 30 Jul 2024 12:01:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs 6.9 .deb build broken on debian 12?
Message-ID: <20240730190155.GJ6352@frogsfrogsfrogs>
References: <20240730033627.GG6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730033627.GG6352@frogsfrogsfrogs>

On Mon, Jul 29, 2024 at 08:36:27PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Has anyone else tried to build xfsprogs 6.9 .deb packages on aarch64 on
> Debian 12 (gcc 12.2.0)?  About midway through I get:
> 
> aarch64-linux-gnu-gcc: internal compiler error: Segmentation fault signal terminated program cc1
> Please submit a full bug report, with preprocessed source (by using -freport-bug).
> See <file:///usr/share/doc/gcc-12/README.Bugs> for instructions.
> 
> Will try harder in the morning to sort this out if I have time.
> Strangely, the regular build completes just fine, so it's something
> about the debuild options that mucks things up.

Weird.  6.8 also doesn't build now, but it built successfully back in
May.  Fiddling around with build chroots and vms demonstrates that the
build works fine in a VM, just not in a schroot.  So I guess something
changed in qemu that broke gcc.  Sigh.

--D
