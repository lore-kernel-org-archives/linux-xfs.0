Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4143613B588
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 10:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724754336; cv=none; b=k9eRHOHuIngAyv4ykj447/pIXcMILCZ20i9Wx664ORnN8e6FydW+s48Z2a9gv2PRGsagDYVpxObVVXElY/XJh/IA6ltpCiiMOzBsCGF2Buu8FtqHCy4sRVR0m6yvX5YZIfp9QC9ApFlYBVkqn0f3vi89KuCkKBmORz1fCNh7rtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724754336; c=relaxed/simple;
	bh=wZEmWFq1Vc009nl04L+wPmbkRHSpFFh06xVkT9GmLYI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HqClilOKRsjgE3gTKH5cZhXhOBcL9Kx82E9fIMNMmuTW9ON6LuBLl53CE7QV6bO113hqHoetwW7LRxxoLAKTpMePRd+HYO62q8K10Q0INhJRhAAyncDqWZMvw1X6FduTaEipUL9OD46eaZ+pSZoOCibRdX3VMH2nIBBnoiPDUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a8498c64645e11efa216b1d71e6e1362-20240827
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:9958b0bf-13b6-46b7-8f92-7a331c30df1d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-3,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:7
X-CID-INFO: VERSION:1.1.38,REQID:9958b0bf-13b6-46b7-8f92-7a331c30df1d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-3,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:7
X-CID-META: VersionHash:82c5f88,CLOUDID:406ec40fb55c92bc0a700dada7d860dc,BulkI
	D:240823084930J9CBJ1U2,BulkQuantity:2,Recheck:0,SF:101|74|66|38|23|17|64|1
	00|19|42|102,TC:nil,Content:0|-5,EDM:-3,IP:-2,URL:11|1,File:nil,RT:nil,Bul
	k:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: a8498c64645e11efa216b1d71e6e1362-20240827
X-User: liuhuan01@kylinos.cn
Received: from [192.168.12.10] [(1.198.30.53)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 281523266; Tue, 27 Aug 2024 18:25:18 +0800
Subject: Re: [PATCH] xfs_db: make sure agblocks is valid to prevent corruption
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
References: <20240821104412.8539-1-liuhuan01@kylinos.cn>
 <20240823004912.GU6082@frogsfrogsfrogs>
 <Zs1GxsICOpY/SKzn@dread.disaster.area>
From: liuh <liuhuan01@kylinos.cn>
Message-ID: <7e23cd96-e022-2458-0b7c-b0138db02718@kylinos.cn>
Date: Tue, 27 Aug 2024 18:24:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zs1GxsICOpY/SKzn@dread.disaster.area>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit

ÔÚ 2024/8/27 11:23, Dave Chinner Ð´µÀ:
> On Thu, Aug 22, 2024 at 05:49:12PM -0700, Darrick J. Wong wrote:
>> On Wed, Aug 21, 2024 at 06:44:12PM +0800, liuhuan01@kylinos.cn wrote:
>>> From: liuh <liuhuan01@kylinos.cn>
>>>
>>> Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
>>> 	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1
>>>
>>> System will generate signal SIGFPE corrupt the process. And the stack as follow:
>>> corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
>>> 	#0  libxfs_getbuf_flags
>>> 	#1  libxfs_getbuf_flags
>>> 	#2  libxfs_buf_read_map
>>> 	#3  libxfs_buf_read
>>> 	#4  libxfs_mount
>>> 	#5  init
>>> 	#6  main
>>>
>>> The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
>>> In this case, user cannot run in expert mode also.
>>>
>>> Never check (mp)->m_sb.sb_agblocks before use it cause this issue.
>>> Make sure (mp)->m_sb.sb_agblocks > 0 before libxfs_mount to prevent corruption and leave a message.
>>>
>>> Signed-off-by: liuh <liuhuan01@kylinos.cn>
>>> ---
>>>   db/init.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/db/init.c b/db/init.c
>>> index cea25ae5..2d3295ba 100644
>>> --- a/db/init.c
>>> +++ b/db/init.c
>>> @@ -129,6 +129,13 @@ init(
>>>   		}
>>>   	}
>>>   
>>> +	if (unlikely(sbp->sb_agblocks == 0)) {
>>> +		fprintf(stderr,
>>> +			_("%s: device %s agblocks unexpected\n"),
>>> +			progname, x.data.name);
>>> +		exit(1);
>> What if we set sb_agblocks to 1 and let the debugger continue?
> Yeah, I'd prefer that xfs_db will operate on a corrupt filesystem and
> maybe crash unexpectedly than to refuse to allow any diagnosis of
> the corrupt filesystem.
>
> xfs_db is a debug and forensic analysis tool. Having it crash
> because it didn't handle some corruption entirely corectly isn't
> something that we should be particularly worried about...
>
> -Dave.

I agree with both of you, xfs_db is just a debugger tool.
But for the above case, xfs_db can do nothing, even do a simple view on 
primary superblock.
The user all knowns is that xfs_db goto corrupt, but don't know what's 
cause the problem.

If set sb_agblocks to 1, xfs_db can going to work to view on primary 
superblock,
but can't relay on it to view more information.

Maybe left a warning message and set sb_agblocks to 1 and let debugger 
continue is better.

Thanks.

