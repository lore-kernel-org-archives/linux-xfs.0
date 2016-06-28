Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF75A7CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 10:39:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9FC938F8039
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:39:32 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id rDXx8QPA9xEzhrNK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:39:27 -0700 (PDT)
Date: Tue, 28 Jun 2016 17:39:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160628153925.GA2643@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
	<20160624230045.GG12670@dastard> <20160628131059.GA30475@lst.de>
	<57727B27.7060104@plexistor.com> <20160628133928.GB31283@lst.de>
	<5772820E.2080403@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5772820E.2080403@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jun 28, 2016 at 04:56:30PM +0300, Boaz Harrosh wrote:
> Actually with O_APPEND each write request should write a different region
> of the file, there are no overlapping writes. And no issue of which version of the
> write came last and got its data written.

You have one fd for multiple threads or processes (it doesn't matter if
you're using O_APPEND or not), and all of them write to it.

i_size is only updated once the write finishes, so having multiple
concurrent writes will mean multiple records go into the same regions.
Now to be fair in current XFS writes beyond i_size will always take
the lock exclusively, so for this case we will not get concurrent
writes and thus data corruption anyway.  But if you have a cycling
log that gets overwritten (say a database journal) we're back to
square one.

> I still don't see how an application can use the fact that two writers
> will not give them mixed records. And surly it does not work on a shared
> FS. So I was really wondering if you know of any such app

If it doesn't work for two threads using the same fd on a shared fs
the fs is broken.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
