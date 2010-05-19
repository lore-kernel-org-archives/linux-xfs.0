Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4J0rc6M088033 for <xfs@oss.sgi.com>; Tue, 18 May 2010 19:53:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 545973581CF
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 17:55:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	D17RhcmaK4SBQlPu for <xfs@oss.sgi.com>;
	Tue, 18 May 2010 17:55:55 -0700 (PDT)
Date: Wed, 19 May 2010 10:55:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] Test basic quota enforcement
Message-ID: <20100519005535.GK2150@dastard>
References: <1274225776-26987-1-git-send-email-jack@suse.cz>
	<1274225776-26987-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274225776-26987-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, May 19, 2010 at 01:36:14AM +0200, Jan Kara wrote:
> Add a test which checks whether basic quota enforcement works.

Couple of quick things:

	- we have ${qa_user} for running stuff under a specific user
	- sudo is not installed or configured for this sort of usage
	  on many systems - typically su is used instead (e.g. see
	  test 193)

> +# real QA test starts here
> +rm -f $seq.full
> +
> +user=nobody
> +group=`sudo -u $user id -g`
> +grace=2
> +
> +umount $SCRATCH_DEV 2>/dev/null

The scratch device should already be unmounted. if it isn't something
went wrong in a previous test and unmounting it here isn't going to
help.

> +_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mount "-o usrquota,grpquota"
> +quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> +quotaon $SCRATCH_MNT 2>/dev/null
> +setquota -u $user 4 12 2 4 $SCRATCH_MNT
> +setquota -u -t $grace $grace $SCRATCH_MNT
> +setquota -g $group 4 12 2 4 $SCRATCH_MNT
> +setquota -g -t $grace $grace $SCRATCH_MNT
> +umount $SCRATCH_DEV
> +
> +echo; echo "### test user limit enforcement"
> +export MOUNT_OPTIONS="-o usrquota"
> +_qmount

That will overwrite any mount options specified on the command line.
perhaps better is to use:

scratch_mount -o usrquota

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
