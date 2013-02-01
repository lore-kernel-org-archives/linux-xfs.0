Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD3D87F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 08:33:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63878AC001
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 06:33:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RrpHg8R94RO9ERD5 for
	<xfs@oss.sgi.com>; Fri, 01 Feb 2013 06:33:13 -0800 (PST)
Date: Fri, 1 Feb 2013 15:33:06 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Xfs fails in xfstests 013
In-Reply-To: <alpine.LFD.2.00.1302011149030.6969@dhcp-1-104.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.1302011219300.6969@dhcp-1-104.brq.redhat.com>
References: <alpine.LFD.2.00.1301310910080.14328@dhcp-1-104.brq.redhat.com>
	<20130201002927.GJ32297@disturbed.disaster>
	<alpine.LFD.2.00.1302011149030.6969@dhcp-1-104.brq.redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-344281500-1359729191=:6969"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-344281500-1359729191=:6969
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 1 Feb 2013, Lukáš Czerner wrote:

> Date: Fri, 1 Feb 2013 11:58:04 +0100 (CET)
> From: Lukáš Czerner <lczerner@redhat.com>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Lukáš Czerner <lczerner@redhat.com>, xfs@oss.sgi.com
> Subject: Re: Xfs fails in xfstests 013
> 
> On Fri, 1 Feb 2013, Dave Chinner wrote:
> 
> > Date: Fri, 1 Feb 2013 11:29:27 +1100
> > From: Dave Chinner <david@fromorbit.com>
> > To: Lukáš Czerner <lczerner@redhat.com>
> > Cc: xfs@oss.sgi.com
> > Subject: Re: Xfs fails in xfstests 013
> > 
> > On Thu, Jan 31, 2013 at 09:19:23AM +0100, Lukáš Czerner wrote:
> > > Hi.
> > > 
> > > I've just run xfstest 013 on xfs and it fails with this backtrace
> > > 
> > > 
> > > Jan 31 03:09:07 rhel6_vm1 kernel: ffff88020b6d1000: 78 78 78 78 78 78 78 78 78 78 2f 78 78 78 78 78  xxxxxxxxxx/xxxxx
> > > Jan 31 03:09:07 rhel6_vm1 kernel: XFS (sda): Internal error xfs_bmbt_verify at line 747 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xffffffffa025486e
> > 
> > Same problem Cai Qian just reported - a remote symlink with a bmbt
> > verifier attached to it.
> > 
> > > I can reproduce it every time with xfstest 013 on 3.8.0-rc5.
> > 
> > And the configuration you are testing?
> 
> The system is x86_64 KVM guest and I am using the following config
> 
> export TEST_DEV=/dev/sda
> export TEST_DIR=/mnt/test
> export SCRATCH_DEV=/dev/sdb
> export SCRATCH_MNT=/mnt/test1
> export MKFS_OPTIONS="-f "
> export FSTYP=xfs
> 
> Where /dev/sda and /dev/sdb are 50GB in size and those are exported
> from the host linear logical volumes.
> 
> > 
> > I'd suggest that you add an:
> > 
> > 	ASSERT(bp->b_ops == NULL);
> > 
> > into xfs_symlink() after the xfs_trans_get_buf() call in the remote
> > symlink crate loop, because the problem occurring implies that the
> > code is getting a new buffer with a stale ops structure on it
> > (though I can't see how that is possible right now).
> > 
> > You should probably put the same assert into
> > xfs_inactive_symlink_rmt() between the get buf and the
> > xfs_trans_binval() call, and into xfs_readlink_bmap() after the
> > contents of a symlink are read from disk.
> 
> Ok, I'll try that and let you know.

This is what I've done:

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index d95f565..22590ef 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -89,6 +89,7 @@ xfs_readlink_bmap(
                        xfs_buf_relse(bp);
                        goto out;
                }
+               ASSERT(bp->b_ops == NULL);
                if (pathlen < byte_cnt)
                        byte_cnt = pathlen;
                pathlen -= byte_cnt;
@@ -313,6 +314,7 @@ xfs_inactive_symlink_rmt(
                        error = ENOMEM;
                        goto error1;
                }
+               ASSERT(bp->b_ops == NULL);
                xfs_trans_binval(tp, bp);
        }
        /*
@@ -1535,6 +1537,7 @@ xfs_symlink(
                                error = ENOMEM;
                                goto error2;
                        }
+                       ASSERT(bp->b_ops == NULL);
                        if (pathlen < byte_cnt) {
                                byte_cnt = pathlen;
                        }

and I have not hit the assert. However I think that I know what's
going on. The verifier is obviously not attached when the symlink is
created, however it is attached when security attributes are created
for the symlink by xfs_init_security().

Thanks!
-Lukas
--8323328-344281500-1359729191=:6969
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-344281500-1359729191=:6969--
