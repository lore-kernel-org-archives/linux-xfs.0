Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15036492502
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 19:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790103616; cv=none; b=s34IiQ/VrW8UQGoovGZWJRnymAxPecUKQwGUsp+7/SZLN1ZYX+6pZJPBQ6AwFHD8lK5xy2AhPDD1dXJFGDvDcHti2byXPmIi1Er4ClNP5mYt/18caSkbAnaws2rudufWB6wXOfkK9P5SHG7jFtQPWjtyaw7B+Gy7SAce47zSAKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790103616; c=relaxed/simple;
	bh=lwDc/4soCDTwvQjj3WdMQO97x7jDvcnzTKVIHsRmsDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiAc3IEr7AsQTrNTugHpJb49u6F9Lj6H+WQnQTqhrWyDFB9UoOkIPKw94P4m3M1vjvsRp1DZaiCGc4cqreg7TQ9sdZ5E9koqbJy4CmjPA2P9cZpacHvM6afiD7Dg1bULa+yUyCwX+g49SQtEnRjYrBl3VW4eraEujSPGZYlEXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+EmNE0m; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+EmNE0m"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ca5b0d6so1159065e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 12:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790103612; x=1790708412; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VEpKCI2OAMvJmBnkvfe9WlT81W7n7zUyoGhbmIGEDGM=;
        b=c+EmNE0mpDQJ4eQlQ3ZGiNyv7YTSwhfNQurSkejNkS44k+pXfE0klYjsX7RzZrkJic
         c6oX1x6oMQIn7dUBf4VpoNGj4PQ6oXwuPjkwam+Dvy4U2IrjfEWd8NQga/SGelPQXKEk
         2Lt7KPGaJjqktxVLLTMm1tlWhgHAm4mFp/hSjJnDpRQVZDxugIJ0PRn1wBfEsB7NZmpv
         sNUsQNi0B/RFVWwtmcRIslHs35nPDp60e8MGMHQYfgYWhnmRzs/t/EO5q94T4FbjEFN0
         HJDmMpq5qCPmrDSk31mRCfAfEW+ioHwkk+wPLaNqtOfqSH0/Zjr4TCBo2HdhN7Udw6lR
         trKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790103612; x=1790708412;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VEpKCI2OAMvJmBnkvfe9WlT81W7n7zUyoGhbmIGEDGM=;
        b=jptlx40Mqi7ter3rS8FAqp272aHjiBrRRjPNLM/F2Eo/onaIT6Ng6IIR2YLGv1MAbR
         YkT6wW3SXEaBjZ+wkpaNgX9gq2YRs8Wk2lM3xmJ4e9cYWuK9sw4X4dgsiDDlb3gxjvF8
         QTEg3vqvUtaMOBwA/j+lOW9C1op84Hbhzxm4ln9oyxip8lDIF8ZpwKKM4+iNf7mDQyes
         699Pblhs6jcpss1n6tV4fib4Nr56vD2WBFbZSz1gAyvab5iyDka/uMf/mr/VXhtU/3dI
         QnpkGxg1qMhR4eskITVJzQOHBpCM6AblFIO/p4/YMBiqHv3KoaeKZolyr0u3hvcwjp31
         wv9w==
X-Forwarded-Encrypted: i=1; AKwUvBzdwHFzGuQQzQ6705Y7joB6burscinAE6U39YQ6wZ4u8czLSFfkMAFNojdMPXJkrt2Lp97YEUOq9Zg=@vger.kernel.org
X-Gm-Message-State: AFuF++mtmqmly8WRZPztTluuLTWvbOa8ffPOWZpTmFtuIfz8W5wMcCPw
	Q7YCJh1bair/gtDuRGz/KhbvMZrfqbmIoBbujZultDXukEzhDj3/UyYP
X-Gm-Gg: AYBFou3nokTYqJ6+tkeb7HCvunhSnUWTDVheMUtjJa+JaDPAdMOEeh5w/1+427UhyR/
	3+BYDf48aIR0Dyl/Qr/IhpVC0bskPwY/tYulqEKgIQNqU584naHpHVVxFTSRdQvsa4Zu/u2Bcte
	ODuwtdSchmqtBzZQJZ+htaEHlASh+BrCHIJ7GRmI9JKDkuqalUCkzDsoBcA4dyZVc1tNhJXkX40
	63DIjiS2Q45g+luBT34LRGUNK1fkQhh90heCg1pZtXEg7rpJIN+5SSGKl59XDQnm7Nx3i0hjXZx
	nBn9Kc+zJnM7k0PsAoZyY9HY+hxrzHWwSU2RoA+NePiGm/I7dIsmhL+Rax/Z4uGPuI+6bapmO05
	ppsHEu1FPBeJNL0rEtSumt0yjKCYaOqSPpJPqNBkGYz9GurPQ87g/TRKREVSlEn3Iw8LYpyj7sO
	52nKSEm4dtjnSTlrwZAMjeKxbLBqP9zU7sRwb0g98TXVvRInvlKaI2AohrIzTjeqAGKnrrT+r+B
	ZQJOJIPzfo6cB5wbkFOEnatyU55XCFPmGP6/HTgGidsxYk=
X-Received: by 2002:a05:600c:6297:b0:49c:fe46:7219 with SMTP id 5b1f17b1804b1-49fdf12ba37mr1731935e9.20.1790103612057;
        Tue, 22 Sep 2026 12:00:12 -0700 (PDT)
Received: from andreayoga.localdomain ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886876c48esm418281f8f.20.2026.09.22.12.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 12:00:11 -0700 (PDT)
Date: Tue, 22 Sep 2026 21:00:08 +0200
From: Andrea Parri <parri.andrea@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <arLQFnituIhphayt@andreayoga.localdomain>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-2-parri.andrea@gmail.com>
 <arITIy2upsoN-DlW@infradead.org>
 <arJETViXYZbX8ckp@andreayoga.localdomain>
 <arJ0qe1KZoIaRCQk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ0qe1KZoIaRCQk@infradead.org>

> Can you add an errortag in fs/xfs/libxfs/xfs_errortag.h to inject
> such an error and write an xfstest that uses it?

Looking into it.  Running a few more local iterations both w/ and w/o my
fix, the plan is to include the errortag patch in v2 of this series.

Thanks!
  Andrea

