Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8256088D
	for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 23:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707868227; cv=none; b=q76AGNByg+eLmk1cnMQ8dDAfMwMAn9iq/DLTelra7oPnIjOYXiRTZ6kzZJhxtUAlMXzK/tVfjmNMJ9RojWhVBqgXQ9egNoTfPo4lW5BnnBkUi4RI1Rh2Vw+4y+oGGH4o415fPfc8VcNlzTkbygWCRm7J3B3Zpgof5oMEpfcm+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707868227; c=relaxed/simple;
	bh=oWycodL9L3zii0Ov8/Q+DQMHgh0JEikOVGPhH652GPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryo8yOVYsJOHDsrRNNoZeQX8pHOD02/iDaCE6aRFhZOH9rBFr7uM8q4y7SIyALjOksJgQRIqjAsukL/SKGqQKdt5q8LrxnYOkTcM4oELnVe6ka+IP+K3GkAPLg1kB8rk1WOyAGiYQ+K6ZG6VevHNCNih57bTzBKxpjG8mbvBFYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FfBP6i2F; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FfBP6i2F"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d73066880eso45031815ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 15:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707868225; x=1708473025; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IYMQSSFks5P2/r408Gknbi9pYvYwzKSkrlXyjrfh77c=;
        b=FfBP6i2FgQZ2YUpoPQaYycA/5CAia9oRP77PYB6SL2rhQ0Gkh9R68FeXvzJFH1JWEl
         iw691uB04BFMTURrqFwquSeizCFC6x7PzSPm9q0WVgoUY43mAW8BVqi2RmRPrTaP9XOZ
         W80VSIxU6TCQSAdxxEHTO58Hrvs1J8lkvNuA/UkqtTU701WXhUb345j2ixObwMaXtunj
         krwoVCzX7RyzMhAi5tuqLkryHt62QZq6nzZDA2N8U6EUxVtGvhPOrs8vjHJGJMexlVce
         A2FXe08yGefZzK/rZcrrnhvlBt95SL91ZjLvrFISObJxBGReKPp4AoAvzKfWQ6pdxPEt
         mESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707868225; x=1708473025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYMQSSFks5P2/r408Gknbi9pYvYwzKSkrlXyjrfh77c=;
        b=oR3CjG5KJLDuXWg4Sxrall2elgAZQShr7yofSIThOfHawpNcdvPTHPThw0dfCQHbDZ
         fraL4wdpfhUV3PO5+XpwUngyaxAn8STe2WMEoNci9cqmVOdGm8PXV/A0QdU2R++969z0
         z5WfjXK76PyMIw75flDhvxeL5496mkBA4JwCZculYs9AY96EXwg+i3DkEjApmYjfg2m5
         KZ/tOX61++lubtaXR8BoQAN6oVmrp2YUzbxDPgy3sJoVcBTWF/rIRnxmGWOGvbQO8e0S
         mKj2gJpgDpPBCRu4jYjwgA3fCniRWX/AGyoI9+8kwb1RR6AMvFShTxiGJVGleT9Pb3b0
         dxNA==
X-Forwarded-Encrypted: i=1; AJvYcCUjOcxQ0TyCPGCqaVqy1+0yOzoIB+0TId8pSlqTus4GpjNGhdGKSsg+L3X1PdDa45fgJKhQg1WoJClYTbXs67rxlbucw6gNc356
X-Gm-Message-State: AOJu0YydiJ9/fPZH7qm25llRdZiI5ccz3OZwUwd1LbzuqLBFAWdbjHE5
	Z1YW9jJMD5TSevEbL7WD1I/3r89vBgMvpiWOOjhj2RSkdPm7fZ9qab+VIA3tv74=
X-Google-Smtp-Source: AGHT+IF6zlBphRv2UyLjtBaQyeX0AKwUx82y5z3w17Y0iKO+2tEkGu7gy45BCPQV9/quH1r+E/HbrQ==
X-Received: by 2002:a17:902:ab8f:b0:1db:2ad9:9393 with SMTP id f15-20020a170902ab8f00b001db2ad99393mr964554plr.48.1707868225444;
        Tue, 13 Feb 2024 15:50:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUI7WapGKA5HInhT2xg3cyB085Cx4TiIwK3oURVy7Mt75n3BPzYEoV1R6LYcSVaUKFGLBEWL6W48qCAzF/HqCzB5I41KmFhdxefeEzKFZx0mWrPEFPFAvQ60+qj45lykZ7TWrgpe+WUl2xB9iKmIUkrRG2LRm8EijirWucVYI31QRpQBJLSR/W4qZ1czK667qxBiGZViG8gMp+IZo4xSROsfdQ6YyY9JPr6p/jmQdUlU2MYjGUsUWHF+f6/MS1fWqP7akaP+yhqMG7tceQwu/ntM50nkvnb05XeH2sN05pkOWMm3Kokjmcs83T2xOMcy2gAzuh6xsfK43eL6q7oFF4q3sAHOfxE+MVkPu38SQFVIIxLl3ovABUjqy+53cMFXsl4VR3j1Hd5NkpO8E4V+Gvao9Lo2MnAHw7er21iQUY3mQnDWzhy0sW2DxFTCQOcoAdu5rY2jAs8tw==
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id kj6-20020a17090306c600b001d9c0c321c6sm2620188plb.67.2024.02.13.15.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 15:50:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ra2Xe-0069aG-2Y;
	Wed, 14 Feb 2024 10:50:22 +1100
Date: Wed, 14 Feb 2024 10:50:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, chandan.babu@oracle.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH 0/6] block atomic writes for XFS
Message-ID: <ZcwAPq8e/ZpAwhYf@dread.disaster.area>
References: <20240124142645.9334-1-john.g.garry@oracle.com>
 <20240213072237.GA24218@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213072237.GA24218@lst.de>

On Tue, Feb 13, 2024 at 08:22:37AM +0100, Christoph Hellwig wrote:
> From reading the series and the discussions with Darrick and Dave
> I'm coming more and more back to my initial position that tying this
> user visible feature to hardware limits is wrong and will just keep
> on creating ever more painpoints in the future.

Yes, that's pretty much what I've been trying to say from the start.

The functionality atomic writes need from the filesystem is for
extent alignment constraints to be applied to all extent
manipulations, not just allocation.  This is the same functionality
that DAX based XFS filesystems need to guarantee PMD aligned
extents.

IOWs, the required filesystem extent alignment functionality is not
specific to atomic writes and it is not specific to a particular
type of storage hardware.

If we implement the generic extent alignment constraints properly,
everything else from there is just a matter of configuring the
filesystem geometry to match the underlying hardware capability.
mkfs can do that for us, like it already does for RAID storage...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
