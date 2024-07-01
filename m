Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007402F34
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 00:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719795554; cv=none; b=OmruEIQaijlUAQJisQK4Zz9y9g0Qy6n58fC442FsERd0LQ5nv/UStpecgOkvFSdxgrLAdQkpmboE0zo6zSAiUCh4Dmx1JA18m/N/HDEVlvFBk8LEq+E1IKo58c85iIWVvD8yHenSg4Iv1ZpMmpPDuuo6eKMdhaqP0tNCdGbbYA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719795554; c=relaxed/simple;
	bh=6+mFvoOeiC9TaFwlOQW/if3BO4Cr4QFnT0gCvn65QPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCXWL4RHwFfbRsa4Dw0Y25OheJxGX+g1agSCgw1hk8nzTJP3LGTntRq/mSicKPfpYbwdvcu5ZoX2hWwTSyIAs+/IWqfeF+AO4DTDgGOfPG5X2w4FGW4/pWGQB82wgRcpS78RmNsqvxGkUpMhAHl3jqeLsAZGOIb5m5pKCUcpvyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=X6Rnmk8F; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="X6Rnmk8F"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-72c03d2926eso1193623a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 17:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719795552; x=1720400352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihmJhyLOf+7wOK+vL09qSkxc1Z0gpUwRV45BcK3P44A=;
        b=X6Rnmk8FY2ysIcPcZBvPk1cEbIRAAoY90FK7fg24NwblstRVrrXRA843rOttElm8hX
         XpYGbE6Gro3QMUqs3drhc9aezdNevfGEPB9fjCyTrWq0FHHQnpQmYMpfKo32JIPFGrQW
         udFhVuIGPeZyFocNGz8/H/0HIBj+Ec+FjY9xm1otsDSr0Zk1sPyQu0zNH1LyMB0EH4Jy
         CWukr9+xiJ/n58R/Wi5Ug2BOW5tfzY0NYMwoUwythl8VIS+DsAIKFQirNuUX2ssqZQCJ
         6TPjThLqBYy07B5OT0NCT6mn4I/mmshQRwDd7vlHeX0st9XC713Pnt/cntVPprUmZeXd
         xHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719795552; x=1720400352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihmJhyLOf+7wOK+vL09qSkxc1Z0gpUwRV45BcK3P44A=;
        b=ZXbUhCOqQ4jCjvhjF9L1qQNgwN+/gV+EfYbWpKppaJAdxoyKIKosP1jL/xKIZojsyY
         3S2FNNmEWIzL1EznFWbyWgApp0P1yY6hmkX9AN8DvG8EQPvdGCIsaOCU13U0VdQh9s5Z
         8YvpMaIHvhNaKHw49hHTzR3RjZ4sw4IZ0CN5nRR1xcT1j0814uT/WM1PsVtlk5hcqy0a
         K+AS6KWFOKW+Za0Zq/JWIy1FH3c+ffWoGuLDprPrRbE72I55zeNBkTorLbowz36iyFzg
         RsHNiu0bNb1diBBmbnjSis2Om3dRrvnTk+FzSbLPZr01uHfascNR5Pctg6GIx3XF/Za4
         AkCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXG7s0ieEG2PFUrTDJ94GpJhiCbq+XHsjP52JBc6PGVKhDLbVux8xFJJtA06/42eW1JI8UzcUr6LZsY6iozkCRGrnylYEKT5awS
X-Gm-Message-State: AOJu0YxCV6XzdJ1M/H1Pi+ppMjYCafa9iEw9LbO4od4XGrhD8ArnapbO
	e/ODuOoWgT2ypwB/GMjwtG1nyz5KTftH81PwfmaTj4xOE0FvK6tCRlHHOL/U6h4SuXxVGqh7SXR
	O
X-Google-Smtp-Source: AGHT+IHvz8hsL7gh5foaCZxmk7gDf0wSyXIun4vrIhvK90PlLn+imzx6S4H2Lgx+EOmslVWWbft7FA==
X-Received: by 2002:a05:6a20:3948:b0:1bd:1d6e:d444 with SMTP id adf61e73a8af0-1bef60f3db9mr3335801637.2.1719795552111;
        Sun, 30 Jun 2024 17:59:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1facea87fa5sm44695375ad.131.2024.06.30.17.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 17:59:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO5Nt-00HMEF-0x;
	Mon, 01 Jul 2024 10:59:09 +1000
Date: Mon, 1 Jul 2024 10:59:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 10/11] xfs: grant heads track byte counts, not LSNs
Message-ID: <ZoH/XRnChpIYZEUH@dread.disaster.area>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620072146.530267-11-hch@lst.de>

On Thu, Jun 20, 2024 at 09:21:27AM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The grant heads in the log track the space reserved in the log for
> running transactions. They do this by tracking how far ahead of the
> tail that the reservation has reached, and the units for doing this
> are {cycle,bytes} for the reserve head rather than {cycle,blocks}
> which are normal used by LSNs.
> 
> This is annoyingly complex because we have to split, crack and
> combined these tuples for any calculation we do to determine log
> space and targets. This is computationally expensive as well as
> difficult to do atomically and locklessly, as well as limiting the
> size of the log to 2^32 bytes.
> 
> Really, though, all the grant heads are tracking is how much space
> is currently available for use in the log. We can track this as a
> simply byte count - we just don't care what the actual physical
> location in the log the head and tail are at, just how much space we
> have remaining before the head and tail overlap.
> 
> So, convert the grant heads to track the byte reservations that are
> active rather than the current (cycle, offset) tuples. This means an
> empty log has zero bytes consumed, and a full log is when the
> reservations reach the size of the log minus the space consumed by
> the AIL.
> 
> This greatly simplifies the accounting and checks for whether there
> is space available. We no longer need to crack or combine LSNs to
> determine how much space the log has left, nor do we need to look at
> the head or tail of the log to determine how close to full we are.
> 
> There is, however, a complexity that needs to be handled. We know
> how much space is being tracked in the AIL now via log->l_tail_space
> and the log tickets track active reservations and return the unused
> portions to the grant heads when ungranted.  Unfortunately, we don't
> track the used portion of the grant, so when we transfer log items
> from the CIL to the AIL, the space accounted to the grant heads is
> transferred to the log tail space.  Hence when we move the AIL head
> forwards on item insert, we have to remove that space from the grant
> heads.
> 
> We also remove the xlog_verify_grant_tail() debug function as it is
> no longer useful. The check it performs has been racy since delayed
> logging was introduced, but now it is clearly only detecting false
> positives so remove it.
> 
> The result of this substantially simpler accounting algorithm is an
> increase in sustained transaction rate from ~1.3 million
> transactions/s to ~1.9 million transactions/s with no increase in
> CPU usage. We also remove the 32 bit space limitation on the grant
> heads, which will allow us to increase the journal size beyond 2GB
> in future.
> 
> Note that this renames the sysfs files exposing the log grant space
> now that the values are exported in bytes.  This allows xfstests
> to auto-detect the old or new ABI.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [hch: move xlog_grant_sub_space out of line,
>       update the xlog_grant_{add,sub}_space prototypes,
>       rename the sysfs files to allow auto-detection in xfstests]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Updates look fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
