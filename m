Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77CA2F5479
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752684753; cv=none; b=n4MqCcnKt86NxLqcyIssd5rPmakJeQvRnnlz9rB+03kcea2IfNmoVB3BVkIXaVzzstESgZm7pzkBhQ5N36GtOPJphVVqtmuZRdmFHRdvhxzgVY4XszJamS9uSqvu2BXh40YTrPEA9Ig7LsKYTfCMLib+QcqJkPugmjveaMy8ViU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752684753; c=relaxed/simple;
	bh=KMtS+ip6TfqfUKiBA7p0woWTjQLyRxG1kZ7H7rx0FYc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aXIKLiRl9hFUtbWa3ES5nBYNQvKLyIHkCRVRGmyI4CNCyeZoFVLymC31lYYJnTImKZzAska6LK4PbAAzkLKlOvGVPNX1/WNvsFR06UNyipgfPlsTNJCy0dOy2d1ClVkEU1DdbU8y1AN5tyO8aztbTiGX+aonSenv1HBd++CpK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fqGNUOj+; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fqGNUOj+"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236377f00a1so133315ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 09:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752684751; x=1753289551; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6WD4ucnviGdcnqdPlH+1XW7MsSpU9n/+IccRlvHavo=;
        b=fqGNUOj+8GhPowWUec3iKrfqRtsNTF4eLVu8thhtUcxzAVSgh//CgE8pRywjS8vMWw
         3xBkelSh6M/cMpX+V9u/4EExSyghD2Sc+4utUrSJpx7OPN8rGlqEJXqSNvei2aulwX9R
         MzMiMKCYhcmVgT0CBBrwFD4UBHbVU+sQpIrQC3YlIZvLcXXujCkgT88ZmDcf4sK+g6lI
         +snrYMa/reyh3FbGMwyGsEBflGLBspaad2UpCFHQTAtUCgFq5bhnypZxSKHczJDZiJg6
         H9pBeVQeegVtQ7wqKhnSVQ7mYu7Hkp+ATZf06bA4DLc8SAkqB6YlUW2bNBRuQSJ1HEOm
         vrig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752684751; x=1753289551;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6WD4ucnviGdcnqdPlH+1XW7MsSpU9n/+IccRlvHavo=;
        b=GcKKiMsWg0ETxX5GwaUvHo/U9KxA/QdmRYnAEPM2ORPdEGxhX31pXZkrNyrgRaoHR+
         Aj4NvY7dd+p6x1N+IInm/EEZJqgsj6n2b94PUsZYZ+aATuzCJAkOb6xTUzn5sjncYZQE
         L2L8T4FZIR2mBBjgYWBoK8ZiqJJoBraJsoadQrMJLqAOS6BlZpHO/LlKSfzbHsChgQOl
         DOmKYtFb0bxppNySriH1750wYwUdSgc8wpdqHi7iMdvk6M9TA2mvB9CEHqSc8VjJtP1S
         XOu5BlVwn4i+l81kaJOIZRNVaYGsRrN8jcHm6NUCCzS0GF8ZLHse4z9Nls2r/QfsMncm
         RZyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKhmqrGf+6xBA0pRZrJWp9NtJRAWCtfmxfqlF9YoQm8rCrHPmzMa1w3HnpAfgVDCNRkjRrdcB+OsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRX6518GmtApgB0i5ibMhrOaBO8L1Jo8eyBQz1P84J9h6vivM4
	0rXr6RBvoOAn68LboyZw2bO0S7KXG4Vf4JRnr6viXw5ro4F17/s8er3WNI/eUYoP
X-Gm-Gg: ASbGnctc/SaL3+khgZzMrhvZzyG353HItx9fpg3O62pzNqcYsXqOYl1ORrMEWjW0wDp
	V23b3ln+90VwTonhAjDGYImq7VfBUIJxy+KFQOQTw0vDlfxOco+MWfG6NxeYoBhfLMOdDQsR5in
	3ASqkkSUzh6UCviZ3la1TBi+0ubgKXk2GpgoAru5/fy6ZUAohdaj1W2rZb6/iupyRSVl1An2tk1
	H9I02USfB6M9UlzUkVrnQI7Ohdc/aNUmBTemSWc1qhuCJpAnpbJhGVIagj3JH60SOGj0Nxabm99
	PSOLwgqdVblasOZHY0zb/W8gLQOqMOEsB0rKZ3CfTChujDBFOkiU/Qi0NsFY89PCQV7y4pNFUkY
	9rrTAtw==
X-Google-Smtp-Source: AGHT+IGoF7n2BHKzis2GgkkpM4HHkw3ptQatUc+Z3Bs9JnA4kzoTRTx/zEJl5VW+Yr2Lf3yjDs6LHQ==
X-Received: by 2002:a17:902:d603:b0:234:d292:be7f with SMTP id d9443c01a7336-23e24f4a936mr53463275ad.31.1752684750914;
        Wed, 16 Jul 2025 09:52:30 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4285fcasm126866455ad.5.2025.07.16.09.52.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:52:30 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 5/7] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250716160206.GL2672049@frogsfrogsfrogs>
Date: Thu, 17 Jul 2025 00:52:14 +0800
Cc: Christoph Hellwig <hch@lst.de>,
 Carlos Maiolino <cem@kernel.org>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 linux-xfs@vger.kernel.org,
 George Hu <integral@archlinux.org>,
 John Garry <john.g.garry@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3B511F05-E1FB-4396-B91F-769678B8E776@gmail.com>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-6-hch@lst.de>
 <20250716160206.GL2672049@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jul 17, 2025, at 00:02, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Wed, Jul 16, 2025 at 02:54:05PM +0200, Christoph Hellwig wrote:
>> From: George Hu <integral@archlinux.org>
>>=20
>> Refactor the xfs_max_open_zones() function by replacing the usage of
>> min() and max() macro with clamp() to simplify the code and improve
>> readability.
>>=20
>> Signed-off-by: George Hu <integral@archlinux.org>
>> Reviewed-by: John Garry <john.g.garry@oracle.com>
>> ---
>> fs/xfs/xfs_zone_alloc.c | 4 +---
>> 1 file changed, 1 insertion(+), 3 deletions(-)
>>=20
>> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
>> index 729d80ff52c1..d9e2b1411434 100644
>> --- a/fs/xfs/xfs_zone_alloc.c
>> +++ b/fs/xfs/xfs_zone_alloc.c
>> @@ -1133,9 +1133,7 @@ xfs_max_open_zones(
>> /*
>>  * Cap the max open limit to 1/4 of available space
>>  */
>> - max_open =3D min(max_open, mp->m_sb.sb_rgcount / 4);
>> -
>> - return max(XFS_MIN_OPEN_ZONES, max_open);
>> + return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / =
4);
>=20
> Does clamp() handle the case where @max < @min properly?

No, it only has BUILD_BUG_ON_MSG(statically_true(ulo > uhi), =E2=80=9Cxxx"=
)


> I'm worried about shenanigans on a runt 7-zone drive, though I can't
> remember off the top of my head if we actually prohibit that...
>=20
> --D
>=20
>> }
>>=20
>> /*
>> --=20
>> 2.47.2


