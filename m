Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D4B633
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068895; cv=none; b=QwptKz2B9Dz2+XLEsNKRFviM116uwxWPHOnG7tO9zx2zU6Y7i1mzQdZeiE5wxXZ/UfDiEqCAC9QaISVAiv4/Y3YwWdtX9Fz0pIWnTGYoFClEpuF2gXGG/OysYluasl1by+lnloVcHqrjlVC59OLG8CYa12G6lvFT/Iq/oQ9I4Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068895; c=relaxed/simple;
	bh=S3eEGSjkR86ZNkdRpe3MVnL+/ySKRYbCgld1pfgBbvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfQ4IFjuZsGPXhewxUgx2r15rrl1ISEfBogMIG9C6i7YY7WMVXNgOIGqBKnq7rGqC4cwJPNyquj9la5jHcD2fanIyMcOGwm48icrSQRgy23oAubMXIYnwx4Jw9Gcu7xAz9Aus5rdf3ejWyPAIg4sMy18HgwGJFSwbUv+VR9Dfec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tAa+nvuJ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tAa+nvuJ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1def89f0cfdso20444165ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068893; x=1711673693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=7HbiphqWxs0ewV61tAtMera9tZGJrkPb6qoFIZT6d6U=;
        b=tAa+nvuJuTrmSfaCrbFch8pBgESrIYDeQ8aJia9+t5p5/JMZUMKK6MJnj1OIYf0l/h
         W9GJkA1wn9usHbCwCA5EqB7XtyetVueRCmB8y5ttaKvCgeeu5C0P3YAogkN4o6e7VRhQ
         ZjR9y2ut0VbYuLK6Dhi6qAEBrrgv0SNYShRWPQfdnYQEJ6zm++RMHYWQ5SLRoXnw/b6d
         PoqW3rcYeUd07h77Cnq5CTq3k2vziJkXZfeVGECEzr2EO2AuggxinJkoGnKuO8GBIHd5
         HOdLsvUDyMRyfi6fTl4/FrkjJePEndKVH1GayyVsbsxWHCVK2WJKnjEV+dATaCCsXlCo
         tzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068893; x=1711673693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7HbiphqWxs0ewV61tAtMera9tZGJrkPb6qoFIZT6d6U=;
        b=s56+y6I1Zc7lrnJI/r4SijG1fdPm24Jeme0fJTOGhCo9h8tRjFl5LoZxB0A5pzT1dy
         nl73c4vXsWTSW/EpAj6qN953yZen5nhtmsTj70fsupdPyluvct/zryu6M2FiMskXzCAt
         5bOtMxAqZKMkYCZDBS/D/enFCVjfquqiOrzE/+HGnv6MTtdH7iRsdGWGlo3vlFoz5+zF
         6Zd3lTAJcULIxx8zddMt3Lwi4TLvSTVb1NmsHR1W4FO5QWP6wsmFhcha08QTBN/pW7Uf
         hHI+X71QFU3mkzS2AUx/w6inHoITFP5pJTajyIPyBh35lGwBcHnk1ihQxz+FCo7b4cTQ
         y5Aw==
X-Gm-Message-State: AOJu0YzjIlhgjlZa6FwhBmef5yYNNOvbwNoRsQaGJclWoMCfHGsRnAQs
	pPjZUqjcxtWq6zUXnPSCXZurkFz1/D0OLb4nGokZ7bIuWg2IKwmlUeLEBVJhvm0TCsdgygPB4df
	g
X-Google-Smtp-Source: AGHT+IFfM4/zOJDAIZh+8vdCyku7oK6xMh9g+N6CY5Zmj2RGzdUzl5kjbA1l4TfFTI0DS40biE1+ug==
X-Received: by 2002:a17:902:e883:b0:1df:f6d0:539a with SMTP id w3-20020a170902e88300b001dff6d0539amr939973plg.15.1711068892885;
        Thu, 21 Mar 2024 17:54:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902b18700b001dd7d00f7afsm511294plr.18.2024.03.21.17.54.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:54:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTBJ-005TZF-2w
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:54:49 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:54:49 +1100
Resent-Message-ID: <ZfzW2VOMhq4nLd1M@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 10:36:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: kill XBF_UNMAPPED
Message-ID: <Zfohkhh/D7KHHZTq@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-5-david@fromorbit.com>
 <20240319173046.GQ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319173046.GQ1927156@frogsfrogsfrogs>

On Tue, Mar 19, 2024 at 10:30:46AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 19, 2024 at 09:45:55AM +1100, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Unmapped buffer access is a pain, so kill it. The switch to large
> > folios means we rarely pay a vmap penalty for large buffers,
> > so this functionality is largely unnecessary now.
> 
> What was the original point of unmapped buffers?  Was it optimizing for
> not using vmalloc space for inode buffers on 32-bit machines?

Largely, yes. This is original XFS-on-Irix design details from the
early 1990s.

The Irix buffer cache could vmap multi-page buffers on demand, but
it could also ask the page allocator/page cache to use use 16kB or
64kB large pages for the buffers to avoid needing vmap. The Irix mm
subsystem was multi-page size aware even on 32 bit machines
(heterogenous, simultaneous use of 4kB, 16kB, 64kB, 256kB, 2MB, and
16MB page sizes within the page cache and the buffer cache was
supported). However, the kernel had a limited vmap pool size even
on 64 bit machines. Hence buffers tended to be mapped and unmapped
at access time similar to how we use kmap_*() on Linux.

As a result, base page size allocation was still always preferred,
so in the cases where vmap or larger pages were not actually
needed they were avoided via unmapped buffers.

It's definitely a positive for us that the linux mm is nearing
functional parity with Irix from the mid 1990s. It means we can
slowly remove the compromises the Linux XFS port had to make to
work on Linux.  If we can now just get GFP_NOFAIL as the the
official memory allocator policy....

> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
