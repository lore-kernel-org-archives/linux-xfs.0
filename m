Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0GJlEYq029229 for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 13:47:15 -0600
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93C499662E
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 11:47:12 -0800 (PST)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id shJkN4jSHDf7Ih89 for
	<xfs@oss.sgi.com>; Fri, 16 Jan 2009 11:47:12 -0800 (PST)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: xfs regression in linux_2.6.28,
	"XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c"
Date: Fri, 16 Jan 2009 10:08:01 +0100
References: <200901150402.39801.edvx1@systemanalysen.net>
	<20090115221438.GF8071@disturbed>
In-Reply-To: <20090115221438.GF8071@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901161008.02387.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

On Thursday Jan 15th 2009 at 23:14:38 Dave Chinner wrote:
> On Thu, Jan 15, 2009 at 04:02:39AM +0100, Roland Eggner wrote:
> > Latest (so far) working linux_2.6.27.9
> > linux_2.6.28 seems to introduce a xfs regression:
> 
> You mean 2.6.29, don't you (i.e. a current TOT development kernel,
> not a stable kernel)?
I meant exactly what I have written:  linux_2.6.28

> We have received a few reports of that since 2.6.29-git2 after the
> big XFS merge occurred. Can you confirm that you are running a very
> recent unstable kernel and not a stable 2.6.28 kernel?
all 2.6.28 builds which I have tried so far are broken,
today tried linux_2.6.29-rc1 and got the same "XFS_WANT_CORRUPTED_GOTO .."
note:  SAME failure with
linux_2.6.28
linux_2.6.28-git7
linux_2.6.28-git9
linux_2.6.29-rc1

Should I compile with CONFIG_XFS_DEBUG?

If you know a 2.6.28 or 2.6.29 kernel with REALLY stable xfs:
please point me :-)

> BTW, I note your kernel is tainted (like a couple of other
> reports of this problem). Can you tell us what module you are
> running that taints the kernel so we can correlate that with
> other reports of the problem?
kernels vanilla from kernel.org
+ NVIDIA-Linux-x86-96.43.09 graphics driver
+ from loop-aes-source the kernel-2.6.27 patch
+ following patch required because of the new credentials framework
--- drivers/block/loop.c.orig   2009-01-11 00:55:28.000000000 +0100
+++ drivers/block/loop.c        2009-01-11 01:07:44.525441742 +0100
@@ -423,7 +423,7 @@
         unsigned char b[64];
     } un;

-    if(lo->lo_key_owner != current->uid && !capable(CAP_SYS_ADMIN))
+    if(lo->lo_key_owner != current_uid() && !capable(CAP_SYS_ADMIN))
         return -EPERM;

     m = (AESmultiKey *)lo->key_data;
@@ -2360,7 +2360,7 @@
        int err;
        struct loop_func_table *xfer = NULL;

-       if (lo->lo_encrypt_key_size && lo->lo_key_owner != current->uid &&
+       if (lo->lo_encrypt_key_size && lo->lo_key_owner != current_uid() &&
            !capable(CAP_SYS_ADMIN))
                return -EPERM;
        if ((unsigned int) info->lo_encrypt_key_size > LO_KEY_SIZE)
@@ -2416,7 +2416,7 @@
        if (info->lo_encrypt_key_size) {
                memcpy(lo->lo_encrypt_key, info->lo_encrypt_key,
                       info->lo_encrypt_key_size);
-               lo->lo_key_owner = current->uid;
+               lo->lo_key_owner = current_uid();
        }

        lo->lo_queue->make_request_fn = loop_make_request_real;


I believe problem is xfs related, because only xfs partitions with write
activity are affected, and the first error line in kernel log was in EVERY case
"XFS_WANT_CORRUPTED_GOTO ..".  It seems that the loop module does not matter,
because both plane xfs partitions and encrypted xfs partitions are similarly
affected.


Cheers
Roland

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
