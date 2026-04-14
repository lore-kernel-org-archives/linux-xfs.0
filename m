Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6FF22156C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 06:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776146902; cv=none; b=Irm92W8HQH8um2XasvgRDDR3bsLWUB2GSM26FGy6XpRU0AllvoH56qx5ERuaXsBCLhMhPVL5r0hUWW8g6UkVlp/MreizcLwnGsfu/ZZuad3uz5SVtktxCFAgqZkc0TBAuvksbiCG8xhpI2CfIR1YVhZpvo8LnlB+cwb9qBtq/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776146902; c=relaxed/simple;
	bh=m3Br1DyQDSBptA1/fcQrgJR2sdqx87dvdwzCyX6l7AI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Bqyj6i56GD2VuVtlIrM97ML8tPB1bzaWbg9aTsYEcMLlcFm5kF6VIvbHdmzjHzrpfUv1tLxCTdpDhbWhQah2vS8e5uLGJdkHL/raFwx2rd3kKISMnOWdUFbs2oIDI5UwgpdgOkI4xGB/m81BDBRRyvduGV7iax/5ldFr1Wu3/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N41bXPPN; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N41bXPPN"
Date: Tue, 14 Apr 2026 14:08:05 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776146897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PEWcpd6z7NSnTOXBVnA8gfmfWf7jiAZOwRce/mM1m+s=;
	b=N41bXPPNJ5M3XVe/8xB5cz196kbM5pT0S50JcRJaOriB/eFsPSSbYmsGSKIKdnXIYa8MGR
	8mX2IaIkPrCAs8EbjQyMOPso1zl+WmXGJmk42ENO6TKloZyN2QkCstVxYca9M+9XGiKt/i
	CtkpSEgQh73NRMmeIYZ3BXzB95KNqRw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj <pankaj.raghav@linux.dev>
To: Lukas Herbolt <lukas@herbolt.com>
CC: linux-xfs@vger.kernel.org, bfoster@redhat.com,
 "Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 kundan.kumar@samsung.com, cem@kernel.org, hch@infradead.org,
 Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
In-Reply-To: <c086dc6d3c95d1aed1ac0950ef3278ea@herbolt.com>
References: <20260413133256.3378243-1-p.raghav@samsung.com> <20260413133256.3378243-3-p.raghav@samsung.com> <c086dc6d3c95d1aed1ac0950ef3278ea@herbolt.com>
Message-ID: <21D56E00-7F57-4708-A967-5149023D453C@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT




>> @@ -1470,7 +1521,7 @@ xfs_falloc_allocate_range(
>>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
>> -		 FALLOC_FL_UNSHARE_RANGE)
>> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>>=20
>>  STATIC long
>>  __xfs_file_fallocate(
>> @@ -1522,6 +1573,9 @@ __xfs_file_fallocate(
>>  	case FALLOC_FL_ALLOCATE_RANGE:
>>  		error =3D xfs_falloc_allocate_range(file, mode, offset, len);
>>  		break;
>> +	case FALLOC_FL_WRITE_ZEROES:
>> +		error =3D xfs_falloc_write_zeroes(file, mode, offset, len, ac);
>> +		break;
>>  	default:
>>  		error =3D -EOPNOTSUPP;
>>  		break;
>
>I have debug option to skip the check of LBPRZ/DLFEAT on the underlying
>device for testing on regular devices=2E
>

Ah, this is a good idea=2E I can fold these changes in the next version=2E

FWIW,  there was a bug in QEMU which disabled this feature for emulated NV=
Me devices which has been fixed now [1]


[1]https://lore=2Ekernel=2Eorg/qemu-devel/aa_w-cz2nKsCdkMi@AALNPWKJENSEN=
=2Eaal=2Escsc=2Elocal/

--
Pankaj Raghav
