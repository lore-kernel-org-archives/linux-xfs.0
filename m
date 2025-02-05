Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2ED79F5
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738715936; cv=none; b=Sti5FJR7Xg0ZH5pKqRuG35/GFeCex9dqqFVmis/hR2C5HE6yPXskjP1UyXouv0CZSDXbYDe/jc8pPHOXm7VDHsutc2vqu9jxazENBfa/3tSl7mMhvOl3ej8u/yGyfBt96pckrIT0b7/ZHFu1qskmgXvPRGGxEYjTMrD+yh4JJBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738715936; c=relaxed/simple;
	bh=mW1OD3BuFbfIzWNrxO9fgwpxwuJ0Qix9fvFQvNwRe6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDQfcGDPnQ2+WybJj7gadhyrOyINhuEc75Gj7OpJZYgOs1f/Duww8C2w5aEqOMz0Igu8/irlW7nIUyWngeXnkOTIrzM64FiwulAVHJEWCIBt77ZDd+7eaBfdmsWAKKKxhwa7X8+fpjhHfLz1dAI+JHEGmGPoF5wSit2vqhlWsxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wLMB+bQg; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wLMB+bQg"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21619108a6bso104668985ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738715932; x=1739320732; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+4F9TLvTLaZFeW21EJEf8M0qCFDAqC+SVSOJf0YLK5Y=;
        b=wLMB+bQg5fLRLqgBq66sN/C1dBdn9UPI0MBLqo9mH/wNWU5bWvKO/vDmT0+DSrQwk+
         OVWXE+LuvE2ASPnMtVk4fTXhCiphnsiZexDfg1JTD/+8gJfAOlNttqCV0jLow1uAOy5T
         xAR3jF8X5E5fEYL3TqxyDPrHT1BY/g7ap7/2SDPjtS9biBzEqnwpdo9h1xqF+o4Rtldn
         rqmNfqrGAJ3ERpsKa5qQQVQGcPoMKOXCC6c6VK1zGH4A+Lw6sT2LYmjvbP3jQPWMSqUm
         UTFyopgQiaslFSlh2NnyfR8zWeNvHCdAFqbBfXbwVBGhL+o7G6XohAnIAPk0XAAZUI8D
         3zDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738715932; x=1739320732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4F9TLvTLaZFeW21EJEf8M0qCFDAqC+SVSOJf0YLK5Y=;
        b=eFtkd6E3LBxweXX5XT7S85ZTMUOh39VhFYk4gBHupPf/JYlWhrtjTau5xERnXELujc
         PmAaN2AF4JWHvfyjV5EDQU4y98YTsdiZ7Jd3qRETU3sPG5oA8IsHe6kA90gux6+Sko2p
         VpV4/FAjhn+0ktFwJ/HI4Ixs8GcKt3wX5RkmXxX2YOtrcoC7tKIFo3xE0eqz1Cf9Lqr6
         EcFIfn7oUxz0JCiwV5JWub5E2sIJN1Xocv3gzsAZ6A3B+qg/FHkwdcamQEx0IheWc1IG
         TB8EVA8uG0g20eQa4f1rLOK+H1ufRU09iQiURnTDIe7tPxZ/S/zx6UBwAff49++yUy3q
         JP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1NvfPeOFZ2oA0cSZZggCbNOGR6dnu26Nt0aQOye6yDyyPyO6we0sxJQIrJTqGleWHAzwYQF6bI34=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIjwnYYsAwkaNK1QUpPr+vDTwItgN39WsTs1gHjDJK6xOKijis
	xRFqWVIo1KmbHBk4eWSkFtn+HxPLABIeZgi4fWkCwz9wIt3EOjEe3tvMhuuZFe0=
X-Gm-Gg: ASbGncuze6b209Og/KnO++HYFnkZvybbJNtpRDGyy5PVVsM4Zu067xJpYaPBFIRE8em
	jWKYWcZjma5zOL0gFRye9pfS+PxFUNX+sLy2HbtsJdSk55wqxltA6h0+JW+aDWo8e33N28gekIP
	BilGgGdENCtRCRfq3RLrg8zNkfvLV18oI/dy1U6NYSRk34lzN/XV/TIQHwZqU43rx8nP41x7ovW
	6DrqGgik9gdNSmMfiodNGgmAlrmpeUScWc+4gv4qESndSqWIKuvueQXaQTHvZYBtF5PHkt9NnvL
	2jcxjfWXInm4ozf2Of0mHyOxVXyy/luOKhEB9IQoevPkr2h8+6eFwAo4
X-Google-Smtp-Source: AGHT+IHqBuV1yiof0Qw+2Mx0DplF/UOOh+y91m5TlM/1KNSCv/EMYl80hHEn5T7tU2SMJp/AP8ESXA==
X-Received: by 2002:a17:903:292:b0:21f:a00:dcdb with SMTP id d9443c01a7336-21f17edbd55mr16040375ad.44.1738715932393;
        Tue, 04 Feb 2025 16:38:52 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21ee2bae0a5sm75584955ad.19.2025.02.04.16.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:38:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTRJ-0000000EjK2-3b10;
	Wed, 05 Feb 2025 11:38:49 +1100
Date: Wed, 5 Feb 2025 11:38:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/34] check: deprecate using process sessions to isolate
 test instances
Message-ID: <Z6KzGaewZBcAXOZ_@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406352.546134.8739392016656606912.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406352.546134.8739392016656606912.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:26:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As I've noted elsewhere, the use of process session ids to "isolate"
> test instances from killing each other is kind of hacky and creates
> other weird side effects.  I'd rather everyone use the new code that
> runs everything in proper isolation with private pid and mount
> namespaces, but I don't know how many people this would break were it a
> hard dependency.
> 
> Deprecate the process session handling immediately with a warning that
> we're going to rip it out in a year.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Ok, that answers some of the questions I raised - the session-id
support is time limited and makes people very aware of it.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
