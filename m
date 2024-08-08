Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941E6374C3
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723143631; cv=none; b=jXot32r4uBevV9tKZ/yfZ7bZDFh3WcyEaHOGMEF2bgMQBukTpD7ImgBxSOp7q9Vm/Z5nM7JavbDVo9YPXrQFPj77HLQTsFxks1+lFtrUbE+IiCF3C3WkE8yJCUH5HhyIA2p8MVasf8A0dSX82uA18o9+OdGiDwY1QB0FgfOVjwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723143631; c=relaxed/simple;
	bh=1UaMA7JT/3n5Sfy9ptopit4fejcQoSxBjuU0DdaLx3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TKUn2E3oZot/OBELvjCjtC7Rh5K1y8BvOc9W1CzhuyazX/nDZSZ0sQKD3bvibk5DJRkamoo7lk5PKpeDEaQD867UiMxUH26Vu5kqsghbJIMJvLB+40Kqro4DN0FfI4zLzbCJ5FS6pnYjBEw0IstulSMtj7kBTLi+Ql/0Gwr4XrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=XybwWAud; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="XybwWAud"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B8B675CE9D5;
	Thu,  8 Aug 2024 14:00:22 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net B8B675CE9D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1723143622;
	bh=a8Z/3iT+EHlcgw879vHafLEctGVsVVEHMpYFFjwc1m4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XybwWAud+4GnK/NlnNrZs/KQp06GcJDltArpe5k11IWrmzjIujxrrCpoplm4xyLSK
	 VyDmlGZ9aBRk+rUPDoiNdmUv2mIHPbgsIF4me68cpJKIZabOi2b/hB1Gq3BehXjoYm
	 lBk5xnEe/zKoWEck/jFoMwf49iMR2kAaZqUysx+4M1b5VhL5eg9KTipRD36uP9f5qO
	 I3QcgF0EBaQoiN3XMzOdcFZSK0d3zp8TtUPW7/0RCeWZsqYqD/hzPcZu1h16nik0+E
	 zbm+BmwwdVw6mbx51E6C1oL2oY8jvWKK5bl4Rsqoe0uly/0T+sKuccKrhdhkrOCav5
	 91aPcv50KA0wQ==
Message-ID: <3a91d785-8c8f-4d2b-998f-a4cd92353120@sandeen.net>
Date: Thu, 8 Aug 2024 14:00:22 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs_db: release ip resource before returning from
 get_next_unlinked()
To: "Darrick J. Wong" <djwong@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
References: <20240807193801.248101-3-bodonnel@redhat.com>
 <20240808182833.GR6051@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240808182833.GR6051@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/8/24 1:28 PM, Darrick J. Wong wrote:
> On Wed, Aug 07, 2024 at 02:38:03PM -0500, Bill O'Donnell wrote:
>> Fix potential memory leak in function get_next_unlinked(). Call
>> libxfs_irele(ip) before exiting.
>>
>> Details:
>> Error: RESOURCE_LEAK (CWE-772):
>> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
>> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
>> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
>> #   74|   	libxfs_buf_relse(ino_bp);
>> #   75|
>> #   76|-> 	return ret;
>> #   77|   bad:
>> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
>>
>> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
>> ---
>> v2: cover error case.
>> v3: fix coverage to not release unitialized variable.
>> ---
>>  db/iunlink.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/db/iunlink.c b/db/iunlink.c
>> index d87562e3..57e51140 100644
>> --- a/db/iunlink.c
>> +++ b/db/iunlink.c
>> @@ -66,15 +66,18 @@ get_next_unlinked(
>>  	}
>>  
>>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
>> -	if (error)
>> +	if (error) {
>> +		libxfs_buf_relse(ino_bp);
> 
> Sorry, I think I've led you astray -- it's not necessary to
> libxfs_buf_relse in any of the bailouts.
> 
> --D
> 
>>  		goto bad;
>> -
>> +	}
>>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>>  	ret = be32_to_cpu(dip->di_next_unlinked);
>>  	libxfs_buf_relse(ino_bp);
>> +	libxfs_irele(ip);
>>  
>>  	return ret;
>>  bad:
>> +	libxfs_irele(ip);

And this addition results in a libxfs_irele of an ip() which failed iget()
via the first goto bad, so you're releasing a thing which was never obtained,
which doesn't make sense.


There are 2 relevant actions here. The libxfs_iget, and the libxfs_imap_to_bp.
Only after libxfs_iget(ip) /succeeds/ does it need a libxfs_irele(ip), on either
error paths or normal exit. The fact that it does neither leads to the two leaks
noted in CID 1554242.

libxfs_imap_to_bp needs a corresponding libxfs_buf_relse() (thanks for clarifying
djwong) but that libxfs_buf_relse() is already present if libxfs_imap_to_bp
succeeds. It's not needed if it fails, because there's nothing to release.

When Darrick said

> I think this needs to cover the error return for libxfs_imap_to_bp too,
> doesn't it?

I think he meant that in the error case where libxfs_imap_to_bp fails, libxfs_irele
is also needed. (In addition to being needed on a normal return.)

-Eric
