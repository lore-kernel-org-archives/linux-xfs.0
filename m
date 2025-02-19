Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192E25760
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943548; cv=none; b=g63sLDDn3CSqOwwfWz+LVDnhTrrR7CFDv5KsPAQbXqHczX6/IHXwTDQDv9emIAxclolEhtXgesEMruMcOFo+zWjpKHZodCqk/b7x4JeW2020AabQaWZoAcQ0vraJoBsCuPll3Nh6KFcGZfAlQOiDaLF1Dr7GzN0+rWkmHwgqMa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943548; c=relaxed/simple;
	bh=4alNAh3Hq1O7yvx6av9KljQJ4TsPf7uEZj21GtzVRW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBGY16Oxye+Zvncze40U546QqzYDKCWP6kEoWvVPf2uNaiTrcDCGL6RcPQsESWYCIK6T3agTJuwLndmv4eoJQlrHb0OZu9Z1kW7dCZ/UuT3eM7UgzY6sQFwO6MBTVqt85Ntj6Nq9AnYWpBwOAFVRD0yJTyjup09yvVWkJHGvp4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sa05WyG7; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sa05WyG7"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-220c4159f87so83581755ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 21:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739943546; x=1740548346; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L1dh30VFk3ANy9jdOQvWN3y/9wP/RfpOnuvU3G9Asbg=;
        b=sa05WyG78CbAI5LyrIXQXNK7+biwZ7R/052KB5Hd2EOycER9VVjcyftEgu1/ybX3T5
         oIWWDonRaVrZibGrO65hIvG2xtuJOx5xEKFWoscjrFnNCMB+TcLa8CdATEILdr6a3nIS
         AmA5gcXOYd3L31wgQxQ1VRA/PPHU/sX0UaoHFe+HW240ubTdijEbONX7ESJZToh0aXu5
         t232dK7fCSLE397X+CCsBxP4m06qpQoufFCAmm775G+dsI0Mn+NqpwXIRtQc1TfGWV/a
         64hsJSfJ6LXsoEDMOApyCzphNrlDt19Un7qzsL8vyzcJbTCuWcWwioEg1yLdtpnlJG04
         JGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739943546; x=1740548346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1dh30VFk3ANy9jdOQvWN3y/9wP/RfpOnuvU3G9Asbg=;
        b=qKfqvWpqXqVcv11Wq4fzDFKZJTc80QbPmJy55/6ABPuaTG3xzB1yD8k/PyawnfC2EC
         HqWt2o63tn/rBkUob9XLUsx+umX+vZf0C+DjzR/zGSMai4T3B58wUPyJCEtQoRb/97Rf
         I0mNdYlKsklh32GUbr205Oki1d20jstoqBMExL29xR0rZxAS1QjXMTKkmkk3NWP6NqnW
         aOFzGt9OjIN2x4rVbyl+bLGB1+lc77nsZ5vC4b0jvgTqcKmlk3enKel5rfR9LN6j9A5S
         Y8OoPF3LJVUAKevYVFbmYvW7vVJaN9Yz9EM1WPOOc01EcINBV1mA+uGnwdxyrXrwajy5
         bVxQ==
X-Gm-Message-State: AOJu0Ywr/p03Y2AJn6nNwfi69cbNUBOZKMLi7Rhz1IztfEKRae4xfRXp
	4O157s/H251sntMl7mdFgda+ClNZQ+7CNmzJb0+Hw3I89AOP0m+Xkd6AxNyXGhc=
X-Gm-Gg: ASbGncsYuc/yJJW3CE/8oeqRfdcEnRGsW124knolpXbFuk4RrlY32g7Zl9KOeD8Hcll
	Zk+bM6hq0Z4aKai2x/ApAuM3y1+dEE7ad7zx0EQ5vK62N34/ox8ORao0JX51LbBshV6y+/WejwK
	5ns5e4RX0t80jJQ9DLUEcAFPrsQJbMsOtVlcYj5LTppBUfZDrwPPt/1nalrMJOYt7x4PtOJnCjf
	MsfVKzXPq3mnJDxUwRXK/aRS7ocGXqHEtjChzenrMBHVIadp/cm71idvXpm7XsMEZOj/0OzeKBn
	1bAafIE895z9UErH6I3q8GdIfU4s4xUrIhKX1P/61rEn2sY4W8uiQPdEpdXP0dAllig=
X-Google-Smtp-Source: AGHT+IEbeSo2bYtJAiAAO/TCqRfaqFW1seUVbUxQwizvZZJqNLWEo9NVgTP8Nb0drsRjQF06ETJUgg==
X-Received: by 2002:a17:903:1ce:b0:220:d909:1734 with SMTP id d9443c01a7336-22103f16a3emr261201285ad.14.1739943546045;
        Tue, 18 Feb 2025 21:39:06 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d556d5e6sm96943125ad.173.2025.02.18.21.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 21:39:05 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tkcnW-0000000378N-3XoA;
	Wed, 19 Feb 2025 16:39:02 +1100
Date: Wed, 19 Feb 2025 16:39:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [regression 6.14-rc2 + xfs-for-next] Bad page state at unmount
Message-ID: <Z7VudncQE3wC-I9i@dread.disaster.area>
References: <Z7VU9QX8MrmZVSrU@dread.disaster.area>
 <Z7VftAeqEgTwUyx_@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7VftAeqEgTwUyx_@casper.infradead.org>

On Wed, Feb 19, 2025 at 04:36:04AM +0000, Matthew Wilcox wrote:
> On Wed, Feb 19, 2025 at 02:50:13PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > I hit this running check-parallel a moment ago:

FWIW, I just hit the bug again...

> > [80180.074658] BUG: Bad page cache in process umount  pfn:7655f4
> > [80180.077259] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x0 pfn:0x7655f4
> > [80180.080573] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
> > [80180.083615] memcg:ffff888104f36000
> > [80180.084977] aops:xfs_address_space_operations ino:84
> > [80180.087175] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
> > [80180.091380] raw: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
> > [80180.094469] raw: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
> > [80180.097740] head: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
> > [80180.100988] head: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
> > [80180.104129] head: 0017ffffc0000202 ffffea001d957d01 ffffffff00000003 0000000000000004
> > [80180.107232] head: 0000000000000004 0000000000000000 0000000000000000 0000000000000000
> > [80180.110338] page dumped because: still mapped when deleted
> 
> Do you have CONFIG_PT_RECLAIM enabled?

Never heard of it - what's that do, and how long before the fix
gets into the mainline tree?

> If so, it's buggy (see linux-mm
> for a fix if you don't want to disable it).

I'll disable it for now, don't feel like going on a fishing trip.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
