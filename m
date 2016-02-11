Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B9F0E7CA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 14:51:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BC568F8050
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:51:18 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fK1SOtjezfBUBy7Y for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 12:51:16 -0800 (PST)
Date: Fri, 12 Feb 2016 07:50:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/2] DAX bdev fixes - move flushing calls to FS
Message-ID: <20160211205049.GJ19486@dastard>
References: <1455137336-28720-1-git-send-email-ross.zwisler@linux.intel.com>
	<20160211124304.GI21760@quack.suse.cz>
	<20160211194922.GA5260@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211194922.GA5260@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com

On Thu, Feb 11, 2016 at 12:49:22PM -0700, Ross Zwisler wrote:
> I think the plan of unsetting S_DAX on bdev->bd_inode when we mount will save
> us from this, as long as we do it super early in the mount process.

I think that S_DAX should not be set on the block device by default
in the first place. If we've been surprised by unexpected behaviour,
then I'm sure there are going to be other surprises waiting for us.
DAX default policy should be opt-in, not opt-out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
