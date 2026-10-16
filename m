Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9945D30D3FE;
	Fri, 16 Oct 2026 07:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135352; cv=none; b=NIXwzk52wnYQvpfprPPyXoxqTBYOGM8niat5OL23PiIkMEd2tRFAIJ8wPU0TBgfPtx8tSSFk7HlsyyWgNJizvk9amHYo0s9AaKK1FkDPhj6i3ICbs1Yqen5NtZcbxu3Kxn57prc1hEJi/Ti6E72O0JPNWh1R4xq9oVMtA6COgws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135352; c=relaxed/simple;
	bh=BA8ioDZ776ZuU05ezDWHSDCIRfQ76U4v4Hl9KK1fOfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EMh3zdwQOgpWRNveXd6HfwyEz6jAOZ5XANvaMYyUnpvO3RGNOVKBjQyd52yWwoJS8uA5xvzA7ux1xkVHIBLLMLan4U1Ew6cv7ASPI1qqRNe6Vc+UHUKr+yC7p21a9mJfGzlfWBcnzGUBkwnqEXJ6Q3rQNNrgQkHV5dktPW+nf78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E2KN0p+B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E2KN0p+B"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FJ11LI531930;
	Fri, 16 Oct 2026 07:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0PpE94ar8OrMZztp76vISiUaAXnWdK
	1GRR6U58uClO4=; b=E2KN0p+BDg7MCcU/FrkuhAPgbpC3ab9sZ4eAKSz0a/Fdry
	biKYELVVpZXjJNhLQpW9yq3oA8yu08Wy1y6TXwzZfqTEktYATQy+sWqNlvTOIw2+
	6P2sWvWggWMuMt3q9HqCV+O/gjUPbw3Y/vWdwBiprJRtdkxyqakePnbVR/YqGddy
	LvbnWuL3GZGMmmPiO4ZrDsJlZIrlNAxv+o7raHD2lEN6FU4vhzDmo71g4pZfIj08
	KqHm7Q0SivuIK0gs+sGiMAKJKGUA8PIfkYsw/HeldGZV5o67KS8a92mQaAzYpKWL
	CMcWC5FkzTVM3sj0RJWNzIZlYLJCwTqDX2S34/Dw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dv3x0w6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:21:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69G49KNI709720;
	Fri, 16 Oct 2026 07:21:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h9wvgartt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:21:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69G7Lmel52494820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 07:21:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC0CC2004E;
	Fri, 16 Oct 2026 07:21:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6550F20040;
	Fri, 16 Oct 2026 07:21:43 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.31.170])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 16 Oct 2026 07:21:43 +0000 (GMT)
Date: Fri, 16 Oct 2026 12:52:43 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>,
        Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 05/12] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <atHQw76Z5nichi49@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
 <as-BQAbk7U43vkqs@quentin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-BQAbk7U43vkqs@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: YahtI-1taUiiLjeZbfw0cpbMfmngRFck
X-Proofpoint-ORIG-GUID: KY__C4R_eJD0-I7OogprQ5kFmB7DQ2vM
X-Authority-Analysis: v=2.4 cv=aqInmiZV c=1 sm=1 tr=0 ts=6ad1d090 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=FPz6nIrhhYSRGt34OqEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyOCBTYWx0ZWRfX+e2F7yPlOJ6+
 b3jrdrSLQhykQnj4TSd6+/SrsO6/LeG6S91YVo4sCn2YXh/QnZ81mZlC2reX1KbkbXz4GTMCwu3
 iJmpGnHLs5Dcg0gnyA/IxuFuyN/35lc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyOCBTYWx0ZWRfX531dxSqiuPSe
 6oFlbfBQvhx4KwiuEb7mxct/cjeuH+eHdussa7mNEH6KImPOV12dO4wGo4C5WSc16WTDqFif6hC
 rVpAzAFg+yDSd3h9OFKTgZLVk6jTweYsZvHWzoFdWGC1EfhwBntK1x9dkoA63mDPFvoSYBx7qi9
 zEPOYAq1XO+ytoezclhjZqqfAjInJOJ9QZlxzyNpw6P9r6bgMHVRcnhNAto3c48j/AUBnznZpWz
 NwzgJYrkKIfpzR0aI0DJTJr0NvNLtWE1C+8BfTXH1u0heuZzOuYabweP8QDowxr6mh3w1aqiXrm
 J/OIDW/bsp0oz++k99oSyG+ABS1HWyWtIoIdIOmYoN+HQa6HW8e9kcfhwzKzbSpnjCy5WeSl7R9
 GnRN/phMyX8hgmu/3ZuwcuLZ320E4AZMzmE8ftL/IWukw5UVLazQzMhhJRNglgr8i5BMU/z/jk4
 GbnxIcmK0+RGvBUbQqA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160028

On Thu, Oct 15, 2026 at 04:09:50PM +0200, Pankaj Raghav (Samsung) wrote:
> Hi Ojaswin,
> 
> I was comparing normal buffered IO scenario and writethrough.
> 
> In a normal buffered IO scenario, for unwritten extents or CoW extents,
> we first convert them before ending the writeback on the folio.
> xfs_end_io calls xfs_end_ioend_write().
> 
> static void
> xfs_end_ioend_write(
>         struct iomap_ioend      *ioend)
> {
> <snip>
>        /*
>          * Success: commit the COW or unwritten blocks if needed.
>          */
>         if (is_zoned)
>                 error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
>                                 ioend->io_private, NULLFSBLOCK);
>         else if (ioend->io_flags & IOMAP_IOEND_SHARED)
>                 error = xfs_reflink_end_cow(ip, offset, size);
>         else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
>                 error = xfs_iomap_write_unwritten(ip, offset, size, false);
> 
>         if (!error &&
>             !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
>             xfs_ioend_is_append(ioend))
>                 error = xfs_setfilesize(ip, offset, size);
> done:
>         if (is_zoned)
>                 xfs_ioend_put_open_zones(ioend);
>         iomap_finish_ioends(ioend, error); // #1
>         memalloc_nofs_restore(nofs_flag);
> }
> 
> #1
> iomap_finish_ioends()
>   iomap_finish_ioend_buffered_write()
>     iomap_finish_folio_write()
>       folio_end_writeback()
> 
> 
> On Mon, Sep 28, 2026 at 05:33:06PM +0530, Ojaswin Mujoo wrote:
> > @@ -1185,6 +1186,384 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> >  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
> >  }
> >  
> > +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> > +{
> > +	struct kiocb *iocb	= wt_ctx->iocb;
> > +	struct inode *inode	= wt_ctx->inode;
> > +	ssize_t ret		= wt_ctx->error;
> > +
> > +	if (wt_ctx->end_io) {
> > +		int err = wt_ctx->end_io(wt_ctx, wt_ctx->written,
> > +					 wt_ctx->error,
> > +					 wt_ctx->flags);
> > +		if (err)
> > +			ret = err;
> > +	}
> > +
> 
> <snip>
> 
> > +static void iomap_writethrough_bio_end_io(struct bio *bio)
> > +{
> > +	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
> > +	struct folio_iter fi;
> > +
> > +	if (bio->bi_status)
> > +		cmpxchg(&wt_ctx->error, 0,
> > +			blk_status_to_errno(bio->bi_status));
> > +	bio_for_each_folio_all(fi, bio)
> > +		folio_end_writeback(fi.folio);
> > +
> > +	bio_put(bio);
> > +	if (atomic_dec_and_test(&wt_ctx->ref))
> > +		iomap_writethrough_done(wt_ctx);
> > +}
> > +
> 
> But in the writethrough patches, we first end the writeback on the folio
> and then call xfs_dio_write_end_io(), which converts unwritten or CoW
> extents.
> 
> Is there a race possible as we are doing the other way? What if folios
> are reclaimed between ending the writeback and conversion? A new read in
> that area will return zero filled folios as XFS still sees IOMAP_UNWRITTEN?
> 
> I don't have a reproducer, but my hunch says we can run into this if we
> have a lot of AIO as the end_io will be run via a workqueue?
> 
> Do we do something similar to buffered IO where we do
> folio_end_writeback after extents conversion?

Hey Pankaj, thanks for pointing this out. I agree that this can open up
some races like you mentioned. I believe the right things will be to
have an buffered endio like flow however we will need to store the
folios somewhere till the whole conversion is done, like buffered endio
does in struct ioend->io_bio. Hmm I think it would be ideal if we could
somehow reuse some of the logic there. I'll see if its possible.

Thanks,
ojaswin


> 
> --
> Pankaj
