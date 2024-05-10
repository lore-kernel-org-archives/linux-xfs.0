Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036F717108E
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715353859; cv=none; b=cosk4tX2I8SiUvPyQcfl0pO6a3KZO2ZqN8CFgjk9RPUi1MJHiCkwECKuUbCRqsh/jDt1lfXcO7TLKGXxddTqXYPPN2zPoKe3s8Kx/IRmXx4cAD4ZJ4cej/fUxD3Xgb1LrEcfg9Amqg31OLd95BjjXYUukOUIQkjsmQdErxCz3Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715353859; c=relaxed/simple;
	bh=qg3i762gXkPTkLqzxd/64MAf2quEhO3mZPLfRnxz0dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRldPxx/VqEGXwaV4Y4jhrXTV+ebi+v0aajca9z7LGO6Y132x1xZdB/2OxpPareYlxDggT4A8/lhwABA42Ut8ztlK/yXPnMz8iOU15T1tZJfwn95RgVRG+ssNQ+5/N1PfckJqjMSuIdkr9v/IuxU/wysYbJU2/ST4t86X3cBH3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hgHo4cMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hgHo4cMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C73C2BBFC;
	Fri, 10 May 2024 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715353858;
	bh=qg3i762gXkPTkLqzxd/64MAf2quEhO3mZPLfRnxz0dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hgHo4cMhV5+qdzAydTAUAnyjRgGCWxbsGhgSLO99IRK6eZ+J7RDpcUvzBinZ7bj/F
	 MyZChlGnOX4gjvuE0/mY7qZu7P20iSC2SrH+blUJl59PaXh2jO50zsyRy5+LZ78izZ
	 CFiMwFmYASboYyUk+XZjmdsppFmqRU1BVQvVywlzzAtSi9AOkE0JacAkoLG+1FWK8K
	 XekqXuC5CQFuwNcEZT/VIvXvKLQ1qNfgDm6wkg17tKhPzNEuGhwBrPxpmDz94iD7bJ
	 bCB/xHZk194kL1LGT5Gzw7Id8l/5/PHPlx6f1/XdPxF6Xfz3jubq+5/Y+9JwSg41fJ
	 yBj9By3rop52Q==
Date: Fri, 10 May 2024 08:10:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <20240510151057.GW360919@frogsfrogsfrogs>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
 <Zj2pevC1NuYNCnn7@infradead.org>
 <oxflz6mkbp3xxk3nmxkhb3wunqmaxtjyxvyjkog5xu2eknalcd@p2fwn55jdhdh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oxflz6mkbp3xxk3nmxkhb3wunqmaxtjyxvyjkog5xu2eknalcd@p2fwn55jdhdh>

On Fri, May 10, 2024 at 11:50:28AM +0200, Andrey Albershteyn wrote:
> On 2024-05-09 21:58:34, Christoph Hellwig wrote:
> > On Thu, May 09, 2024 at 05:15:00PM +0200, Andrey Albershteyn wrote:
> > > XFS has project quotas which could be attached to a directory. All
> > > new inodes in these directories inherit project ID.
> > > 
> > > The project is created from userspace by opening and calling
> > > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > > files such as FIFO, SOCK, BLK etc. as opening them return special
> > > inode from VFS. Therefore, some inodes are left with empty project
> > > ID.
> > > 
> > > This patch adds new XFS ioctl which allows userspace, such as
> > > xfs_quota, to set project ID on special files. This will let
> > > xfs_quota set ID on all inodes and also reset it when project is
> > > removed.
> > 
> > Having these ioctls in XFS while the non-AT ones are in the VFS feels
> > really odd.  What is the reason to make them XFS-specific?
> > 
> 
> I just don't see other uses for these in other fs, and in xfs it's
> just for project quota. So, I put them in XFS. But based on other
> feedback I will move them to VFS.

Yeah, ext4 has project quota now too. ;)

--D

> -- 
> - Andrey
> 
> 
