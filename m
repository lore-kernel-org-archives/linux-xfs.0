Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LHuBaQ168042 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 12:56:11 -0500
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35AA41510DA7
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 10:59:38 -0700 (PDT)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id RFDwyGMWqcTpjVOY for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 10:59:38 -0700 (PDT)
Subject: Re: buffered writeback torture program
Mime-Version: 1.0 (Apple Message framework v1082)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110421174120.GA7267@infradead.org>
Date: Thu, 21 Apr 2011 11:59:37 -0600
Message-Id: <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>

On 2011-04-21, at 11:41 AM, Christoph Hellwig wrote:
> On Thu, Apr 21, 2011 at 01:34:44PM -0400, Chris Mason wrote:
>> Sorry, this doesn't do it.  I think that given what a strange special
>> case this is, we're best off waiting for the IO-less throttling, and
>> maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
>> maybe not, it has to get written eventually either way.
> 
> I'm not sure what you mean with seek aware.  XFS only clusters
> additional pages that are in the same extent, and in fact only does
> so for asynchrononous writeback.  Not sure how this should be more
> seek aware.

But doesn't XFS have potentially very large extents, especially in the case of files that were fallocate()'d or linearly written?  If there is a single 8GB extent, and then random writes within that extent (seems very database like) grouping the all of the writes in the extent doesn't seem so great.


Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
