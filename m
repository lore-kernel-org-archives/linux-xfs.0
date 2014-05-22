Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BDEF7F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 18:34:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5030C8F8037
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 16:34:56 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8Gg39ZpqnNXB9XpN for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 16:34:52 -0700 (PDT)
Date: Fri, 23 May 2014 09:34:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/005: filter _scratch_mount output and fix golden
	output to match it
Message-ID: <20140522233449.GN18954@dastard>
References: <1400775429-30015-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400775429-30015-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 23, 2014 at 12:17:09AM +0800, Eryu Guan wrote:
> Failure message of _scratch_mount is something like:
> 
> mount: mount /dev/sda5 on /mnt/scratch failed: Structure needs cleaning
> 
> not
> 
> mount: Structure needs cleaning

Evidence to the contrary:

# MKFS_OPTIONS="-b size=1024 -m crc=1"  ./check xfs/005
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test1 3.15.0-rc5-dgc+
MKFS_OPTIONS  -- -f -b size=1024 -m crc=1 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/005 0s ... 0s
Ran: xfs/005
Passed all 1 tests

# mount /dev/vdb /mnt/scratch
mount: Structure needs cleaning
# mount -V
mount from util-linux 2.20.1 (with libblkid and selinux support)
#

So xfs/005 is correct for a relatively recent mount binary.
What version of mount are you using?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
