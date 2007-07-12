Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 07:41:17 -0700 (PDT)
Received: from mail.clusterfs.com (74-0-229-162.T1.lbdsl.net [74.0.229.162])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6CEeubm032429
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 07:40:59 -0700
Date: Thu, 12 Jul 2007 08:40:55 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070712144055.GH5586@schatzie.adilger.int>
References: <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com> <20070711090312.GA18301@infradead.org> <20070712072813.GA31260@in.ibm.com> <20070712082650.GB12817@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712082650.GB12817@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, cmm@us.ibm.com, xfs@oss.sgi.com

On Jul 12, 2007  13:56 +0530, Amit K. Arora wrote:
> As you suggest, let us just have two modes for the time being:
> 
> #define FALLOC_ALLOCATE			0x1
> #define FALLOC_ALLOCATE_KEEP_SIZE	0x2
> 
> As the name suggests, when FALLOC_ALLOCATE_KEEP_SIZE mode is passed it
> will result in file size not being changed even if the preallocation is
> beyond EOF.

What does FALLOC_ALLOCATE mean vs. not passing this flag?  I have no
objection to this as long as the code remains with these as "flags"
instead of "modes"...  Essentially just dropping the FALLOC_FL_DEALLOCATE
and FALLOC_FL_DEL_DATA from the interface.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
