Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v3JHaO0X"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F218DCA
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=htgFqatAndqsYuGlGtX9etX8gjDd/NeTYBtedMlEaGE=; b=v3JHaO0XPsNaK/TxgWuc1QLUaY
	4w3S3uzGfZhBWrWwgT4S99hx2zH2JXRmMc9D/pV1N4LOOLehNkxiuRARwIkd8C7RuePUUr8wuWNfm
	c+BMu/x3EXlQO/5HwdVYAqN1JlBpWcemQyDE4cY2N6SyLQN+X53cy7KAt2gI2753/YhuU5fYuBKLb
	8P4ss/NHNxqA4jni2aZbdwN9A79XQ388b0U27LQAQrwOkaZCaxe9eRHn1WB2z5OjoOKA/+9BVVXlA
	SjO4i1lqzTAEKPmNXJVkx6LW/M+HBT5fhrPw1KZc6BU0TapXq4kvicTcVMXbFrQhty+hIaHztP7/3
	XX80yS4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAN3L-006Dh0-2J;
	Tue, 05 Dec 2023 04:28:59 +0000
Date: Mon, 4 Dec 2023 20:28:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: zap broken inode forks
Message-ID: <ZW6nC43hU7qkZu8e@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927504.2771142.15805044109521081838.stgit@frogsfrogsfrogs>
 <ZWgTSyc4grcWG9L7@infradead.org>
 <20231130210858.GN361584@frogsfrogsfrogs>
 <ZW1YHT4o0WI1F/3U@infradead.org>
 <20231204204351.GG361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204204351.GG361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 04, 2023 at 12:43:51PM -0800, Darrick J. Wong wrote:
> Moving things around in the directory tree might be worse, since we'd
> now have to read the parent pointer(s) from the file to remove those
> directory connections and add the new ones to lost+found.

True.

> I /think/ scouring around in a zapped data fork for a directory access
> will return EFSCORRUPTED anyway, though that might occur at a late
> enough stage in the process that the fs goes down, which isn't
> desirable.
> 
> However, once xrep_inode massages the ondisk inode into good enough
> shape that iget starts working again, I could set XFS_SICK_INO_BMBTD (and
> XFS_SICK_INO_DIR as appropriate) after zapping the data fork so that the
> directory accesses would return EFSCORRUPTED instead of scouring around
> in the zapped fork.
> 
> Once we start persisting the sick flags, the prevention will last until
> scrub or someone came along to fix the inode, instead of being a purely
> incore flag.  But, babysteps for now.  I'll fix this patch to set the
> XFS_SICK_INO_* flags after zapping things, and the predicates to pick
> them up.

Sounds good.
