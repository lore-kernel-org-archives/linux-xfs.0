Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341739FCA7
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381703; cv=none; b=sr+TBg4COlEmqodK2pSsLkSSxGAztTy2OfcUMrR0sOwvNJWnWv8T8ypJQAn8jOxBe3UH0DpiAiyo9d4LtitIpBJWwElifhO1BDc2WxrTP6O2UVsyJxAc+wyb6xz99hbii3MZ6/bz4MgU/NbyQit9Ec/HRE8O3HqgbxjVHf9/+f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381703; c=relaxed/simple;
	bh=1zJh+gMNLh3n9Gp3wdZERWR7klivM5dIWbl3gOrvCZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5zatPnBgcg51QUeyxPkIVQ9SEloS6BS1X3U0lYPXZT+ChLyL6FjI+uQ6uR5gnQlzqDdmxdhMe8317GApZjlqryBqO6LNzsv6hiv5I+rzIor29UJ4eBgsdy0vbm9qKmKzagcuMxOwUXqDgs5EovbTthwz0Po1ohbXL37cd2+teo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4J6vtIQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4J6vtIQ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4888375f735so698975e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 16:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776381700; x=1776986500; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtSi1JUHvm8h9ZtScbheLnAanBRgPo0T9nN7jS0tLq8=;
        b=m4J6vtIQ0er4WBcUyW7Vs+GyWO0eI3k33YIr6/cLkiRai6ad7kokNdfk6bnBBbVgu7
         p03pcRtlu4Wga1uf7P1AV3TP6JETrN+3zf+UemEd1fio6FClZGj2UzHczYkQcHxdDTeI
         0s4j0Zw/AGYXKZ9g/3lNbLmfKfUeRDHMBtdOM2LENcL97WWm0tpNQwSV1ityaWu7Eqk+
         0cASWkUhGEYG+oO9GB4ZqcGIw7nWo7h9rnXljqMD1YnlFu/VCC/Rsv3DkQaFd2f66vQ+
         64ErKCHXqABWqma8RppIWHqO/jLA7SIT5TAjvYUm0HRoYkwNcSAGjl/tzthmVqZ/Six8
         LQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381700; x=1776986500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtSi1JUHvm8h9ZtScbheLnAanBRgPo0T9nN7jS0tLq8=;
        b=ei37cyS21nXlKZSflRzbm40BoEXPYz8Sk7EkqOganlVhiaX3C8h3vQLcUeOpZ0gvdm
         I1emSbWcfGV4ZSr4v8kxFIhgm0XGdlU9Un6Eatg571YkCdZegJcXPd6HIO8HPlG5dPfy
         CbB6U5IfWQWWdyGPTXJZbXPri6RTeOl3sl9SX/EUhPqCUUTwaJbLzu+kRjPhP63YzEwd
         bS4DWShYFPg72xKosfJe+/KsJ3qf+DUTGZxEQQgJM+Vim6VGVP5NObuwWUCkbt/cNu6s
         1zGVVruDRxIVZAsbOXvtvQExlSEAPVVf8TpsZgP1bzEgt11uR2wFGHJVPqSSUEFJ3l7u
         /DNw==
X-Forwarded-Encrypted: i=1; AFNElJ9SPU7+vKtn0cUOQ1WIS7GySxaSB+nkZ/I2nwagpRLa2zr1loVgZ6VdO1BsWHzM/K47rd7g1mxiefk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPIxxwGB61uEEy6fkHzrYpfEz30VvRL6t63NWEC1x/jvvrG0B2
	WxzoVSVX5cNyUCM3m+czqpKuSS+RhnBkSBCB86w300v353Ku2I0G5Wu0
X-Gm-Gg: AeBDieu1DP9VQbFg+KEp+yTIu1hT6SFs9v1lcJKZG6xZqtoXlECHyB/skVAoaGDrQQI
	4sd80OKxS6Zo14TL2t8YTFdI8mp5JKIhdYY4GUmaplwd9uj9SPdaYX1S11PmKasfel3itE0CJj7
	79yqz1LF3r/goxp6e9Wsd6WYQL6fNGL6KleM84Afj0adi0VWd48uY7qtR+7YS0y6rmHFvU8QjKq
	nKKsfRyzrO6rzkkl5zAlqBjePcZbvtqT3Jf5HLf2rYC8aA2b7xockus9/YNgfxgI+GZLb6S22lz
	1gRZHPsIGb6xXGNXuT/rb4DAe1U/CdGp4007thtDfGd0pzoA38X4l13XmqqmrwMonWDYQEKSfbV
	7b3niW/2W6Hv8LT26i3Yp9EwCN1idmER/pb8nP9kCNMkoGtyXRdHLjEWN95svBPF46bYp5cdLSG
	exui4Q63dO/Z7QhqyOiLaZqn5OktsVXUZV06R5JoGX1ZmCBAvICLZUPnk6Qjlm4+nPHqhZrTIpT
	yThRI2Dvn08H6KGGBer
X-Received: by 2002:a05:600c:34c3:b0:485:41c4:e2e4 with SMTP id 5b1f17b1804b1-488fb792dd0mr7666275e9.23.1776381700006;
        Thu, 16 Apr 2026 16:21:40 -0700 (PDT)
Received: from f (cst-prg-89-171.cust.vodafone.cz. [46.135.89.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe43021cfsm429354f8f.2.2026.04.16.16.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 16:21:39 -0700 (PDT)
Date: Fri, 17 Apr 2026 01:20:27 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, 
	Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, lidiangang@bytedance.com, 
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
Message-ID: <hgug5jbkwk352zrwcngdofwiy2hq4nk7eq7yvzi6nru5zyebd2@fe64yziutvlk>
References: <20260416030642.26744-1-changfengnan@bytedance.com>
 <aeDjui2LGSidEHcJ@bfoster>
 <20260416152705.GC114239@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416152705.GC114239@frogsfrogsfrogs>

On Thu, Apr 16, 2026 at 08:27:05AM -0700, Darrick J. Wong wrote:
> What kind of computer is this where there's a 5% hit to iops from a
> memset of ~150 bytes?
> 

Such a memset is not free in its own right, but here the real problem is
*how* it is done: by default gcc emits inlined 'rep stosq' which has
utterly horrid performance (same as 'rep movsq') and in this particular
case the 2 memsets in the source code result in 2 separate 'rep movsq'
invocations.

I complained about it numerous times, see this to get a taste:
https://lore.kernel.org/all/20250605164733.737543-1-mjguzik@gmail.com/

Also see
https://lore.kernel.org/all/202504181042.54ea2b8a-lkp@intel.com/

If memory serves right gcc is going to fix it, so this is largely going
to clear itself down the road.
