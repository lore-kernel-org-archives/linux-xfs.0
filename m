Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 04:46:48 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47BkifB032153
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 04:46:45 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47Bkh21026930
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:46:43 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47BkhAb550744
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:46:43 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47Bkh3g010826
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:46:43 -0400
Date: Mon, 7 May 2007 17:16:49 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] ext4: Extent overlap bugfix
Message-ID: <20070507114649.GC7012@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181101.GC7209@amitarora.in.ibm.com> <20070503213002.eff696db.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213002.eff696db.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 03, 2007 at 09:30:02PM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 23:41:01 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > +unsigned int ext4_ext_check_overlap(struct inode *inode,
> > +					struct ext4_extent *newext,
> > +					struct ext4_ext_path *path)
> > +{
> > +	unsigned long b1, b2;
> > +	unsigned int depth, len1;
> > +
> > +	b1 = le32_to_cpu(newext->ee_block);
> > +	len1 = le16_to_cpu(newext->ee_len);
> > +	depth = ext_depth(inode);
> > +	if (!path[depth].p_ext)
> > +		goto out;
> > +	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
> > +
> > +	/* get the next allocated block if the extent in the path
> > +	 * is before the requested block(s) */
> > +	if (b2 < b1) {
> > +		b2 = ext4_ext_next_allocated_block(path);
> > +		if (b2 == EXT_MAX_BLOCK)
> > +			goto out;
> > +	}
> > +
> > +	if (b1 + len1 > b2) {
> 
> Are we sure that b1+len cannot wrap through zero here?

No. Will add a check here for this. Thanks!
 
> > +		newext->ee_len = cpu_to_le16(b2 - b1);
> > +		return 1;
> > +	}


--
Regards,
Amit Arora
