Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5THeeeP126015 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 12:40:40 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 345144285A0
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 10:40:39 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id U5d5KUSw0aszi2cO for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 10:40:39 -0700 (PDT)
Message-ID: <4E0B6371.3000104@oracle.com>
Date: Wed, 29 Jun 2011 10:40:01 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110629065306.GC1026@dastard>
	<20110629074021.GA26086@infradead.org>
	<4E0B019E.8080800@draigBrady.com> <4E0B60DE.50908@oracle.com>
	<20110629173648.GA22293@infradead.org>
In-Reply-To: <20110629173648.GA22293@infradead.org>
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
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, P?draig Brady <P@draigBrady.com>, Josef Bacik <josef@redhat.com>

On 06/29/2011 10:36 AM, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 10:29:02AM -0700, Sunil Mushran wrote:
>> I'm not too sure about that. Atleast not enabled by default. Most users
>> use cp to backup data. Not empty space. In this case, this empty extent
>> may not even be de-dupable.
>>
>> Frankly I'd be happier of cp started to exploited fallocate() to create larger
>> extents before copying data into them. Atleast for the large files.
> That's what delayed allocation is for.

A feature fewer file systems support than fallocate(). ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
