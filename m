Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DB71F757B
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455533; cv=none; b=aoaz8e6eSMtfp/b3+V59TJuxY4aiGkTiYdQbpEBEDzPscjToCxOz49LYSbPhDkPu7rfN9ZtD6RH0NdJsTrn3VSOqweY8AodN2kheRX7hFmbrIZKJOEUdlZSln67xMDAhbgjlLwnpyZnql8YZHyi+/jIYnSmD34kkEE5qtUYs7G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455533; c=relaxed/simple;
	bh=jmcgRjtjU7jNzXQKhMksGee+5xpY9X5N6/+PTcBzHkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SM0RmC8zJ3JFx7LDbTUOp9jUFYc8EACbjyLb5b9om+wNcJ2al78i0SUGRtnjKxVUfQ8kc7HZH07vQJVAkDZxBrMAEbJjQZ3v4QpWgBR/KdvwRRaPL9uOUweG204lDOZTSjNCLeKQIEoQszAX83qKR49uqOG38vZO5vvRPvHQS1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4zjFdAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4zjFdAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E3EC4CED3;
	Tue, 17 Dec 2024 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734455533;
	bh=jmcgRjtjU7jNzXQKhMksGee+5xpY9X5N6/+PTcBzHkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r4zjFdAlrapms+/abyeFbJkrW2+YN8TOI9u53ZFRyIWF7imsQ3gBmnLpuhISSkird
	 oaa/nTRlyKFxjCBy7njngQX2HN/KiY49VBcafDULOPQd/MysBW0X+X5a0ZzgR/Yujx
	 ejI5aTQyaBwTVzUANqfQn+/HwFdaYXMEbBW3xnQMgXFgyFz/D6jspE1GDLOfLLMHQo
	 Xt2ufm6R46NEZnvLTGw3DgBIS+dQrJcyXQeqtx32Ggzaa1k4VlhotF4cQsQb4ArEO0
	 zPfdOskWMZTJlL19V5uKt2u4HGza0W6cqCvcRySZLHCKKY/4ZoAED8uezfQlQ4792p
	 sXJ/YTxATb97Q==
Date: Tue, 17 Dec 2024 09:12:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/43] xfs: add a max_open_zones mount option
Message-ID: <20241217171212.GK6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-41-hch@lst.de>
 <20241213225711.GA6678@frogsfrogsfrogs>
 <20241215061644.GD10855@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215061644.GD10855@lst.de>

On Sun, Dec 15, 2024 at 07:16:44AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 02:57:11PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:55:05AM +0100, Christoph Hellwig wrote:
> > > Allow limiting the number of open zones used below that exported by the
> > > device.  This is required to tune the number of write streams when zoned
> > > RT devices are used on conventional devices, and can be useful on zoned
> > > devices that support a very large number of open zones.
> > 
> > Can this be changed during a remount operation?  Do we have to
> > revalidate the value?
> 
> Right no it can't be changed during remount as there is no code added for
> it in xfs_fs_reconfigure.  If a strong use case to change it shows up
> we could support it, but it's going to require some nasty code especially
> for reducing the limit, so I'd rather not do it unless I have to.

Nah let's wait until someone actually gives us a use case.

--D
