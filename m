Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63ED87FED
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 17:50:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 500CF304039
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 15:50:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UBYOFRQsnLdth6s9 for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 15:50:38 -0800 (PST)
Date: Fri, 30 Jan 2015 10:45:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RE : xfs_repair fails with corrupt dinode
Message-ID: <20150129234512.GF6282@dastard>
References: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
	<20150129173414.GL17652@laptop.bfoster>
	<587A9635632B174A943E53AF3B58A9082E3BE068D0@vanda>
	<20150129225646.GA24547@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150129225646.GA24547@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "SCHEFFER, Philippe" <Philippe.SCHEFFER@inist.fr>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 05:56:46PM -0500, Brian Foster wrote:
> On Thu, Jan 29, 2015 at 11:09:48PM +0100, SCHEFFER, Philippe wrote:
> > I join info in attached files.
> > 
> > Chronology:
> > Problem detected on FS.
> 
> Do you have a record/log of the original problem? Did the fs shutdown?
> 
> > FS unmounted
> > multiple xfs_repair -P  with message in my precedent mail
> > A try to remount FS give a kernel panic
> 
> I suspect a problem during log replay. Do you have a record of this
> panic? From your comments, I take it this is now 100% reproducible.
> 
> There's quite a lot of noise in the repair output besides the final
> error. Did repair ever complain about a dirty log?

Argh, off-list reply. Brian, can you attach the repair output - it's
not in the body of your reply.

> > Linux vp-istex-li 3.11.0-26-generic #45~precise1-Ubuntu SMP Tue Jul 15 04:02:35 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > xfs_repair version 3.1.7

First: upgrade to 3.2.2, run repair again.

> > /dev/mapper/system-tmp /tmp ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/system-home /home ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/system-opt /opt ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/system-usr /usr ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/system-var /var ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/data-lvol0 /applis/istex ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/data-lvol1 /applis/getstate ext4 rw,relatime,data=ordered 0 0
> > /dev/sde /data/brut/elsevier ext3 ro,relatime,errors=continue,barrier=1,data=ordered 0 0
> > /dev/sdf /data/brut/rsc ext3 ro,relatime,errors=continue,barrier=1,data=ordered 0 0
> > /dev/sdh /data/oup xfs ro,relatime,attr2,inode64,noquota 0 0
> > /dev/sdi /data/rsc xfs rw,relatime,attr2,inode64,noquota 0 0
> > /dev/sdn /data/nature xfs rw,relatime,attr2,inode64,noquota 0 0
> > /dev/sdo /data/brill xfs rw,relatime,attr2,inode64,noquota 0 0
> > /dev/sdp /data/iop xfs rw,relatime,attr2,inode64,noquota 0 0
> > /dev/mapper/vgistex--brut-lvol00 /data/brut/wiley xfs rw,relatime,attr2,inode64,noquota 0 0
> > /dev/mapper/vgistex--work-lvol00 /data/brut/temp xfs rw,relatime,attr2,inode64,noquota 0 0
> > /dev/mapper/vgistex--sample-lvol0 /data/sample ext3 rw,relatime,errors=continue,barrier=1,data=ordered 0 0
> > /dev/mapper/vgistex--corpus-lvol00 /data/springer ext3 ro,relatime,errors=continue,barrier=1,data=ordered 0 0
> > /dev/mapper/vgistex--corpus-lvol01 /data/ecco ext4 ro,relatime,data=ordered 0 0
> > /dev/mapper/vgeebo-lvol00 /data/eebo ext3 ro,relatime,errors=continue,barrier=1,data=ordered 0 0
> > /dev/mapper/vgistex--corpus-lvol02 /data/wiley xfs ro,relatime,attr2,inode64,noquota 0 0
> > /dev/mapper/vgli2-lvol0 /applis/istex/corpusOutput ext4 rw,relatime,data=ordered 0 0
> > /dev/mapper/vgli2-lvol1 /applis/istex/li2 ext4 rw,relatime,data=ordered 0 0
> > /dev/sda1 /boot ext2 rw,relatime,errors=continue,user_xattr,acl 0 0
> > rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
> > nfsd /proc/fs/nfsd nfsd rw,relatime 0 0

Which of these filesystems is the one that is problematic?

> > xfs_info : not possible, FS not mounted. Last try of mount give a Kernel panic.

It shouldn't do that. please post the stack trace and preceding
error messages...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
