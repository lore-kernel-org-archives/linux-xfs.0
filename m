Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742D3FFAC6;
	Thu, 30 Jul 2026 10:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407641; cv=none; b=WI652CfLy9j4q3KXKGNDy7blTTU1ZnVlX5P8KErA090H+lw1Y2066w6gCSCDfH0cdVBDVv1XG8WUFtQii/y3J/3xnyMjWn7iilM7vXuKjm8SVCZvemnfDm+iRhoJjJWmeD8ENGeIc4PohWo9FtcclSCsRyuRNaXtJ3urFqvf1pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407641; c=relaxed/simple;
	bh=/qEWh4oCOA7I23pBmnC5fLImPusmY15jC8pzm6AA3XM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ff0Tikck3LYwPt7MHH3BbkJMkL9of3uA6DkR+iUvAwkvHVUD1wbglrss5DZP1Lsi0S64H0krdFHb6BFFiJCCXhPXgC7TzF0WFRIZT66gbw6HNLB2ECosNsk819Ir3zUe2SD1ZGLYQ320xsSck0LlDe9pJ7GeAfwUZzjVS2gztK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiMJt017; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiMJt017"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3541F000E9;
	Thu, 30 Jul 2026 10:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407640;
	bh=ad4iIDWV6Q5imgNVqOlCRj0zi5i1zdNcu7P9bmUsQiI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kiMJt017TkTCkIw518vQbRUXqwkLkxsUzmVOWaYDvQdu4DT4OcPIEHBSHQCFdMOP/
	 woC2huEqfs6OWzZnC0XfSJx9zdPds5SEfvIA/C0xNyMd+4Kha/q2d2FOXypw0J8sKz
	 2pdqWgEuyTw5YDFsRWWNqPU/JlDSlTgw7/3izkNqzZzr1xAPZEWP8y+ypzeZ+/CFXP
	 ncpW/lAHH+41cGTohVmj2/8gU24JHK45SsoXVX34kII3ZTWbbdXMVGf4pvnv+2bsgq
	 CZgsG9QwgsgQyqC7y6+FFB9rRwVMj2iqE+73Yw+5C6Sy+RaJhizH+a8QAoR1oPjrJM
	 F/70qBESnGH0g==
From: Christian Brauner <brauner@kernel.org>
To: hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>, 
 linux-fsdevel@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Cc: changfengnan@bytedance.com, kbusch@kernel.org, 
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 libaokun@linux.alibaba.com, bfoster@redhat.com, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Subject: Re: (subset) [PATCH v5 00/22] iomap: convert to in-iter
 iomap_next() model
Message-Id: <20260730-habseligkeiten-adrett-axthieb-e619a48325ad@brauner>
Date: Thu, 30 Jul 2026 12:33:44 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3471; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/qEWh4oCOA7I23pBmnC5fLImPusmY15jC8pzm6AA3XM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRla0xebzu9f67JQ+3D5u+Xcxk/EcpS7tp/aEWd3Zm6x
 umV/hYSHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO58J3hf47f0j8RFqKWR+Yu
 evJ689Ja9czSvzeWHTfbdfJTstGuoO8MfwVOeCziWN+8gJunk+vDvkOzK++lSK4/K3D0lq1A2pW
 TSgwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 29 Jul 2026 12:27:15 -0700, Joanne Koong wrote:
> iomap: convert to in-iter iomap_next() model
> 
> This series implements a suggestion by Christoph for finishing the conversion
> of iomap to an iterator model. This revives Matthew's previous RFC [1], which
> had the same intention.
> 
> Every iomap operation currently drives its iteration through a struct
> iomap_ops, which contains two callbacks, ->iomap_begin() and ->iomap_end().
> iomap_iter() only ever sees these as pointers, so every step of every
> iteration is an indirect call, including on the hottest paths.
> 
> [...]

Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap

[01/22] iomap: release the folio batch on iomap callback failures
        https://git.kernel.org/vfs/vfs/c/c02d8298c979
[02/22] iomap: split iomap_iter() logic into iomap_iter_next()
        https://git.kernel.org/vfs/vfs/c/78c9e6b07ffe
[03/22] iomap: decouple simple direct I/O reads from iomap_dio_rw
        https://git.kernel.org/vfs/vfs/c/59389c7d3068
[04/22] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
        https://git.kernel.org/vfs/vfs/c/98aa16d184b7
[05/22] iomap: add ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/e93eeed8ce74
[06/22] xfs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/c807f6c9de95
[07/22] btrfs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/8a5cf58dc6c6
[08/22] ntfs3: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/2d53882bcb18
[09/22] ntfs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/4d9ea94adc0d
[10/22] ext4: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/e85fe93027cf
[11/22] erofs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/9b0cef67d4e0
[12/22] zonefs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/4b9de085c9a2
[13/22] ext2: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/cfcfc6724b0a
[14/22] block: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/cb372ea04331
[15/22] f2fs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/c034d0d0bcd0
[16/22] gfs2: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/1096941fd797
[17/22] hpfs: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/7e8aad7196b1
[18/22] fuse: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/a9032fd59a40
[19/22] exfat: convert iomap ops to ->iomap_next()
        https://git.kernel.org/vfs/vfs/c/332f88127cfa
[20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
        https://git.kernel.org/vfs/vfs/c/0210c4ba2547

