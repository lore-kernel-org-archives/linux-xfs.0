Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0893C1412;
	Wed, 11 Mar 2026 10:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773225361; cv=none; b=aCh+Difg6ePjWi2a8oDiy4pweQlPXpFlvIB+wyIkALu7qK955R8HobY86643VJAj3fjkT3vMm0AH7W1eVDyIRQcEU1hiv/TwgtjWt0sxiKv678UY6ynescC5s3714qRmuBaHDkTGVbXg2hFTuHxlptR29powiasOVmzvHiVzgbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773225361; c=relaxed/simple;
	bh=6Sj9nEKsZx47NU0e/BIvyW3IUY0CM84RcOkBP2PFLck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRCdPO77eHZefa0/C3gOYnJTlD6RVXphU37C7NyEHKhOSvY7Ow9aXHemdXnvlQq9CH8fCIya0UZmeGlLtblHZe/i8hGABXIHPz57k+hrBv4BtAM1YEBEZ8dSwvwo36n3sxyEApmsKAUUO/Lm7nKiNdj1rrSqvDUT4ooyOg7j10w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KSeGyCOn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KSeGyCOn"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AN3Irv1609981;
	Wed, 11 Mar 2026 10:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=tif99qDg3EpC2FggF+zzOWQfp3UeJa
	1fcxtwTqw7Z0s=; b=KSeGyCOn2Fh+rFGxNyKXsZE/4mI9Sl6a0A9RtsT8hZxCaH
	TpO+49NWxcTgOyfM854nXbgZpLU5tXxyC7HtCvr0ZPK+NwTs+X+QcwXNgi99laYq
	7xUkEygkbM+q1OtiwmEGvPFnXEE4vxgYYhu/Ssj4mSa6/AAQ0cuygIffXGZOOWTv
	E6WrG+FMLAOYlvgEhrKkCGwqeisDjCtNymhUWZKgMRqqM0s110ZM3njJ3J6t1WcM
	x5n0DPBOlaRlMCIf9pUrLi4x3O0REttK0TQ7g9vpJVByMpWtKSZ2WMv047knR4PV
	PEAHbpauXWOS76iOS8i/ZYfqn3RsNc2ho682NDqQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcunevrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 10:35:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62B8VafA015750;
	Wed, 11 Mar 2026 10:35:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs1224tj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 10:35:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62BAZYc848038146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 10:35:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AFBE2006A;
	Wed, 11 Mar 2026 10:35:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 721322006B;
	Wed, 11 Mar 2026 10:35:31 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.158])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 11 Mar 2026 10:35:31 +0000 (GMT)
Date: Wed, 11 Mar 2026 16:05:29 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] iomap: Support buffered RWF_WRITETHROUGH via async dio
 backend
Message-ID: <abFFcSTmUaAzbmOB@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1773076216.git.ojaswin@linux.ibm.com>
 <c84ddc3f864f840d646b6aa19fd9b3e83e079c0b.1773076216.git.ojaswin@linux.ibm.com>
 <aa--rBKQG7ck5nuM@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa--rBKQG7ck5nuM@dread>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: o3E0sEordKcdciC2N54a8mcOwQZZ1crU
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69b1457b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=vxzPlDirLMDX4tnNRrsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA4OCBTYWx0ZWRfX9mDWYc5oUNBv
 3Gg6szdxFs99V1/0bWbEyWJ4jpRMLc/gFkJ8CH1Bj0PCHgIBcwnv9/QQ/hJpDms+IaOC3cW9YoJ
 noBuTStj02IMCOY4XnkFCqmIIZrqpRflPoAWzfLXhD+zv+TQKUHiC3BvFIMa0U9KGKh5HCa7f3d
 CV/hl2OVPjPHcdKbmCmBgYob2t7pV8mJNpvQZBCWfMKZlXQuCw+Sg3E8S075evVcw3U+HUyPWFv
 zvGSPV928FLKBG9KS8gdSBk9dQ5Xx0HMkxYX7hb8YqB47PgtK9E6pmfi1StimLnjZuC+FDeTVBI
 gnTviEy55odeUHTO9xWzxJ8vydeF+blBA8e0p+s69mnEzxIKJrXme14R9WteyzeCMzOh0IeACMQ
 wdtBNVNADhzqrWJSxEG+w+n31GUBSK27CLxpb4c49A+8N2KKJMrfAnHY9JmPLirNw4PEmfO+E8J
 DDASv6qiyVdk/wvSABQ==
X-Proofpoint-ORIG-GUID: 3ZlUg0okJyqXCZeUUEIbSX96RU0jdYrm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603110088

On Tue, Mar 10, 2026 at 05:48:12PM +1100, Dave Chinner wrote:
> On Mon, Mar 09, 2026 at 11:04:31PM +0530, Ojaswin Mujoo wrote:
> > +/**
> > + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> > + * @iocb: kernel iocb struct
> > + * @iter: iomap iter holding mapping information
> > + * @i: iov_iter for write
> > + * @wt_ops: the fs callbacks needed for writethrough
> > + *
> > + * This function copies the user buffer to folio similar to usual buffered
> > + * IO path, with the difference that we immediately issue the IO. For this we
> > + * utilize the async dio machinery. While issuing the async IO, we need to be
> > + * careful to clone the iocb so that it doesnt get destroyed underneath us
> > + * incase the syscall exits before endio() is triggered.
> > + *
> > + * Folio handling note: We might be writing through a partial folio so we need
> > + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> > + * in the folio after the writethrough.
> > + *
> > + * TODO: Filesystem freezing during ongoing writethrough writes is currently
> > + * buggy. We call file_start_write() once before taking any lock but we can't
> > + * just simply call the corresponding file_end_write() in endio because single
> > + * RWF_WRITETHROUGH might be split into many IOs leading to multiple endio()
> > + * calls. Currently we are looking into the right way to synchronise with
> > + * freeze_super().
> > + */
> > +static int iomap_writethrough_iter(struct kiocb *iocb, struct iomap_iter *iter,
> > +				   struct iov_iter *i,
> > +				   const struct iomap_writethrough_ops *wt_ops)
> > +{
> > +	ssize_t total_written = 0;
> > +	int status = 0;
> > +	struct address_space *mapping = iter->inode->i_mapping;
> > +	size_t chunk = mapping_max_folio_size(mapping);
> > +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> > +
> > +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> > +		return -EINVAL;
> > +
> > +	do {
> ......
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
> ......
> > +		/*
> > +		 * The copy-to-folio operation succeeded. Lets use the dio
> > +		 * machinery to send the writethrough IO.
> > +		 */
> > +		if (written) {
> > +			struct iomap_writethrough_ctx *wt_ctx;
> > +			int dio_flags = IOMAP_DIO_BUF_WRITETHROUGH;
> > +			struct iov_iter iov_wt;
> > +
> > +			wt_ctx = kzalloc(sizeof(struct iomap_writethrough_ctx),
> > +					GFP_KERNEL | GFP_NOFS);
> > +			if (!wt_ctx) {
> > +				status = -ENOMEM;
> > +				written = 0;
> > +				goto put_folio;
> > +			}
> > +
> > +			status = iomap_writethrough_begin(iocb, folio, iter,
> > +							  wt_ctx, &iov_wt,
> > +							  offset, written);
> > +			if (status < 0) {
> > +				if (status != -ENOMEM)
> > +					noretry = true;
> > +				written = 0;
> > +				kfree(wt_ctx);
> > +				goto put_folio;
> > +			}
> > +
> > +			/* Dont retry for any failures in writethrough */
> > +			noretry = true;
> > +
> > +			status = iomap_dio_rw(&wt_ctx->iocb, &iov_wt,
> > +					      wt_ops->ops, wt_ops->dio_ops,
> > +					      dio_flags, NULL, 0);
> .....
> 
> This is not what I envisiaged write-through using DIO to look like.
> This is a DIO per folio, rather than a DIO per write() syscall. We
> want the latter to be the common case, not the former, especially
> when it comes to RWF_ATOMIC support.
> 
> i.e. I was expecting something more like having a wt context
> allocated up front with an appropriately sized bvec appended to it
> (i.e. single allocation for the common case). Then in
> iomap_write_end(), we'd mark the folio as under writeback and add it
> to the bvec. Then we iterate through the IO range adding folio after
> folio to the bvec.
> 
> When the bvec is full or we reach the end of the IO, we then push
> that bvec down to the DIO code. Ideally we'd also push the iomap we
> already hold down as well, so that the DIO code does not need to
> look it up again (unless the mapping is stale). The DIO completion
> callback then runs a completion callback that iterates the folios
> attached ot the bvec and runs buffered writeback compeltion on them.
> It can then decrements the wt-ctx IO-in-flight counter.
> 
> If there is more user data to submit, we keep going around (with a
> new bvec if we need it) adding folios and submitting them to the dio
> code until there is no more data to copy in and submit.
> 
> The writethrough context then drops it's own "in-flight" reference
> and waits for the in-flight counter to go to zero.

Hi Dave,

Thanks for the review. IIUC you are suggesting a per iomap submission of
dio rather than a per folio, and for each iomap we submit we can
maintain a per writethrough counter which helps us perform any sort of
endio cleanup work. I can give this design a try in v2.

> 
> 
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index c24d94349ca5..f4d8ff08a83a 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -713,7 +713,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  	dio->i_size = i_size_read(inode);
> >  	dio->dops = dops;
> >  	dio->error = 0;
> > -	dio->flags = dio_flags & (IOMAP_DIO_FSBLOCK_ALIGNED | IOMAP_DIO_BOUNCE);
> > +	dio->flags = dio_flags & (IOMAP_DIO_FSBLOCK_ALIGNED | IOMAP_DIO_BOUNCE |
> > +				  IOMAP_DIO_BUF_WRITETHROUGH);
> >  	dio->done_before = done_before;
> >  
> >  	dio->submit.iter = iter;
> > @@ -747,8 +748,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  		if (iocb->ki_flags & IOCB_ATOMIC)
> >  			iomi.flags |= IOMAP_ATOMIC;
> >  
> > -		/* for data sync or sync, we need sync completion processing */
> > -		if (iocb_is_dsync(iocb)) {
> > +		/*
> > +		 * for data sync or sync, we need sync completion processing.
> > +		 * for buffered writethrough, sync is handled in buffered IO
> > +		 * path so not needed here
> > +		 */
> > +		if (iocb_is_dsync(iocb) &&
> > +		    !(dio->flags & IOMAP_DIO_BUF_WRITETHROUGH)) {
> >  			dio->flags |= IOMAP_DIO_NEED_SYNC;
> 
> Ah, that looks wrong. We want writethrough to be able to use FUA
> optimisations for RWF_DSYNC. This prevents the DIO write for wt from
> setting IOMAP_DIO_WRITE_THROUGH which is needed to trigger FUA
> writes for RWF_DSYNC ops.
> 
> i.e. we need DIO to handle the write completions directly to allow
> conditional calling of generic_write_sync() based on whether FUA
> writes were used or not.

Yes right, for now we just let xfs_file_buffered_write() ->
generic_write_sync() to handle the sync because first we wanted to have
some discussion on how to correctly implement optimized
O_DSYNC/RWF_DSYNC. 

Some open questions that I have right now:

1. For non-aio non FUA writethrough, where is the right place to do the
   sync? We can't simply rely on iomap_dio_complete() to do the sync
   since we still hold writeback bit and that causes a deadlock. Even if
   we solve that, we need to have a way to propogate any fsync errors
   back to user so endio might not be the right place anyways?

2. For non-aio writethrough, if we do want to do the sync via
   xfs_file_buffered_write() -> generic_write_sync(), we need a way to
   propogate IOMAP_DIO_WRITE_THROUGH to the higher level so that we can
   skip the sync.

Also, a naive question, usually DSYNC means that by the time the
syscall returns we'd either know data has reached the medium or we will
get an error. Even in aio context I think we respect this semantic
currently. However, with our idea of making the DSYNC buffered aio also
truly async, via writethrough, won't we be violating this guarantee?

Regards,
Ojaswin

> 
> > @@ -765,35 +771,47 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  		}
> >  
> >  		/*
> > -		 * i_size updates must to happen from process context.
> > +		 * i_size updates must to happen from process context. For
> > +		 * buffered writetthrough, caller might have already changed the
> > +		 * i_size but still needs endio i_size handling. We can't detect
> > +		 * this here so just use process context unconditionally.
> >  		 */
> > -		if (iomi.pos + iomi.len > dio->i_size)
> > +		if ((iomi.pos + iomi.len > dio->i_size) ||
> > +		    dio_flags & IOMAP_DIO_BUF_WRITETHROUGH)
> >  			dio->flags |= IOMAP_DIO_COMP_WORK;
> 
> This is only true because you called i_size_write() in
> iomap_writethrough_iter() before calling down into the DIO code.
> We should only update i_size on completion of the write-through IO,
> not before we've submitted the IO.
> 
> i.e. i_size_write() should only be called by the IO completion that
> drops the wt-ctx in-flight counter to zero. i.e. i_size should not
> change until the entire IO is complete, it should not be updated
> after each folio has the data copied into it.
> 
> >  		/*
> >  		 * Try to invalidate cache pages for the range we are writing.
> >  		 * If this invalidation fails, let the caller fall back to
> >  		 * buffered I/O.
> > +		 *
> > +		 * The execption is if we are using dio path for buffered
> > +		 * RWF_WRITETHROUGH in which case we cannot inavlidate the pages
> > +		 * as we are writing them through and already hold their
> > +		 * folio_lock. For the same reason, disable end of write invalidation
> >  		 */
> > -		ret = kiocb_invalidate_pages(iocb, iomi.len);
> > -		if (ret) {
> > -			if (ret != -EAGAIN) {
> > -				trace_iomap_dio_invalidate_fail(inode, iomi.pos,
> > -								iomi.len);
> > -				if (iocb->ki_flags & IOCB_ATOMIC) {
> > -					/*
> > -					 * folio invalidation failed, maybe
> > -					 * this is transient, unlock and see if
> > -					 * the caller tries again.
> > -					 */
> > -					ret = -EAGAIN;
> > -				} else {
> > -					/* fall back to buffered write */
> > -					ret = -ENOTBLK;
> > +		if (!(dio_flags & IOMAP_DIO_BUF_WRITETHROUGH)) {
> > +			ret = kiocb_invalidate_pages(iocb, iomi.len);
> > +			if (ret) {
> > +				if (ret != -EAGAIN) {
> > +					trace_iomap_dio_invalidate_fail(inode, iomi.pos,
> > +									iomi.len);
> > +					if (iocb->ki_flags & IOCB_ATOMIC) {
> > +						/*
> > +						* folio invalidation failed, maybe
> > +						* this is transient, unlock and see if
> > +						* the caller tries again.
> > +						*/
> > +						ret = -EAGAIN;
> > +					} else {
> > +						/* fall back to buffered write */
> > +						ret = -ENOTBLK;
> > +					}
> >  				}
> > +				goto out_free_dio;
> >  			}
> > -			goto out_free_dio;
> > -		}
> > +		} else
> > +			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
> >  	}
> 
> Waaaay too much indent. It is time to start factoring
> __iomap_dio_rw() - it is turning into spaghetti with all these
> conditional behaviours.
> 
> >  
> >  	if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 8b3dd145b25e..ca291957140e 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -346,6 +346,7 @@ struct readahead_control;
> >  #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
> >  #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
> >  #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
> > +#define IOCB_WRITETHROUGH	(__force int) RWF_WRITETHROUGH
> >  
> >  /* non-RWF related bits - start at 16 */
> >  #define IOCB_EVENTFD		(1 << 16)
> > @@ -1985,6 +1986,8 @@ struct file_operations {
> >  #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
> >  /* File system supports uncached read/write buffered IO */
> >  #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
> > +/* File system supports write through buffered IO */
> > +#define FOP_WRITETHROUGH	((__force fop_flags_t)(1 << 8))
> >  
> >  /* Wrap a directory iterator that needs exclusive inode access */
> >  int wrap_directory_iterator(struct file *, struct dir_context *,
> > @@ -3436,6 +3439,10 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
> >  		if (IS_DAX(ki->ki_filp->f_mapping->host))
> >  			return -EOPNOTSUPP;
> >  	}
> > +	if (flags & RWF_WRITETHROUGH)
> > +		/* file system must support it */
> > +		if (!(ki->ki_filp->f_op->fop_flags & FOP_WRITETHROUGH))
> > +			return -EOPNOTSUPP;
> 
> Needs {}
> 
> >  	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
> >  	if (flags & RWF_SYNC)
> >  		kiocb_flags |= IOCB_DSYNC;
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 531f9ebdeeae..b96574bb2918 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -209,6 +209,7 @@ struct iomap_write_ops {
> >  #endif /* CONFIG_FS_DAX */
> >  #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
> >  #define IOMAP_DONTCACHE		(1 << 10)
> > +#define IOMAP_WRITETHROUGH	(1 << 11)
> >  
> >  struct iomap_ops {
> >  	/*
> > @@ -475,6 +476,15 @@ struct iomap_writepage_ctx {
> >  	void			*wb_ctx;	/* pending writeback context */
> >  };
> >  
> > +struct iomap_writethrough_ctx {
> > +	struct kiocb iocb;
> > +	struct folio *folio;
> > +	struct inode *inode;
> > +	struct bio_vec *bvec;
> > +	loff_t orig_pos;
> > +	loff_t orig_len;
> > +};
> > +
> >  struct iomap_ioend *iomap_init_ioend(struct inode *inode, struct bio *bio,
> >  		loff_t file_offset, u16 ioend_flags);
> >  struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
> > @@ -590,6 +600,14 @@ struct iomap_dio_ops {
> >   */
> >  #define IOMAP_DIO_BOUNCE		(1 << 4)
> >  
> > +/*
> > + * Set when we are using the dio path to perform writethrough for
> > + * RWF_WRITETHROUGH buffered write. The ->endio handler must check this
> > + * to perform any writethrough related cleanup like ending writeback on
> > + * a folio.
> > + */
> > +#define IOMAP_DIO_BUF_WRITETHROUGH	(1 << 5)
> 
> I suspect that iomap should provide the dio ->endio handler itself
> to run the higher level buffered IO completion handling. i.e. we
> have callbacks for custom endio handling, I'm not sure that we need
> logic flags for that...

Got it Dave, will look into this. Thanks for the review.

Regards,
Ojaswin

> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
