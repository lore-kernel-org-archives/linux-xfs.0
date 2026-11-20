Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795213214;
	b=M6rBDEUSnjcPRas9YA5LXQBclqLdINidPJQ2V9APj09B1mjIms2eCxiGed0uDq6BG1M6
	 baoH7WtMDImXXsvItl/ZVIKuXvwDLY3eik3CttrZclxT8metUarjSIZy0A//XS5eAU61k
	 dB103ux101DIS+vPkfCLQgVnyIrGAzYgvMJ/OAbaJHgoYhvlF7Ita3lT8lNT+hAmaF636
	 n42fJ5oqKeoabmZ3L+QZyBbqareD34Oll9Iogud+98m7LQ0YYieMHtFP8929LC3A/jPxI
	 hYp/nNT0Tyb+lMbpJFRTVO5Ow1VgDiEUBeMEXJsvp19IuZ9McRJx4ZVGjoOshxjP3UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795213214;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Aq8c5jMV6FAXyr7m5r03HEVCZDhHL41cwgsujaioS6A=;
	b=49EeBsijQJjAxJSBoAaRP3bK95kkOE2Iq4r+VTfn9QDQ5BTIV3xKdcEhWVFbhxA2ZWB7
	 bZD3n6sHJOT518wYBixXDc6oWE9XJd7S5LS8rHDiRk38lF5/waG34dmC9hgfe17ZZY9S0
	 iRA6n0KVo67uas8V7gnKX7uK9PYmP8XlODCKJiJV0omHW8BxQ2WWPd5vX3B/HelJ/c5Ju
	 rONWfZzmilkK9v4EF5Aw8R6b8A4ovxaojmHvtwBiFXRSXzHTPYEL8/n1bm3GHPwsmfCdk
	 bN0792p+Ekh9EMHBbMrGlVKqn8tZR1wHsn8sNDMIGswPWt+enpKM4GHvXfc/o/yoatA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mROE1RDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C6606A6BD;
	Fri, 20 Nov 2026 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mROE1RDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A981F000D0;
	Fri, 20 Nov 2026 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795213213;
	bh=Aq8c5jMV6FAXyr7m5r03HEVCZDhHL41cwgsujaioS6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mROE1RDF4XR/10ikQZwTB7UauvDH8Mr0dtNAipdw8X4FBhIUtl4UuLN1CK6fWMrvA
	 S6GnDbxs18Gpd9S+N167jEN6pdhS1mHG16PUjB8K1WV6xmBNbQrsVM3FReCSvZ9j1P
	 ghEnvSdOgS5O2d5+USYeir0mVGqjfa8uecN4PpOIrF1TBwSv7Mczx7RFXRcYU0tNWs
	 Iw+TgsABMdafm2FfaPqUnqKVmigWAcpU8qcKWlnbpj2KHLKtry+JPYVirQVxnF0R8F
	 OldD5aP2DlLdJbIkvBTArvseERJ/s2ZYpD0bpeZ9WhZ2TXWU/1YsQ6/EeqWciLHfhX
	 B/zHscYkajU8w==
Date: Fri, 20 Nov 2026 22:20:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>,
	fsverity <fsverity@lists.linux.dev>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>,
	linux-xfs <linux-xfs@vger.kernel.org>, dsterba@suse.com,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	chao@kernel.org, jaegeuk@kernel.org, viro@zeniv.linux.org.uk,
	Boris Burkov <boris@bur.io>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 2/7] fs: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Message-ID: <20261120222011.GC3048696@google.com>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-3-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120155032.187246-3-aalbersh@kernel.org>

On Fri, Nov 20, 2026 at 04:50:24PM +0100, Andrey Albershteyn wrote:
> The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
> Filesystems could return verity status with GETFLAGS, attempting to then
> pass FS_VERITY_FL to SETFLAGS is not allowed.
> 
> The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
> however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
> doesn't work on BTRFS for fsverity inodes.
> 
> Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
> no-op. The file_get/setattr() path is fine here as this flag is cleared
> right before fileattr_set_prepare(). The future fsverity support in XFS
> would also need it.

The commit message should explicitly state that this changes behavior
not just in the get-modify-set case on btrfs, but also makes
FS_VERITY_FL be silently ignored if it's attempted to be set on a file
that didn't have it before.  I guess that behavior is okay since ext4
and f2fs do that, but we should be intentional about it.

- Eric
