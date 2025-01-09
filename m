Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87FB2594BA;
	Thu,  9 Jan 2025 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736415802; cv=none; b=ER+8KekEBH5NY+OC0oyxwo31zgssOkp/FU377KpS41cegMT/aT7RP55pi9jWDZ640UG0YcshDdtqnsSufm0IVy0wIAsTiYIaSQcgvfOwCxrN7lvazQxDb6XFRZ1e1WLva7e1KxGnpVsts3cpIyWr/yiPMvLIa5LtyxtTTBCmYJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736415802; c=relaxed/simple;
	bh=dJzcy0GOvQLcTrhV0oAhnyhYhhChLTv0pOgFK3kE9sQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrZwHlYcNt2Dok/2mhMowgWDfj5dExbpEeL1I+hx2MSQFIF3NImVyrsxqnkkW8xnv7PhfVe5/BARHEhDUOye9k32jFsUt1lk7EdzjuPprAIgDOTXAgxvze8vZIZ59AhEUEYWFI94cu6AO1G1241wRKkaSOXgtx90j4mcGe0TjdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 25616e00ce6e11efa216b1d71e6e1362-20250109
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:8835ea7a-ac2c-4e93-a900-391999cf3a10,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:b5c482fd05a7146d4c74f638dc25823b,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 25616e00ce6e11efa216b1d71e6e1362-20250109
Received: from node4.com.cn [(10.44.16.170)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2037107913; Thu, 09 Jan 2025 17:43:14 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id D74F616003301;
	Thu,  9 Jan 2025 17:43:13 +0800 (CST)
X-ns-mid: postfix-677F9A31-8059261467
Received: from [10.42.13.56] (unknown [10.42.13.56])
	by node4.com.cn (NSMail) with ESMTPA id 4CEF716001CC7;
	Thu,  9 Jan 2025 09:43:13 +0000 (UTC)
Message-ID: <8064ea56-deb3-4097-ac6e-45afa59d8b5f@kylinos.cn>
Date: Thu, 9 Jan 2025 17:43:12 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: use kmemdup() to replace kmalloc + memcpy
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <37bbe1eb5f72685e54abb1ee6b50eaff788ecd93.1735268963.git.xiaopei01@kylinos.cn>
 <7c3kfhrtjpxrw44u44pow2un3q463w3qkiend2j374ixjqtfvb@rl33jhp7cmmu>
From: Pei Xiao <xiaopei01@kylinos.cn>
In-Reply-To: <7c3kfhrtjpxrw44u44pow2un3q463w3qkiend2j374ixjqtfvb@rl33jhp7cmmu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


=E5=9C=A8 2025/1/9 17:39, Carlos Maiolino =E5=86=99=E9=81=93:
> On Fri, Dec 27, 2024 at 11:11:13AM +0800, Pei Xiao wrote:
>> cocci warnings:
>>     fs/xfs/libxfs/xfs_dir2.c:336:15-22: WARNING opportunity for kmemdu=
p
> https://lore.kernel.org/all/20241217225811.2437150-4-mtodorovac69@gmail=
.com/

ok=EF=BC=8Cthank you, I didn't realize it was a duplicate commit.

>> Fixes: 30f712c9dd69 ("libxfs: move source files")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202412260425.O3CDUhIi-lk=
p@intel.com/
>> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
>> ---
>>  fs/xfs/libxfs/xfs_dir2.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index 202468223bf9..24251e42bdeb 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -379,12 +379,11 @@ xfs_dir_cilookup_result(
>>  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
>>  		return -EEXIST;
>> =20
>> -	args->value =3D kmalloc(len,
>> +	args->value =3D kmemdup(name, len,
>>  			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
>>  	if (!args->value)
>>  		return -ENOMEM;
>> =20
>> -	memcpy(args->value, name, len);
>>  	args->valuelen =3D len;
>>  	return -EEXIST;
>>  }
>> --=20
>> 2.25.1
>>
>>
