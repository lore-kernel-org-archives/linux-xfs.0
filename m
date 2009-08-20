Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7K19fGp240551 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 20:09:51 -0500
Received: from mail2.shareable.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AB6114EDF93
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:10:28 -0700 (PDT)
Received: from mail2.shareable.org (mail2.shareable.org [80.68.89.115]) by
	cuda.sgi.com with ESMTP id uCUPQHlAFnV179WR for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:10:28 -0700 (PDT)
Date: Thu, 20 Aug 2009 02:10:04 +0100
From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090820011004.GC14005@shareable.org>
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu>
	<20090820010552.GA22107@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090820010552.GA22107@infradead.org>
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Paul Mackerras <paulus@samba.org>, liml@rtr.ca, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>

Christoph Hellwig wrote:
> > So i'm torn about the 'syscall versus ioctl' issue, i'd 
> > like to avoid making interface design mistakes and i'd 
> > like to solicit some opinions about this. I've attached 
> > the perfcounters ioctl patch below.
> 
> Only add a syscall if it has _one_ clear defined purpose,
> which has kernel-wide meaning.

One clear defined purpose which comes to mind is a "trim" or "punch"
system call, for making holes in files as well as trimming block
devices.  Several other OSes have that capability on files.

I don't remember - does TRIM guarantee the blocks read zeros afterwards?

It would be tidy if it does, as it could have the same meaning with files.

-- Jamie

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
