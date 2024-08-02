Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7418F4C70
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 00:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722557793; cv=none; b=n4Ng8FRIs5w3ooetYePelx40iRLu30p9jkNtyh1PHyiWy0obg5bpCzY25d3bWyzjSY61KGv/pGJbitqjtE5mpT6Q0rhIWEcKTr4jJApnqp1rhojsCum+94ucbYgrFO7d2dM0yN/bQwEDt/e8KDhCxaGpoxM5HZmIcLlreepnTMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722557793; c=relaxed/simple;
	bh=gv0MSjTTxtetpP1I5Q0ld5WOmfLG/jl/3ZbphmqXk7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CebfCrtIRC3UJnAT2gh90Z0yiKM8+Ed/1z3TbISYjksf1Fz/9Vibge6P1VKzTkO6t7zW5UdY2+ZaieLeQA4Zj6VjOtgyOoOKxbJ+KVpQjZ6AO88uKR7tonnfxPCdtgbHCE7k1D3aJWXOWncEUzapBRv0iZTuWbamjnkjQKXtMr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eq18qnBA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eq18qnBA"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fd9e6189d5so61254575ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2024 17:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722557792; x=1723162592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5O2y+QX/4+AvfWat8SXeriUYt2eRpPEagaMMXLYINk=;
        b=eq18qnBAP1Y41hHojGR56cnJDFMU9z/iJ0HzI3mgxSEMtUtoeRdpcitC3QHVEU7Yis
         4vfV+1WgxhCS57vJJZ0pxmQmgFRIyu5pJOoV6mTSsd9SOeEAdH6lFY3Dfx8a7+MpwA8/
         8wbmz1JvZnb8IhfARl5cV2t8+8rZYbCKK1bHUyXMlVAwMGoeVqKVR/jjiombbvduMZTS
         qY8FJOtKVq79fIyxU0q7y9WtFEsZIEdmw3DhgS5knScvajbtgrasTI7phOXOlZjpEZoP
         X7qMl6IfvkpystLU4+wViCiP0sUYSU49coRLFG9hjb4Nxxw2O5rLTF1dp6G+c1ZPZqGL
         2iwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722557792; x=1723162592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5O2y+QX/4+AvfWat8SXeriUYt2eRpPEagaMMXLYINk=;
        b=flqQQH7CuxQpaiW/kPoFbU5Q34h26/JMYvcgQjbKSEu/duU99gaO2yUlDmLKDWystW
         FYko+imsejrux1cO1dRiulyK9P2L7ee9WF8aYmUo6xUza3BS67PZKh2wV04SwugtNhJA
         Eigj5FTQGyUgzXK3s+XcUzBGGKamoBNDdjA+GKBrOBeRJgHD/H1VpYH6BrLSkhCC1+dB
         h5U6MmEvmBfZxQZXQNdhjzUmJdFUz06PcBSWUpao4Wrfteyn8jqNr3UHrWi/IR5TO4fz
         m34scJyOO/J27Z00G0Gz9YOGJgMCAzoyLTtj6A8yxsyJIPcUOuMM9HllS4H0p3V8oPtW
         0RKg==
X-Forwarded-Encrypted: i=1; AJvYcCXnqSWUxyVhQp5KnK9NcQRdLytG500uFyMWnViGXOUMVUoY0dpiuhQe6R9h9G7TiQGV0uLsDCwS17ZTWFpzTQackZNAMdTRfcwW
X-Gm-Message-State: AOJu0YzRE1znZlni3f5QKw3CkmYanO/Yq9Pp3jox7Wuutz/BR9wSQlOu
	uz2h6ISYGBp5xNjkZMx4ID/SDPkbuld5X9415MDo8okSDq3X6Xi9esSU4oU/ES60CQhRyqygt3d
	N
X-Google-Smtp-Source: AGHT+IED/ILVYPuwHi1/Uz0YtlmpTCrj7vPR+yLRUqKIk8PNLDSf+Y2JTEx/rvVAm1tIbDP9SLdPgg==
X-Received: by 2002:a17:902:f60a:b0:1fc:4763:445c with SMTP id d9443c01a7336-1ff572ecabdmr27886065ad.32.1722557791675;
        Thu, 01 Aug 2024 17:16:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f5c5f6sm4919625ad.111.2024.08.01.17.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 17:16:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sZfy8-0023d6-2e;
	Fri, 02 Aug 2024 10:16:28 +1000
Date: Fri, 2 Aug 2024 10:16:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_spaceman: edit filesystem properties
Message-ID: <ZqwlXKpYtu6c5rZ5@dread.disaster.area>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940600.1543753.11770032596501355577.stgit@frogsfrogsfrogs>
 <ZqleFeJhCVee5ttL@infradead.org>
 <20240730223725.GL6352@frogsfrogsfrogs>
 <ZqpbRibHaNodChSt@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqpbRibHaNodChSt@infradead.org>

On Wed, Jul 31, 2024 at 08:41:58AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 30, 2024 at 03:37:25PM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 30, 2024 at 02:41:41PM -0700, Christoph Hellwig wrote:
> > > Is this really a xfs_spaceman thingy?  The code itself looks fine,
> > > but the association with space management is kinda weird.
> > 
> > I dunno.  It could just as easily go into xfs_io I suppose; the tiny
> > advantage of putting it in spaceman is that spaceman grabs the
> > fsgeometry structure on file open so we don't have to do that again.
> 
> For the online changes xfs_io seems ok, and for the offline ones xfs_db
> seems like a perfevt fit anyway.

If fsprops can be managed both online and offline,
then xfs_admin is probably the right user facing interface
to document.  i.e. We already have xfs_admin vectoring between
xfs_io when the filesystem is online and xfs_db when the filesystem
is offline to do things like change UUIDs and labels. This would
make setting fsprops somewhat simpler for admins and scripts as they
then only have to learn/code one mechanism instead of two...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
