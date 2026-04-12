Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B991E98EF
	for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776024271; cv=none; b=prAUCCs06V7J9hsdjEn8HtagKKWE8G9wMkzxZe8ccTecDJrF0fqnFK+ZlVAkgAKCekD601B1YaZiqMnKzvW+C53Uh/ZZxmHzZAPDJYcZxojwe7ONmt5Et70hV9vY4G6nRlnKM48ZFR+TKSJkcoFBSJCGVrBn5b9KijKOAusOmMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776024271; c=relaxed/simple;
	bh=51TnkSlbMfxn71YheRGrQRBWGKB7t9lPIcpIejRAUxw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLmsRyvVi/OHNcvvnLZdk/Qty2ZVq1W3B2NuDpHf/aAPUqVl3TOj1itend3AZJHIVjZsyqHs9aZbMQKD2VB6iGfGgvH08h6QqBW3o2iAknq0LscW3X39SWpSt0xVEt3A34RPtDUl6ZNC8HSCsFqUUGaV1ELbMqjewHuSA0afo8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8xX+JeB; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8xX+JeB"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so2114868a91.3
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 13:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776024269; x=1776629069; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+n+uvHecK6kDUehBzYAl5Rv5D+nI/Pk+/kCFULnxKRc=;
        b=g8xX+JeBsBHuPaycfS7LXi5rSuu514cq+R4e2UQ43P263VskAsX1gsXoCnDu2WqUuV
         YwKvWgv1vI2fburPUseg2Y0NxH9xHXq4X44XtqQwYGPV/XPpqlv4ANCjGwk9R2kw/i1A
         OOMB44Nn7A/BTppbTxsmneeBPDFddkkUFfjRM7m2hIod9FjzD7RKd6zLzlFizu2ueV5o
         ye4U28igu61QpBkcQik/hTLuXhn2mdYHL11DzRrNXWOUMJmHtHcod2c3TzQV0UTKh+KR
         4ahd8adjJraoI1uPWprWMhCnaH27LQWtdP75PZLFtrgb83mPgvN0qV37TvO++czrrGaP
         NhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776024269; x=1776629069;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+n+uvHecK6kDUehBzYAl5Rv5D+nI/Pk+/kCFULnxKRc=;
        b=R3EDs8beWy1v96EVHhAqBNxGR691Rds+ybqxG7EZubY+Gb/p3+ZyKmPilT71NIffD4
         ySDjkNvA/7jhi+w+XH3edjEtU4IGVK2mqmGoQDUeDjBf5/gjLCf8sN0f5S+Xiq0TQ1co
         2NW04fa9XHOrZvyxcvfWRJCsriHDWvG/0z0ILWnAqHlzm9hMHrfoI9w7Nl13CjJHyN5E
         qyHALHjWo8GZJQGonQn1idEGgMD7K0UfcT3ziyeYkQN+yINfIfgWIfrXsMdTWF8hzM8e
         K38NVm9QIpGKqTY2iSG2PXjCbkMLZ7IxWfkkjf3lV+DTwAOTLPKYjswYebZ58V//PdJe
         y4Sg==
X-Gm-Message-State: AOJu0YxQHayyyITonjDY10c00m8Zpp6bgO89m/VWt1LWBtNT+Sa5KpGY
	BV2p7wDbZZ2zHWQd6yzBjSetTgJjgVIbBoh40RYV0+J94HKXj0NKTAXqg8csiLD6Ahg=
X-Gm-Gg: AeBDies11UxbLbWEOLRtySlIfh8sEJYOTAz9cGFPCp/22gLuJxPkQH7cLD+KTwSWdZg
	C1hA5unuenn+Ln5fh7L5HR9mEi2up/Kw/T3fFIg73gkax4oNo85txrFvLiIOzJaMhO/p65Pln2Y
	6jctYR1nqbtfv8cr1m4bmPIMIrnnySZL8aKnXJ6VeJYmITm1v2poWFjLQl28vQ2bUiPtjfKK0uO
	1RKPJKu7H3laWlBmOR7Tef5qnOiZrheAW27Ypfhd6BUJ3E/xJEPdB7NMYX1xd847KY3XbsqJXMT
	TVEJ/l3rknXRp9k7ZJCSnhfyte9kYjYes98t9ZoAfVYE6HtNa5UT8kMtHbHue0WWjPQrED7+QKl
	M+gFg1pX/8VAvYt49OZPSp7Kz+ZJhVrV1lSI+S6rIzZjSP2eoQ1CbQzSm9lbEZAWX4934deIlZ1
	iUyjNM5r6GWd1ZG7UEcyRm
X-Received: by 2002:a17:90b:4d0e:b0:35b:90e7:c44f with SMTP id 98e67ed59e1d1-35e425381c6mr11085526a91.7.1776024268847;
        Sun, 12 Apr 2026 13:04:28 -0700 (PDT)
Received: from zlang-laptop ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e34e959bcsm13303332a91.0.2026.04.12.13.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 13:04:28 -0700 (PDT)
From: Zorro Lang <zorro.lang@gmail.com>
X-Google-Original-From: Zorro Lang <zlang@kernel.org>
Date: Mon, 13 Apr 2026 04:04:24 +0800
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] mkfs: unify validation behavior for data, log and rt
 dev
Message-ID: <adv4ME5cK9BQFWdy@zlang-laptop>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
References: <20260404163640.1013997-1-zlang@kernel.org>
 <20260404163640.1013997-3-zlang@kernel.org>
 <20260406153726.GD1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260406153726.GD1048989@frogsfrogsfrogs>

On Mon, Apr 06, 2026 at 08:37:26AM -0700, Darrick J. Wong wrote:
> On Sun, Apr 05, 2026 at 12:36:40AM +0800, Zorro Lang wrote:
> > The current validation logic in validate_datadev, validate_logdev,
> > and validate_rtdev is inconsistent and confusing when checking device
> > sizes, particularly when handling file images.
> > 
> > This patch unifies the validation flow by categorizing devices into
> > two distinct cases: "regular file" and "block device". Validation is
> > now performed separately for each case across all three subvolumes to
> > ensure consistent behavior.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > validate_datadev, validate_logdev and validate_rtdev, these three functions
> > handle xi->*.size, cfg->*blocks, and cli->*size inconsistently while also
> > juggling xi->*.isfile status. Three functions ideally have similar validation
> > patterns, but instead of following a template, each function has its own
> > custom implementation, which invites bugs, maintenance overhead and inconsistent
> > behavior, especially for file images.
> > 
> > For example, mkfs.xfs works on an empty data file with -d size=xxx:
> > 
> > # mkfs.xfs -f -d name=/home/emptyfile,size=300m
> > meta-data=/home/emptyfile        isize=512    agcount=4, agsize=19200 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> >          =                       exchange=1   metadir=0
> > data     =                       bsize=4096   blocks=76800, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> > log      =internal log           bsize=4096   blocks=16384, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >          =                       rgcount=0    rgsize=0 extents
> >          =                       zoned=0      start=0 reserved=0
> > 
> > But for log or rt, we got below weird errors:
> > 
> > # mkfs.xfs -f -l logdev=/home/emptyfile,size=128m /dev/pmem1
> > size 128m specified for log subvolume is too large, maximum is 0 blocks
> > ...
> > # mkfs.xfs -f -r rtdev=/home/emptyfile,size=128m /dev/pmem1
> > Invalid zero length rt subvolume found
> > ...
> > 
> > One said the "size=128m" is too large, maximum is 0 (??? due to the file
> > size is 0). The other one ignored the "size=128m", just complained the empty
> > file.
> > 
> > Thanks,
> > Zorro
> > 
> > 
> >  mkfs/xfs_mkfs.c | 115 ++++++++++++++++++++++++++++++------------------
> >  1 file changed, 72 insertions(+), 43 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 9a93330f..5a2274ed 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3839,34 +3839,37 @@ validate_datadev(
> >  {
> >  	struct libxfs_init	*xi = cli->xi;
> >  
> > -	if (!xi->data.size) {
> > +	if (!xi->data.isfile) {
> >  		/*
> >  		 * if the device is a file, we can't validate the size here.
> >  		 * Instead, the file will be truncated to the correct length
> >  		 * later on. if it's not a file, we've got a dud device.
> >  		 */
> > -		if (!xi->data.isfile) {
> > +		if (!xi->data.size) {
> >  			fprintf(stderr, _("can't get size of data subvolume\n"));
> >  			usage();
> > -		} else {
> > -			if (!cli->dsize) {
> > +		}
> > +		if (cfg->dblocks) {
> > +			/* check the size fits into the underlying device */
> > +			if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
> >  				fprintf(stderr,
> > -_("Warning: Empty file needs a data subvolume size by -d size=<value> option\n"));
> > +_("size %s specified for data subvolume is too large, maximum is %lld blocks\n"),
> > +				        cli->dsize,
> > +				        (long long)DTOBT(xi->data.size, cfg->blocklog));
> >  				usage();
> >  			}
> > +		} else {
> > +			/* no user size, so use the full block device */
> > +			cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);
> >  		}
> > -	} else if (cfg->dblocks) {
> > -		/* check the size fits into the underlying device */
> > -		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
> > +	} else {
> > +		if (!cfg->dblocks && !xi->data.size) {
> >  			fprintf(stderr,
> > -_("size %s specified for data subvolume is too large, maximum is %lld blocks\n"),
> > -				cli->dsize,
> > -				(long long)DTOBT(xi->data.size, cfg->blocklog));
> > +_("Warning: Empty data file needs a data subvolume size by -d size=<value> option\n"));
> >  			usage();
> > +		} else if (xi->data.size && !cfg->dblocks) {
> > +			cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);
> >  		}
> > -	} else {
> > -		/* no user size, so use the full block device */
> > -		cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);
> 
> I think this rearrangement preserves all the datadev validation checks,
> then makes the log/rt validation code look almost the same, except for
> which variables are accessed.  That change looks ok to me, but it's
> disappointing that there isn't a third patch that actually refactors all
> three into a single function, seeing as the commit message talks about
> unifying the implementations.

Thanks Darrick, you're right. I actually considered adding another patch
initially, but I wasn’t entirely confident in the modified logic since we
lack a regression test case for this specific mkfs.xfs behavior. Although
I’ve done some manual testing, I wanted to send this out for review first,
specially the "zt->rt.nr_zones" part, I'm not sure if I have missed
something. If the general approach looks good, I can send a v2 to have the
3rd patch.

Thanks,
Zorro

> 
> --D
> 
> >  	}
> >  
> >  	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS(cfg)) {
> > @@ -3925,19 +3928,31 @@ _("log size %lld too large for internal log\n"),
> >  		usage();
> >  	}
> >  
> > -	if (!cfg->logblocks) {
> > -		if (xi->log.size == 0) {
> > +	if (!xi->log.isfile) {
> > +		if (!xi->log.size) {
> > +			fprintf(stderr, _("can't get size of log subvolume\n"));
> > +			usage();
> > +		} else if (cfg->logblocks) {
> > +			/* check the size fits into the underlying device */
> > +			if (cfg->logblocks > DTOBT(xi->log.size, cfg->blocklog)) {
> > +				fprintf(stderr,
> > +_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
> > +				        cli->logsize,
> > +				        (long long)DTOBT(xi->log.size, cfg->blocklog));
> > +				usage();
> > +			}
> > +		} else {
> > +			/* no user size, so use the full block device */
> > +			cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
> > +		}
> > +	} else {
> > +		if (!cfg->logblocks && !xi->log.size) {
> >  			fprintf(stderr,
> > -_("unable to get size of the log subvolume.\n"));
> > +_("Warning: Empty log file needs a log subvolume size by -l size=<value> option\n"));
> >  			usage();
> > +		} else if (xi->log.size && !cfg->logblocks) {
> > +			cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
> >  		}
> > -		cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
> > -	} else if (cfg->logblocks > DTOBT(xi->log.size, cfg->blocklog)) {
> > -		fprintf(stderr,
> > -_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
> > -			cli->logsize,
> > -			(long long)DTOBT(xi->log.size, cfg->blocklog));
> > -		usage();
> >  	}
> >  
> >  	if (xi->log.bsize > cfg->lsectorsize) {
> > @@ -3968,31 +3983,45 @@ _("size specified for non-existent rt subvolume\n"));
> >  		cfg->rtbmblocks = 0;
> >  		return;
> >  	}
> > -	if (!xi->rt.size) {
> > -		fprintf(stderr, _("Invalid zero length rt subvolume found\n"));
> > -		usage();
> > -	}
> >  
> > -	if (cli->rtsize) {
> > -		if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
> > -			fprintf(stderr,
> > +	if (!xi->rt.isfile) {
> > +		if (!xi->rt.size) {
> > +			fprintf(stderr, _("can't get size of realtime subvolume\n"));
> > +			usage();
> > +		}
> > +		if (cfg->rtblocks) {
> > +			/* check the size fits into the underlying device */
> > +			if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
> > +				fprintf(stderr,
> >  _("size %s specified for rt subvolume is too large, maximum is %lld blocks\n"),
> > -				cli->rtsize,
> > -				(long long)DTOBT(xi->rt.size, cfg->blocklog));
> > +				        cli->rtsize,
> > +				        (long long)DTOBT(xi->rt.size, cfg->blocklog));
> > +				usage();
> > +			}
> > +		} else {
> > +			/* no user size, so use the full block device */
> > +			if (zt->rt.nr_zones) {
> > +				cfg->rtblocks = DTOBT(zt->rt.nr_zones * zt->rt.zone_capacity,
> > +				                      cfg->blocklog);
> > +			} else {
> > +				cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
> > +			}
> > +		}
> > +	} else {
> > +		if (!cfg->rtblocks && !xi->rt.size) {
> > +			fprintf(stderr,
> > +_("Warning: Empty rt file needs a rt subvolume size by -r size=<value> option\n"));
> >  			usage();
> > +		} else if (xi->rt.size && !cfg->rtblocks) {
> > +			cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
> >  		}
> > -		if (xi->rt.bsize > cfg->sectorsize) {
> > -			fprintf(stderr, _(
> > +	}
> > +
> > +	if (xi->rt.bsize > cfg->sectorsize) {
> > +		fprintf(stderr, _(
> >  "Warning: the realtime subvolume sector size %u is less than the sector size\n\
> >  reported by the device (%u).\n"),
> > -				cfg->sectorsize, xi->rt.bsize);
> > -		}
> > -	} else if (zt->rt.nr_zones) {
> > -		cfg->rtblocks = DTOBT(zt->rt.nr_zones * zt->rt.zone_capacity,
> > -				      cfg->blocklog);
> > -	} else {
> > -		/* grab volume size */
> > -		cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
> > +		        cfg->sectorsize, xi->rt.bsize);
> >  	}
> >  
> >  	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
> > -- 
> > 2.52.0
> > 
> > 
> 
