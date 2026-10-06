Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7959E339364
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791317553; cv=none; b=GmmsETAYJWokcHg53T6bKrRny9xwAvwEwMWLG3e6w/bmxxLJyWh66PE35KciJaB8newSNUQn+BpcMnulgRMpAbHsQQIDQOwAwiI9+/pr3Id/iiAyWzFnGDeLklhTDj78qntPdfzBkdyShjV3uLgyS7oQKgNvbFHgoWSimYjUajk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791317553; c=relaxed/simple;
	bh=XkY8LQ3f74ltGlyxgIyBdU0BFhZkURFJLXZ0J37Jp+Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TNEq/QyxYRcrvb0wDCP3DzTOQHwPEcPznvVxWy+G/DQb/47Gal5Pb7WgQprVXrnZpT15Gsp0dnKzJNHXGyxWbA0HMWPtZCaQzZ209OCWJDHHptfqZRb/rKadLRrtIETeGMYslFJTDDDVb3AzIz1yiULDdquZzvd7rbl7W3Sqat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=Y3NQQg23; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="Y3NQQg23"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6aff0c4bda3so651351a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2026 13:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1791317550; x=1791922350; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TLReMVkFkV4Fm3z9xnLkdJCOSqGTU9UUMRRaZUmlCQk=;
        b=Y3NQQg23mCNr0enc/jtNU6OlzJEeDYd1FI4dxrYXc5C+CxoMf2xEmiSvc2oQXAxE2p
         ScesSo5OWkmeBBPGqDjAuzSvCJNGGN+cf8hxBXmEU2QaGOTI5ifB6qqYZS9996ULtIC3
         I7dylnz2p+dVuzbjfH/ABotcnqkcKXYLAzzTbTKxYuUIaOiQTyiynojj43LHEsw/qrdE
         fhjkDmIVTja1HGXTkAJeL6faQJogNHFMJO9w5P7sv4Yhn8A8rqkUsl7OGoKCrGqVKJlV
         zfPSBomHHAd/53Eurya0tb/OdMN9uwV+sEwiaqzPzzHIk1NwtPgT5gscxbQKEtJTD/cG
         sf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791317550; x=1791922350;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TLReMVkFkV4Fm3z9xnLkdJCOSqGTU9UUMRRaZUmlCQk=;
        b=iQZYTIzQptY8remCmPJjycLPVQkctkgzP3aKpjKLJEOhgaWR0dsEgoLQrzMnyhS2I4
         5zBXROyPI9jf/L5YoUFqAOrFymnoFBb/n6DS+D+ZxYVC3oPDlCyzVJuNeuZ2XYjxtLc5
         W+reE4c+Po3G6r6OpJC9VRy7ztPqqPgSdm8nfqN/WHS/T23JBlQFg0Q9ZFcTbqaPni8U
         Y69OI+vm82ZTDnp7ATEW/X0RsmSr7Q1Aht0HpQCWsXBoAKYDjk3KX8pc++CqbWrorDhV
         5I9QjX4Nv8vXXTw5ltwEUhbDIBviUSivGrPnDnrFfHeMknIFFNr65nikEi6sgwuzI88J
         8vKQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhVLnhbr52GAgqXD64h3Wg5WIkotfb4nqFQJTQgZp1kIkW8o6C47O/OKSpRPXXJOBASeVba9dqcNE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLvjJkA1hixgZfMMB4BBsDsrPgBSa60Z0xLtUduTz3hS45ggPjG
	oAvaPLOiZVEjVdVSqgmjKRVs+1C8rYHphDPzp2SRpdeTKwNBAIxACSeI06Dvu+6C1aI=
X-Gm-Gg: AYBFou2UMljNm3wxGTnxkMerX0G6jUzC8u6FGT55UEfCljs+IWr/wy7VKxCw3OIIldk
	5hYpSQL6lzl3ExqmEth1WWDZFaWL0nFIQPhIv4/XjE2ehDRDPtrrPmCdhEc3R+HSyw4Gl+6dArN
	2k5qQ8ujAVyDfaN/r7y/Iut8riJt5wRfys9XC4rMFOP9+PmnKEHeOWlR+ZBThcpcRrn3cWVAQbJ
	awAuoIszj7KWOPnbRfhX5d2b17Ew/CApPiHnIyxDIR2McG9gGb6muNSmbphPoblhaS/ESVTyKoM
	/kXNEk84KWEK47M6cQmdeV5gi8EUVpvrYakxTqfxPQJyNLsX6qVMgOUhFgO/y5DjUhUhCsqQOBR
	4SvrNmP5eRyGrleDSabFLmE47G78r0BPy1PoUfTjxebULa/iqnWiq5e088kpAl61le8tdCJpelt
	Na8veuinHNZsi+tdJ0D5zHWyOUrRP0HjfnGSnmExxlUV0RF4wyK+5HXxhFlBodzcMBtP02NmZDB
	3ZvCZtk7AOD3U7Zqxx5brSCOD2NrrqTzogMuMCa8jhl4NQe1I9Zph0pDA0btQ==
X-Received: by 2002:a05:6402:460a:b0:6aa:e46b:2c3 with SMTP id 4fb4d7f45d1cf-6aff44256bamr108718a12.29.1791317549173;
        Tue, 06 Oct 2026 13:12:29 -0700 (PDT)
Received: from smtpclient.apple (80.49.145.194.ipv4.supernova.orange.pl. [80.49.145.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c317bdb3050sm5818866b.11.2026.10.06.13.12.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 13:12:28 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] xfs: fix exchange-range-to-eof file size exchange
From: Norbert Szetei <norbert@doyensec.com>
In-Reply-To: <20261006150001.GY2705364@frogsfrogsfrogs>
Date: Tue, 6 Oct 2026 22:12:17 +0200
Cc: Dave Chinner <dgc@kernel.org>,
 Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6363D9F4-4DD0-4E63-90C0-38721B244783@doyensec.com>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
 <asSiXW4XxBl8Kivw@dread> <20261006150001.GY2705364@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

> On Oct 6, 2026, at 17:00, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Tue, Oct 06, 2026 at 06:25:17PM +1100, Dave Chinner wrote:
>> On Mon, Oct 05, 2026 at 10:09:14PM -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>=20
>>> Norbert Szetei posted a patch containing an incomplete description =
of a
>>> bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
>>> exchange-range into modifying a file so that it has shared blocks
>>> starting beyond EOF, which is never allowed because files never have
>>> written data beyond EOF, and you can only share written data blocks.
>>> This is key to all the incorrect behavior that follows.
>> ....
>>>=20
>>> Having confused the file sizes, the PoC uses a second exchange-range
>>> call on what looks like a non-reflinked single-block file.  Because =
the
>>> file size is set incorrectly, exchange-range thinks it's exchanging =
the
>>> full contents of two files and clears the reflink flag on the broken
>>> file.
>>=20
>> Hmmm, another "exchrange reflink flag coherency" bug.
>>=20
>> Aside from fixing this specific issue, how can we prevent
>> other/future logic bugs from failing to set the reflink flag
>> appropriately and so never expose such a bug to userspace again?
>>=20
>> I'm thinking that we should not try to swap the reflink flag along
>> with the extents. Instead, if one of the files had the reflink flag
>> set before the swap, then we scan scan the extents of both files
>> after the swap for shared extents and set the reflink flags for each
>> file appropriately.  EXCHRANGE isn't really performance sensitive,
>> so the cost of the refcount scans shouldn't be an issue.
>>=20
>> Setting the flags this way means it doesn't matter what file shared
>> extent(s) ends up in, the inode(s) that owns it(them) will always
>> have the reflink flag set correctly. Hence there is no way to use
>> EXCHRANGE creatively to expose this "didn't COW when it should have'
>> class of corruption bugs ever again...
>=20
> That is what Norbert's patch actually does.  If you think removing
> xfs_exchmaps_clear_reflink and all the stuff that calls it is a good
> idea (and it probably is!) then let's move that discussion and review =
to
> that patch's thread.

I realized the patch I proposed is not complete on its own either.
XFS_IOC_SWAPEXT swaps the reflink flags as well, in xfs_swap_extents()
(xfs_bmap_util.c:1704), which my patch does not touch. The test guarding =
it

        /* Verify all data are being swapped */
        if (sxp->sx_offset !=3D 0 ||
            sxp->sx_length !=3D ip->i_disk_size ||
            sxp->sx_length !=3D tip->i_disk_size) {

only proves the requested length matches i_disk_size, and i_disk_size =
does
not bound the inode's mappings, so xfs_swap_extent_rmap() leaves =
mappings
behind and the flags are traded anyway.

N.

> That enables an extending write of the broken file to rewrite the
>>> shared block that's just past EOF.  This has become known =
colloquially
>>> as refluxfs.
>>>=20
>>> Once the file sizes are set correctly, the second exchange-range no
>>> longer thinks that it's doing a full-contents swap, so it won't =
clear
>>> the reflink flag on either of its file arguments.
>>>=20
>>> Link: =
https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doy=
ensec.com/
>>> Reported-by: Norbert Szetei <norbert@doyensec.com>
>>> Cc: <stable@vger.kernel.org> # v6.10
>>> Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file =
mapping exchanges")
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>> fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
>>> fs/xfs/xfs_exchrange.c       |   10 ++++++----
>>> 2 files changed, 12 insertions(+), 6 deletions(-)
>>>=20
>>> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c =
b/fs/xfs/libxfs/xfs_exchmaps.c
>>> index 6a66b6075e0af4..c9d9464e9d39f5 100644
>>> --- a/fs/xfs/libxfs/xfs_exchmaps.c
>>> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
>>> @@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
>>> const struct xfs_exchmaps_req *req)
>>> {
>>> struct xfs_exchmaps_intent *xmi;
>>> + struct xfs_mount *mp =3D req->ip1->i_mount;
>>> unsigned int rs =3D 0;
>>>=20
>>> xmi =3D kmem_cache_zalloc(xfs_exchmaps_intent_cache,
>>> @@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
>>> }
>>>=20
>>> if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
>>> + loff_t off1 =3D XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
>>> + loff_t off2 =3D XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
>>> +
>>> xmi->xmi_flags |=3D XFS_EXCHMAPS_SET_SIZES;
>>> - xmi->xmi_isize1 =3D req->ip2->i_disk_size;
>>> - xmi->xmi_isize2 =3D req->ip1->i_disk_size;
>>> + xmi->xmi_isize1 =3D off1 + (req->ip2->i_disk_size - off2);
>>> + xmi->xmi_isize2 =3D off2 + (req->ip1->i_disk_size - off1);
>>> }
>>=20
>> I think this really needs a comment to explain why the calculation
>> is structured this way. I think it is trying to set the file sizes
>> to the "destination offset" + "swap length from other file" because
>> the ranges in each file might be different lengths, but I could be
>> wrong...
>=20
> That's correct.  I'll add that as a code comment.
>=20
> --D
>=20
>>=20
>> Cheers,
>>=20
>> Dave.
>> --=20
>> Dave Chinner
>> dgc@kernel.org


