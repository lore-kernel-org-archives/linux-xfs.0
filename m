Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9F355F43
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775679045; cv=none; b=XGmuJ1a3ZvveAJw3hGtDqP8a3vsql1KWHxWOhXIsXeAr3BKJpFTuFUDQmRkm2DS0dkvnCcKvDcuSznnDkm+fmfagh2Cm21C2IwN/OvZZOEHWoEvE76wXOcRdAKq6LJ3NR3bSVhIcsxgQUZ4MSzISXGnUvhuwKL7iduWX3BjW41c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775679045; c=relaxed/simple;
	bh=WMLKKNYiSxEy2xAU6WTHaAaTE+cBa07ovGOG8ufCpc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qFaMcmfhsnlfgxmFJYz8Usjr0AqgZPEiGfjNPeROyz3Ic8Z7q7UdPZElUwML3E7+ehGwL6BmbEQEk5DSCu0hCtV1c24WieB+7QaKW2hHQBpTpwtj1jADNUssNh2npyMx9V7X7WrriVVKT6xYpfwDx/zwjJbWKErgK0ucM5Ni3Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=g//499sA; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="g//499sA"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JuBxn1413672
	for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2026 16:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=vSff
	Q46dxsNqLEMfW9mFNMfZBuciexIdSUQp95L3zYs=; b=g//499sAUgG6l/aPNEY4
	MrWDgZlHmfuOJ2N7pJMdRvAl/ADxc31gcYWWhPadhtApYsJGBMdVuAZ84Tyf0TLd
	o7X5qy6NkDuP6cuAUkdTFD8YsGuNlKCVqHKCAnE9rBvb0CUUJkvkmpeafOlj6nFb
	KtVZjONIOH0+rMVhdndCyxP4SZmYj9cAcwKbHQBhr3E0D2JfV0q7q15HV/dekLR8
	RPvAfnvNTl8WK7OvOdrYJ5LOORWmu9FgFUIZkXM0Vzzwg+Yg6PWm5vkmCIWOp7A6
	AKzSJZs356dJIl90Rk97kyFsa3pwGkyruHvPJHy6Wv6ixy5KnZy0bZvHdbim9/DG
	Ww==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mfn3a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 16:10:41 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50b4661881eso1684631cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 13:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775679041; x=1776283841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vSffQ46dxsNqLEMfW9mFNMfZBuciexIdSUQp95L3zYs=;
        b=OKC/TnUQV0Z9ieC4VewWgKa5DcHx461tAJ7vU/YudmDiX+C7GbUoUoZQklOiVYJeai
         dOd8JuRC0MHsunERmE8F/EC9gR2Sh/yu65oBuoiNAJwkX2tGwTpiGk5bFriKTMUp6Kng
         hVebS1AKJUwvKqx6xfhM+mIWyqCfPSyr+flqmwF3EKWXO4t2Z54vP6agTEC2IRggxal9
         QmJOWj1xExL2J1QUcEjYwLF+naRO5ajaogyvL+907dS3u48CF99tacvxWxhuJYCCmEtP
         C5OqwcNLr/bI5sDCadN+M/OuZce7FDXEqfEmbo9I2Z2IZ9mfCNiJxYYapDgAnjY7aVw7
         zfSw==
X-Forwarded-Encrypted: i=1; AJvYcCXB8INMMnEDJ9bC6F0wtgpP83D7R8iZsz9E+oHw1D9Hfdk+2gpS9BwMpT9hx8VY0LxH2b1T+uynUUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYTf5Zz/DYgv6J/SwcRkBIhdr2L15hAq/Dafqejmcmru+QLaus
	/Z6drEaGOszPKIeTbWfa2e6q9+OXbvhSF/lXxchIa+4NKFuOwjrwa0Uj0YKaP0Rh6l+PwwdbE3D
	dWLknTv6upB2+sN3zHKF9EFTt5Z18gEWZpoZJiibn/6KWoXRBRq8bZ9NosQ==
X-Gm-Gg: AeBDiesNp4RoQ2kqtjpoAmRl0IlkbjkMGIy0N4FOkuDusYDsMUGhscrSkPsKhyoCVxv
	xrYMCDM+k2MZAFTlHKAlMYKZArifpKTx55B0d1fG7gHgzc/plbNwlbL6vUDHM26Hh18a91rSHy2
	FY+RgRZEUfclQI6vjHX1fDyl4ICLoHsPQt8MJ4m/PfySiMHks7G2BJb3Pm15rAu+t9tTAd4dOhX
	PYYc06S9n6Nn/WO5yFZ2nvuJXgrviFhNMhFfvLmprOMX+QjBHeZuCQysfOf93MwQlj0L9752HnD
	nmqfMpVFh4inUmRRw4RDX9Hk7I6lmTKyN5mYN/1cDZujpZCEp/6V70gvuyJl3AGc84xvUJbI2Wy
	nJycosf6Br0zC4Kd5Pq70+xTbaJttGnP1UnTkBHN7
X-Received: by 2002:ac8:5846:0:b0:50d:83d7:686c with SMTP id d75a77b69052e-50d83d76b21mr252299081cf.31.1775679041394;
        Wed, 08 Apr 2026 13:10:41 -0700 (PDT)
X-Received: by 2002:ac8:5846:0:b0:50d:83d7:686c with SMTP id d75a77b69052e-50d83d76b21mr252298531cf.31.1775679040871;
        Wed, 08 Apr 2026 13:10:40 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50db5cfd8a9sm20333591cf.12.2026.04.08.13.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 13:10:40 -0700 (PDT)
Message-ID: <62c1ec17-082d-4215-85ca-3e87048a6226@columbia.edu>
Date: Wed, 8 Apr 2026 16:10:39 -0400
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
 <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
 <ada0KnRjpYnY_QYh@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ada0KnRjpYnY_QYh@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: mgKwYQj5rUS9vHCf2jga25SuSLSp60Tm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4OCBTYWx0ZWRfX87M0P2Le+xr5
 Z0ZU57LUAvFU1RzjfiN9N0f562fYV5V5ZWnLgsPe/uhQ/FFnvCrVDnBOetYw6kSFLb6ld+6KREL
 7cNM8LeL8RywrdR4hM29CjENBBJv1dYChF6c86gEPQ5akeDs+7AgqKZJNOTeE/mYYoxJUL73MbK
 O0b/bEk4cW3DTO65hMjD/yDyDfZYaWarcwkZ0E2p6LAYMh9CpzV8UlgQLL47vMY6zprLtpV82JT
 AXLxwf5LeA/SrfdM3GGmrtFGViIwbDntdrN98t6OK8p2jEuq+YM3ieyiRzEagTZKvS6mERu1Sd/
 ihCTRWKs172/eZgyLZpuS6Mi8FNMMQ1Gim52VrZZSShMuYDWRGG2YNHay/Gwa6YNnZaUX2Zoh32
 Efq7QS+ZrlHosVWI86efJNbGbMPAnC43E3+vb6aPXj+nIlqnf9dlZoXplFzgYycBiYqM5URjRf0
 hyaKfztIj+YgvrWRMGg==
X-Proofpoint-ORIG-GUID: mgKwYQj5rUS9vHCf2jga25SuSLSp60Tm
X-Authority-Analysis: v=2.4 cv=X7Fi7mTe c=1 sm=1 tr=0 ts=69d6b641 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=rfDhleDhcnsx78YaP-MA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080188

On 4/8/26 4:01 PM, Matthew Wilcox wrote:
> On Wed, Apr 08, 2026 at 03:44:37PM -0400, Tal Zussman wrote:
>> On 3/25/26 4:21 PM, Matthew Wilcox wrote:
>> > On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
>> >> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
>> >> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
>> >> context, where folio_end_dropbehind() can safely invalidate folios.
>> >> 
>> >> With the bio layer now handling task-context deferral generically, XFS
>> >> no longer needs to route DONTCACHE ioends through its completion
>> >> workqueue for page cache invalidation. Remove the DONTCACHE check from
>> >> xfs_ioend_needs_wq_completion().
>> >> 
>> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> >> ---
>> >>  fs/iomap/ioend.c  | 2 ++
>> >>  fs/xfs/xfs_aops.c | 4 ----
>> >>  2 files changed, 2 insertions(+), 4 deletions(-)
>> >> 
>> >> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
>> >> index e4d57cb969f1..6b8375d11cc0 100644
>> >> --- a/fs/iomap/ioend.c
>> >> +++ b/fs/iomap/ioend.c
>> >> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>> >>  			       GFP_NOFS, &iomap_ioend_bioset);
>> >>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>> >>  	bio->bi_write_hint = wpc->inode->i_write_hint;
>> >> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
>> >> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>> >>  	wbc_init_bio(wpc->wbc, bio);
>> >>  	wpc->nr_folios = 0;
>> >>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
>> > 
>> > Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
>> > 
>> > 	if (folio_test_dropbehind(folio))
>> > 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
>> > 
>> > It'd need to move down a few lines in iomap_add_to_ioend() to after
>> > bio_add_folio() succeeds.
>> > 
>> 
>> Actually, looking into it more, IOMAP_IOEND_DONTCACHE is used as part of
>> IOMAP_IOEND_NOMERGE_FLAGS. I think deleting it while maintaining the
>> no-merge behavior would be uglier than leaving it in.
> 
> But why was it added to NOMERGE in the first place?  I don't think it's
> harmful to merge writeback I/Os which are COMPLETE_IN_TASK and I/Os
> which are not, as long as the final I/O is completed in a task.
> 

Looks like it was added in commit 34ecde3c5606 to ensure XFS DONTCACHE
completions were actually punted to task context... which we now ensure
elsewhere. Will delete and mention the side effect on regular I/Os in the
commit message.

