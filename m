Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D8CB7F5D
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:41:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14876AC003
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:41:23 -0800 (PST)
Received: from boogeyman.armory.com
	(adsl-76-230-21-225.dsl.pltn13.sbcglobal.net [76.230.21.225])
	by cuda.sgi.com with ESMTP id Z3D6EkMRHamzEdia (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 18:41:22 -0800 (PST)
Date: Tue, 26 Nov 2013 18:41:19 -0800
From: Phil White <cerise-xfs@l.armory.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131127024119.GD13101@boogeyman>
References: <20131127023119.GB13101@boogeyman>
	<1428728255.17190956.1385519900454.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428728255.17190956.1385519900454.JavaMail.root@redhat.com>
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
To: Nathan Scott <nathans@debian.org>
Cc: Phil White <cerise-xfs@littlegreenmen.armory.com>, xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 09:38:20PM -0500, Nathan Scott wrote:
> ----- Original Message -----
> > ...
> > It's trying to read/write 512 bytes at the beginning of the file which seems
> > reasonably innocuous.  I double checked the man page which says that under
> > 2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.  sbp
> > comes
> > out with 4096 in blocksize and 512 in sectsize when zero_old_xfs_structures()
> > is called and the first error comes up, so I'm at a loss for what's going
> > wrong.
> 
> The filesystem backing the new /root/image file doesn't support direct I/O?
> 
> cheers.

The filesystem backing /root/image is xfs.  Good guess though.

For the record:
caliban mnt # xfs_info /
meta-data=/dev/root              isize=256    agcount=4, agsize=25685952 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=102743808, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=50167, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
