Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D7D39CCFD;
	Mon, 21 Sep 2026 09:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982040; cv=none; b=lQA8gK5/RT7YmtGc3VNc1P8WnTja6t2Fa7YoQBdCJRXLYmBrQ3d9Fx0fX18jzs2ADr4N2MLrUpumFPOrMq7dxVoDny+uVZgV1PWVNvQPF7FCrVEuptIUtnwA8xT5W+ktWOVQVKxNEm0zr1+gkwG41lLo3KUcCoPT++UD7Nqu2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982040; c=relaxed/simple;
	bh=Ta0mONJEgWqK4IOpydKvzfByfKA5pOCqingtiLqLF8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5LqMto+Snk5qE2nb7eugqPZvW0epeCVo3tVtlvbctStZENM7+hfo9DndHiK9f015nAkQHR7erSqmMwoGvKYm4SAWiiXUfdPGMEs9mWIQRMztC8X7UoNXb/f0X0FAOO3fEpuWICVMocJGrvcB7/kNG+1rCsn/1Sm37uvthJ/Li0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pKci3Ps+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pKci3Ps+"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7ZNxo3153438;
	Mon, 21 Sep 2026 09:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uHpbWh7ilinEK48bRJAdvGAA+5jlm2
	rCmcP1EDTkoz4=; b=pKci3Ps+2aw2U5R77z+tRH0KMIIy39lGtvbMJ+gdtBZiRt
	XhEm/AXhPSH3hctgwMPABnss/uqbHzSH593IUdAD2t4pjQOnxsX5vLIHSfY6x3gK
	znL6s/QaX1WtfUM9j8rvnstSomglvHqgCbCYfTYltH9Ei7MsX2LNjWUsWorCgcvG
	0qtD8l5oi0UC/su4IJAu8iEBMNpU8dabcnrH+D/UC2/tzBZG59Zm6dfX39wwwYxI
	xxYWL++xeB/NilAV0eP7Yz2yschmDwBYfX9Pg1RX6zOYr1W2Q4fsSGanZGMRAXN9
	vMByWddAzO5hDzSubz3hmo6wvj+JNaTeTyvqHUsg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1fpws-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:13:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7HmQp931526;
	Mon, 21 Sep 2026 09:13:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt6xgcdym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:13:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68L9D51F8454422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 09:13:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BBD820040;
	Mon, 21 Sep 2026 09:13:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D72420043;
	Mon, 21 Sep 2026 09:13:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.16.92])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Sep 2026 09:12:59 +0000 (GMT)
Date: Mon, 21 Sep 2026 14:42:57 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 05/11] xfs: Add RWF_WRITETHROUGH support to xfs
Message-ID: <arD1GWfg3fH0FhIo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <c284da9ae8f72cea47dfee7bd9f28a270c31a08d.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c284da9ae8f72cea47dfee7bd9f28a270c31a08d.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: XS3xRSuQdjeYIFIUQHGQYYN3KuZLWfc9
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6ab0f524 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=N6Loc1iCyasMdZpCZgQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfXxS1QcLmEMZV9
 lUHzF7Eylxtv46P8/KT/+lnTMiSyCfBmiSe3eGpQXWqW29y339SCozQI+9rtWFkA4d4Ga14yWqK
 s8+YtrcWgpJjK7C6HaCzIgoptX1UIG4=
X-Proofpoint-GUID: QmoOPoBIiT2Xgnop7Sjxbxi1qTn-39yW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfX5sy/h8HRajq7
 mbYA4O3K+QkXU0RJy2e+pDazA3NMDYrsw4X7Q5YXBmtZyiWb/UeSUAqhEJxv/sajcaDkVjdXdaR
 1CI3rJbFV0vbDFWGh+HpTFV5QysOKuL/sbyBbzNyNOEuq1WkqAeT9jdzq2iA9uJDhcIC0X97WBr
 nykKjjmsm2V2cWifiiDUh3SK9Rxr0c6sccv3E8oIsKEoFE+Dbhsn3NDMOpDgMXM7/k5EKVfqL3d
 RBa6UJioZFcANPSPwCF2mDdNZhg4PddrB67QOEo1Qp99gyXjSGybwPC3od4WrPi3V8PUr03QsD4
 R/EdKy/drQJlJxm/lIzYycrtw2KyE872zcoAtevQhD6D7B/ecJlaeaeDP7fAgOSeZewbEXsGcGM
 e2u7woLMJsTQxoIG/gpy5a5xxi5TTCAafqw/JyLhnr/HUUSMieOGTnNn8rIerEyWhlAD/T8C0uH
 gTI5+VhPxdMEYf9TM+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210130

On Wed, Aug 05, 2026 at 11:58:11AM +0530, Ojaswin Mujoo wrote:
> Add the boilerplate needed to start supporting RWF_WRITETHROUGH in XFS.
> We use the direct write ->iomap_begin() functions to ensure the range
> under write through always has a real non-delalloc extent. We reuse the xfs
> dio's end IO function to perform extent conversion and i_size handling
> for us.
> 
> *Note on COW extent over DATA hole case*
> 
> In case of an unmapped COW extent over a DATA hole
> (due to COW preallocations), leave the extent unmapped until we are just
> about to send IO. At that time, use the ->writethrough_submit() call
> back to convert the COW extent to written.
> 
> We initially tried converting during iomap begin() time (like dio does)
> but that results in a stale data exposure as follows:
> 
> 1. iomap begin() - converts COW extent over DATA hole to written and
> marks IOMAP_F_NEW to handle zeroing.
> 2. During iomap_write_begin() -> realise extent is stale and return back
> without zeroing.
> 3. iomap begin() - Again sees the same COW extent but it's written
> this time so we don't mark IOMAP_F_NEW
> 4. Since IOMAP_F_NEW is unmarked, we never zeroout and hence expose
> stale data.
> 
> To avoid the above, take the buffered IO approach of converting the
> extent just before IO, when we are sure to have zeroed out the folio.
> 
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/xfs/xfs_file.c | 83 +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 77 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 768cabf6250b..4b45ceacd461 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -702,6 +702,36 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
>  	.end_io		= xfs_dio_write_end_io,
>  };
>  
> +static int
> +xfs_writethrough_end_io(
> +	struct iomap_writethrough_ctx	*wt_ctx,
> +	ssize_t				size,
> +	int				error,
> +	unsigned int			flags)
> +{
> +	struct xfs_inode *ip = XFS_I(wt_ctx->inode);
> +	xfs_off_t offset = wt_ctx->iocb->ki_pos;
> +
> +	if (unlikely(error)) {
> +		if (wt_ctx->flags & IOMAP_DIO_COW)
> +			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> +
> +		return error;
> +	}
> +
> +	/*
> +	 * writethrough completions are handled same as dio with the exception
> +	 * that we need to explicitly change the i_disk_size. This is because
> +	 * unlike dio, we have already updated the i_size and hence the
> +	 * (i_disk_size < i_size) check will fail in dio code
> +	 */
> +	xfs_dio_write_end_io(wt_ctx->iocb, size, error, flags);
> +	if (offset + size > ip->i_disk_size)

Okay so mostly the Sashiko reviews are straight forward but I would like
to discuss one of it here:

  Is it safe to read ip->i_disk_size locklessly here?

  On 32-bit systems, a lockless read of a 64-bit value can result in a torn
  read. If another thread is concurrently updating i_disk_size via
  xfs_setfilesize(), a torn read might yield a spuriously large value.

  Could this cause the offset + size > ip->i_disk_size condition to evaluate
  to false, skipping the on-disk size update entirely?

Although this seems like a valid concern and we can end up tearing
i_disk_size read on 32 bit machines which can lead to a skipped disksize
update, I see that same sort of unsafe checks for i_disk_size is also
present in the endio code (xfs_ioend_is_append() call)

Shouldnt we ideally be fixing those sites as well or is there something
I'm missing in xfs that makes this acceptable?

Regards,
ojaswin

> +		return xfs_setfilesize(ip, offset, size);
> +
> +	return 0;
> +}
> +
>  static void
>  xfs_dio_zoned_submit_io(
>  	const struct iomap_iter	*iter,
> @@ -1033,6 +1063,39 @@ xfs_file_dax_write(
>  	return ret;
>  }
>  
> +static int
> +xfs_writethrough_submit(
> +	struct inode		*inode,
> +	struct iomap		*iomap,
> +	loff_t			offset,
> +	u64			count)
> +{
> +	int error = 0;
> +	unsigned int		nofs_flag;
> +
> +	/*
> +	 * Convert CoW extents to regular.
> +	 *
> +	 * We are under writethrough context with folio lock possibly held. To
> +	 * avoid memory allocation deadlocks, set the task-wide nofs context.
> +	 */
> +	if (iomap->flags & IOMAP_F_SHARED) {
> +		nofs_flag = memalloc_nofs_save();
> +		error = xfs_reflink_convert_cow(XFS_I(inode), offset, count);
> +		memalloc_nofs_restore(nofs_flag);
> +	}
> +
> +	return error;
> +}
> +
> +const struct iomap_writethrough_ops xfs_writethrough_ops = {
> +	.ops			= &xfs_direct_write_iomap_ops,
> +	.write_ops		= &xfs_iomap_write_ops,
> +	.end_io		= xfs_writethrough_end_io,
> +	.writethrough_submit	= &xfs_writethrough_submit
> +};
> +
> +
>  STATIC ssize_t
>  xfs_file_buffered_write(
>  	struct kiocb		*iocb,
> @@ -1055,9 +1118,13 @@ xfs_file_buffered_write(
>  		goto out;
>  
>  	trace_xfs_file_buffered_write(iocb, from);
> -	ret = iomap_file_buffered_write(iocb, from,
> -			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
> -			NULL);
> +	if (iocb->ki_flags & IOCB_WRITETHROUGH) {
> +		ret = iomap_file_writethrough_write(iocb, from,
> +						    &xfs_writethrough_ops, NULL);
> +	} else
> +		ret = iomap_file_buffered_write(iocb, from,
> +						&xfs_buffered_write_iomap_ops,
> +						&xfs_iomap_write_ops, NULL);
>  
>  	/*
>  	 * If we hit a space limit, try to free up some lingering preallocated
> @@ -1092,8 +1159,12 @@ xfs_file_buffered_write(
>  
>  	if (ret > 0) {
>  		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
> -		/* Handle various SYNC-type writes */
> -		ret = generic_write_sync(iocb, ret);
> +		/*
> +		 * Handle various SYNC-type writes.
> +		 * For writethrough, we handle sync during completion.
> +		 */
> +		if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> +			ret = generic_write_sync(iocb, ret);
>  	}
>  	return ret;
>  }
> @@ -2104,7 +2175,7 @@ const struct file_operations xfs_file_operations = {
>  	.remap_file_range = xfs_file_remap_range,
>  	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
>  			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
> -			  FOP_DONTCACHE,
> +			  FOP_DONTCACHE | FOP_WRITETHROUGH,
>  	.setlease	= generic_setlease,
>  };
>  
> -- 
> 2.55.0
> 
> 
