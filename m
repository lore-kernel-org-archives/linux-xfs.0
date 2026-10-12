Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB63C34F24E;
	Mon, 12 Oct 2026 14:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815133; cv=none; b=f80uG/3wjVbtIAJ0yTFKvfes9e7yDWVgqAd3pj5ze5lIzVBxBUQiPhk6A5IPDnQN2gC/Xc6+GJQsARy7TmMc59c1K8UiEXC+Wk9YQOc0K3Xi2z8DYmYBRvbWguNXhH/0EM6+3OqoMCfFYFAFNmNxi6M740qtqzw5SZT2O3AjZ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815133; c=relaxed/simple;
	bh=CB5K1aNtrorexA/JdeWaL5lEgFC4gzph3QWPwtcKpcg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QSuwscav/8WQekLZxoZiCuMfl6JwSy//V3MauOmgwxSN2IOUV6SZZ5RwW4M+WKTyfrfqlnfUfIqCP2DZJMAeDeiMN1Lv4Yl3vfUBQp693JMpfasoMJMtv5iXwa2kIFDIYALzKIOxHc2B3D9g5QQQZhguaAy2Qzaxh5l3FaQjR7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtuCoNhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtuCoNhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D351F0089C;
	Mon, 12 Oct 2026 14:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815132;
	bh=wPVH+ldGDfqUbS8gIISm626Z1jh5SZOobA1gnB3ErGQ=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=KtuCoNhPkqT8F5evTqux2DuKCpAAdrbX5fuohGhzxZBMxcCtZHQjn5CYXymL3Z3l3
	 5kEbXThVP6tzGqFFg7Y3mmlrypT6f46DH6EGMo9ALKmDWo2MtJPiTkPct/lHrw4Cij
	 Y01QoLOU2UkLEPyTmJcoU2CCMZdVkldegol1+8hyON9LAd8krKg+RzNwN0RBSfHeKn
	 wX/ifhYZA/KNlo2jEdB0k3x2yBbNlCLQcZAGWYMJ+X864aX3OVif5fhSamifTysBcx
	 Djq6xfFiAmtdGL9bs1TsW9dWHpwshAMYTjNhO0DzIwjVzw6MXAP5V/iLZzytQZTayI
	 RTon45nHTn1kA==
From: Christian Brauner <brauner@kernel.org>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
In-Reply-To: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
References: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
Subject: Re: [PATCH v4] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-Id: <20261012-wallung-heizanlage-begangen-5ebbb33cb59d@brauner>
Date: Mon, 12 Oct 2026 16:25:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Wed, 05 Aug 2026 07:29:51 +0930, Qu Wenruo wrote:
> [BUG]
> On the latest development branch, btrfs with 8K block size on 4K page
> sized systems will fail all test cases that run fsstress.
> 
> One very short example would be:
> 
>  # $fsstress -n 4 -d $mnt -s 1785675805 -v
>  0/0: dwrite - no filename
>  0/1: creat f0 x:0 0 0
>  0/1: creat add id=0,parent=-1
>  0/2: write dontcache f0[259 1 0 0 0 0] [816411,3620] 0
>  0/3: dread - xfsctl(XFS_IOC_DIOINFO) f0[259 1 0 0 32 820031] return 25, fallback to stat()
>  0/3: dread f0[259 1 0 0 32 820031] [483328,81920] 0
> 
> [...]

Applied to the vfs-7.4.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.iomap

[1/1] iomap: follow the alignment requirement for iomap_dio_hole_iter()
      https://git.kernel.org/vfs/vfs/c/c156c9afe59b

