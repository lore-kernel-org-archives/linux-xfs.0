Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F7657CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 13:47:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 557738F8040
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 11:47:00 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id g72XsXvYPe1i7hRH for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 11:46:59 -0700 (PDT)
Date: Thu, 4 Aug 2016 12:46:58 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
Message-ID: <20160804184658.GB3128@linux.intel.com>
References: <20160803003354.GP16044@dastard>
	<20160804154805.GA24025@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804154805.GA24025@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com

On Thu, Aug 04, 2016 at 08:48:05AM -0700, Christoph Hellwig wrote:
> Just send a fix that you're Cc'ed on.  But now xfs/049 hangs, although
> only on pmem devices, loop on non-pmem seems to be fine.  4.7 was fine
> as well.

I don't think Mike's fix solves this issue.  I'm still able to reproduce the
hang with linux/master + the patch he sent out.

Did you retest and get a different result?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
