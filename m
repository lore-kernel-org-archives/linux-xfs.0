Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE9311C2F
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772007718; cv=none; b=FvKYYDBJf/7XDEF6W+5xCo/WDwlXtW30C49dLNxucGOU26zOAGMQT3lzMXS0wh60qVx+q1P2dt874GhoIEBpvztWM1h9Mkdy6Y9rSdrefH/OAqtyk9sqErCA3T57ULeed+2TFVmr1DrOEzu2/C0s3Cwtpq7lFB8ezHnzGDP+1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772007718; c=relaxed/simple;
	bh=yxLKYR+x3rPedx1Pc7QGPLEBb4HWHrP6OpH5qMCI9UM=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=q2mrMjDnEUolNtnIlw5CSWYvWIw+p9AyaKaUNZZ7/0PH4t1MVt9Aw1IPkgYKzwkXuERw6R1ItRM0fxiPl+u2F1l7D3GT6P6Ox8rvwmTJnlJTtT318KTkqjxHox4w3GoDVMr5ozLPYaz22YVI+kkAvFpTU8uM5Ufq1+4lwxcU9z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id DE647180F2E7;
	Wed, 25 Feb 2026 09:21:42 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id 5zuANRaxnmlepA8AKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 25 Feb 2026 09:21:42 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Feb 2026 09:21:42 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: socketpair@gmail.com, Linux Xfs <linux-xfs@vger.kernel.org>
Subject: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Reply-To: aZ29iJJF9sGfya1k@infradead.org
Mail-Reply-To: aZ29iJJF9sGfya1k@infradead.org
Message-ID: <74e545ca6c3b98c00018f604812853cc@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

> I like your proposal.  This is actually a relatively east project,
> and I've happy to mentor whomever wants to take it up.  Although
I like the idea and can take a look at it, but I will leave it to
the author if they will pick it up.

Just for the LVM extent size, LVM does not expose it unless you look
at the metadata, afaik.

> I think json output while generally useful is probably a separate
> issue and should be addressed separately and in a more general
> fashion.

I guess json output could be also added to mkfs.xfs, xfs_admin (xfs_db)


-- 
-lhe
