Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DDkkDx024291 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 08:46:56 -0500
Received: from mail.bgs.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 37A313C7DB9
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 06:47:19 -0700 (PDT)
Received: from mail.bgs.hu (bgs.hu [195.228.254.245]) by cuda.sgi.com with
	SMTP id AL0ETIA2ptwBCsKV for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2009 06:47:19 -0700 (PDT)
Message-ID: <4A84195C.8070002@bgs.hu>
Date: Thu, 13 Aug 2009 15:47:08 +0200
From: Bgs <bgs@bgs.hu>
MIME-Version: 1.0
Subject: Re: fs change on read-only mount
References: <4A84090A.6040601@bgs.hu> <20090813131407.GA1088@infradead.org>
In-Reply-To: <20090813131407.GA1088@infradead.org>
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
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>


 Thanks for the fast answer.

So the following scenarios should be ok:

1) Normal boot (no crash, previous mount was ro as well, journal empty)
-> mount ro from the beginning => partition hash stays the same

2) Mount rw at any point -> make changes -> remount ro -> sync -> create
 new hash -> next boot with ro mount has this new hash.

Regards
Bgs


Christoph Hellwig wrote:
> On Thu, Aug 13, 2009 at 02:37:30PM +0200, Bgs wrote:
>>  Greetings,
>>
>> I don't know xfs' superblock handling well enough, so I'm asking for
>> advice here:
>>
>> Does xfs write anything on the disk when mounting read-only? Is it
>> possible to use a partitions hash (or some well defined portion of the
>> partition) for integrity checks?
> 
> It should not write anything to disk [1], but older versions did so due to
> bugs.  Doing a hash of a read-only filesystem should be fine.
> 
>> The partitions are used read-only and hash would be re-generated  if any
>> rw action was done (after remount ro or full reboot of course). Can this
>> be done? I'm concerned about 'mount count' like writes...
> 
> There is no mount-count like write in XFS.
> 
> [1] the only exception is that log reocvery is performed when we attempt 
>     a read-only mount with an unclean log, that is the box crashed while
>     writing the filesystems.  To make sure you never do this always mark
>     the underlying device readonly, using blkdev --ro.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
