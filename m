Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661903BB670;
	Fri, 17 Jul 2026 06:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784270902; cv=none; b=tzZbwa4FDrbSpYgBYx4W0zV1y2FuGWem42iIt4suGAKUbw5S2mCHj+q6IO8B3BFvRmt10AEgt7dsH/ChCArxW7si5xHLJejKRXB/73lgtFZFbHcxJSTZb1meJtZDgph58USsojq42lSa9h7ChIySoS05x2fahGOnmPlb9jf1xDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784270902; c=relaxed/simple;
	bh=2SImvpveMUJl7WEI82HNsMIayq/rGPsDMRwKM/Fed1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LS4FJWujmeeiTaxnZwSDJeaw4oSEwWmP7wnj1X4TxUjOiDrktfbtk6rV3xfDLp+LRt81WfHVFo2SndDlmHGw0rc9kpgOlnmygkD/KlUALJTSkrftH8x1jQK89ySFp+ZR7i9LfC/UgcKBEsoPGhUloF7LYdTlcNqtbH83+czxANE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F29BE68AFE; Fri, 17 Jul 2026 08:48:07 +0200 (CEST)
Date: Fri, 17 Jul 2026 08:48:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  9b64ca202f:
 fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec 24.1% regression
Message-ID: <20260717064807.GA23992@lst.de>
References: <202607161601.867c143e-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202607161601.867c143e-lkp@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 16, 2026 at 09:13:19PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 24.1% regression of fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec on:
> 

This looks really odd.  While the patch adds a bit more computation,
that is very cheap shifting and masking.  So the only theory I have here
is that this somehow affects the inode data layout.  Can you re-run this
with the patch below applied on top of commit
9b64ca202f364a6bf8e19bdd20953bc2d776c67f ?

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 57192adc7744..319e83d4a087 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -15,6 +15,7 @@ struct xfs_dinode;
  */
 struct xfs_imap {
 	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
+	uint32_t	__im_pad;
 	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
 };
 
