Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 503847F55
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 14:34:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CFE2304039
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 12:34:51 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id HtACJcBN1VQwqumj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 12:34:50 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C47B77C0425
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 13:34:49 -0600 (MDT)
Date: Wed, 26 Jun 2013 15:34:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: check if the scratch dev pool is mounted in
	_require_scratch
Message-ID: <20130626193446.GO4288@localhost.localdomain>
References: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
	<20130626191804.GA20692@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130626191804.GA20692@lenny.home.zabbo.net>
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
To: Zach Brown <zab@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Wed, Jun 26, 2013 at 12:18:04PM -0700, Zach Brown wrote:
> > $SCRATCH_DEV, so anybody who wants to just use the scratch mnt with the scratch
> > dev will fail to work because we never unmount the scratch mount.
> 
> Yeah, this is annoying.
> 
> > Fix this by
> > checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
> > so we can run our test.  This fixes the issue I was seeing by running
> 
> But this fix seems bonkers.  Can we have _scratch_unmount unmount the
> mountpoint instead of the device?  That's what Eric suggested when I
> whined about this a while ago.
> 

Well actually we probably need both, since we need callers of _scratch_umount to
actually work.  But my patch is slightly wrong, I need to be making sure the
device is actually mounted at scratch mnt before I unmount it, otherwise error
out.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
