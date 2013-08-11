Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 533687F53
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 13:36:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE010AC002
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 11:36:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UG1A4gzHVh3OUZcn for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 11:36:54 -0700 (PDT)
Message-ID: <5207D9C4.7020102@sandeen.net>
Date: Sun, 11 Aug 2013 13:36:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net>
In-Reply-To: <52073905.8010608@allmail.net>
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
To: Michael Maier <m1278468@allmail.net>
Cc: xfs@oss.sgi.com

On 8/11/13 2:11 AM, Michael Maier wrote:
> Hello!
> 
> I think I'm facing the same problem as already described here:
> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428

Maybe you can try the tracing Dave suggested in that thread?
It certainly does look similar.

<snip>

> xfs_info /mnt
> meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=319815680, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=60160, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 

FWIW, f I make a filesystem with that geometry on 3.10.5, and grow it to the same
size as below, using xfsprogs-3.1.11,

> Doing xfs_growfs again gives:
> 
> xfs_growfs /mnt
> meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=319815680, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=60160, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
> data blocks changed from 319815680 to 346030080

it works fine here.  I don't know if luks could have something to do with it.

Still, reread the thread you pointed to ,and see if you can gather some
of the info Dave asked for then (which was never provided on that thread,
so it died.)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
