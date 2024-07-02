Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3A34084E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719949981; cv=none; b=rbWeVZ6LGTliiiaF4tQshyy/6am2sP4ZuJplFFPrYjJVtrMOAhHwxn9AnCj6PkQLFFKhIWyB85VcJnq54Rnuz45d5j548Z4Racgq/64kdPbCrCh7oKaljwpGScKsAF0k8nGcKfzMQRyPow8fho+KJ1vTgFzumGRIfXdQAA1bGjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719949981; c=relaxed/simple;
	bh=AhKBgKkOKuwFCM0gCb1KZuuevY26btmfNxN9xL7fOew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lcjp3Or6sNNNIhrLVAOXqhZc4sM3jH4fS6UuYpDZYCUKy09YoOYsDZPtnEAdouOkk01Km1uMSYxlytq70VtX/Xt/IPqW4mmY2dh7czzc3YbpjBk+iZ4kVMlCTxYf0y+GXkHm8qItpsbOhQ5L/8KkbDoWs3OY+rEYHcohSRzuTJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YY5n4C7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YY5n4C7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FC1C116B1;
	Tue,  2 Jul 2024 19:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719949981;
	bh=AhKBgKkOKuwFCM0gCb1KZuuevY26btmfNxN9xL7fOew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YY5n4C7py1fibWcGQi0S09fcq/b6NFCtR6IiU1DuUqViv1RAr3ijmRsRKe6NWInaE
	 FlQ8ztmn9hmNPYoiJWrcHralBFKvxUMti5PXENfSaCLy19Q/09oId3DCiDf3t8+oFm
	 ZojozF/jaNmsw+L6emo2VgUYoJXw1pk27YvXnNsOOrVYLavqwfj5/dE5mMapZkCmMz
	 ME3FiWruiHyhujIHggNh9vW671Pn8ictehUCV6HWhp0T3HwuntlS+Q7x6RIItgosRY
	 0whvz4c1haitWgjj1b5mDhR/We39thYPoiFnMhsX6k3vJXdAH/9Zisxm123xS29pO4
	 n2ul+ezewffYQ==
Date: Tue, 2 Jul 2024 12:53:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs_io: create exchangerange command to test file
 range exchange ioctl
Message-ID: <20240702195300.GQ612460@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
 <171988116847.2006519.4476289388418471452.stgit@frogsfrogsfrogs>
 <20240702051510.GI22284@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702051510.GI22284@lst.de>

On Tue, Jul 02, 2024 at 07:15:10AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2024 at 05:55:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new xfs_Io command to make raw calls to the
> 
> s/xfs_Io/xfs_io/ ?
> 
> > +extern void		exchangerange_init(void);
> 
> No need for the extern.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Both fixed, thanks!

--D
