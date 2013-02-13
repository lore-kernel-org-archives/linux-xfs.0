Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D28C37FCC
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 15:32:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B65DC304053
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 13:32:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9nBCUxu7vFXannir for <xfs@oss.sgi.com>;
	Wed, 13 Feb 2013 13:32:55 -0800 (PST)
Date: Thu, 14 Feb 2013 08:32:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add disk failure simulation test
Message-ID: <20130213213217.GG26694@dastard>
References: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Wed, Feb 13, 2013 at 07:41:37PM +0400, Dmitry Monakhov wrote:
> BE CAREFUL!! test known to cause memory corruption for XFS
> see: https://gist.github.com/dmonakhov/4945005

Commit 9f87832 (xfs: fix shutdown hang on invalid inode during
create) might actually fix this. IIRC, it went into 3.8-rc7 so that
wouldn't have been in the kernel you were testing. Can you retest
with a more recent kernel and if it is still busted, send a bug
report to the list?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
