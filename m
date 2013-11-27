Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CDB87F5F
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:48:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAD22AC001
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:48:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DFnr4o8g5T1KYuCF for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 18:48:00 -0800 (PST)
Date: Wed, 27 Nov 2013 13:47:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131127024757.GF10988@dastard>
References: <20131127023119.GB13101@boogeyman>
	<1428728255.17190956.1385519900454.JavaMail.root@redhat.com>
	<20131127024119.GD13101@boogeyman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131127024119.GD13101@boogeyman>
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
To: Phil White <cerise-xfs@l.armory.com>
Cc: Nathan Scott <nathans@debian.org>, Phil White <cerise-xfs@littlegreenmen.armory.com>, xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 06:41:19PM -0800, Phil White wrote:
> On Tue, Nov 26, 2013 at 09:38:20PM -0500, Nathan Scott wrote:
> > ----- Original Message -----
> > > ...
> > > It's trying to read/write 512 bytes at the beginning of the file which seems
> > > reasonably innocuous.  I double checked the man page which says that under
> > > 2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.  sbp
> > > comes
> > > out with 4096 in blocksize and 512 in sectsize when zero_old_xfs_structures()
> > > is called and the first error comes up, so I'm at a loss for what's going
> > > wrong.
> > 
> > The filesystem backing the new /root/image file doesn't support direct I/O?
> > 
> > cheers.
> 
> The filesystem backing /root/image is xfs.  Good guess though.
> 
> For the record:
> caliban mnt # xfs_info /
> meta-data=/dev/root              isize=256    agcount=4, agsize=25685952 blks
>          =                       sectsz=4096  attr=2
                                   ^^^^^^^^^^^
Yup, there's your problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
