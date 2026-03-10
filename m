Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5BC28468E;
	Tue, 10 Mar 2026 05:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120472; cv=none; b=IebHSeLCSRnQ3G5lSsplawwx4dSW9KZSZc40e7tg1PMzNBkOwRxhenH1A5B9jaTvnFRqU5C0btqfQG1R5MPNXujGw5BaC0VTNFtZcJaapkgqytNPULIbuo0nkKL0LsFdTxg37yaHkZEHTdRZkMdJBHC1PFOPaVI4bOTFecH3sRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120472; c=relaxed/simple;
	bh=anH1pe6TUk7ae3GJ2eiwpGsBVXXD6aMEmUhsJEHTvns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmT7TJzekrCRqkAUbLKuGDLl9VjrcKvQrcCsvVpDzvmhcnZqwG7m7/8EXENla+Lng46wupFCS9wkAKqSAdu92K4xES5OGFNZM/CcruvbrNJvc4EgzLOp+dYVl4Dduamkho9m8C+dI1u8O1Z7qdWmMKC+zN2w6b1gLSxLaj5JsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phKkhOhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phKkhOhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC20C19423;
	Tue, 10 Mar 2026 05:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773120472;
	bh=anH1pe6TUk7ae3GJ2eiwpGsBVXXD6aMEmUhsJEHTvns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phKkhOhKeybGPIsZTHeoxD+QUtRrfzDIPpd+9ItXIVR3U7Bn4UCnRuGStiwvr6svW
	 1se/9q8g5Gta5L8mAZFp5GSPCW7h0d11bBuGDyi0ijmtAQNqt0EQUP4nq+uE4ViT03
	 V7vNU09AmLSYtuUqO71PU0Et1xy6osZyFiGoHVGq7hlEDw3wytd/HJdwIkEwBli5md
	 UGlXmbEZQqzvgUodrVVdPCDcrg/QZ3Czs80CeT3h6QU3RJ6E8Bg50lRJCMPQQB0jIq
	 fs9xONNDDWhjMJW9q5+DDXd4ZB22GCPcxZtkNq4l7O4d1zTSCSqvX61w3NrDo7MGjb
	 YYTsH7MnoH5Ag==
Date: Tue, 10 Mar 2026 16:27:46 +1100
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs: save ailp before dropping the AIL lock in
 push callbacks
Message-ID: <aa-r0lbQbh6YzKfg@dread>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-10-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-10-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:09PM +0000, Yuto Ohnuki wrote:
> In xfs_inode_item_push() and xfs_qm_dquot_logitem_push(), the AIL lock
> is dropped to perform buffer IO. Once the cluster buffer no longer
> protects the log item from reclaim, the log item may be freed by
> background reclaim or the dquot shrinker. The subsequent spin_lock()
> call dereferences lip->li_ailp, which is a use-after-free.
> 
> Fix this by saving the ailp pointer in a local variable while the AIL
> lock is held and the log item is guaranteed to be valid.
> 
> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
dgc@kernel.org
