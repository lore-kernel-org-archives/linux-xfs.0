Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 07:46:24 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DEkGbm017582
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 07:46:19 -0700
Date: Fri, 13 Jul 2007 15:46:12 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6][TAKE7] fallocate() implementation in i386, x86_64 and powerpc
Message-ID: <20070713144612.GA26879@infradead.org>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124755.GB22961@amitarora.in.ibm.com> <20070713132118.GA23256@infradead.org> <20070713141858.GB27291@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713141858.GB27291@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

On Fri, Jul 13, 2007 at 07:48:58PM +0530, Amit K. Arora wrote:
> Ok. Since we have only one flag (FALLOC_FL_KEEP_SIZE) and we do not want
> to declare the default mode (FALLOC_ALLOCATE), we can _just_ have this
> flag and remove the other mode too (FALLOC_RESV_SPACE).
> Is this what you are suggesting ?

Yes.

> Should we need a header file just to declare one flag - i.e.
> FALLOC_FL_KEEP_SIZE (since now there is no point of declaring the two
> modes) ? If "linux/fs.h" is not a good place, will "asm-generic/fcntl.h"
> be a sane place for this flag ?

It might sound a litte silly but is the cleanest thing we could do by
far.  And I suspect there will be more more flags soon..
