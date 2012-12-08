Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8GPKD2043168 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 10:25:20 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1tQGvDSKEWQGK2qb for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 08:27:45 -0800 (PST)
Message-ID: <50C36A83.1040406@sandeen.net>
Date: Sat, 08 Dec 2012 10:27:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Ensure cmdline geometry puts mkfs.xfs into
	multidisk mode
References: <50ABB115.9070905@sandeen.net>
	<20121121095636.GC23339@infradead.org>
	<50C115E8.9090106@sandeen.net>
	<20121208120007.GB4430@infradead.org>
In-Reply-To: <20121208120007.GB4430@infradead.org>
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
Cc: Ben England <bengland@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 12/8/12 6:00 AM, Christoph Hellwig wrote:
> On Thu, Dec 06, 2012 at 04:02:16PM -0600, Eric Sandeen wrote:
>> Ensure that when mkfs.xfs is invoked with commandline geometry, it
>> triggers multidisk mode and creates more AGs.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks

>> Maybe this should also test device-specified geometry, but not sure
>> how to do that easily within xfstests, any ideas?
> 
> That would involved scsi_debug so that we could set them up.  We had
> several ideas how to use scsi debug for these sort of tests but never
> really bothered to do it.  If you have some spare cycles I'd love to see
> this sort of tests.

scsi_debug won't report geometry on its own today; we'd need to assemble
something out of scsi_debug luns I'm afraid, so it gets even more involved.

We do have a little bit of scsi_debug framework in xfstests today, though,
so if scsi_debug grew the capability it'd be easy to add.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
