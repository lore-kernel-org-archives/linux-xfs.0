Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CDB6FC5;
	Tue, 15 Sep 2026 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454226; cv=none; b=QVnplK/omUTpEHSwBH0IbKP1CABGC2qUbLYFwu+XdxNoohoH1BlXJRRIH1fnGKXLYRtFz5lq/b+mzaO+RLnHMScyj/CUorFNo9sjeXkdybJmsZ7cAXAy4EL8Xfp0sdVL1ejgr2Y+StkSz1Y9l/FyaQ5ExL7Cx4ipQA3Lax5hW2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454226; c=relaxed/simple;
	bh=9dpLU790yr6BvWPN4uN9Ofxtt0ngh6LpS8kTFga2aVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F26m19DH/Sbs/Q+MJlu+qJqLFvl96DfQf7rA+vr89v8eN9IWtzhNIA+6lO+96AMEa53qST/0+9nxXGi7lgGHGkpfzK0oVuz0gnzGnhXngmaxTp0jNfE+HoKsQnpOaTG3PiGln/spR1PIv+o/olLVuzDjWPblbzbtDkgUhIXYXjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B1VKq6sY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1VKq6sY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UgfSs7l2UiblMitONWa2ILOf/vc42d67TCvKj8Opi+0=; b=B1VKq6sYIMAiFy3/TvYqSFG9L8
	AWGm6nIfa3erQctRivx47A47sdE3aGUa0pe5VzaF9sOB95mCur2QF/hoqWao3tKkfVACR92606cQ4
	IBoJiOh7g2KL/tUgW1IExwonAmtrKjtHMYQTn73gNkDJy4PgVjyMRT7Wa/xTGDM5FakgypBDYreXD
	ptCiPWxcZ+fQTY9cMGpJHqyzP1qp3hK0mTpseAjan4KVmtaGA226bIWEQuA+Qdn8zAyXAruPwmZaD
	wLMt+Of5b+lSAIlLy2CKPwW5PRl1J3D/Gyxx3xRlLDGez00yhwnjGb4Gq3UjVehQJO+/YEo5RRXcl
	MnB8Cy3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MXT-00000005L9v-1caa;
	Tue, 15 Sep 2026 06:21:08 +0000
Date: Mon, 14 Sep 2026 23:21:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH v3] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <aqjj04f66MqUXgdV@infradead.org>
References: <20260731031010.2627884-1-yun.zhou@windriver.com>
 <20260911174247.GK6265@frogsfrogsfrogs>
 <4ff8e91e-a5b2-4754-ac9a-20f64f169af0@windriver.com>
 <20260915043105.GB2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915043105.GB2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 14, 2026 at 09:31:05PM -0700, Darrick J. Wong wrote:
> > 
> > Alternatively, since xfs_ioc_setlabel() is currently the only caller
> > and it's kernel-only, we could just move xfs_sync_sb_buf() out of
> > libxfs into xfs_ioctl.c.
> 
> Probably safer to do that, since there's no other user of that function,
> and none in userspace.

Yeah, I was going to suggest to move it out of libxfs as well.
Either xfs_ioctl.c or something like xfs_mount.c if we think it will
be reused elsewhere in the near future.
