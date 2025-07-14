Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57CB239E6B
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 20:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752526495; cv=none; b=De74Ki+a9Tpx5gS13x23hIlGqI47gsSE/uE9bpaZZ4l926eqyFbyS+tNrDaT4R0WvcLuxay2zrm/nj3rXGgGyt3aazauv3vczdfLi/Z25NDMXtqYp4gRfPsDjBx6y7dfWyQ2rW9OpE6alLBzbpS/oDApiHAEVqd3xRISYJ3ExSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752526495; c=relaxed/simple;
	bh=UssYM10cXHtEcGcVprveJh7EKol/CCB/gL9GO63IzDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEgCf0PRcil2nnR0LdeUNHQ/uJxjShm2pQd6rrsntUlju2I3RcFBK98vFrVuO59PPPeWnGg2DPZ7nr3qU42W42tjhsYWS75PmM+KXm4XXeIqv9VMPEnr5rmhBr/7ShDcCWmQmK6xBkHpF6XtaeNDAA2TW4op+RzMQGC76JWtsCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1aPW62xT; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1aPW62xT"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2349f096605so61326885ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 13:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1752526493; x=1753131293; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cGaTIejbIDa1EnTWl7iUyz2fyjxkyhNDZbvM+32wvCo=;
        b=1aPW62xTDqX4SBY2eQ12DluPYJzYPjJN5vW9MCwEtzlnulqxp/82Q20MA2wGiaFLq3
         QhmsN25gNvthtcAGoXVkuqwRdk8mBoO7h4CQCZ5iWYmzwnc/92kPgcBnw3/lcAuTzEw1
         58N0uuZkwwFtUaXsmIpXbYg09oc9/x8OP8JrkgQfmrfaqx8NQzu5O3fB0re4cB/0iyHh
         pn72dIAEXkeODFOYbhDZ6RTfIP4KFeafqkQj+sH/xgZTkyUewye2A5JwquuGhYHzVA7G
         2P1/nibg9+niOegZgGEV68saNHxgqtVDjXPJzv8DLetc27qfvIt2OhB5RV6vEhm3TXxz
         Sv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752526493; x=1753131293;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGaTIejbIDa1EnTWl7iUyz2fyjxkyhNDZbvM+32wvCo=;
        b=vMOBOibJ/DbKfZrkwj4MiEwxO3q5XeSdDlziIyExJHGD/5L8fsbYrlULISc/od9vH4
         voKoIg+mS1cMe09nQzXNplsQdKGG7uClt9Gkrgsv0z7IhoMnczelMS/3yDIcEHWRdsJt
         D0u/4gkmLODuxYQxlJaIl/HjdECF2SVzbmHKYQ9tzRHsME1A5qiJsopQiaa0BrgO7M2/
         SL3zKK1c5dzIYiuImUMZCuGI9vOHkX97TNd9nS3C+Eu4tNl86ch43kaNyjreY6QGVNCP
         CHLcRx3W6d34hmI7v1A6Wyx5vNbA60FnMJ4o9jdvcGHYSynmR9POqCXZ6WGkV0IA7zdj
         o9wA==
X-Gm-Message-State: AOJu0Yy/RfypqpcWNPcJdHqjLmsXXB1TgRpsLdebloebmsAfEUO8PpHD
	PxEqFGSFQDrDowJU9pTcB904hL6xiLo8vYXXPv6cAfEo3RMOkyFOYkBQiGilOUYFLvg=
X-Gm-Gg: ASbGncu34srwIqITQPdSqvmeM3qUaat21hhawGOJz5yCDOsCVblGsaW5W4XonvqmIT9
	UP3Q8l22J75mSuWPX1PErv9c601CDsuYiGx+AHIkPDch2UHOLfwzrfNbuu1GB+Bm0iu64jnMRpd
	oGd1z99SaxRn7nTKaSsVB2jEkow0i6ajOclIdiiIg10z+vd2eeyW4NcqNQCluCkusJ3o/nh5/pP
	SXMDvjgkSX8B7xya9OzvZ+U/2YXqmXAeJd/ute+CBa47bGQymHY1w9/HCDEuWmW3FuUVzOvbSWf
	qqRAAuxufZ45zA1ERlygScGx8H3hUrM6Pjc1+v55PoJuv6pswPb1ct3kQaLvhgS3icoN3iqRYJT
	6AUahUozPhMCGHTp9aMiEBaoMUgUUs2A8GD0THEX48jyf9Vngj/X6dUKBZQ1LWF8=
X-Google-Smtp-Source: AGHT+IH40fPmlO2oed4NRXUZXZM4riGncAWr5LufeNctBGIp5Qtr/N/qeRchKlAnjLJ11w0tm9I1UQ==
X-Received: by 2002:a17:902:f546:b0:23c:8f2d:5e24 with SMTP id d9443c01a7336-23dee17a3b8mr251189325ad.5.1752526493091;
        Mon, 14 Jul 2025 13:54:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de43226d9sm98061385ad.116.2025.07.14.13.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 13:54:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ubQCI-0000000B4Dp-19G8;
	Tue, 15 Jul 2025 06:54:50 +1000
Date: Tue, 15 Jul 2025 06:54:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Priya PM <pmpriya@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Query: XFS reflink unique block measurement / snapshot accounting
Message-ID: <aHVumrkSqBlgU_ZJ@dread.disaster.area>
References: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>

On Sat, Jul 12, 2025 at 01:19:19PM +0530, Priya PM wrote:
> Hi,
> 
> I was using reflinks to create snapshots of an XFS filesystem;
> however, I’m looking for ways to determine the unique snapshot usage
> or perform snapshot accounting.

XFS doesn't have any "snapshot" functionality in it. What are you
trying to measure, exactly?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
