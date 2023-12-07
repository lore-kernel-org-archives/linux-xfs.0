Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p9jJE2pZ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C9FD44
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BPkPrfmjnJBU/UKDjhNhuvsPCFbf09LNu/oeb8PkQ/4=; b=p9jJE2pZzI3vuPVBAe/AjrQEv2
	2j9H+W1va4mTFs7sr7ewLn274DNHiQfrx4J053zZd8CbiMCNDDIQH4dRCDDdQHw/wKcYVVwoqnrOR
	kaRBIhw9ZRApq+al4i7LFZ0FEcMOQhbjrT29u5ahZ7fxjt2dpAgC/6ukQZUNDjfsvEUdZKSoO2Kai
	Pk9hpz/JQjzryuIfQUgHObwkQgMFtzOWXcXALUo1u3zXF0P2DmIDjodMkjo1yI2KcMDkBLcPw71RN
	Oq8wz0rHD35i16n0Ffph8pqrVQyS/bs0XqdLXY1ACoKilXVhZJfpnKtWeUVIAkhwYVmW2q4AbNV08
	2sJ67j6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB78u-00BvEB-1X;
	Thu, 07 Dec 2023 05:41:48 +0000
Date: Wed, 6 Dec 2023 21:41:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: repair inode records
Message-ID: <ZXFbHDCxAkFq1OXT@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666171.1182270.14955183758137681010.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666171.1182270.14955183758137681010.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 06:42:44PM -0800, Darrick J. Wong wrote:
>  #define XFS_DFORK_DPTR(dip) \
> -	((char *)dip + xfs_dinode_size(dip->di_version))
> +	((void *)dip + xfs_dinode_size(dip->di_version))
>  #define XFS_DFORK_APTR(dip)	\
>  	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
>  #define XFS_DFORK_PTR(dip,w)	\

> +	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
>  		xchk_ino_set_corrupt(sc, ino);

This should be a prep patch.

Otherwise I'm still a bit worried about the symlink pointing to ?
and suspect we need a clear and documented strategy for things that
can change data for applications before doing something like that.

The rest looks good to me.

