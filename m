Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jul 2007 03:08:59 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l63A8rtL005713
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 03:08:55 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l63A3g77003667
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 06:03:42 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l63A8s7x263866
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 04:08:54 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l63A8rGY030281
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 04:08:54 -0600
Date: Tue, 3 Jul 2007 15:38:48 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070703100848.GA14936@amitarora.in.ibm.com>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630165246.GA5159@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: adilger@clusterfs.com, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On Sat, Jun 30, 2007 at 12:52:46PM -0400, Andreas Dilger wrote:
> The @mode flags that are currently under consideration are (AFAIK):
> 
> FA_FL_DEALLOC		0x01 /* deallocate unwritten extent (default allocate) */
> FA_FL_KEEP_SIZE	0x02 /* keep size for EOF {pre,de}alloc (default change size) */
> FA_FL_DEL_DATA	0x04 /* delete existing data in alloc range (default keep) */

We now have two sets of flags - 
1) the above three with which I think no one has any issues with, and
2) the ones below, for which we need some discussions before finalizing
on them.

I will prefer fallocate going in mainline with the above three modes, and
rest of the modes can be debated upon and discussed parallely. And, each
new mode/flag can be pushed as a separate patch. This will not hold
fallocate feature indefinitely...

Please confirm if you find this approach ok. Otherwise, please object.
Thanks!

> FA_FL_ERR_FREE	0x08 /* free preallocation on error (default keep prealloc) */
> FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
> FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */

--
Regards,
Amit Arora
