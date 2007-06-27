Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 16:29:44 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5RNTbtL012194
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 16:29:39 -0700
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070627133657.GQ989688@sgi.com>
References: <20070613235217.GS86004887@sgi.com>
	 <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070625134500.GE1951@amitarora.in.ibm.com>
	 <20070625150320.GA8686@amitarora.in.ibm.com>
	 <20070625214626.GJ5181@schatzie.adilger.int>
	 <20070626231431.GO31489@sgi.com>
	 <20070627034915.GR6652@schatzie.adilger.int>
	 <20070627133657.GQ989688@sgi.com>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 09:28:36 +1000
Message-Id: <1182986916.15488.88.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Cc: xfs-oss <xfs@oss.sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com

On Wed, 2007-06-27 at 23:36 +1000, David Chinner wrote:
> .... Allows setup_swap_extents() to use preallocated files on XFS
> filesystems for swap files without ever needing to convert them.

Using unwritten extents (as opposed to the MKSWAP flag mentioned
earlier) has the unfortunate down side of requiring transactions,
possibly additional IO, and memory allocation during swap.  (but,
this patch should probably go in regardless, as teaching generic
code about unwritten extents is not a bad idea).

cheers.

--
Nathan
