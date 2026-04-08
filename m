Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76127979A
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775677010; cv=none; b=M87yr2Q7fAqnrJ32vfQxlW5y7Z1JHsH40KsuOcK4f0IOu27nFoLyccvvTcnhni6WpIbf//w5F9F5gdhbu8O1rCwTVTj9t5okUHYM7daWHaN2XKhHnRCsjjEkTn9Y3Ie1WX4FF7AB0aUyOkT9AskARYoEUc5jIT3pOqQp5ektFPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775677010; c=relaxed/simple;
	bh=XwPRZu5Ld+QTZqlV+HMue7Ds/fH2LaUK/cZVeqKosVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EzGLKbYIxcTOU7fQulfTIqYsf6hxuPMDo8pahHGC2Kfaz2g3hbsVW/K2ko7WGGCyJlCdCaUhdOUlL97SA1NK0dhmpz61Jxi61th7FNndJrNtuwHbWE1bhI9Cvdzihrc+5X0p9y7112jnEdT9oPQnAtkUPc9/QBl3rdPS+71AGaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=QA99faMh; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="QA99faMh"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JPF3u1274194
	for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2026 15:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=96l/
	i7uyqouj4dytN5MpYVZKfSy3eXi7wDZWJb62Zz8=; b=QA99faMhBQ2CRLNNFL8L
	qRU0KP4xnwNqn7cMfDQW5hCPv6hts7r/Xd5kZaAY3dSC43v6ijdCL1tNUW26zeG0
	i00xv5/w0hQP+E/6FmGItYboGNRG00oqthfvGcLHUjewrJYPfEU7rIUhb+rrH3ZI
	E7MY1V9FjX/Rjvqq6Buhdtpm+GujTj7zgsZPqlGlaK9OmmMVEoPJ8/8i9H/r++Ew
	xasVMLD228PIgjw2pkPCzEZbfiWSUlXyI0hlkxJ+Un5rnqSYBqPbHFeq+tEtIyhj
	R4oX1MgQkBQVvA1CNbDR1nsrNcP1286385FwkRZAdf/g5IG6aI/qI16ZN0btyleO
	5w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mfb23-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 15:36:48 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50b44f7b7bbso5160761cf.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 12:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677008; x=1776281808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96l/i7uyqouj4dytN5MpYVZKfSy3eXi7wDZWJb62Zz8=;
        b=m42o3Q+4zIBcXzTHaW2XOknh7MOpdk/6tG+hj42oHGWFkS/SEc2ORaaj6P/WXgShYG
         tgqEzCTxgHMhGygs4NTC41GsxDY9UrQcsLOe30otv/Yqznx692yZIzTikzEuuu42Gecd
         M8R1uwVeqaYm1wWP7HNwzT1ySmHDX1mPJZiqzSIoaEBGI/qn4Tyrfv3jONN4fZQAc4jX
         DW16kp8AZQNnGT2cl3HShgNHRYzqln6FfIL1kE5ksoia3NivbIHbM7+QjrIQVs9/rZJy
         ZlmKLb/eLWeBrEbH0tu9PLHdHIvKY3ejXyljJ1uQQm7I0TN/oASQUuN9YqP+c3UpsBjo
         zlUQ==
X-Forwarded-Encrypted: i=1; AJvYcCX86k4dlFG8uxy3JTjPW3vuX2wPNd6LpxkNOZeT9ChS90N1AjQroPtijBbGOXouk9d3sMVvk7rU1X8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyweJnNRY02x+9sOfMKTBNt980gw3xBuk+9vcIVZ+Hhthp85p09
	XiZziIDD83UNtlyAjI51B65r9oAJlGA7ZWlgmryxq95wQOckVUPGSrs2l0qTVgajOuNdfdk2IpN
	y5o+v7GTvhw1fIbXorMnJVnLJrUrdZ4o/nE5lvP8T7Z/YqCaL+J5QCe9ABg==
X-Gm-Gg: AeBDietHC+D0TEUtiyg/eTypA3qshzXlk5Al9aWXM/62yUinjUvdYDcRO1NcS3u4DJI
	AROSbvx7ALgjc1/SnlMuNRgWz+U5p4m2k99Kj/qWZlCXgZJ3gGxqY7OkXOQ4Wqz+BmJfSlzYkOO
	IQhBIv7jjfEu/4vkaxMYyV+VO+i439QIiR1zSOnFamH5rbxVzyZTjYe3H9Ry5hAQA26WavX8AmW
	HdOBA/kF7a1TfXII+TVZ+yn46fxEgu57B27M+mkNTSLRamDwUuI5JL/qa4dE7Egk/5+K4pLBxrA
	5OysQLF7uB2juVXSd4cv6+1araDP5CB/BmHskHi6EstE+OVT2j7w+I/JzBSrrZNMqIlY2BJvZzH
	XiGh8gU0H8pYNsj/AlfvpOMGafyUpPEpOUYSeHcVo
X-Received: by 2002:a05:622a:1a86:b0:50d:6b6d:bc17 with SMTP id d75a77b69052e-50dc212b2e3mr10299401cf.23.1775677007883;
        Wed, 08 Apr 2026 12:36:47 -0700 (PDT)
X-Received: by 2002:a05:622a:1a86:b0:50d:6b6d:bc17 with SMTP id d75a77b69052e-50dc212b2e3mr10298851cf.23.1775677007355;
        Wed, 08 Apr 2026 12:36:47 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d64752857sm142454931cf.21.2026.04.08.12.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 12:36:46 -0700 (PDT)
Message-ID: <c7342d7f-5c92-4a2c-9d00-5f9cf478f4e1@columbia.edu>
Date: Wed, 8 Apr 2026 15:36:45 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <acRDyJrkJhnHHMSe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: jZzJint8kgWR_vwXXCWLDwEHVDi0MRUC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4MyBTYWx0ZWRfX/qaJstqe2pxK
 Pcohv69Co4+p+9oQacVQhcFNaU66A7JwQcoL2Or/QO+HRNiFKgZctJncGI/d/pwR/G2YQNmI5VP
 m+Pefrug3fH00cySocfvHhXbirRs4VSXhkp38VBqj7i1fvvr3SEy9qnOccQGsMdhKen7cn8Kl2J
 oMu+O1xY+2p6fTHvC9I/T2ZkqpGF3DcapzhS28ZwTqLciVd6jLZP8f85V/8PaBlHAxeX35AwFDe
 m59oHdp1aWgj34bRDM5L1Z0qRI38Qy1hEBrxFxImIYqEWknW83DkyFPabUjZWc+BqzISsfa+ICL
 4hbLmK0xByvwnQNsbhus0J03kODIi3BhxhNDQUsuKvuRS+YhkOJycufkiTXyv06ThCN3+YSlvBb
 6ZtPce85mKCRFNIMvMyC+aIF+LNUqih4Aljh6eupTgkDo39zpGNI8J30ASWsz33IUUKcP5tL/ND
 76/D/BosnH89UCNqphA==
X-Proofpoint-ORIG-GUID: jZzJint8kgWR_vwXXCWLDwEHVDi0MRUC
X-Authority-Analysis: v=2.4 cv=X7Fi7mTe c=1 sm=1 tr=0 ts=69d6ae50 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=fDzNMwFgse8Xf2NrkjQA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080183

On 3/25/26 4:21 PM, Matthew Wilcox wrote:
> On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
>> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
>> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
>> context, where folio_end_dropbehind() can safely invalidate folios.
>> 
>> With the bio layer now handling task-context deferral generically, XFS
>> no longer needs to route DONTCACHE ioends through its completion
>> workqueue for page cache invalidation. Remove the DONTCACHE check from
>> xfs_ioend_needs_wq_completion().
>> 
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  fs/iomap/ioend.c  | 2 ++
>>  fs/xfs/xfs_aops.c | 4 ----
>>  2 files changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
>> index e4d57cb969f1..6b8375d11cc0 100644
>> --- a/fs/iomap/ioend.c
>> +++ b/fs/iomap/ioend.c
>> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>>  			       GFP_NOFS, &iomap_ioend_bioset);
>>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>>  	bio->bi_write_hint = wpc->inode->i_write_hint;
>> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
>> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>>  	wbc_init_bio(wpc->wbc, bio);
>>  	wpc->nr_folios = 0;
>>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> 
> Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
> 
> 	if (folio_test_dropbehind(folio))
> 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> It'd need to move down a few lines in iomap_add_to_ioend() to after
> bio_add_folio() succeeds.
> 

Will do, thanks Matthew!

