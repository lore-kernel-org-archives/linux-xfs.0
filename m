Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DXpYIuDo"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F6585;
	Wed, 13 Dec 2023 20:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m1NNmrmQD/DoZona1Vw/Txrz8Aj+03lv/Cf8YfFewP4=; b=DXpYIuDoyYqWaZBURKnODjYFq3
	YNy3vMNzoA3OXAskAASJZXuTZeMRAl8Rsl+oiB9tw+E5ff0sFA536fDnmpBuhupVi4qUuQJxmJ4kG
	uGjBIaWbk9L9gl0iEaOg0mzd5j3JyzaEhZeqlepKDVkfVLqLdgt9vZvjWBhHq7+EaN5FbiWk23ySN
	DkYaNHX74pM3yRNCBvYmXjUIywfziqQ+FsL3bztcw7J2BVN0SOSVsa70NkNQ8K5yxtLETKtVyTSyn
	tXLuzY/2v//YDnoIkHrpD8ETSC8IIC8COxMgaqgvTa7ia41a/ltdzn/T09l63ZF2For8pqUNopy78
	uPNthOog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDda4-00GjLC-1d;
	Thu, 14 Dec 2023 04:44:16 +0000
Date: Wed, 13 Dec 2023 20:44:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] generic/615: fix loop termination failures
Message-ID: <ZXqIIMHEab5gWWde@infradead.org>
References: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
 <170250687380.1363584.4078567385149829394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250687380.1363584.4078567385149829394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 13, 2023 at 02:34:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On 6.7-rc2, I've noticed that this test hangs unpredictably because the
> stat loop fails to exit.  While the kill $loop_pid command /should/ take
> care of it, it clearly isn't.
> 
> Set up an additional safety factor by checking for the existence of a
> sentinel flag before starting the loop body.  In bash, "[" is a builtin
> so the loop should run almost as tightly as it did before.

Loks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
