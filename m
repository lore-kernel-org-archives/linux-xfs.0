Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331DE6FA7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2024 03:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fS3TEv0X"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6e0a64d94d1so1589385a34.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 19:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705374450; x=1705979250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wL0qBWiBkCN64t0DJlGpnsYnRQAkrBhetdbdjTFLd2M=;
        b=fS3TEv0X4xNlKlZuBXhWLVooRk8QDCxuAeptR4kldn3LV0bp9Q4+CXvpmZjP+LJG9u
         GJkMIFwP9T5z2XqTyo8NtYJnOJd9rDMxq0popwtB1PSMSXeDExbMnHYvN9wITD15J4Gq
         XuANeL2rUSj8jcL/WVE4NOHiGs/i9uF6y7+DczrMMMlsuzNrHBsqQGy39ZX28gB69aZ3
         z+qZAKTwMC+VWHrQnUYwd/ptU3hcJ7VoVXfeQr4+JmTusTfyWfWgN01+eJ2btJ2z8Y9x
         9STtk3lsOOGxYgxGzDCYqNokC8LtfYZGcVF+h24PJJICeVm4FhSiVR8YZ4uiBLCrqOAd
         +i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705374450; x=1705979250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wL0qBWiBkCN64t0DJlGpnsYnRQAkrBhetdbdjTFLd2M=;
        b=vxExh/erKoU6nKPrsKBI+AWHRPnckMK0wXxfRODq5aAmhYrVCTeHXUMgzXa223pPvr
         DdSl1Woqp72Slfc9J46oBEfPpRPcX7cdCmZVJKkeqxf98yVquypl+XjDosqaNS7Zl6jx
         A8jWJ8dLiP+dPt7ZtMbShA7PYr9sKAmhNJgMpY32e1FHXC86BhtRpI2tpuDrrGqIX98g
         qyjXMVw4A4bzl4fkA/7N6eMlwmMe7GdLqL3DqU1uEcTBjdYdbCuSuSzzBVp35nMKHoae
         fhRiSOh+HnqwWV+TnUQqJzBHpLrsgA//m0YBoEL4W2DTrRpeIzNcqinTZhKp9I5FQ8zn
         7TNw==
X-Gm-Message-State: AOJu0Yycs2EKBIGVIuijkDJgP97oy33SQ/V7gUQbHwoYtut/zn6GhjBc
	eLqtSumCLh6ecNFsNfwvUhrZvikBWZ6/ZA==
X-Google-Smtp-Source: AGHT+IEWcK2VO4aACKAStgCaiUMFDJ1mIYf5m1oD1S9Q7oOM/p128nW2OuN92AxZuuHzvtISGtog3Q==
X-Received: by 2002:a9d:6519:0:b0:6dd:eb24:9d1d with SMTP id i25-20020a9d6519000000b006ddeb249d1dmr5267455otl.72.1705374449847;
        Mon, 15 Jan 2024 19:07:29 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id e26-20020a65679a000000b005cddfe17c0csm7789779pgr.92.2024.01.15.19.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 19:07:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rPZnS-00AxzI-1m;
	Tue, 16 Jan 2024 14:07:26 +1100
Date: Tue, 16 Jan 2024 14:07:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 0/3] Remove the XFS mrlock
Message-ID: <ZaXy7uKOvtiTadCr@dread.disaster.area>
References: <20240111212424.3572189-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111212424.3572189-1-willy@infradead.org>

On Thu, Jan 11, 2024 at 09:24:21PM +0000, Matthew Wilcox (Oracle) wrote:
> XFS has an mrlock wrapper around the rwsem which adds only the
> functionality of knowing whether the rwsem is currently held in read
> or write mode.  Both regular rwsems and rt-rwsems know this, they just
> don't expose it as an API.  By adding that, we can remove the XFS mrlock
> as well as improving the debug assertions for the mmap_lock when lockdep
> is disabled.
> 
> I have an ack on the first patch from Peter, so I would like to see this
> merged through the XFS tree since most of what it touches is XFS.

With the minor nits that have already been noticed fix up, the whole
series looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
