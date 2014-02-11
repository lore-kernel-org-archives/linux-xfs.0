Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C44537F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:11:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0580304043
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 12:11:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cnAmFl3azytoxycR for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 12:11:55 -0800 (PST)
Message-ID: <52FA840A.7090309@sandeen.net>
Date: Tue, 11 Feb 2014 14:11:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair fails to repair, run under valgrind shows "Invalid
	read..." and XFS_CORRUPTION_ERROR
References: <52FA8021.9050604@linux.vnet.ibm.com>
In-Reply-To: <52FA8021.9050604@linux.vnet.ibm.com>
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
To: Cody P Schafer <cody@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 2/11/14, 1:55 PM, Cody P Schafer wrote:
> xfsprogs version: v3.2.0-alpha2-14-g6e79202
> 
> uname: Linux hostname 3.11.10-301.fc20.ppc64 #1 SMP Tue Dec 10 00:35:15 MST 2013 ppc64 POWER8 (architected), altivec supported CHRP IBM,8286-42A GNU/Linux
> 
> full log attached.

Yikes, that's one destroyed filesystem.  What happened?

==6700== Invalid read of size 8
==6700==    at 0x1003DB10: libxfs_trans_commit (trans.c:743)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)

So it's reading ip:

        if (ip->i_itemp) <--- read here, line 743
                kmem_zone_free(xfs_ili_zone, ip->i_itemp);

==6700==  Address 0x13cbf4b8 is 216 bytes inside a block of size 416 free'd
==6700==    at 0x4067C2C: free (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
==6700==    by 0x1003C9EF: libxfs_iput (kmem.h:41)
==6700==    by 0x1003DB0B: libxfs_trans_commit (trans.c:740)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)

after it's been previously freed

        if (iip->ili_lock_flags) {
                iip->ili_lock_flags = 0;
                return;
        } else {
                libxfs_iput(ip, 0);  <--- freed here, line 740
        }

==6700== Invalid write of size 8
==6700==    at 0x1003DB38: libxfs_trans_commit (trans.c:747)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)

ditto for this write:

        ip->i_itemp = NULL; <--- written here, line 747

So, this should be fixed, but I kind of doubt it's the underlying
problem with your xfs_repair failure.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
