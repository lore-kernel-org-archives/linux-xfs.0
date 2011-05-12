Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4CEN52L180712 for <xfs@oss.sgi.com>; Thu, 12 May 2011 09:23:06 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69FFA14CD3D7
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 07:23:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tCL0EOeFum6tyJza for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 07:23:04 -0700 (PDT)
Message-ID: <4DCBED3E.4020302@redhat.com>
Date: Thu, 12 May 2011 09:22:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Attempt to sync the fsstress writes to a frozen F.S
References: <4DCA3583.7010904@canonical.com>
	<1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
In-Reply-To: <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
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
To: Surbhi Palande <surbhi.palande@canonical.com>
Cc: m.mizuma@jp.fujitsu.com, jack@suse.cz, marco.stornelli@gmail.com, xfs-oss <xfs@oss.sgi.com>, toshi.okajima@jp.fujitsu.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On 5/11/11 2:10 AM, Surbhi Palande wrote:
> While the fsstress background writes are busy dirtying the page cache, if a
> fsfreeze happens then the background writes should stall. A sync should then
> not have any data to sync to the FS. If it does have any data to sync then
> sync will cause a deadlock by holding the s_umount write semaphore and waiting
> in the wait queue for the FS to thaw, whereas the F.S can never thaw without
> getting the s_umount write semaphore.
> 
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>

Seems ok to me.  In the future, when sending xfstests patches,
if you can add "xfstests" to the subject, and cc: the xfs list,
it'd be great.

I presume that this test does fail for you without your fixes?

I'll see if anyone on the xfs list has comments and if not, I can check this in.

Thanks,
-Eric

> ---
>  068 |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/068 b/068
> index 82c1a4e..b9ac58d 100755
> --- a/068
> +++ b/068
> @@ -101,6 +101,11 @@ do
>  	    tee -a $seq.full
>  	sleep 2
>  
> +	# there should be nothing to sync at this point. This may hang in case
> +	# of fsstress background writes dirtying the page cache while the F.S is frozen
> +	sync &
> +	sleep 2
> +
>  	echo "*** thawing  \$SCRATCH_MNT" | tee -a $seq.full
>  	xfs_freeze -u "$SCRATCH_MNT" | tee -a $seq.full
>  	[ $? != 0 ] && echo xfs_freeze -u "$SCRATCH_MNT" failed | \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
