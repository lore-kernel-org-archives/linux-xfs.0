Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A1C2343BE
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758879564; cv=none; b=h8ZJsjd9MZQNTOTTnO8WWRD3BxOv6rHVWXEgEckdLBdpIskbddYJV0WfIF5YaJbh4K790P57RQVc+qTQyQ+/R7l8w5Q8+KNEzJnjUo3CqAOc5MpLusc9N0AmveY+uF9IPfdCVqcjeKK1fuOy519wlwNyWDrdX5PAtsiBQ/56upE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758879564; c=relaxed/simple;
	bh=yATc3DtmryKzb58cor5lo0iKj0xdm61HIlYhU98eHwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EinUBD6ppyvR76DrYJHK5uDspRpqQLrCy1oIRWBRAegsfmXjtbjBGdWcy5mosUlmxxod99MpaLUJFf+YhHE/ouBlFDX51LqasC5BI4h8xFW6NR0cj1GFt080A3u5DCAz7QK8Z76T4Qp7xclBteo0z+cMQ0IP1pyWclSpfcl/QNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=x97B03Hu; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="x97B03Hu"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77f343231fcso1240381b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 02:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758879562; x=1759484362; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NSb5MNv8ZFQulROwH9H8GpX5UqySF14O/Swo6TNfJ0=;
        b=x97B03HuAqKMHPF/n9Sa3kRCCMnz/IQ2r0l65VpIgswol/Ss7gUIv1Tg8cHPh4jKKG
         RG40/zpvRUNVzQqK+svx6t3ci/5bnWpeTPGyRAAplZiix+MTBIQMsx7dXYfHk1Pwqva1
         9/NkcJM0LuhptnY50Quz+OYHa1EvHU0NAq/coaKVjriJ1Pmfs5/aAMGKUnHjXyjHTtpa
         JzovaXoLKyjs1LXZStRD/ez2U/LJHNybMJ9kpGQquuCny7tLtcyx8BSzzvUBfDvJGLzt
         9BFlfRqBl9tQlR5YdkAtQdUhyB1P0uszxfoyZPQzg4W2RdRQ79Z3HiyMU5ASaHs7hmDo
         e9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879562; x=1759484362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NSb5MNv8ZFQulROwH9H8GpX5UqySF14O/Swo6TNfJ0=;
        b=qV595t4u1ceXvQ5LWFfbcdC9Ln9LJZ0aaVY2g8k5kW+aN4ggqv8ZSftV7ZDRZ1WofP
         WNaTCMbw05eJyS6401sXLvugGopKtr+rd29UgIZ9YVDRR9WZ658GRUzb0YxSFdFVnYOl
         QZW/I8GACGc662STIBWJN+EfQ/4N+dBof/E8K6l6V2rpgfuFJ+1SSZc4NKeNgFDGvPqb
         VGZXKvwb91ZvKolvztlwrS9FYv/w4+qvPVCWfJKOZZjQ0ATabPr67klenmAkEoEgBhag
         X3av3j8L9eE2Toj6alfRFpiemWO6GsuNFpi7eEECk54p2JPQXn+J8h9syjwZc1pAD+a4
         4o5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrAmr7YxHiA48VXbEdV1hBgAz0mGalYEdqX9+zaIafbbVNcKADzoiSYRPntFZV1Ydzp8Lk8Bw35WI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFKpAiUBp6hx/UIytjO5tc/JAKFhPQgjZwm4KLbtbd2PtzL3n4
	D3memQfzdVidl/Aj2nlPoeUU/Z3cMw4QzwMJxvZpH99pu0p4P7R9J/YTilKhAr0Utpak3wXRzID
	P1Ys+
X-Gm-Gg: ASbGncvMwQhKq+fYTAqrWhEEmW9XzM6oeJe2W6xIRbMMi6ld8hzM52jZSbLEm20bHEG
	0UKFy7Ai2bCvUdeFEQY7mTjfPzicrn7qtC11CLgHb309y7JUwa+/gd5okdC1DTEFZTBHXhGAMPK
	ew5HoRb9g6DLS0ZMKfkRgf2L0MlJ+X97HhkREXqSP3e2mDarVCpFk2H+ABX0jF31z/dC2BdQpwQ
	o/HEM+5P9Zb4zAttTgSjEo9Jo02lQ1S0ZwW3C1eCD0Qw5rCPG/n5zLrort5yBbIvSnceeOLwgzJ
	KdDoBy+ZQLAhkhntwMtquzP2zh7B7yBcq3yVD2fROUUXxtV5cPlZbuIGO5fmpaUQ4bI+LgoUh7q
	zl1JOrjZvrKamEfyhyIqywKJCIIi62qCJYu5Sv1Vqp3kbwlWO3X6o8IWcjVMUpvPPPk+lyVdtBg
	==
X-Google-Smtp-Source: AGHT+IGP5Ixg8C6fOmIzyvEr++4MnWmWOuMDf0taSpLWMiZ2rSXIY7nzhSROQxBHTk/HoawXM+WeUw==
X-Received: by 2002:a17:903:244d:b0:25c:392c:33be with SMTP id d9443c01a7336-27ed4a5c567mr74533615ad.59.1758879561845;
        Fri, 26 Sep 2025 02:39:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed671e93asm48660035ad.57.2025.09.26.02.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 02:39:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v24v8-00000006v0T-2vQV;
	Fri, 26 Sep 2025 19:39:18 +1000
Date: Fri, 26 Sep 2025 19:39:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: "hubert ." <hubjin657@outlook.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <aNZfRuIVgIOiP6Qp@dread.disaster.area>
References: <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
 <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>

On Fri, Sep 26, 2025 at 09:04:12AM +0000, hubert . wrote:
> >> Regarding the xfs_metadump segfault, yes, a core might be useful to
> >> investigate where the segfault is triggered, but you'll need to be
> >> running xfsprogs from the upstream tree (preferentially latest code), so
> >> we can actually match the core information the code.
> >
> > I figured it was not all the needed info, thanks for clarifying.
> >
> > Right now we had to put away the original hdds, as we cannot afford
> > another failed drive and time is pressing, and are dd'ing the image to a
> > real partition to try xfs_repair on it directly (takes days, of course,
> > but we're lucky we got the storage).
> > I will try the metadump and do further debugging if it segfaults again.
> 
> So I'm back now with a real partition. 
> First, I ran "xfs_repair -vn" and it did complete, reporting - as expected - a 
> bunch of entries to junk, skipping the last phases with "Inode allocation 
> btrees are too corrupted, skipping phases 6 and 7".
> It created a 270MB log, I can upload it somewhere if it could be of interest.

No need, but thanks for the offer.

> Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump /dev/sda1'.
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0  libxfs_bmbt_disk_get_all (rec=0x55c47aec3eb0, irec=<synthetic pointer>) at ../include/libxfs.h:226
> 
> warning: 226	../include/libxfs.h: No such file or directory
> (gdb) bt full
> #0  libxfs_bmbt_disk_get_all (rec=0x55c47aec3eb0, irec=<synthetic pointer>) at ../include/libxfs.h:226
>         l0 = <optimized out>
>         l1 = <optimized out>
>         l0 = <optimized out>
>         l1 = <optimized out>

Ok, so it's faulted when trying to read a BMBT record from an
in-memory buffer...

Remember the addr of the rec (0x55c47aec3eb0) now....

> #1  convert_extent (rp=0x55c47aec3eb0, op=<synthetic pointer>, sp=<synthetic pointer>, cp=<synthetic pointer>, fp=<synthetic pointer>) at /build/reproducible-path/xfsprogs-6.16.0/db/bmap.c:320
>         irec = <optimized out>
>         irec = <optimized out>
> #2  process_bmbt_reclist (dip=dip@entry=0x55c37aec3e00, whichfork=whichfork@entry=0, rp=0x55c37aec3eb0, numrecs=numrecs@entry=268435457) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2181

Smoking gun:

numrecs=numrecs@entry=268435457

268435457 = 2^28 + 1

>         is_meta = false
>         btype = <optimized out>
>         i = <optimized out>
>         o = <optimized out>
>         op = <optimized out>
>         s = <optimized out>
>         c = <optimized out>
>         cp = <optimized out>
>         f = <optimized out>
>         last = <optimized out>
>         agno = <optimized out>
>         agbno = <optimized out>
>         rval = <optimized out>
> #3  0x000055c36404e042 in process_exinode (dip=0x55c37aec3e00, whichfork=0) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2421
>         max_nex = <optimized out>
>         nex = 268435457

Yup, that's the problem.

The inode is in extent format, which means the extent records are in
the inode data fork area, which is about 300 bytes max for a 512
byte inode. IOWs, it can hold about 12 BMBT records. The BMBT
records are in the on-disk inode buffer, as is the disk inode @dip.

Look at the address of dip:  0x55c37aec3e00
The address of the BMBT rec: 0x55c47aec3eb0

Now lok at what BMBT record convert_extent() is trying to access:

process_bmbt_reclist()
{
.....
	convert_extent(&rp[numrecs - 1], &o, &s, &c, &f);
.....

Yeah, that inode buffer isn't 268 million bmbt recrods long....

So there must be a bounds checking bug in process_exinode():

static int
process_exinode(
        struct xfs_dinode       *dip,
        int                     whichfork)
{
        xfs_extnum_t            max_nex = xfs_iext_max_nextents(
                        xfs_dinode_has_large_extent_counts(dip), whichfork);
        xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
        int                     used = nex * sizeof(struct xfs_bmbt_rec);

        if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
                if (metadump.show_warnings)
                        print_warning("bad number of extents %llu in inode %lld",
                                (unsigned long long)nex,
                                (long long)metadump.cur_ino);
                return 1;
        }

Can you spot it?

Hint: ((2^28 + 1) * 2^4) - 1 as an int is?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
