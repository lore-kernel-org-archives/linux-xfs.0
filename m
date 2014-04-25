Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4BFBA7F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:31:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2722F8F8054
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 23:31:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lrOx5bVOxEpHqX2q (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 23:31:54 -0700 (PDT)
Date: Thu, 24 Apr 2014 23:31:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: introduce FSX_AVOID env var
Message-ID: <20140425063153.GC27527@infradead.org>
References: <5355478C.8070905@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5355478C.8070905@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 21, 2014 at 11:30:04AM -0500, Eric Sandeen wrote:
> Just like FSSTRESS_AVOID, FSX_AVOID can be used to add
> options at the end of the default fsx runs in each test.
> i.e. FSX_AVOID="-H -z -C" will disable punch hole, zero range,
> and collapse range calls in all tests which run fsx.
> 
> This should handle Ted's concerns about buggy ext4 fallocate
> code without needing to add tunables to the kernel to reject
> these operations during xfstests runs.

I would much prefer to add a little _run_fsx helper to encapsulate this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
