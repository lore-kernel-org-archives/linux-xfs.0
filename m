Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54556487B3
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 21:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707771989; cv=none; b=GPpd8D5vNbNCTSza7LuOdtqLiLB6M6j+m3N8K50HHFTaOhOuIjR37hSQuG5plpMNScrR7mgbE27fFrIhJYp30MvV2B7T1Iyc2i6Cp/AKJhArHLGYRUWCMlN/zToF/GFzf3tq96uixXZnNcd8Kf8+NtqtnALX1WlKfAGOngsqOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707771989; c=relaxed/simple;
	bh=VOZ0Mxsihm3bjZWlToucx56xowq6uQw2yUTgu3gthwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mXfzWwuNJWln7liR0ruJRKUvibbnl943aswfbZ1aK56wMkK7MGOzisY5mJCG7H0fYmgOVP56ua5aCTxrcTwyg3wTNlyArxBzZXx6lRfAo8+89zMWP6TEp77cGI4DSO4OyM5SQBzkg/4qjEOD4wbRYe6nYNCEYWPT5/em9l9KgEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qgFPgIEJ; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qgFPgIEJ"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2970f940b7cso1365096a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 13:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707771986; x=1708376786; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=031Uhabmhg3Wfutkhct0qCCNA84KCxBAOLbJhkY2TAI=;
        b=qgFPgIEJgksOh+V/O4oxRx42DbOxyoiiKOMnM3wlZBZ4gQLwbwH6MZqNB0wFY0C/mK
         zVz4qrhev1OsVQ04WHCQrp955H68v/I84HjtQeudq6w5aprXplBiOZ1CwaIxCrBR4BFS
         Sixb+3/VNPS8O6RdILTjOR8gY6RYxdOsdLns3NqDnZ6WFYri/PH4VnpFTm5jdU6Q1mOH
         gqZzyEBfMZQLSRalXQiHIE8pqAPTctIp+sGIMRvfWaoDbcWg/0nMseOJgb5upzaq1pls
         REib0QXbjCCmPk93ZRe20x9Zk5mS/r4q0BebE9Et1g6w6eKUHF9CXYmeeytUFmzWjpSK
         YVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707771986; x=1708376786;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=031Uhabmhg3Wfutkhct0qCCNA84KCxBAOLbJhkY2TAI=;
        b=epTUNxquVi6QK2/dCCQGO2N4bGOSEiK5W6ZshpWvs6BkMA89Asl/OHwQNqWncERIBm
         7rYuK/WXSJJrUcAmawQk9csBckNa/OMyV7JgZWR5+73L/lWk0QLYLOYzd5KZW66s72z/
         Man1wLMruwUr3HbO52iIZEcI2Itlni0WxkdV1UelOWJw2h1mw5OhI/8lAzQsiWFjR65+
         L6ZTPvGFSCK6yHEhjNiUoutu4OTNgJ9aMANUyD7/eF0sQSZWhAHv0MutjWI29wP5mUT1
         DfEBYSV/B1Qek1L31m6dTWRDGc2lTtZOOeqrhkRvz5PBUVB4A7nFBtEeVpSP6o4kyQ1A
         Is+A==
X-Forwarded-Encrypted: i=1; AJvYcCUqPyO6X+Xni5A17ioxFMYgBSBcHUWQAossotRucz8u2PUIwmyyL2xLSBZfzON2oMKKhsHWXt+W3XCBjs3kRYht1niOAq6LLL2u
X-Gm-Message-State: AOJu0YxOblOcSM7/RiAn4t2WmAHUp8mgj7v7y+6gijwmCNzUM4JWVAfD
	jDkP19Vm2811S5aWlpNQjOQyRbB9VaaoLo2JWKF3JAWi9rkrYeNbKFSruftbCKc=
X-Google-Smtp-Source: AGHT+IEP2dwuR56P1W5zjqR6nxvxRLnNfmaGSPRXjaJPy7Nd0yrs0qcrUAphd6FoI1wm57BCpCw7Pg==
X-Received: by 2002:a17:90b:104f:b0:297:322b:1916 with SMTP id gq15-20020a17090b104f00b00297322b1916mr2379408pjb.15.1707771986555;
        Mon, 12 Feb 2024 13:06:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWcLnrKzUtuT8KJq3izPDnQlNGSJlp5eVLWXJIE9LU+a5e9p/Sl3OHNfwKkKsNGZZkUDz9VkCxbtXXwZAvt/q6aFraRzpCGv0op
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id h24-20020a17090adb9800b00296f4f643d5sm970263pjv.25.2024.02.12.13.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 13:06:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rZdVO-005egX-1f;
	Tue, 13 Feb 2024 08:06:22 +1100
Date: Tue, 13 Feb 2024 08:06:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jorge Garcia <jgarcia@soe.ucsc.edu>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: XFS corruption after power surge/outage
Message-ID: <ZcqITqNBz6pmgiHJ@dread.disaster.area>
References: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
 <6ecca473-f23e-4bb6-a3c3-ebef6d08cc7e@sandeen.net>
 <CAMz=2ccSrb9bG3ahRJTpwu2_8-mQDtwRz-YmKjkH+4qoGoURxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMz=2ccSrb9bG3ahRJTpwu2_8-mQDtwRz-YmKjkH+4qoGoURxQ@mail.gmail.com>

On Mon, Feb 12, 2024 at 10:07:33AM -0800, Jorge Garcia wrote:
> On Sun, Feb 11, 2024 at 12:39 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> > I was going to suggest creating an xfs_metadump image for analysis.
> > Was that created with xfsprogs v6.5.0 as well?
> 
> > so the metadump did not complete?
> 
> I actually tried running xfs_metadump with both v5.0 and v6.5.0. They
> both gave many error messages, but they created files. Not sure what I
> can do with those files

Nothing - they are incomplete as metadump aborted at when it got
that error.

> > Does the filesystem mount? Can you mount it -o ro or -o ro,norecovery
> > to see how much you can read off of it?
> 
> The file system doesn't mount. the message when I try to mount it is:
> 
> mount: /data: wrong fs type, bad option, bad superblock on /dev/sda1,
> missing codepage or helper program, or other error.
> 
> and
> 
> Feb 12 10:06:02 hgdownload1 kernel: XFS (sda1): Superblock has unknown
> incompatible features (0x10) enabled.
> Feb 12 10:06:02 hgdownload1 kernel: XFS (sda1): Filesystem cannot be
> safely mounted by this kernel.
> Feb 12 10:06:02 hgdownload1 kernel: XFS (sda1): SB validate failed
> with error -22.

That has the XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR bit set...

> I wonder if that is because I tried a xfs_repair with a newer version...

.... which is a result of xfs_repair 6.5.0 crashing mid way through
repair of the filesystem. Your kernel is too old to recognise the
NEEDSREPAIR bit. You can clear it with xfs_db like this:

Run this to get the current field value:

# xfs_db -c "sb 0" -c "p features_incompat" <dev>

Then subtract 0x10 from the value returned and run:

# xfs_db -c "sb 0" -c "write features_incompat <val>" <dev>

But that won't get you too far - the filesystem is still corrupt and
inconsistent. By blowing away the log with xfs_repair before
actually determining if the problem was caused by a RAID array
issue, you've essentially forced yourself into a filesystem recovery
situation.

> > If mount fails, what is in the kernel log when it fails?
> 
> > Power losses really should not cause corruption, it's a metadata journaling
> > filesytem which should maintain consistency even with a power loss.
> >
> > What kind of storage do you have, though? Corruption after a power loss often
> > stems from a filesystem on a RAID with a write cache that does not honor
> > data integrity commands and/or does not have its own battery backup.
> 
> We have a RAID 6 card with a BBU:
> 
> Product Name    : AVAGO MegaRAID SAS 9361-8i
> Serial No       : SK00485396
> FW Package Build: 24.21.0-0017

Ok, so they don't actually have a BBU on board - it's an option to
add via a module, but the basic RAID controller doesn't have any
power failure protection. These cards are also pretty old tech now -
how old is this card, and when was the last time the cache
protection module was tested?

Indeed, how long was the power out for?

The BBU on most RAID controllers is only guaranteed to hold the
state for 72 hours (when new) and I've personally seen them last for
only a few minutes before dying when the RAID controller had been in
continuous service for ~5 years. So the duration of the power
failure may be important here.

Also, how are the back end disks configured? Do they have their
volatile write caches turned off? What cache mode was the RAID
controller operating in - write-back or write-through?

What's the rest of your storage stack? Do you have MD, LVM, etc
between the storage hardware and the filesystem?

> I agree that power issues should not cause corruption, but here we
> are.

Yup. Keep in mind that we do occasionally see these old LSI
hardware raid cards corrupt storage on power failure, so we're not
necessarily even looking for filesystem problems at this point in
time. We need to rule that out first before doing any more damage to
the filesystem than you've already done trying to recover it so
far...

> Somewhere on one of the discussion threads I saw somebody mention
> ufsexplorer, and when I downloaded the trial version, it seemed to see
> most of the files on the device. I guess if I can't find a way to
> recover the current filesystem, I will try to use that to recover the
> data.

Well, that's a last resort. But if your raid controller is unhealthy
or the volume has been corrupted by the raid controller the
ufsexplorer won't help you get your data back, either....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
