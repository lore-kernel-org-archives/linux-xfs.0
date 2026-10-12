Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369AF32824B;
	Mon, 12 Oct 2026 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815132; cv=none; b=dc3ax3gIxsRxlq86WJErdpM3JfgYTv5/ds3g9HKvpJT6LwzLhdrGI6Nodl8KX0JWtfkUtLXjhFMohv/fa0NpIcFU3KhKyC5J+5zb/UKmdZXUWFkR47ufwKibVRfmlzNKUaMjRlbGkoNDXjr3ccc6jL/uhbQVrRSGTxdvljtAG8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815132; c=relaxed/simple;
	bh=rSb27zLdpu0dYHiznSvxveaV1ziAQuwRQHdiQPEcrPg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=leHLBLb+vXCL4vi6CZNqtDlkhS1HZd8oq6csHU/MdRi1yN88KUL3lYaInBBpTRI8dRZogR8h27hwmJAnZglTYwyW3aBa94siAA2yq28x2WcIWS8QAzRVIgdeYdoAs/c3Ux6o3UEPotEGn9lHpldw1Rzl1bTVQ6ELQbC9GuX1tj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HsEHvGOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HsEHvGOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76201F0089B;
	Mon, 12 Oct 2026 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815130;
	bh=mjEQR7BUyCacDd88k8LcDx+pGeS9YyLHTLECabn56ew=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=HsEHvGOLdNLNMk2ekkqfnbimIZtTFazE3X2Si695B0muhw/PzGvKqP3A5J6ZuAzNF
	 LAjghAXJhElYFUuAdhUCTbo4Qjag0MpvECSP92lMxOABK5smPyGLKfVkl36zIRbIyd
	 AyXIr+tcFX2N/thWxGZWc7H6kL7xTu7C6/RIb5fXsw4ILJxcwJiFNZ2B/XdoBES3UU
	 B0Ps5MlRbBXkKKzZqblXBe2f8hJsmW/p62EJPJNQPy+c4Xvxu/TtGOui01Fi4DNQDo
	 GqJWzJWVAKzzHcktQSPCkr/8e961uSm5F+sxJO2SAOEGwi/juK2vymTbAW7fTTw4IE
	 fyYVyTxzonySw==
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, 
 "Darrick J . Wong" <djwong@kernel.org>, 
 Joanne Koong <joannelkoong@gmail.com>, Brian Foster <bfoster@redhat.com>, 
 Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
 Hannes Reinecke <hare@suse.de>, Daniel Gomez <da.gomez@samsung.com>, 
 Pankaj Raghav <p.raghav@samsung.com>, Dave Chinner <dchinner@redhat.com>, 
 Andrea Parri <parri.andrea@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <cover.1790342457.git.parri.andrea@gmail.com>
References: <cover.1790342457.git.parri.andrea@gmail.com>
Subject: Re: [PATCH v3 0/4] iomap: fix error handling regressions
Message-Id: <20261012-puschen-bibliothek-normung-535ea9605a95@brauner>
Date: Mon, 12 Oct 2026 16:25:25 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Mon, 28 Sep 2026 10:48:05 +0200, Andrea Parri wrote:
> Fix three independent error handling regressions in iomap:
> 
>  - clear the writeback context after a failed ->writeback_submit() call,
>    preventing an already completed ioend from being submitted again;
>  - preserve an iomap iteration error when iomap_fiemap() has a pending
>    extent to emit; and
>  - preserve a direct I/O data path error when sub-block tail zeroing
>    succeeds.
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

[1/4] iomap: don't resubmit an ioend after ->writeback_submit() failed
      https://git.kernel.org/vfs/vfs/c/9646682717e6
[2/4] xfs: add an error tag to inject a ->writeback_submit() failure
      https://git.kernel.org/vfs/vfs/c/e50b5a3028d0
[3/4] iomap: don't lose a fiemap iteration error when emitting the last extent
      https://git.kernel.org/vfs/vfs/c/ec2874845c99
[4/4] iomap: don't lose a failed direct I/O bio's error when zeroing the tail
      https://git.kernel.org/vfs/vfs/c/750148e10873

