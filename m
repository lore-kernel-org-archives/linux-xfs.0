Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3CBjTL007414 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 07:11:46 -0500
Message-ID: <4EB284FE.2040409@sgi.com>
Date: Thu, 03 Nov 2011 07:11:42 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/8] xfsdump: enable support for multiple streams
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
	<20111103101908.GA8572@infradead.org>
In-Reply-To: <20111103101908.GA8572@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/03/2011 05:19 AM, Christoph Hellwig wrote:
> On Wed, Nov 02, 2011 at 04:10:46PM -0500, Bill Kendall wrote:
>> This series resurrects the IRIX multi-stream support for splitting a
>> backup among several output files/tapes. This offers some nice
>> performance improvements, particularly in xfsrestore where a single
>> stream often cannot keep the filesystem/disks busy. I've observed
>> a 1.7x improvement on a backup and a 5x improvement on restore.
>>
>> I have a couple of xfstests for this, and will submit those once
>> a few outstanding xfsdump test patches have been reviewed.
>
> I've put both your two previous xfsdump patches and the all your
> xfstests changes into the kernel.org repositories.  They all look
> fine to me.

Thanks for the reviews. I'm going to be out of town for a few days
but will look at your suggestion to use POSIX semaphores when I
return.

>
> Btw, one thing I'd love to see is a script that uses the userspace
> iscsi target (tgt) infrastructure to emulate a tape, and thus allow to
> run the tape tests in any VM without requiring a real tape device.
>
> Maybe there is someone on the list feels challenged by this?

I've been using an open source vtl to achieve the same goal, and have
given some thought to integrating (or at a minimum documenting) how
to use it with the xfsdump tests.

https://github.com/markh794/mhvtl

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
