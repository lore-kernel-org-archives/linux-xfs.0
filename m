Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFD352F62
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713330226; cv=none; b=cH6CUudovJikc3ToZINTUdzlM9d4hfIZTiiogqcsdiiwvFyBdshJ9/9zay+qnc7t2cGp7GvKZ8SXL+Z26Wkmse5ONj+gsx1Kt35ukyEH6MvzgoYK2jZbrFVJGo4D/J38S+Hh1i0K+pA8aHfjqvV9QgmHW0IS1qxL2yCdzsnwtrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713330226; c=relaxed/simple;
	bh=/KvbKBHg8kueSg+YnIeufyAFcyfc5wCXkASQ4hE5s08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhpPwKjHAjxzvL+uQp8txTKhyImcEgdKoF8pSEnmRCIXRdbpyD2v4GiMYP9M3AFO/wz17S02knunn7QIubpBSpujeaVJ1mkHCnl+HOFfJpQAOXuGP4JQ7BVTMoZExtt5nWctponuWpaCtffwm79kI1FSqx4Iv+ua11nRPBM4TPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=udqvzicQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="udqvzicQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6vOAKRYeFgSBedurhxbt+o9AhRn7GvjciDReF0HIMMI=; b=udqvzicQSQts2cgnMy66Y9rarG
	xQYjd7xsL6BVRW6D4w/E5zYcTqmuTdig95cS20EgnD3+I6wV+tUbNbsIlYWR766E1FDty9TPCT+Xk
	EFUeO4mj22dev87qTAeRnxKI1C6L6JwZLVHMZAeFzmEXdaerje1HtZrn3mBMWX4OhJ4NPSAMEqZeh
	s/DvBRgM7u3yqU4XIqjvr2wsCK4x4nlxNPGQKyBxjK4sZNWHFvoEDRuzwU87wNXwTcWT+m4z/VFWj
	9G17v0KBzcZILPWFtp+KjirZEkFfIR/9/qybkQLTtqCEMa4+36iLW/oMJ660C0ERo/xL7vjlVLUIS
	xKZVlFhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwxST-0000000EjJ7-0ewX;
	Wed, 17 Apr 2024 05:03:45 +0000
Date: Tue, 16 Apr 2024 22:03:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs_db: add helper for flist_find_type for clearer
 field matching
Message-ID: <Zh9YMR1WIOB_8kJM@infradead.org>
References: <20240416202841.725706-2-aalbersh@redhat.com>
 <20240416202841.725706-4-aalbersh@redhat.com>
 <20240416205348.GE11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416205348.GE11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 01:53:48PM -0700, Darrick J. Wong wrote:
> You could do:
> 
> 	if (!fa->subfld)
> 		goto out;
> 
> 	nfl = flist_find_ftyp(...);
> 
> to reduce the indenting here.  But I think you were trying to make
> before and after as identical as possible, right?

FYI, the goto version s what I had in mind with my original suggestion,
although the version here shoud be ok as well.  We'll need the static
either way, though.
