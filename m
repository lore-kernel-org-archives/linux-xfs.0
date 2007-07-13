Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 07:27:28 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DERNbm010753
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 07:27:23 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DERN44019200
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 10:27:23 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6DERGh8180046
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:27:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DERCoJ029904
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:27:12 -0600
Date: Fri, 13 Jul 2007 19:57:23 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6][TAKE7] manpage for fallocate
Message-ID: <20070713142723.GC27291@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070713140651.GO31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713140651.GO31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, michael.kerrisk@gmx.net, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com

On Sat, Jul 14, 2007 at 12:06:51AM +1000, David Chinner wrote:
> On Fri, Jul 13, 2007 at 06:16:01PM +0530, Amit K. Arora wrote:
> > Following is the modified version of the manpage originally submitted by
> > David Chinner. Please use `nroff -man fallocate.2 | less` to view.
> > 
> > This includes changes suggested by Heikki Orsila and Barry Naujok.
> 
> Can we get itemised change logs for all these patches from now on?

Sure.
 
> > .TH fallocate 2
> > .SH NAME
> > fallocate \- allocate or remove file space
> 
> If fallocate is just being used for allocating space this is wrong.
> maybe - "manipulate file space" instead?

Yes, it needs to be changed.
 
> dd> .TP
> > .B FALLOC_RESV_SPACE
> > provides the same functionality as
> > .B FALLOC_ALLOCATE
> > except it does not ever change the file size. This allows allocation
> > of zero blocks beyond the end of file and is useful for optimising
> 
> "of zeroed blocks"

Ok.

--
Regards,
Amit Arora

> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
