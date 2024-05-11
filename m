Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AF71843
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 03:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715399123; cv=none; b=DlOcCi9tbnsgBJFLD6ygnp3rNsY908bPoqE1dCn+Yky4eDN9Zuw/51uTP1/cjH0XNga8Q26A9z5y0OzUbeHndRRUPRuVWV7u2jS+ZjP/92wqAfnJ/ZeQiKA+bVqtHWUsXYL0ex5e7M+8QHPTIejCyEjOwnl1mSIi+mKNXck96Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715399123; c=relaxed/simple;
	bh=WzOTVZ8GCGiKQi4TF8klcgJTBycPjYkacv4ZdJWCBh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eaMfS/OCbbrAOEX00PFzL7sSOfuoZKa9L/bWNjnOwTqMXiL72OcavJg3ijyEcJTsXvfPESksnAsJmExJVziCUUTqjeC7xleD1gPn6gZ/Ne/dH6LuGX24Pi+XFn1tG8JaywFoxVbiUBdTiQzMJ1I4VXXkQc+OYSmLAsiKe+6GsSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aseShwrv; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aseShwrv"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e3c3aa8938so19351985ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 20:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715399121; x=1716003921; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oUoBni/ncwQ6orRMlcHEjyA9DgrRVMLRCUTD4QAwLBA=;
        b=aseShwrvUptn4PnXHwbFuk55KPWRNESKIofgRdrq6mGd33kNMRjMh/01arHHWSxuyR
         Lze1B7d0El3ldH7b0DxpGreoUN9L/MOW/rU38D6OXe4NuaXLZUQalui72AOmxfUrF+Rl
         1Ern9nmfvhtQ0tm1AlkVYMCrLPMN1gr6RVy41ug56QucrdhIHcbZKBpheYK1V/d+ggk5
         hbwpIoUp6H/l2Lfg8BfmF7kr4aj7FugFeDkIaPR+bHdZdnW5p2rIm5zYwyJhZQGOnWvb
         QcwU7HOn5WL8j3b+Sd+iC3TuWXgoqZxmUJoqZKTAo35pxr+oZc1g6VG6EnrD1ttX+QUb
         BAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715399121; x=1716003921;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUoBni/ncwQ6orRMlcHEjyA9DgrRVMLRCUTD4QAwLBA=;
        b=e1MlWWSuHFHp6DbTEBfzX8IvM8s8cAUrRqT/O0yu2d91chaWudgZUvs4hESd9xjxVb
         WTOkhrnxTlyjxGGgFAHitqVzLYIVUGLj96kAwkNJ1cad6JI6KrG48njVWGoi0Uod8JVT
         g4ldMxQJhlVJduPnoVSnL/6gcf1l1v00Uh8nQueOrCfEG3j52L2iUXGtpr6yBoXJO7bF
         24ynICoDYCVOq58eBOk/YhjrUSs/zmVMkJG/PyeJA3rcKFX1ujzIK6Q2K4a4RYoUw8p9
         ni+0PeWirYZ+sfjC3DXq4/RJrbCExQhNfVBDC6+ec/9lT5pIybzjREJmqZrzj7JmQixc
         ++Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVAjlmLCOs2Fi5Pub0aBto+9ONFpsQkKOS+iPqrmaOJx5uvKE2fhC0icQOpQ0JwtX5/Xqc7WMGlg9WG7aMMbHW4MbGWIW9Kj05j
X-Gm-Message-State: AOJu0YwI7kV1o7H5i/eLO79O1Tf1lFRMdLPtpMdOH5ogLdpN43R4VD8g
	pi+4rfvxc08qDBArAd+5m+dvnNY7dkJnRA0odf2se9MFXVqDtQr2hGHLorqRds9UVE6OeCzKzwv
	Q
X-Google-Smtp-Source: AGHT+IETEq2sTtbfK9w6iVR+JAvy7FFgY4suhMgCCAK0ezGbJbr+iPsP4ne9S/d7aovh/nxVIJuEzg==
X-Received: by 2002:a17:902:9007:b0:1ec:681c:30fa with SMTP id d9443c01a7336-1ef43e23407mr38503035ad.36.1715399120633;
        Fri, 10 May 2024 20:45:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad886csm40076255ad.70.2024.05.10.20.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 20:45:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s5dfh-00AvWa-10;
	Sat, 11 May 2024 13:45:17 +1000
Date: Sat, 11 May 2024 13:45:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Chandan Babu R <chandanbabu@kernel.org>, djwong@kernel.org,
	Christoph Hellwig <hch@infradead.org>, brauner@kernel.org,
	Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: [BUG REPORT] generic/561 fails when testing xfs on next-20240506
 kernel
Message-ID: <Zj7pzTR7QOSpEXEi@dread.disaster.area>
References: <87ttj8ircu.fsf@debian-BULLSEYE-live-builder-AMD64>
 <6c2c5235-d19e-202c-67cf-2609db932d5a@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6c2c5235-d19e-202c-67cf-2609db932d5a@huaweicloud.com>

On Sat, May 11, 2024 at 11:11:32AM +0800, Zhang Yi wrote:
> On 2024/5/8 17:01, Chandan Babu R wrote:
> > Hi,
> >=20
> > generic/561 fails when testing XFS on a next-20240506 kernel as shown b=
elow,
> >=20
> > # ./check generic/561
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 xfs-crc-rtdev-extsize-28k 6.9.0-rc7-next-=
20240506+ #1 SMP PREEMPT_DYNAMIC Mon May  6 07:53:46 GMT 2024
> > MKFS_OPTIONS  -- -f -rrtdev=3D/dev/loop14 -f -m reflink=3D0,rmapbt=3D0,=
 -d rtinherit=3D1 -r extsize=3D28k /dev/loop5
> > MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 -ortdev=3D/de=
v/loop14 /dev/loop5 /media/scratch
> >=20
> > generic/561       - output mismatch (see /var/lib/xfstests/results/xfs-=
crc-rtdev-extsize-28k/6.9.0-rc7-next-20240506+/xfs_crc_rtdev_extsize_28k/ge=
neric/561.out.bad)
> >     --- tests/generic/561.out   2024-05-06 08:18:09.681430366 +0000
> >     +++ /var/lib/xfstests/results/xfs-crc-rtdev-extsize-28k/6.9.0-rc7-n=
ext-20240506+/xfs_crc_rtdev_extsize_28k/generic/561.out.bad        2024-05-=
08 09:14:24.908010133 +0000
> >     @@ -1,2 +1,5 @@
> >      QA output created by 561
> >     +/media/scratch/dir/p0/d0XXXXXXXXXXXXXXXXXXXXXXX/d486/d4bXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXX/d5bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d212XXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d11XXXXXXXXX/d54/de4/d158/d27f/d895/d1307X=
XX/d8a4/d832XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/r112fXXXX=
XXXXXXX: FAILED
> >     +/media/scratch/dir/p0/d0XXXXXXXXXXXXXXXXXXXXXXX/d486/d4bXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXX/d5bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d212XXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d11XXXXXXXXX/d54/de4/d158/d27f/d13a3XXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/=
d13c0XXXXXXXX/d2301X/d222bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d1240XXXXXXXX=
XXXXXXXXXXXXXXXX/d722XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d1380XXXXXXXXXXXXXXXX/dc62XXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/r10d5: FAILED
> >     +md5sum: WARNING: 2 computed checksums did NOT match
> >      Silence is golden
> >     ...
> >     (Run 'diff -u /var/lib/xfstests/tests/generic/561.out /var/lib/xfst=
ests/results/xfs-crc-rtdev-extsize-28k/6.9.0-rc7-next-20240506+/xfs_crc_rtd=
ev_extsize_28k/generic/561.out.bad'  to see the entire diff)
> > Ran: generic/561
> > Failures: generic/561
> > Failed 1 of 1 tests
> >=20
>=20
> Sorry about this regression. After debuging and analyzing the code, I not=
ice
> that this problem could only happens on xfs realtime inode. The real prob=
lem
> is about realtime extent alignment.
>=20
> Please assume that if we have a file that contains a written extent [A, D=
).
> We unaligned truncate to the file to B, in the middle of this written ext=
ent.
>=20
>        A            B                  D
>       +wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
>=20
> After the truncate, the i_size is set to B, but due to the sb_rextsize,
> xfs_itruncate_extents() truncate and aligned the written extent to C, so =
the
> data in [B, C) doesn't zeroed and becomes stale.
>=20
>        A            B     C
>       +wwwwwwwwwwwwwwSSSSSS
>                     ^
>                    EOF

This region must be zeroed on disk before we call
xfs_itruncate_extents().  i.e completed xfs_setattr_size() via
xfs_truncate_page() and flushed to disk before we start removing
extents.

The problem is that iomap_truncate_page() only zeros the trailing
portion of the i_blocksize() value, which is wrong for realtime
devices with rtextsize !=3D fs blocksize.

Further, xfs_setattr_size() then calls truncate_setsize(newsize)
before the zeroing has been written back to disk, which means
that the flush that occurs immediately after the truncate_setsize()
call can not write blocks beyond the new EOF regardless of whether
iomap_truncate_page() wrote zeroes to them or not.

> The if we write [E, F) beyond this written extent, xfs_file_write_checks(=
)->
> xfs_zero_range() would zero [B, C) in page cache, but since we don't incr=
ease
> i_size in iomap_zero_iter(), the writeback process doesn't write zero data
> to disk. After write, the data in [B, C) is still stale so once we clear =
the
> pagecache, this stale data is exposed.
>=20
>        A            B     C        E      F
>       +wwwwwwwwwwwwwwSSSSSS        wwwwwwww
>=20
> The reason this problem doesn't occur on normal inode is because normal i=
node
> doesn't have a post EOF written extent.

That's incorrect - we can have post-eof written extents on normal
files. The reason this doesn't get exposed for normal files is that
the zeroing range used in iomap_truncate_page() covers the entire
filesystem block and writeback can write the entire EOF page that
covers that block containing the zeroes. Hence when we remove all
the written extents beyond EOF later in the truncate, we don't leave
any blocks beyond EOF that we haven't zeroed.

> For realtime inode, I guess it's not
> enough to just zero the EOF block (xfs_setattr_size()->xfs_truncate_page(=
)),
> we should also zero the extra blocks that aligned to realtime extent size
> before updating i_size. Any suggestions?

Right. xfs_setattr_size() needs fixing to flush the entire zeroed
range *before* truncating the page cache and changing the inode size.

Of course, xfs_truncate_page() also needs fixing to zero the=20
entire rtextsize range, not use iomap_truncate_page() which only
zeroes to the end of the EOF filesystem block.

I note that dax_truncate_page() has the same problem with RT device
block sizes as iomap_truncate_page(), so we need the same fix for
both dax and non-dax paths here.

It might actually be easiest to pass the block size for zeroing into
iomap_truncate_page() rather than relying on being able to extract
the zeroing range from the inode via i_blocksize(). We can't use
i_blocksize() for RT files, because inode->i_blkbits and hence
i_blocksize() only supports power of 2 block sizes. Changing that is
a *much* bigger job, so fixing xfs_truncate_page() is likely the
best thing to do right now...

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
