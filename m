Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3801DA10C
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413217; cv=none; b=FRWOYn9tWOBc3RIlKo7OJWiFZpwWpDr5Gp1KDPEEtIjgvASFaDUJ6Wrn+PGyO0zUg3pBOGgsTs5BkIWLvrDzQPpuAAU+CtHq81Hhd8BiSEnSHULq+/GNAPFeFVTfdmLiCucc7JVj6DCQblMghzw4kgDoulnvirupiJQ+SpdlKiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413217; c=relaxed/simple;
	bh=qcMjWw4fX7jjWA19sZ1iLJuGrQdY1lwKigkjMhkOujo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CjCw93vNtyA1KQV5lqanw/AbZIPdigUkIk4TSib0dxPw+Y4qVCE3wDF3bu3iGTwDB+VDzs7N7RlcnNMcle+Ai3cGm3NPHB2U6CgQdcui5WK32UaTu8xFop76tE7PQtX+CR2R/T+6RzZ/YyV5AKJ140rYrD77XXSUHsg2J9aB9cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCRf1ETC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCRf1ETC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18558C4CED1;
	Thu,  5 Dec 2024 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733413216;
	bh=qcMjWw4fX7jjWA19sZ1iLJuGrQdY1lwKigkjMhkOujo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XCRf1ETCNi9T8Pw/BEvh7i5WPJIdMShz5h2slQdrpZujDMZp7mncnT/rW3DlRHMn6
	 I8QRunDxOFmI6/2yx3VtWKUyN83Bu6hSkEZJzFAjv5LjGvoFKWDJBrdXcIKBBmeovV
	 qcVLp8ZuHsJKdTFAKusVUT69nYUmXtF3WgQ1EdCSeSQyCKaSVNWnKvUeWqJGhQ+3ZC
	 y0jsbaYh1VrotRChP//0c6wus977c/xhfVarRXqWNWJIrTHc95xLwSlSRL6zm7QAHa
	 UXUxDUBt4YmOFPiR1acUoVXowNEPmw+igdKSAr2Y4tnrG56BpWF4NhEX9CGIEqay9e
	 qM2dAP4OObZWQ==
Date: Thu, 5 Dec 2024 07:40:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: 64k blocksize xfs can't be mounted
Message-ID: <20241205154015.GM7837@frogsfrogsfrogs>
References: <20241205152920.ptesvhhxvq2tcxif@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205152920.ptesvhhxvq2tcxif@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Dec 05, 2024 at 11:29:20PM +0800, Zorro Lang wrote:
> Hi,
> 
> Recently all my 64k blocksize xfs tests fail [1] on latest mainline
> linux (HEAD=feffde684ac29a3b7aec82d2df850fbdbdee55e4) with
> latest xfsprogs (for-next branch, HEAD=409477af). Do I miss something?

Most probably this:
https://lore.kernel.org/linux-xfs/Z0l5OezlOv7QGCeT@infradead.org/T/#m0e8676370031255c7b198565d34ae597cef908bc

--D

> Thanks,
> Zorro
> 
> [1]
> # mkfs.xfs -f -b size=65536 /dev/nvme0n1p5
> meta-data=/dev/nvme0n1p5         isize=512    agcount=4, agsize=61440 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0  
> data     =                       bsize=65536  blocks=245760, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=65536  blocks=32608, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> Discarding blocks...Done.
> 
> # mount -t xfs /dev/nvme0n1p5 /mnt/test
> mount: /mnt/xfstests/test: wrong fs type, bad option, bad superblock on /dev/nvme0n1p5, missing codepage or helper program, or other error.
>        dmesg(1) may have more information after failed mount system call.
> 
> # dmesg
> [  459.450856] XFS (nvme0n1p5): Sparse inode alignment (0) is invalid. 
> [  459.458090] XFS (nvme0n1p5): SB validate failed with error -22. 
> 
> 
