Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3034537C0F6;
	Thu, 25 Jun 2026 07:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782373432; cv=none; b=ui1jmWR9e6mu96fQtxsc5NidcyQsdCpnsoaCYraVsrT61haejY2ZQGtE3aFiCi11QLefXZ2qxPiLngKS8iyv73kX/W703GI4WUp/7jzxMnVuJ2PuDcqDK7FCrXVQhKwN7ISXH4a3Ttw7k9wcpWP4TvAumBMEQjMwLQaqgyP/mB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782373432; c=relaxed/simple;
	bh=8Kpmnt6rJqz2IYsinEtKGnJv3u35NDT4GQMZZcBwYSk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EjugSoSJygLLcSUWFqEl8Se2RDY2SZbbvQjTmcBKQhqw6CH++80WsIwnwptVnj+lbI9PHzP9dsubDWJ58z6Gs6TfrR3Of7teJ0nrhEpt1vLZsqeEK1yl6fhPf4w4Lue6E/+XZ5EDvHtCGIAwVuH+hobt2nZ7CsYEbScy6yr3PyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h98B5iTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h98B5iTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B4B1F000E9;
	Thu, 25 Jun 2026 07:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373430;
	bh=KNUZd9Y0cWzbb8WiacdB9j4WHVQiN9fbNdDWbtWpD9w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=h98B5iTc/JTwSLIvhTpbNoVneCn2xTlBFmheR7eiwEPrC42gGG7SSnLPVEXW/LTsK
	 d+AgQ/JiHxywcwAQG8vL0aBL2UNqQ47gvfL5BXrbs9GRnoqZiLUt/CUiXZNFC1jkaR
	 K9K5O4h2SkrcUgQAS4bP9CYwu7hyUBOcRIG3Au4Jx7CDoh1jAVRQxk2kX5zI1hM4/y
	 sgZCZC5J3vu5Z1Af4DxMF3vXUmAVxQbiydk80uNuo+z30wUNJLhgnZ4G4pU1ktoqNP
	 xNHK3Gk+ofOFf1n2nhTfEz/P+XTAXWp/2+AJ5ZuzEK0kfnv5CZCECINSEbKfdKEiSK
	 sN7BENl0wYk9A==
From: Christian Brauner <brauner@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
 Yuezhang Mo <yuezhang.mo@sony.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Gruenbacher <agruenba@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-block@vger.kernel.org, fuse-devel@lists.linux.dev, 
 gfs2@lists.linux.dev, ntfs3@lists.linux.dev
In-Reply-To: <20260624174228.2015893-1-willy@infradead.org>
References: <20260624174228.2015893-1-willy@infradead.org>
Subject: Re: [PATCH] iomap: Remove FGP_NOFS from iomap_get_folio()
Message-Id: <20260625-anwesen-allumfassend-konfrontieren-769e406acb07@brauner>
Date: Thu, 25 Jun 2026 09:43:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8Kpmnt6rJqz2IYsinEtKGnJv3u35NDT4GQMZZcBwYSk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZ3DGSWK8/NXu6nd7dLJ/Fz5nLfLakrMo7u8llUf7yY
 +G/fVnXdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk4SHDXxEXT92oXWt/97xd
 8r9XMSR/1/EFi16v1nn1SNL8spRLjxYjw6KnRltcdqo4RU5dbP1Q7kVdm5x/M0+97at7Rve2PGT
 awAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 24 Jun 2026 18:42:26 +0100, Matthew Wilcox (Oracle) wrote:
> iomap: Remove FGP_NOFS from iomap_get_folio()

Moving into -next so we see fallout...

---

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

[1/1] iomap: Remove FGP_NOFS from iomap_get_folio()
      https://git.kernel.org/vfs/vfs/c/ec17795fb797

