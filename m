Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FMPFSh094606 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 17:25:16 -0500
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 886803E5266
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 15:28:38 -0700 (PDT)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id 0yECkXYz8Kk5wcTS for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 15:28:38 -0700 (PDT)
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Mime-Version: 1.0 (Apple Message framework v1082)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110415172603.GA20086@infradead.org>
Date: Fri, 15 Apr 2011 16:28:37 -0600
Message-Id: <DD59E27A-FD96-4983-A274-B76CCE99AE7A@dilger.ca>
References: <20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<87sjtjq4ir.fsf@rho.meyering.net>
	<20110415171629.GA9088@infradead.org> <4DA87F43.5040807@redhat.com>
	<20110415172603.GA20086@infradead.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Jim Meyering <jim@meyering.net>, xfs-oss <xfs@oss.sgi.com>, coreutils@gnu.org, linux-ext4@vger.kernel.org, Eric Blake <eblake@redhat.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On 2011-04-15, at 11:26 AM, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 11:24:19AM -0600, Eric Blake wrote:
>> Would it be worth borrowing from Solaris' semantics and adding SEEK_HOLE
>> and SEEK_DATA to lseek(2), as a higher level (less-detailed, but easier
>> to define and easier to use) interface for discovering the regions of a
>> file that only contain NUL bytes?
> 
> Yes, I've already suggested that both in this thread and on IRC.
> 
> For efficient copies it's the only usable interface.

I suspect that these bugs would have still existed whether the interface is SEEK_HOLE/SEEK_DATA, or FIEMAP.  The main problem is that the delalloc pages were not accounted for correctly during layout traversal.

For ext4 I think it is sufficient to add another case to ext4_ext_fiemap_cb() to check the pagecache for unmapped pages when it finds an uninitialized extent on disk.  This will be very similar to the fix for finding holes in the on-disk mapping.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
