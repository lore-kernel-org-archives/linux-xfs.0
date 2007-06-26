Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 03:45:41 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QAjZtL018634
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 03:45:36 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l5QAecIG026107
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 06:40:38 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QAja6l215516
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 04:45:36 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QAjaUK021802
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 04:45:36 -0600
Date: Tue, 26 Jun 2007 16:15:46 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626104546.GB19870@amitarora.in.ibm.com>
References: <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625215239.GK5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  19:15 +0530, Amit K. Arora wrote:
> > +#define FA_FL_DEALLOC	0x01 /* default is allocate */
> > +#define FA_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
> > +#define FA_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */
> 
> In XFS one of the (many) ALLOC modes is to zero existing data on allocate.
> For ext4 all this would mean is calling ext4_ext_mark_uninitialized() on
> each extent.  For some workloads this would be much faster than truncate
> and reallocate of all the blocks in a file.

In ext4, we already mark each extent having preallocated blocks as
uninitialized. This is done as part of following code (which is part of
patch 5/7) in ext4_ext_get_blocks() :  

@@ -2122,6 +2160,8 @@ int ext4_ext_get_blocks(handle_t *handle
        /* try to insert new extent into found leaf and return */
        ext4_ext_store_pblock(&newex, newblock);
        newex.ee_len = cpu_to_le16(allocated);
+       if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
+               ext4_ext_mark_uninitialized(&newex);
        err = ext4_ext_insert_extent(handle, inode, path, &newex);
        if (err) {
                /* free data blocks we just allocated */


> In that light, please change the comment to /* default is keep existing data */
> so that it doesn't imply this is only for DEALLOC.

Ok. Will update the comment.

Thanks!
--
Regards,
Amit Arora
