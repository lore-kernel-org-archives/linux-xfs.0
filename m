Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C7C18DF8D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375445; cv=none; b=utzrSc4ZcTlEicddm5sntEflylWfHVlS8pSK2MTSofIBwHfcxiodnvB1pxbk6TtTReOOjsE/do/A37QUpTTOZlr2/2wGsJNpyXPHsa6tvuSo3Qp47Z0zDLq4PQIhBHsrRfq/XdGJLy/TJgc+3EvC89OVwjHlgbKcFETB6lM59fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375445; c=relaxed/simple;
	bh=fv/80tmw2O3B74SGgiTXbfJvNlVn5+/UZquDCaWwv7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSxVbnXww6Ui6DwjGbUVOchK+8+T0oXpNEaygEStdFdAqQ/CICkabQKbjH/cMw5IblemA7iZKTVsWTQW0SPQi3/cTAEMTJF18glVPzisCE7RzkJ3n0EWpi7+q5E3wEbZ1P7TGtsyx+PyS2L0hyHJu4qHn8jXUNzDDaQ/QDls77g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VzEYLJSx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VzEYLJSx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ik3JvGYhM49+NV03+eqB5kzzr29bpeuH74xn1v1Dfeg=; b=VzEYLJSxSYhibfAPjDIqwp+IoK
	Xb8dO7SCUyZwGuD+dYwV7mtmxhnJZtu7dwxGQSl5D568gOLP6tlLi5nyNRT5xeGDFdgtCLK3cuUSR
	pzl/Pwr/s2wu7DdmWU6clMZVxEQHOpxhVoX7ISlXSEnZXl8MlZZYut+hDqKhlddbhFsT5uP6D4fuh
	lxxDVmafiokDxBn0rTc8nB7Z8bxEVpDJZzJh0KCDq8CaXNpbvDYMvcl6rcMGzT/67gOel1GhTrTp4
	HCshQTI0+xqLIoEle7W/cxHXRWOGKNqVWy7LEIWBkzOc/Pk1fH6jAJYfDeMrjEScXTAMniuGjcuOf
	PkLZcTKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYuX6-0000000GYsN-037h;
	Tue, 30 Jul 2024 21:37:24 +0000
Date: Tue, 30 Jul 2024 14:37:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_db: improve getting and setting extended
 attributes
Message-ID: <ZqldE1lgKED2d2Tl@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940616.1543753.12935781628377990063.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940616.1543753.12935781628377990063.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static int		attr_get_f(int argc, char **argv);
>  static int		attr_set_f(int argc, char **argv);
>  static int		attr_remove_f(int argc, char **argv);
> +static void		attrget_help(void);
>  static void		attrset_help(void);

I always hate these forward declarations, but I guess it matches the
existing code..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
