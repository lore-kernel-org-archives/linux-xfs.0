Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AD927F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 08:57:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E155EAC009
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 06:57:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iIDnzMy3mEWPiMCu for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 06:57:47 -0700 (PDT)
Message-ID: <535A69E0.80900@sandeen.net>
Date: Fri, 25 Apr 2014 08:57:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: introduce FSX_AVOID env var
References: <5355478C.8070905@redhat.com>
	<20140425063153.GC27527@infradead.org>
In-Reply-To: <20140425063153.GC27527@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On 4/25/14, 1:31 AM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 11:30:04AM -0500, Eric Sandeen wrote:
>> Just like FSSTRESS_AVOID, FSX_AVOID can be used to add
>> options at the end of the default fsx runs in each test.
>> i.e. FSX_AVOID="-H -z -C" will disable punch hole, zero range,
>> and collapse range calls in all tests which run fsx.
>>
>> This should handle Ted's concerns about buggy ext4 fallocate
>> code without needing to add tunables to the kernel to reject
>> these operations during xfstests runs.
> 
> I would much prefer to add a little _run_fsx helper to encapsulate this.
> 

Dave already merged it, but yeah, that's a good idea, for fsx
as well as fsstress.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
