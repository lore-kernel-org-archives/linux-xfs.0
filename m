Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35D1494D7;
	Tue, 25 Jun 2024 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719315261; cv=none; b=j+gFeCswPCTGimsT3Jzbp0Tvuuxah7VJ8iZK6gVnqT0OTpaLavPhKkhxYzyHbQAAgU2MxP72qVHWaX54uPwb5ri3L4PUNaFa0qIOC1byiDUjArU6U6lZjAzA57vZ6cPzmthMscyBnW8kSUnSreLWDAehvjHG55RJyTAkdgL52Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719315261; c=relaxed/simple;
	bh=xEqPfyh9X6YuMifFgEaBh2xb//PTMQ+e5kd9VxjCj2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0xN7FSAxSjowr8724oPc+5z+c90net6EDL10FRJAZcUWgw9bPZFyU8s2LUok28o9nWTS+dplODlMP3tc/lOh7rK8BfLCAP9R5PEfNcF72Yc7sTuo0wipwTd7x2DhmuD8mU0umN2Tt8ser7sFhILt4SkvKYGhFGeFhpWug6jp2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sJSzMm8F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sJSzMm8F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=faux9V9iXqed8tIz+6pT8trL+2XAtII7wPG/Di7LJdE=; b=sJSzMm8FD5d9R+48pDS5r7+eD7
	NJYbMFte26n8KE1pBgWTDys4Ib1tryeMYIU8XvvMWOU6VyEbgeU4n27btTBIV8Yy14UaE54GCTxX3
	ovD9XP5n2HZJfy/JKjVt7dEf9zimuQV2t4Meq8DBqCmOS8w6pSYitaE1g/wUSy2ufbtetBTldyZqV
	RNhCgMUcp2T8KN9cf/BVqroqwOpYDW5fZIlHzGDfKGTXp7GqzaUXlSIZr+d00jK+mQsmQt4kKWpN5
	R0XO5gYGD2NXc+XAZhJVJ1Ci9siYWB7O/ckj78Z4DY/UDoaix+i1x7RvLIOgOzdGkEfnPW1Egk8gr
	cc708vtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM4RC-00000002Yl5-4BGY;
	Tue, 25 Jun 2024 11:34:15 +0000
Date: Tue, 25 Jun 2024 04:34:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: alexjlzheng@gmail.com
Cc: hch@infradead.org, alexjlzheng@tencent.com, chandan.babu@oracle.com,
	david@fromorbit.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and
 release it early
Message-ID: <ZnqrNi-cEjs92-b8@infradead.org>
References: <Znqmr3Iki4Q8BkxJ@infradead.org>
 <20240625112438.1925184-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625112438.1925184-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 25, 2024 at 07:24:38PM +0800, alexjlzheng@gmail.com wrote:
> I am sorry, but I didn't get your point. May I ask if you could clarify your
> viewpoint more clearly?

The explanation you gave in reply to Darrick should be covered in
the commit log for the patch.  The commit log should also contain
measurement of how much memory this saves and explain why this is a
good trafeoff vs the extra memory allocation.

