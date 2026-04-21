Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BD633D6E3;
	Tue, 21 Apr 2026 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776795377; cv=none; b=bDDzC4Jz3cEybsO33r19hJOV6D3CF3//zQODMiB72kxPMze7mLTOsvD+LPKEC3bjp6qVhsxlvCiW7eENEheoPW1wu/2TVkyVz9N0+NmT2ptOTgFLksM4qVYzNfafN08sgkeEAyzSIOzr4xfYuLCfoxXrgyQFreGeOXB8sfOrzN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776795377; c=relaxed/simple;
	bh=ztM+qleEtEf2sEYtWBOtunlzaNA2ae78J/a9RqdRZ5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UIVikLFZHq2CQb28suJN7XVNLAF/H3B6rMCowpJCNWYOy3VybGOKjIAUIwa6Xw5+8It8Z9opeIiQiEv3Vq8TgOWHWTSPX6ZiuwqbxufZS8hEiK6WEW85qL4JFRjF65SlpgehKoMqrftKYlM+lPut5iUTmoWv/zbIqZcDOT5Negw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o8/qWa4t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o8/qWa4t"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LHoB3T753710;
	Tue, 21 Apr 2026 18:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Q/M2ql55deJBXwgrNvuvQcgHfU/E88
	NoJNIezEXyITc=; b=o8/qWa4tC5O04YnEVrhapsWZRAMvKopusd8ObM2NLb+h05
	73VB0k+5b9xqsRSH0QgI47hAeNNYA9R+M1yeCxqhdqRAAXLf9qn+xmNAQwLEyCtq
	tJ8i9xWbXNPVRM8NQgCsXKkdC+RoGSSwIrtwIvHjPyNMRnbA3qU/8TBKPn6OqgPU
	gtKgFBsa0wb4YOsmaV917/UlMWm37AK4FB96rd8SPpupcLIjqbQlxYUKmrB7zdHI
	ZrlSUyAgyjiXBeFWnfiruBxxy8IXh9lKDv9b/mhy90slZ/LJNKZVd9l1mbv+6TFi
	Oc/u/NdnRAdda1wRHqF1d3s59vEzJ6oDvwQZrHKw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2nf5ra9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:15:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63LHZIcp009830;
	Tue, 21 Apr 2026 18:15:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9k1tv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:15:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63LIFfuP61669838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 18:15:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E768A20043;
	Tue, 21 Apr 2026 18:15:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A03520040;
	Tue, 21 Apr 2026 18:15:36 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.146])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Apr 2026 18:15:35 +0000 (GMT)
Date: Tue, 21 Apr 2026 23:45:33 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: y36Nuu59mSgnJb-uQq-EDrVFDYuFRljY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDE3NyBTYWx0ZWRfX99+kfwP9K8GZ
 YEvRRYzVFnAXxgPhX+oxgfDX5G0Ygs2AjsgDPKwvyaus27lu73g8pJf2RdL1V9BUluclbuYqv0J
 JEqN7/xHp+x9l+aiOZcWKXmRwG+J53C2XgqRuU3OfTNkj7ENaE3AzyVmoHSH/Atqhb/iKFDB3s0
 5aFmYn9C5kxaMYJ1c1YuCnq0IyTEEcoJvWjA5jtyRk+NNAKlxXEzT0nPF73o8YvrX2BEhy8UBKO
 C8HGsJNN79s/a8PmjsicfViblBl7PcBdTmK0OUr6rdpV+RBQdDMTYLdAi/tVx4VBX7iyaZNheWh
 thIUS//th7iID74yWnL1jLykbGhksX0rlqLru0zCqz+VlbwQj69K68WjOOj566HAcESCU7+b+F7
 EUzW9WYHwJWXry6msY+nsyU8Wl/ptEXwTd4/z1ZywOku+aWBFX3KzHDUOGU+45EhJfP1VcGIjfY
 Dr1p4apDJ6P+Y1HmR5A==
X-Proofpoint-GUID: rqpRcvBTBogBp19_f8NgESjUZm6_IUnP
X-Authority-Analysis: v=2.4 cv=B7iJFutM c=1 sm=1 tr=0 ts=69e7bed0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Cl_7ivfH_JflWmaJJIsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210177

On Mon, Apr 20, 2026 at 01:56:02PM +0200, Pankaj Raghav (Samsung) wrote:
> > +
> > +	if (wt_ops->writethrough_submit)
> > +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
> > +					    len);
> > +
> > +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
> 
> We might want to check if bio_alloc succeeded here.

Hi Pankaj, so we pass GFP_NOFS which has GFP_DIRECT_RECLAIM and
according to comment over bio_alloc()

 * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
 * allocate a bio.  This is due to the mempool guarantees.  To make this work,
 * callers must never allocate more than 1 bio at a time from the general pool.

And we seem to be following this.

> 
> > +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> > +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> > +	bio->bi_private		= wt_ctx;
> > +
> > +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> > +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> > +				wt_ctx->bvec[i].bv_len,
> > +				wt_ctx->bvec[i].bv_offset);
> > +
> > +	atomic_inc(&wt_ctx->ref);
> > +	submit_bio(bio);
> > +	wt_ctx->nr_bvecs = 0;
> > +}
> > +
> <snip>
> > +
> > +/**
> > + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> > + * @wt_ctx: writethrough context
> > + * @iter: iomap iter holding mapping information
> > + * @i: iov_iter for write
> > + * @wt_ops: the fs callbacks needed for writethrough
> > + *
> > + * This function copies the user buffer to folio similar to usual buffered
> > + * IO path, with the difference that we immediately issue the IO. For this we
> > + * utilize IO submission and completion mechanism that is inspired by dio.
> > + *
> > + * Folio handling note: We might be writing through a partial folio so we need
> > + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> > + * in the folio after the writethrough.
> > + */
> > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > +				   struct iomap_iter *iter, struct iov_iter *i,
> > +				   const struct iomap_writethrough_ops *wt_ops)
> > +
> > +{
> > +	ssize_t total_written = 0;
> > +	int status = 0;
> > +	struct address_space *mapping = iter->inode->i_mapping;
> > +	size_t chunk = mapping_max_folio_size(mapping);
> > +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> > +	unsigned int bs = i_blocksize(iter->inode);
> > +
> > +	/* copied over based on DIO handles these flags */
> > +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> > +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> > +	if (iter->iomap.flags & IOMAP_F_SHARED)
> > +		wt_ctx->flags |= IOMAP_DIO_COW;
> > +
> > +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> > +		return -EINVAL;
> > +
> > +	do {
> > +		struct folio *folio;
> > +		size_t offset;		/* Offset into folio */
> > +		u64 bytes;		/* Bytes to write to folio */
> > +		size_t copied;		/* Bytes copied from user */
> > +		u64 written;		/* Bytes have been written */
> > +		loff_t pos;
> > +		size_t off_aligned, len_aligned;
> > +
> > +		bytes = iov_iter_count(i);
> > +retry:
> > +		offset = iter->pos & (chunk - 1);
> > +		bytes = min(chunk - offset, bytes);
> > +		status = balance_dirty_pages_ratelimited_flags(mapping,
> > +							       bdp_flags);
> > +		if (unlikely(status))
> > +			break;
> > +
> > +		/*
> > +		 * If completions already occurred and reported errors, give up
> > +		 * now and don't bother submitting more bios.
> > +		 */
> > +		if (unlikely(data_race(wt_ctx->error))) {
> 
> In the unlikely scenario where we encounter an error, do we have to also
> clear the writeback flag on all the folios that is part of this
> bvec until now?
> 
> Something like explicitly iterate over wt_ctx->bvec[0] through 
> wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
> on them, and then discard the bvecs by setting the nr_bvecs = 0;
> 
> I am wondering if the folios that were processed until now will be in
> PG_WRITEBACK state which can affect reclaim as we never clear the flag.

Hey Pankaj, yes you are right. I think the error handling is a bit buggy
and Sashiko has also pointed some of these. I'll take care of this in
v3, thanks for pointing this out.

Regards,
ojaswin

> 
> > +			wt_ctx->nr_bvecs = 0;
> > +			break;
> > +		}
> > +
> 
> --
> Pankaj
