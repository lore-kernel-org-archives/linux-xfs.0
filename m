Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x6k2fRWa"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DD695
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c3TDJYjCq+PSxvmhPnZXGO2rIfNqo6rz9WGkD1SpvT8=; b=x6k2fRWacUoYruj4neadTyL/Z2
	aTpwp4kMKOZ34nug0Gmb7hoViRBzeLOtpeOXQ2JfIJuArpy/SNOrFdLZYykKuoRtNl5NGRDJU0Xxd
	+jRD/WuAzxOgsGV+vIXOvsVoYq8XQH8L/8mkIw66x/+6mF14Wo62NHRyKngz9++2Hxn3/FeKXDHTg
	UAf5u1CXaKKXtdfQ82dQIJoaOoJodQ8hLm0toDJNRW5+UyS+6hViuPsdBgvkJN40dqM+/mS4/dNDN
	97gcx2ajMbpzQV7mzOIa0nImnZ/o0H9KNWszHsVRdmCetwkOp34wL5RWWq/TvxDKSOzUJQ1BY7GnP
	eUGrsjNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0kP-002zpz-2X;
	Mon, 04 Dec 2023 04:39:57 +0000
Date: Sun, 3 Dec 2023 20:39:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: zap broken inode forks
Message-ID: <ZW1YHT4o0WI1F/3U@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927504.2771142.15805044109521081838.stgit@frogsfrogsfrogs>
 <ZWgTSyc4grcWG9L7@infradead.org>
 <20231130210858.GN361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130210858.GN361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 01:08:58PM -0800, Darrick J. Wong wrote:
> So I think we can grab the inode in the same transaction as the inode
> core repairs.  Nobody else should even be able to see that inode, so it
> should be safe to grab i_rwsem before committing the transaction.  Even
> if I have to use trylock in a loop to make lockdep happy.

Hmm, I though more of an inode flag that makes access to the inode
outside of the scrubbe return -EIO.  I can also warm up to the idea of
having all inodes that are broken in some way in lost+found..

