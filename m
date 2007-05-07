Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 08:48:24 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47FmJfB009196
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 08:48:21 -0700
Received: from e1.ny.us.ibm.com ([192.168.1.101])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l47FOkpf023745
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:24:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47FOffK009339
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:24:41 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47FOfJk549588
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:24:41 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47FOewe027863
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:24:40 -0400
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <20070507120719.GD7012@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426181332.GD7209@amitarora.in.ibm.com>
	 <20070503213133.d1559f52.akpm@linux-foundation.org>
	 <20070507120719.GD7012@amitarora.in.ibm.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 10:24:37 -0500
Message-Id: <1178551477.12900.6.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, 2007-05-07 at 17:37 +0530, Amit K. Arora wrote:
> On Thu, May 03, 2007 at 09:31:33PM -0700, Andrew Morton wrote:
> > On Thu, 26 Apr 2007 23:43:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> > > +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> > > +{
> > > +	handle_t *handle;
> > > +	ext4_fsblk_t block, max_blocks;
> > > +	int ret, ret2, nblocks = 0, retries = 0;
> > > +	struct buffer_head map_bh;
> > > +	unsigned int credits, blkbits = inode->i_blkbits;
> > > +
> > > +	/* Currently supporting (pre)allocate mode _only_ */
> > > +	if (mode != FA_ALLOCATE)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > > +		return -ENOTTY;
> > 
> > So we don't implement fallocate on bitmap-based files!  Well that's huge
> > news.  The changelog would be an appropriate place to communicate this,
> > along with reasons why, or a description of the plan to fix it.
> 
> Ok. Will add this in the function description as well.
> 
> > Also, posix says nothing about fallocate() returning ENOTTY.
> 
> Right. I don't seem to find any suitable error from posix description.
> Can you please suggest an error code which might make more sense here ?
> Will -ENOTSUPP be ok ? Since we want to say here that we don't support
> non-extent files.

Isn't the idea that libc will interpret -ENOTTY, or whatever is returned
here, and fall back to the current library code to do preallocation?
This way, the caller of fallocate() will never see this return code, so
it won't violate posix.

-- 
David Kleikamp
IBM Linux Technology Center
