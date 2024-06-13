Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E1E37C
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 06:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718258640; cv=none; b=VwIL9o9L94r5QKwFJfV93H/OucMvjQwVsVjoB20jLAcp9FKrxRrO00APafBtKRPy0qNEFLd5kjv8NVQ4s+tKy9Gn4tSQNknjL+E7Ze5LNCQ/R3eNIwvvruz92zmd3/wDORrxsMFl2ptbwW5KW3HRRC/E+5efKRXSxP4ZPai0zeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718258640; c=relaxed/simple;
	bh=lsmV8e5FR5lS/ECjluBYAj1pA4tMlv4kw4KfuHxRfVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnTLpbETGCVjCGfkk/bce+52lpB2hUbC9e9uSt9gyuMoXv0MKbIIkuAq/OSQo2RhIl6eAkKoZ3aKhBW+2vVsmzNz3gNpQl3g2Px9FGK9TZlu1pZGhljhA4RAQmRtb+ws65AaC00U+roT3JSzZkxnEscuCT1dP9QVW75nz8oalnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=GXY1HdwB; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="GXY1HdwB"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-6818eea9c3aso508098a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 23:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718258637; x=1718863437; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZnoGMxyJ4ewE2MaMY28TMBdZdb8/KfEaqnPDeMvJXs=;
        b=GXY1HdwBezhsBzSQpuXhmFC3QqLWJVi84xPI2CIn91hB03k1+p6jrX0bu/YbcwVoqk
         fFJcqxDe5faadzHwnhfgp7PUl8j4R/GVsp56mZBx74KDDqFV5QhCKoxjiWG0LYpb9Yw0
         7+FzFhkdUtK4vBY06JOZ2fqzpnCAi6ezErDEeSliPFidIUIZsc+4HU/AOFyNt0hsdxP5
         ik2CCpx/vLZDzozVNjbz+jnOXjV3PMOVdnfKe+gw5rL7HFT4BZ2Pe6XYSFG6/0My+ipX
         5gGuM57PG4k+fK8dEW04HuX2ANa1zfPQSmyRXD3+JBlqMuGQfYRxUGzmlKfgcT4xtBWr
         iL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718258637; x=1718863437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ZnoGMxyJ4ewE2MaMY28TMBdZdb8/KfEaqnPDeMvJXs=;
        b=MmNk4LEFWdBgIM+82oEHf9r4mu5vKnZU6FIVMSzYYvI+KgsOBJpJ9Vhi3HJOhLiw18
         dLg8sqKSr0QLDdFEfA7S6ftQ4gdZNzEnrQsR4dvuPwEuEzXMKJkS7nzEZMf1flQJy3R3
         chxmjCr6m/OTvlcvrYCC0TaYV+da91nycBCntu1TfM+TZQFGsaf4GkB1gQTuMAQfiyvh
         RGlv+aa5uvh8dG2kG5o0kqewIi1bvZ9/qDT9g3OqqxLWuRitOTYYPsKGfiTyVVZ+aI86
         ysTXhtzQTBiSccdPzQVTvU+Np7BPzv6UXQtnVe/JpvyQzv7z0pzjuJydO/q5GfTk6NXY
         ZxHw==
X-Forwarded-Encrypted: i=1; AJvYcCVk9lX5CN+sJLv6bO7xOltJrX/BTdpeMwHDpAZFI7ihaVoeaKXUEbo64jf8wCX9oYBlYUA6aFWXqOzogL8MQO3nFQ/Js52mzDC/
X-Gm-Message-State: AOJu0YySPZvkt/39A7jPYLjXlEzF5bxtvjfNkDG4Vh3dzqfIakUbLsoF
	4BGsNWIVGmkgUB7PuaxilcUIOd4uNH09TgMse7culX6PfIvcYucqwAJsbzkKUZtbTc+iCtz7WQP
	0
X-Google-Smtp-Source: AGHT+IFrHC9araD51yDeTlxVHXOu6cwaobKLLmBzokMGb6zNu+PkBpiMzenCkajNPKqi4bfPGlA5kQ==
X-Received: by 2002:a05:6a20:3d88:b0:1b7:8b89:e55b with SMTP id adf61e73a8af0-1b8ab6ab87dmr4499377637.56.1718258636998;
        Wed, 12 Jun 2024 23:03:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c45cb217sm725757a91.18.2024.06.12.23.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 23:03:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sHdYv-00EBsB-39;
	Thu, 13 Jun 2024 16:03:54 +1000
Date: Thu, 13 Jun 2024 16:03:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: don't treat append-only files as having
 preallocations
Message-ID: <ZmqLyfdH5KGzSYDY@dread.disaster.area>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs>

On Wed, Jun 12, 2024 at 10:46:48AM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The XFS XFS_DIFLAG_APPEND maps to the VFS S_APPEND flag, which forbids
> writes that don't append at the current EOF.
> 
> But the commit originally adding XFS_DIFLAG_APPEND support (commit
> a23321e766d in xfs xfs-import repository) also checked it to skip
> releasing speculative preallocations, which doesn't make any sense.

I disagree, there was a very good reason for this behaviour:
preventing append-only log files from getting excessively fragmented
because speculative prealloc would get removed on close().

i.e. applications that slowly log messages to append only files
with the pattern open(O_APPEND); write(a single line to the log);
close(); caused worst case file fragmentation because the close()
always removed the speculative prealloc beyond EOF.

The fix for this pessimisitic XFS behaviour is for the application
to use chattr +A (like they would for ext3/4) hence triggering the
existence of XFS_DIFLAG_APPEND and that avoided the removal
speculative delalloc removed when the file is closed. hence the
fragmentation problems went away.

Note that fragmentation issue didn't affect the log writes - it
badly affected log reads because it turned them into worse case
random read workloads instead of sequential reads.

As such, I think the justification for this change is wrong and that
it removes a longstanding feature that prevents severe fragmentation
of append only log files. I think we should be leaving this code as
it currently stands.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
