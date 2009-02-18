Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1J0Z5Mb067783 for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 18:35:06 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03B13131BCC
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 16:34:31 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 5xQ1LFMwgoPEf0aX for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2009 16:34:31 -0800 (PST)
Message-ID: <499C9779.4000705@sandeen.net>
Date: Wed, 18 Feb 2009 17:19:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>	<200812141912.59649.Martin@lichtvoll.de>	<18757.33373.744917.457587@tree.ty.sabi.co.uk>	<200812151948.59870.Martin@lichtvoll.de>	<18758.57121.570007.816329@tree.ty.sabi.co.uk>	<B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
	<20090218230958.GA6506@theco.de>
In-Reply-To: <20090218230958.GA6506@theco.de>
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
To: ralf@theco.de
Cc: xfs@oss.sgi.com

Ralf Liebenow wrote:
> Hello !
> 
>> Correct ordering can be proven to be enough to provide transactional
>> correctness, enough to ensure that filesystems can not get corrupted
>> on power down.
> 
> Please beware that caching RAID controllers which are not battery
> backed and the harddisk (when write caching) may decide to 
> re-order writes to the disk, so the ordering imposed by the 
> operating system (filesystem driver) may not be retained. 
> This is usually done by harddisks and
> controllers to minimize seek times and thats what disk
> command queueing is good for. So ordering can only be retained
> if all external caching mechanism and command queueing are
> switched off. 

That's not necessarily true.

The only *requirement* for barriers is preservation of ordering.  It is
*implemented* today by cache flushing, because that's the best we can do
for now (as I understand it).

It is certainly possible that an IO could be flagged which tells the
drive that it may not rearrange the cache destaging across a barrier IO.
 It could cache at will, as long as the critical ordering is maintained.

http://www.t13.org/Documents/UploadedDocuments/docs2007/e07174r0-Write_Barrier_Command_Proposal.doc

So even though barriers are be implemented w/ cache flushes today, it
would be a mistake to rely on that implementation.  IOW, don't confuse
cache flushing w/ ordering requirements just because the ordering
problem is solved *today* with cache flushes.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
