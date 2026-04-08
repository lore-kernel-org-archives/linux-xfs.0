Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F29737EFE9
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 19:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775677482; cv=none; b=SXHHerns7vdsVLUfZXyyAXWz8QmE5j/IbIfMV22R1eJfZH2zhNxmxVcDMa/HbZjgLEfDXQEpxE7ZAiy9TKj/xJx4nLVoI2IFfJ/V0akFn927mVic7eV3FkgfJL5iVvrA8gGZpfZgBWTfHl7YpBipxa/hNfyJWBQB+O9vQPRmg4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775677482; c=relaxed/simple;
	bh=UKOON8VnufQeIosYs85uC5OQYu8eeg0kTOI170aPmhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8xCZMpnG2tQtQm9n5r6rkffqKdkQOGFTKc2zBuONwaiXKCUnqdPJPgnuUqOLCL0kV7x2rv/z0jmM6wQoCsBklxGsC6jqwXTw/nn3H2y2uF3Pg4Oz1pPaNJbfClta7Wdl+lUZfVz2hyTPeVJfVJxch9k3G3Y262vqs4i1sZR9Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=iUwfPg//; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="iUwfPg//"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JN33b992473
	for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2026 15:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cQ/T
	G8NyYW11ar8cP2zAAoS1p0Xy/yaGNX7PKSKfnNI=; b=iUwfPg//iz4QeOnNBzRS
	26n2mXDCUin867E41bkq6MbXzJHVhjIy/JEpfgrWMmzpIsMffhoxNVTijCNdayK/
	omdxmyQIaWWqjhhsoGUDrlftst5MjFj746hiLNxRoVv72HAOs+GhT20N0600pdSJ
	u5kM8hnYgRkZX6K4bIoCR7Qo/G/l5U/VGm6eJWpF8tJjbvRicduLndw2xV5BJFV6
	2MO5int4NAEXn+ocjmyXJjwWv5Zn7wusO7sw/CSCjPjDYkxyp/CFH6qM1gnEVUvO
	4Dt9o5W5NtfMdq6ljtr/V5OX8jy9ZDscvwkt3yUFXutNGJ/muM2RT9QZnmgA/w5E
	Zg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3nf8s2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 15:44:39 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50b220c72bbso6228871cf.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 12:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677478; x=1776282278;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cQ/TG8NyYW11ar8cP2zAAoS1p0Xy/yaGNX7PKSKfnNI=;
        b=ZaGxCndWdXOQZWz7az5Ty1i+REUA5NZtBuG5d/H/4ZqagYik+ChLn/VDwyGbtlTR71
         Qqcld95pxqg+OwCQ6E2UDVCUeTMP+jqnQ3bp/mOgqblBXyy5LEtuDmLD86BmXKjJVdwx
         u9vIv/CIhQ6nypBikY8p6liXtDtdwJ208YGaS/DyG8ewcs3LV+ZvqeV+nUkyMUKAO4vH
         5u7q+A/R6eg/tJoJTxzTrCvK+MINoOHjGAJbigkuy1zyv/9dd12FGdBskHfiHlxVdXRw
         jELHSMpkoDbbFAYNW9/vfzTIRXymk16QCBp1VPYiHH5glE1+oCyCniaOrJBgft2aWL5m
         PlVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQgmkaM5lofsSrx523122YkiueKlviaUTwmaU36LS+hKNrrRjAcC7v1+sKV0zOehovi99rF5uhjHo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy14k7h3iMDPLKcprrYgspngaUjAHtofLXT8DVyn2ky7VLoIBNN
	l4R78D6SMkyyK0jZ2VxsivLsknid7znOmQqSXfHC23t8CU6z9ln57yVBzmXXDbkHjd/VTO7DEIp
	JUyKchSevA6wWxgIBzojZI41GZlOV3ik4JJnR131oBPNYEGYF5f00pgNNImxdoC6Zzg==
X-Gm-Gg: AeBDietyAakMvRnBrULmX0I65n7pEuGalBpEW9wo2Y/Np8vRENNUy8xFFQ/g2/NdXIS
	/Rrd8YnXUIsEzbH1CFGSFEKw6mw+px2GNcFk2W5OEUdXdCs9g467vjXX86Kv5KioSAHUee4ee6j
	rluaU0mzG5Dt3OJugg11fgnKlaoWaWTsCkS5CUY8aKZzYGWv7JW9ScQfwE16v8z5t7HF8T1fcRV
	21VSZVPWm5QWvqesHhMrseldD+Cm0jTAVvaaXASCVasXpFnfgxwZcr54NxfCTOP/8Pw0kZdKw7f
	va7oJ7gvMmhh2RdmS07BJQEk4hdNNubtxrW3pKCyEoZjwpdbiwZen1pp4gkCr4Df6aK3AxY23zU
	gKemwtLj6sRO+lhYY1K1qKrJHr3MOvrA185OfvLNI
X-Received: by 2002:a05:622a:558b:b0:509:3098:819a with SMTP id d75a77b69052e-50dc22dd2a7mr10872201cf.44.1775677478533;
        Wed, 08 Apr 2026 12:44:38 -0700 (PDT)
X-Received: by 2002:a05:622a:558b:b0:509:3098:819a with SMTP id d75a77b69052e-50dc22dd2a7mr10871821cf.44.1775677478076;
        Wed, 08 Apr 2026 12:44:38 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b1a3fc7sm215560781cf.5.2026.04.08.12.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 12:44:37 -0700 (PDT)
Message-ID: <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
Date: Wed, 8 Apr 2026 15:44:37 -0400
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4NCBTYWx0ZWRfXyuA/mBElVfs/
 nXmJB0socg5xyj/rkwOJW03C91Jr9dhvGvXA+zkx8Z9IXuFpYaxdhMsuxZBWeYB9HLl19LFDnHq
 e9VpEFnB1GOAPN77wB4yazBrUZzjtXJxGThB/iecR2qIfMPaI/1BwcVu28LHb17qCsRQyxh/mZ9
 HEy0z1Ni5EmTRgHuQugDeRDsJ/JwUL4rMnID4HrghP6UXJi491OjxZ1+bRpzjO3xs291ax1OR2c
 Dp8LoCimOf8Gr05TVFPJuhYfE4rH3aIz7UWDF8jsmkcOf9AATeeOAnORqKm0NiDAQMPHSqILybM
 su4HhnZOYQjLC7EOXHuEQNtWzN8QcIbe5BkLy+igpheYCGKDNRKwTg0a+J8wVP7eba97ZQDmxBG
 ydhDgfo5SNk2312tMZZWAmlfxjKmravq/LfS5Ej854MaKYvi489Oknd19QmHGCwZOo8fOzewi1N
 fW0o15X776gwDuUgsJw==
X-Proofpoint-GUID: SjaNe0k4BlY82ldapzDt6N7rWlnxBwZ6
X-Authority-Analysis: v=2.4 cv=d6HFDxjE c=1 sm=1 tr=0 ts=69d6b027 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=X-nALmS6JCAzqVr0gswA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: SjaNe0k4BlY82ldapzDt6N7rWlnxBwZ6
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=10
 impostorscore=10 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080184



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

Actually, looking into it more, IOMAP_IOEND_DONTCACHE is used as part of
IOMAP_IOEND_NOMERGE_FLAGS. I think deleting it while maintaining the
no-merge behavior would be uglier than leaving it in.

