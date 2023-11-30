Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oG/TN4Cm"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2EEA3
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 00:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K9J6F17rr9CqUzEYDbsipxvHy7ZYuhTEZsrLhorPuuY=; b=oG/TN4CmA/42gK05CMGnVfbkx2
	R/XMmJo/4xIkx6smLME5vIAWDf+uOHeVIB1pcUSHYL6jsnowsT4ZT57LuMUJkeuLsyvC1sKbM6gqL
	DPLhO2Y5+Vwyp1AkQNkUUMwxJGIoNRlL3O7XV0BK5o9MI0F4QwViD4mx6qTqZdcdiNCa484V5VTes
	O9vGMp/xj8P+/A+2WpVewKlntRhvZLlEt2h3aJMN3RUFhJSn1mn3hadEdJIwtSw4iKuFV1Fl8M5xg
	PGH3QujbULWlnSmCirvejMX5QONiMbId50vFkCEy5SmkwiwTR0Kt+OmXaN20SQ3hPSQVmVuGo+LNG
	4ha9xyVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8c8B-00ABA3-0A;
	Thu, 30 Nov 2023 08:10:43 +0000
Date: Thu, 30 Nov 2023 00:10:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: use xfs_defer_finish_one to finish recovered
 work items
Message-ID: <ZWhDg3Vbj3/aA+Tj@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120322304.13206.5309817289433296873.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120322304.13206.5309817289433296873.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 12:27:03PM -0800, Darrick J. Wong wrote:
> While we're at it, dump xattr log items if the recovery fails with
> corruption errors like we do for the other intent items.

Normally I'd expect this as a split out prep patch.

> -	error = xfs_xattri_finish_update(attr, done_item);

As a follow on cleanup, xfs_xattri_finish_update could now be folded
into xfs_attr_finish_item, making the logic a littl simpler to follow.
Same for the other items.

Otherwise this looks good to me.
