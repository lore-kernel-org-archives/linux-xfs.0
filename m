Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD430BB9B
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 09:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782466970; cv=none; b=KQ6g+r78Q5tpCe4cFSdHZRya1zdBXl+3o8Bshn2FhpyrVanaIfiNOWaQxcIBJmMt4ppLkG/80lInDXyofVlDy4yNTIGuXxdTBUu8t0eEAusYzJSae+xWM+5aYEDTG94z+WI8gPz/Jp/6V36Yl5onXd+nCnz51rKw0U4bBNToz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782466970; c=relaxed/simple;
	bh=WKREoeKXA1Hnf6EYFBSk+6BgapGeRff/XzUGhwqro2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odosg5yGQjGbLB9N5jfgZPP7+7kU+Z8hvDz4bugKOJnP93ucElIWS+VyWWNmqOMzvqv0oVJ/ouCyudvOUfh5JV5599n53dDtVqrj/Ic7Qd1l0s9ZkYhJlRMwAchW890PtFCn2dTyZlP9S3Cd2djFKnWv68KtYnUGr7Wt+Mor7BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 60d400a0714311f1aa26b74ffac11d73-20260626
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:43386124-3ff0-4ba7-9fcb-0e5fcbf6de8f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:43386124-3ff0-4ba7-9fcb-0e5fcbf6de8f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c0e53931bd40adfeddfcd87a43a23234,BulkI
	D:260626000520RKESHILB,BulkQuantity:2,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|136|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 60d400a0714311f1aa26b74ffac11d73-20260626
X-User: liuhuan01@kylinos.cn
Received: from [192.168.109.190] [(1.193.56.173)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 440931214; Fri, 26 Jun 2026 17:42:42 +0800
Message-ID: <8cafea86-162f-4f2b-8de2-b0226c09d516@kylinos.cn>
Date: Fri, 26 Jun 2026 17:42:39 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mkfs: simplify setup_proto file status checks
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20260625054445.28751-2-liuhuan01@kylinos.cn>
 <20260625160509.GZ6078@frogsfrogsfrogs>
Content-Language: en-US
From: liuh <liuhuan01@kylinos.cn>
In-Reply-To: <20260625160509.GZ6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/6/26 00:05, Darrick J. Wong 写道:
> On Thu, Jun 25, 2026 at 01:44:46PM +0800, liuh wrote:
>> setup_proto() calls filesize() before validating the source type with
>> fstat(), even though both operations ultimately require the same file
>> status information.
>>
>> Perform a single fstat() immediately after opening the source path and
>> reuse the resulting metadata for both source type validation and file
>> size retrieval. This simplifies the setup logic and eliminates a
>> redundant metadata lookup.
>>
>> Signed-off-by: liuh <liuhuan01@kylinos.cn>
>> ---
>>   mkfs/proto.c | 17 ++++++++++++++---
>>   1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/mkfs/proto.c b/mkfs/proto.c
>> index a460aebd..72fefb6e 100644
>> --- a/mkfs/proto.c
>> +++ b/mkfs/proto.c
>> @@ -82,14 +82,17 @@ setup_proto(
>>   		return result;
>>   	}
>>   
>> -	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
>> +	if ((fd = open(fname, O_RDONLY|O_NONBLOCK|O_CLOEXEC)) < 0) {
> Why is there a random unrelated change here that wasn't in v1?  And
> isn't even mentioned in the commit message?
>
> --D
O_NONBLOCK is needed because this path can open a FIFO. Without it, 
open(O_RDONLY) blocks until a writer appears.

You're also right that I should have mentioned this change in the commit 
message and the v2 changelog.

I'll fix that in the next revision and drop the unrelated O_CLOEXEC change.
>
>>   		fprintf(stderr, _("%s: failed to open %s: %s\n"),
>>   			progname, fname, strerror(errno));
>>   		goto out_fail;
>>   	}
>>   
>> -	if (fstat(fd, &statbuf) < 0)
>> -		fail(_("invalid or unreadable source path"), errno);
>> +	if (fstat(fd, &statbuf) < 0) {
>> +		fprintf(stderr, _("%s: failed to fstat %s: %s\n"),
>> +			progname, fname, strerror(errno));
>> +		goto out_fail;
>> +	}
>>   
>>   	/*
>>   	 * Handle directory inputs.
>> @@ -101,6 +104,14 @@ setup_proto(
>>   		return result;
>>   	}
>>   
>> +	if (!S_ISREG(statbuf.st_mode)) {
>> +		fprintf(stderr, _("%s: %s not a regular file\n"),
>> +			progname, fname);
>> +		goto out_fail;
>> +	}
>> +
>> +	size = statbuf.st_size;
>> +
>>   	/*
>>   	 * Else this is a protofile, let's handle traditionally.
>>   	 */
>> -- 
>> 2.43.0
>>
>>
