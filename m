Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BAB34D93C;
	Fri, 17 Apr 2026 19:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776455002; cv=none; b=rpj2pFjEm7+v1Uh2hLI2/pHmDJt4owYNcS9b9Krcp9tenKF1TYhO8PDqtRNCNWuAzgRILL2e85q0FO7SPrBGrwNnpIUkXCwrywOCffvvN2riWk1hS72opwTqEChlGmTPhK1QCfhW44gbFxDy2+scjknN2vdKVmUxLdk7cOLOmaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776455002; c=relaxed/simple;
	bh=53imMrCG7vlCdD/9bVGPkEjYjcplJLJDWDE0NP4f4ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2BU2yGWKuvcQe1CBSmkYBmYIJHB6HCCT3TZ3pQvGojfg4Gob5EEZQyrPQdufqXJTrVrSw4t9tbveqAj3h+mBtaj6Vvyym8uQ85hCLrP6SOBL9fGpvklq9TytuMtEb8DvNgPuYFjyDkyfdxfa4ifUBAdCOw35zmxL4XJs4iG0bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=irnyE72w; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="irnyE72w"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HG05Si3154222;
	Fri, 17 Apr 2026 19:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=cvh1VgONX4/3qNjA2Ob+WGs9ue62xz
	Y0MNvI0t9yelQ=; b=irnyE72wrTq/N3edtXG0bWlhqfGzzOSft6rYh5arm0QlD7
	5yStzFELHh3l8dVAHYoRw2D/5BKXjR2OUkbOAgg6c+IlS9+4CzDZns8dy2FFIx7S
	GaLBKcmmt0N4MjgET58cOrpkmcsyhRJO3yKWnGzmdoTrQt9zz1izm4yQ45Ci7ySV
	FVOZ8mgajxrmqgmZZdXMyVwFGOL+mQs8vr46Z8gUr7LUTdVYqEpw+DIcFOEPthdq
	cFDwi1wRXRvXs6s1qcWtzvxOw2Fb2IIKDkvN7LMT7UWk/wzXcdTtlG8csHjBeAKh
	b+xO366VKW2kOX5mowW/jxYK8nO3bSSjG6Nf3/eg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mjx93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 19:42:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63HJgLeP027004;
	Fri, 17 Apr 2026 19:42:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dkrud8jqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 19:42:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63HJgS3m51970514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 19:42:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C862620040;
	Fri, 17 Apr 2026 19:42:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE82E20043;
	Fri, 17 Apr 2026 19:42:24 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.217.229])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Apr 2026 19:42:24 +0000 (GMT)
Date: Sat, 18 Apr 2026 01:12:22 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69e28d28 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=iox4zFpeAAAA:8 a=L_Rc3U-7anCWMeNG1UEA:9 a=CjuIK1q_8ugA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: d08wlshN9TBrM0DgmDRH27aWDxiMxpHQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDE5NCBTYWx0ZWRfX1PICK/4BfjE2
 cIEoFcSTptUofhQ8IAypPoiWIt71w/V7OmsVZxBxj0dW7le8aDAfHDsRUw14wUe2rraigFwVWWh
 KEa+x3ReMsooPS3exPpY/JZTNaNNTJs6vOChkjtveQ9e0+EWmF8yJpCvNJK8ED3sMF7MDwoxUy/
 hfv+/pbI1H+3F5VBt6c4mHmv/N7juJ1c/l/eb4n3S76miM0r2VK91salkCKKypY3dZXs+i9kUvG
 /JvQNYRVkDFVElCcfZ9vLCjx/j7LUJf77IBuXwNd/E5TMaA+tuVe0tDfP0+EstkMtZ2eOlBpvrH
 xlxwkwwU6ONLSguFZ5ZKog2swnC2ulZzRKTbZLAkNxe9X6Up5xJxC7mUTv8haR+2w6qAWb7/ErP
 9ljCqIn0uFtM2lX2PyUolx5YBBRO6y2mFS9jtIDiORtkKf9k47zW6X5kPGG+UwRdQSEBsGsmOmz
 n96ldTv0BQoetQwuFIg==
X-Proofpoint-ORIG-GUID: XT_8hpf9nsPNK5yUFMbPS2N0zU2uf0Je
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170194

On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> Some more thoughs... :)

Hi Jan, 

Thanks for the review!
> 
> > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> >  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
> >  }
> >  
> > +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> > +{
> > +	struct kiocb *iocb	= wt_ctx->iocb;
> > +	struct inode *inode	= wt_ctx->inode;
> > +	ssize_t ret		= wt_ctx->error;
> > +
> > +	if (wt_ctx->dops && wt_ctx->dops->end_io) {
> > +		int err = wt_ctx->dops->end_io(iocb, wt_ctx->written,
> > +						wt_ctx->error,
> > +						wt_ctx->flags);
> 
> It's a bit odd to use only ->end_io from dops also because we don't really
> use direct IO submission path. So perhaps you can have just an end_io
> handler pointer in iomap_writethrough_ops similarly as you have a
> submission one?

Yes makes sense, I can change that in v3.
> 
> > +		if (err)
> > +			ret = err;
> > +	}
> > +
> > +	mapping_clear_stable_writes(inode->i_mapping);
> > +
> > +	if (!ret) {
> > +		ret = wt_ctx->written;
> > +		iocb->ki_pos = wt_ctx->pos + ret;
> > +	}
> > +
> > +	kfree(wt_ctx);
> > +	return ret;
> > +}
> 
> ...
> 
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
> > +			wt_ctx->nr_bvecs = 0;
> > +			break;
> > +		}
> > +
> > +		if (bytes > iomap_length(iter))
> > +			bytes = iomap_length(iter);
> > +
> > +		/*
> > +		 * Bring in the user page that we'll copy from _first_.
> > +		 * Otherwise there's a nasty deadlock on copying from the
> > +		 * same page as we're writing to, without it being marked
> > +		 * up-to-date.
> > +		 *
> > +		 * For async buffered writes the assumption is that the user
> > +		 * page has already been faulted in. This can be optimized by
> > +		 * faulting the user page.
> > +		 */
> > +		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
> > +			status = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
> > +					   &offset, &bytes);
> > +		if (unlikely(status)) {
> > +			iomap_write_failed(iter->inode, iter->pos, bytes);
> > +			break;
> > +		}
> > +		if (iter->iomap.flags & IOMAP_F_STALE)
> > +			break;
> > +
> > +		pos = iter->pos;
> > +
> > +		if (mapping_writably_mapped(mapping))
> > +			flush_dcache_folio(folio);
> > +
> > +		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
> > +		written = iomap_write_end(iter, bytes, copied, folio) ?
> > +			  copied : 0;
> > +
> > +		if (!written)
> > +			goto put_folio;
> > +
> > +		off_aligned = round_down(offset, bs);
> > +		len_aligned = round_up(offset + written, bs) - off_aligned;
> > +
> > +		iomap_folio_prepare_writethrough(folio, off_aligned,
> > +						 len_aligned);
> > +
> > +		if (!wt_ctx->nr_bvecs)
> > +			wt_ctx->bio_pos = round_down(pos, bs);
> > +
> > +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> > +			       len_aligned, off_aligned);
> 
> Shouldn't we zero out the tail of the folio if we are submitting partial
> folio for write?

Hmm, so for the folio range we zeroout if needed in
__iomap_write_begin(). I think that should take care of this right? 

> 
> > +		wt_ctx->nr_bvecs++;
> > +		wt_ctx->written += written;
> > +
> > +		if (pos + written > wt_ctx->new_i_size)
> > +			wt_ctx->new_i_size = pos + written;
> 
> I'm probably missing something here but where is i_size update handled? I
> don't see new_i_size used anywhere? 

So the i_size update happens in endio(), similar to dio. We initially
had the update in iomap_writethrough_iter in v1 however based on Dave's
feedback [1], moved it to the endio. The idea is for writethrough
semantics to be closer to dio hence we either update isize when we
succeffuly write, or return an error to user without update isize.

[1] https://lore.kernel.org/linux-fsdevel/aa--rBKQG7ck5nuM@dread/

> Also why is it OK to not call pagecache_isize_extended() but that goes
> with the i_size update...

As for pagecache_isize_extended(), (this might be a bit tangential from
your comment but) after this email, I started diggin a bit more into why
it is needed.  As per my understanding, it tackles 2 things:

Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
allows us to allocate new blocks which previously might not be allocated
if bs < ps.

Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
old EOF to end of that folio so that readers dont read junk data after
isize extension.

Another thing I noticed is that most users of
iomap_file_buffered_write() do their own eof zeroing in the FS layer
(eg, xfs_file_write_zero_eof(), ext4's new changes,
ntfs_extend_initialized_size() etc). 
I think this FS level zerooing should take care of mkcleaning the eof
folio (problem 1), as they call iomap_zero_range() which would flush the
eof range anyways. So am I right in assuming that for FSes that do their
own zeroing, 1. is already taken care of?

As for 2, I think after the EOF zeroing of the FS, there might be a
window before iomap_write_iter() where an mmap writer can still dirty
EOF blocks, hence the pagecache_isize_extended() would be needed here.
But doesn't that then make the eof zeroing in the FS layer redundant? Am
I missing something here?

Regardless, for our case I think we will also need to do the
pagecache_isize_extended(), mainly to take care of problem 2, but where
exactly should we do it now?  We currently change the isize in endio()
but for aio, it can run outside inode or folio lock. I think this
function needs to be called under inode lock(). Hmm.. its a bit late here so
I'll revisit this tomorrow with a fresh mind :)

> 
> > +
> > +		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs)
> > +			iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
> > +
> > +put_folio:
> > +		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
> > +
> > +		cond_resched();
> > +		if (unlikely(written == 0)) {
> > +			iomap_write_failed(iter->inode, pos, bytes);
> > +			iov_iter_revert(i, copied);
> > +
> > +			if (chunk > PAGE_SIZE)
> > +				chunk /= 2;
> > +			if (copied) {
> > +				bytes = copied;
> > +				goto retry;
> > +			}
> > +		} else {
> > +			total_written += written;
> > +			iomap_iter_advance(iter, written);
> > +		}
> > +	} while (iov_iter_count(i) && iomap_length(iter));
> 
> Overall the differences of this function from iomap_write_iter() seem
> relatively small so maybe it would be possible to just extend
> iomap_write_iter() to support writethrough IO as well? Basically once we've
> copied data into the folio and called iomap_write_end() we can have "if
> writethrough, call function to prepare & submit the folio for IO".

Right, we ideally want to avoid as much duplication of the code as
possible, but in v1 where we did use iomap_write_iter() and
iomap_dio_rw(), we ended up with a lot of if else logic making it messy.

I think just using iomap_write_iter() with writethrough specific IO
submission functions is worth a try though, but Im not sure how ugly
passing the extra writethrough params will look there :) Anyways, thanks
for the suggesting, I'll give it a try and see.

> 
> > +
> > +	if (wt_ctx->nr_bvecs)
> > +		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
> > +
> > +	return total_written ? 0 : status;
> > +}
> > +
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
