Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44E197F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 11:36:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 355918F8035
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 09:35:57 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id iMFt1IsvSOqbQB6a (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 09:35:55 -0800 (PST)
Date: Tue, 5 Jan 2016 18:36:04 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: lazytime implementation questions
Message-ID: <20160105173604.GE18604@quack.suse.cz>
References: <20160104062219.GB19802@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160104062219.GB19802@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

  Hi,

On Mon 04-01-16 17:22:19, Dave Chinner wrote:
> I've been looking at implementing the lazytime mount option for XFS,
> and I'm struggling to work out what it is supposed to mean.
> 
> AFAICT, on ext4, lazytime means that pure timestamp updates are not
> journalled and they are only ever written back when the inode is
> otherwise dirtied and written, or they are timestamp dirty for 24
> hours which triggers writeback.
> 
> This poses a couple of problems for XFS:
> 
> 	1. we log every timestamp change, so there is no mechanism
> 	   for delayed/deferred update.
> 
> 	2. we track dirty metadata in the journal, not via the VFS
> 	   dirty inode lists, so all the infrastructure written for
> 	   ext4 to do periodic flushing is useless to us.
> 
> These are solvable problems, but what I'm not sure about is exactly
> what the intended semantics of lazytime durability are. That is,
> exactly what guaranteed are we giving userspace about timestamp
> updates when lazytime is used? The guarantees we have to give will
> greatly influence the XFS implementation, so I really need to nail
> down what we are expected to provide userspace. Can we:
> 
> 	a) just ignore all durability concerns?
> 	b) if not, do we only need to care about the 24 hour
> 	   writeback and unmount?
> 	c) if not, are fsync/sync/syncfs/freeze/unmount supposed
> 	   to provide durability of all metadata changes?
> 	d) do we have to care about ordering - if we fsync one inode
> 	   with 1 hour old timestamps, do we also need to guarantee
> 	   that all the inodes with older dirty timestamps also get
> 	   made durable?

So the intended semantics is:
1) fsync / sync / freeze / unmount will write the timestamp updates even
   with lazytime. So unless crash happens, timestamps are guaranteed to be
   consistent. Also sync / fsync guarantees all changes to get to disk.
2) We periodically write back timestamps (once per 24 hours) to avoid too
   big timestamp inconsistencies in case of crash.

Otherwise there are no guarantees wrt durability. I've CCed Ted who
designed this just in case I missed something.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
