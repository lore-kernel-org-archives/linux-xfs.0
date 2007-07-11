Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 02:13:55 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B9Dobm000787
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 02:13:51 -0700
Date: Wed, 11 Jul 2007 10:05:16 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070711090516.GC18301@infradead.org>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070701225543.GW31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701225543.GW31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jul 02, 2007 at 08:55:43AM +1000, David Chinner wrote:
> Given the current behaviour for posix_fallocate() in glibc, I think
> that retaining the same error semantic and punting the cleanup to
> userspace (where the app will fail with ENOSPC anyway) is the only
> sane thing we can do here. Trying to undo this in the kernel leads
> to lots of extra rarely used code in error handling paths...

Agreed, looks like we should stay with the user has to clean up behaviour.
