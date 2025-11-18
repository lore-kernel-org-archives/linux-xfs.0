Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150B22D4DD
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508640; cv=none; b=Elc6bOJbFgVZK1emiliXzU7kkEJ8lyTbaXulRIuWAtrOCCf1cHkLkVmPBBKZlQciShr6PNh+dWAI2W3HIMQZzv/HKcENZNH95SjmOIaPGZT7/AMBdBJOur78gg7PjGdD5kcjk8JIgXbLVPfVC7dTvKilcui9GM/4nxbsHrZXeB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508640; c=relaxed/simple;
	bh=Ll890/m+4oA95x8d4X0J/e5b2OUfoKs6Dh9eC3XMaNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwnxRrR/HYFQi3lXUgeUgzgejtRbyRMWufS3Wsa8LBj9X80ucwD+0nAvm7DJiKymYP6bjoSwzt6AA+DqNNTz+OEGqfdLivKf5nqaaIl5xqPNB/1m8behTafwWgIovUVgsthpjbG20PMcszGwDICaBKUdgYoEr/8kM1FHhrnp7TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rKdfUEVi; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rKdfUEVi"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3414de5b27eso4916965a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 15:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763508638; x=1764113438; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MnIQ5czAIlDUTiRSsv9UfW61iWVDuRBQUnVcKZcJB1w=;
        b=rKdfUEViRk2eHns7ezpaBZ3rb6Xn7WELhxhLp9wibrXP37D45/opfQ8U/2wzneLYhX
         DQ+7yJTZg1ollHP+oUfyBZI59oSSk0ZNaittOqb35qxXB7TYcwqyWkl1mYc3GH5zdQQj
         DBpmc+wvoeVu45KKzzbWmimB+UiESiDxNl68cfSl0iCRpfZbmCZ8i37HM/G/rrPHkoNc
         GMinkDCJSMinucjmFt4pUg2qsRFxSAU+W1DBOcCF0bnw6eLIV3AFU5OOtcI2d0+EaLtZ
         UtHj0jNUF+ADLSBs01d3xl6rmfbMzWVob0j+RJIPAkZcpFOe85R2CIvTuWMo5/rNgalN
         KFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508638; x=1764113438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnIQ5czAIlDUTiRSsv9UfW61iWVDuRBQUnVcKZcJB1w=;
        b=SfXIA1EDTN/RE5wjprLf5wPf9BOlHLbUJfrWXOJlduJdH8mDnSseQas85g1I1vTlDE
         w8HdXXItOinX5LhE4AUuhxlhXv6WCRHeZ96Crb3rBEaY+WokK2zpvGBqVkiJQlQlu/H6
         bxXdpu7+xaNmmiDOX0JyR05nhFJ/MSLtg423s36/ZKQwBEGs55e7DDIc0bWE2z0HtKqn
         NjC7Fk6qfT3oBiACQUUZzKQCMEXH33K7F/ugouHKlDYiPKn6gdHpVB9yQunXFVo3Q/Hr
         9H6zvd/47dY7x7mELZpm7GvFZExrQ/jSgdWTJPE3RDrauV5LY0WTtPwkakiLQq9dHyNP
         hJWA==
X-Forwarded-Encrypted: i=1; AJvYcCW2fUSCndgYStylTLz3Pk0i0q8djpXtMSbBmiPMu7qp+FegeM92NBDqXIOKewrHj8G0bZ3VGaLEKJE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg0I42yhdeq0T8h1Bc1fAB/sceCpgUGyVG05DolubUyo7cQUqF
	+02L16HMUTu0MbVmWN5sFReNPuGZDbADhltra3vFiF/NC8KoXsztCoS5HlE9OLSycx4=
X-Gm-Gg: ASbGnct1IAkBGU0xrT11NWWLRqHBLEkY9iOAnZhoIpg3F8rkP6wzqx1XCwsXCa+O/yL
	tjJ5F36NYtkQ1eFsgAsH/4BkBC2r/W3Mvo5LeCPymUTr/JEOXZ/pYX9FKhmv9hppz4HNCrshONQ
	uSsmlvUzpaXOzLuc3lilOfSmAth3roaUAsNOCv3mPCvVeScx/IUT+xTYImUn3d21o7CDh4/zjTD
	dMSZtLKu6V8qcjr4B5ZVT+PBtllHG1uxDM2nws8CFep56qsL5oT15WRlwNgi8p9Hxs5UiAkzlFM
	NBeTU0rmEmt8J/92SW7KmCcqgmBdN4S5KGvBIV8KO0I8pV4mQXv9fC/snRdpeGkwEM6DNb2WfBA
	FEfznr/B5Z2EsHGLgtkG6Paf7KMuMg84JIAjOoMrAaLDaJgQY3dNq2kH0obrklTIWGF7t5tcmzo
	FhzhwU4jDH68C5CoAN74V0s6PVQL+L7XCLgCMfA7Va9JK+AkZGIE3KSLrjCODR4xknjvWXGuO2g
	89uRn6bXvQ=
X-Google-Smtp-Source: AGHT+IG0xrV617/K2Q2zctZIX2rlkSw5B1Jp1MywYakVFhxJ0IxXfb/aHGJIAHe675+ap1LI/Djfwg==
X-Received: by 2002:a17:90b:570c:b0:340:cb39:74cd with SMTP id 98e67ed59e1d1-345bd413f51mr358384a91.32.1763508637774;
        Tue, 18 Nov 2025 15:30:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345bc110a6dsm560282a91.14.2025.11.18.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 15:30:37 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vLV9e-0000000Ceqh-0jNc;
	Wed, 19 Nov 2025 10:30:34 +1100
Date: Wed, 19 Nov 2025 10:30:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, dchinner@redhat.com,
	hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
Message-ID: <aR0BmpbQe0s4B80S@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
 <aRSuH82gM-8BzPCU@casper.infradead.org>
 <87ecq18azq.ritesh.list@gmail.com>
 <aRcrwgxV6cBu2_RH@casper.infradead.org>
 <878qg32u3d.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qg32u3d.ritesh.list@gmail.com>

On Tue, Nov 18, 2025 at 09:47:42PM +0530, Ritesh Harjani wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> 
> > On Fri, Nov 14, 2025 at 10:30:09AM +0530, Ritesh Harjani wrote:
> >> Matthew Wilcox <willy@infradead.org> writes:
> >> 
> >> > On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
> >> >> From: John Garry <john.g.garry@oracle.com>
> >> >> 
> >> >> Add page flag PG_atomic, meaning that a folio needs to be written back
> >> >> atomically. This will be used by for handling RWF_ATOMIC buffered IO
> >> >> in upcoming patches.
> >> >
> >> > Page flags are a precious resource.  I'm not thrilled about allocating one
> >> > to this rather niche usecase.  Wouldn't this be more aptly a flag on the
> >> > address_space rather than the folio?  ie if we're doing this kind of write
> >> > to a file, aren't most/all of the writes to the file going to be atomic?
> >> 
> >> As of today the atomic writes functionality works on the per-write
> >> basis (given it's a per-write characteristic). 
> >> 
> >> So, we can have two types of dirty folios sitting in the page cache of
> >> an inode. Ones which were done using atomic buffered I/O flag
> >> (RWF_ATOMIC) and the other ones which were non-atomic writes. Hence a
> >> need of a folio flag to distinguish between the two writes.
> >
> > I know, but is this useful?  AFAIK, the files where Postgres wants to
> > use this functionality are the log files, and all writes to the log
> > files will want to use the atomic functionality.  What's the usecase
> > for "I want to mix atomic and non-atomic buffered writes to this file"?
> 
> Actually this goes back to the design of how we added support of atomic
> writes during DIO. So during the initial design phase we decided that
> this need not be a per-inode attribute or an open flag, but this is a
> per write I/O characteristic.
> 
> So as per the current design, we don't have any open flag or a
> persistent inode attribute which says kernel should permit _only_ atomic
> writes I/O to this file. Instead what we support today is DIO atomic
> writes using RWF_ATOMIC flag in pwritev2 syscall.

Which, if we can't do with REQ_ATOMIC IO, we fall back to the
filesystem COW IO path to provide RWF_ATOMIC semantics without
needing to involve the page cache.

IOWs, DIO REQ_ATOMIC writes are simply a fast path for the atomic
COW IO path inherent in COW-capable filesystems.

This is no different for buffered RWF_ATOMIC writes. We need to
ingest the data into the page cache as a COW operation, then at
writeback time we optimise away the COW operations if REQ_ATOMIC IO
can be performed instead.

Using COW for buffered RWF_ATOMIC writes means don't need to involve
the page caceh at all - this can all be implemented at the
filesystem extent mapping and iomap layers....

> Having said that there can be several policy decision that could still be
> discussed e.g. make sure any previous dirty data is flushed to disk when a
> buffered atomic write request is made to an inode. 

We don't need to care about mixed dirty non-atomic/atomic data on the
same file if REQ_ATOMIC is used as an optimisation for COW-based
atomic IO.  Filesystems like XFS naturally separate COW and non-COW
extents. If we combine non-atomic and atomic data into a single
atomic update at writeback(be it COW or REQ_ATOMIC IO), then we
have still honoured the requested atomic semantics required to
persist the data. It just doesn't matter.

IMO, trying to hack atomic physical IO semantics through the page
cache creates all sorts of issues that simply don't exist when we
use the atomic overwrite paths present in modern COW capable
filesystems....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
