Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F1827AC3E;
	Mon, 21 Jul 2025 06:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753079648; cv=none; b=blNXMifJjzdiRPBCojxl2MOlsCibkFGthwpah2r7qUjNG8x3k+PIBwZAe6+X+O487ie/Qho0Rso229GOa5SRcJnB2nWDj1+j2T2uWLVPJeb2+FJsmRmA4XDZKDo6KpHHAOqdCcNhvYn9FZy/I4Rr5YJg9lg8I6GFIpm9DhSIKdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753079648; c=relaxed/simple;
	bh=2hikPorBUTfG5oonj2T3OsRDG5d/oNQ9Pawi3KKFJrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESoRr5ngF+pUSmnRzWPffSq6kofzdHbrUtemUBaYbEA2EO6uTTaTGj/Wuwsj3dO/7hViKlVCgjCxImj+lN/HlgPusEtrpND7lPWfk2qDXr1YxU6todRLA1VgRkXMLSVQ1b/Gl5K0WvcKYk4QG4R0vEocFronz05R6WXwE0MaWq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NLtB7ZgP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NLtB7ZgP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X02kqUfwhV7HgXwTN+DIIxEHxV9Vemu2dNXZxJ/Ker4=; b=NLtB7ZgPoFqHmVwtjbVrUSfxAc
	zQ+Te7/by80VISg3jTmzk7kew8hEm7y+P2BLulH0VF62ziHUoi3r4ZjENjzOlbaxmxtDkq/asz5mu
	FoKmDtapw66OlAw+NukAGOvP0rD1F0zZOq/fx2JTpcJuR8yMxmWbDHre3i3TpgcGtcNt5DfSHE2v9
	dYYCrBf4LF9MXGVc9GQFmoiQx11EPTKTfAuNFaDsJakyp0RaxGFyMZuqF1iYOYtz5xLjL+nG7agNp
	v3GqoDtxoWTHRgygxK3JS4YxAVUvZNs1AFQaLq3OKfAi7MDx+SkF+28UEmy2NNlZU6YCezeiNn8Tp
	tIJFBLyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1udk6A-0000000GNgV-25AF;
	Mon, 21 Jul 2025 06:34:06 +0000
Date: Sun, 20 Jul 2025 23:34:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cen zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	zhenghaoran154@gmail.com, r33s3n6@gmail.com, gality365@gmail.com,
	linux-xfs@vger.kernel.org
Subject: Re: [BUG] xfs: Assertion failed in xfs_iwalk_args triggered by
 XFS_IOC_INUMBERS
Message-ID: <aH3fXv5tlfGtzVD1@infradead.org>
References: <CAFRLqsU-k2GYx4D9HUmu+tSTvmMbY_ea9aYwE+2yvHwLP_+JDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRLqsU-k2GYx4D9HUmu+tSTvmMbY_ea9aYwE+2yvHwLP_+JDQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The patch below should fix the issue.  But I wonder if we should split
the flags a bit better to make things more obvious.

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c8c9b8d8309f..302efe54e2af 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -457,7 +457,8 @@ xfs_inumbers(
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
 	tp = xfs_trans_alloc_empty(breq->mp);
-	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino,
+			breq->flags & XFS_IBULK_SAME_AG,
 			xfs_inumbers_walk, breq->icount, &ic);
 	xfs_trans_cancel(tp);
 
