Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EAA2367B8;
	Mon, 25 May 2026 07:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695291; cv=none; b=kzep/QHea742MvggYWo+LcBj5Be3gObRhkL+nKpVqgMhGBBGhvmkBa6dY9EYYek76l4nwXUo5UyIIsXGbPjbcPI7MZWerlQvL5oSrH/Rkd/MdqRk0nc+TQc1wc9Uj4ZDKES0WyEftVzisyAvoQYJ+2ejCIomIGWoITPNRN7Cfhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695291; c=relaxed/simple;
	bh=euFze5DW7c94aBxmpuMNLE5uTeJlaB7Wokc8PVRhePM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8Y3V+skJ0u+6U44fSLzEZfMrf8Bsm3TeUrThV88k6X5QUs2Gdr4de7XdjUO828qQiToHgk4xS2Hd53qzk2uoZfNAwSTAZBGSvgZxobFMvu3wk269KNDE1s6hB+L1nId1ALxOm3Xq/NrQblWbfWX32/vQ03AVj9+7SzSGNKoUOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RdlTfBNe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RdlTfBNe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p6HXUE5maqWOqqNdkQf6Chxjefp69EbTbXysqERpwN0=; b=RdlTfBNeuy0k1F9PZ0YR8drnGs
	eBqabHKYy9PgReZrikdURYAGLM4kuPxoxf7uIV3NhhUHy8T1PrE8bW0bsg3rf9DD+SK1YVv3IXqr4
	Qlms2kHqd89x9S4hCPxR7JCdhrOt6YEq+V6PxipeVlemN+b7eqqX56E8OX8NVT8yutxmwY2rSjTSj
	87cw9z17EKgEXLhLy5oq5yfnmWDXzsXWCZQYlbdz52oN5gmhRnVdWfXWt+Omb95uGsg7rWYaDjRrE
	snKfpY2mwaC7PGt8V43WBRoUqKD4WluWYXkijmy6yZ5+9HfFKmte54uu9t9voJ5T0Poj8ICsfchou
	IqLpwXvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRQ2j-0000000GYsn-2NW4;
	Mon, 25 May 2026 07:48:09 +0000
Date: Mon, 25 May 2026 00:48:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	zlang@redhat.com, Zorro Lang <zlang@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-f2fs@vger.kernel.org,
	amir73il@gmail.com, Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v5 09/10] fstests: add pre_clone_tune_uuid() healper
Message-ID: <ahP-uWb0PIt57NEz@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <0d9f455d20145103faaf4e45262ee44418cbaca1.1779367627.git.asj@kernel.org>
 <fbc03a78-0a6c-4c3a-9608-656d0df83d29@gmail.com>
 <ahP21UfAr3DvEG1B@infradead.org>
 <7f846f9f-4193-4f6a-8a87-4084988d2044@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f846f9f-4193-4f6a-8a87-4084988d2044@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 25, 2026 at 03:31:59PM +0800, Anand Jain wrote:
> > and a comment explaining the helper.  Also I think it should
> > be named to describe what it does, not what you use for, i.e.
> > something about changing the metadata uuid.
> > 
> 
> Agreed. I'll update it. Is _change_metadata_uuid() a better name?

Sounds better to me at least.
