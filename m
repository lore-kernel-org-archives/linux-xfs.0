Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBDD3161B5;
	Wed, 19 Nov 2025 06:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763532411; cv=none; b=TJxqDdxly1LynrH/0glM8oCOKjkVjS1PP3EdlR/+SgI1SMMqhSoymCUq513mXA6LzlrZ3bmoyuDRRpkvcItdZoHVknqg9Ap7x9NnUVA6eliLo5kO+IuMaFgfCrClO/zpJPsnv8sotAns23vE2d64PRlqh4mdmEuwBepqvT2OPAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763532411; c=relaxed/simple;
	bh=ONG2vwLPNJh7PBUkhMvLCd3bHEPsK0YgBE1zCxlsTww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfqOPvUROeXL8P3QZ0LZ0UDqQk8DXwlhIIq0LVtr6rs04qbxfB842tohrh8MO/I3nupFQf/XqOUbF8CHCMB92NtRS3Arm0Lec7wIhiQeMW2vaiMXB5bOMVlhS86ZpyAj56cnVryPRRLTnGVNenDx37BYdSE2J2d0uUDOdDhMQQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e/ggI730; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e/ggI730"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=7N4LZbNFjhOXZauo6ZN58e7HqZMwxLihvoZtrbow1zY=; b=e/ggI730wsrZVALNzfORRf0tjS
	+vrVQVVPl+QPktbe8ScdvjGPXOFjlNeJiCmI6YmgcA+a4lM/8BUKj32RDCYUayYfV73hfvecC7QEG
	jBxsSmkKYku2yT2wNF/2XhBr+oPJ7VKwGOoNWcooD/HHOwHtKFqogvbfSXXbN8GgLi0xsnZEhdl3s
	Lx7LAtZzvSapUK9hqlGo9KQByZytoTKP2mrVUP2dxWyczTWkI2VCtfHc372d6Gg0z+cIZdVaSfw2C
	J/03MQM8q6RvPHANY1azf4pLTcdqOAYX08od84zfMM6KkNg9kGYOiY/6Q5V+4r214EllMZVeRWkU/
	UXn9g/wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLbL7-00000002art-29XI;
	Wed, 19 Nov 2025 06:06:49 +0000
Date: Tue, 18 Nov 2025 22:06:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?B?5p2O5aSp5a6H?= <lty218@stu.pku.edu.cn>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, cem <cem@kernel.org>
Subject: Re: [BUG] xfs: NULL pointer dereference in xfs_buf.h: xfs_buf_daddr()
Message-ID: <aR1eeeCKE4AJSKwL@infradead.org>
References: <AA6A7gB4JrG-pMrNGmqTzap7.1.1763463974419.Hmail.2200013188@stu.pku.edu.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AA6A7gB4JrG-pMrNGmqTzap7.1.1763463974419.Hmail.2200013188@stu.pku.edu.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 18, 2025 at 07:06:14PM +0800, 李天宇 wrote:
> The kernel reports a kernel NULL pointer dereference when the sys_mount is called. This is triggered by the statement b_maps[0], where b_maps is NULL.
> 
> This bug was discovered through a fuzzing framework on Linux v6.2

Linux 6.2 is ancient (Feb 2023), and the buffer cache code has seen a
major rewrite since:

ch@brick:~/work/linux$ git diff v6.2..HEAD fs/xfs/xfs_buf.[ch] | diffstat
 xfs_buf.c | 1651 +++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
  xfs_buf.h |   96 +++--
2 files changed, 768 insertions(+), 979 deletions(-)

hch@brick:~/work/linux$ wc -l fs/xfs/xfs_buf.[ch]
 2132 fs/xfs/xfs_buf.c
  391 fs/xfs/xfs_buf.h
 2523 total

so I'm not sure how relevant this report is, especially without a good
report.
