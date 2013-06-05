Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 235CB29DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 20:49:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE2F7AC002
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 18:49:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jhYRfpC9aFgYU35j for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 18:49:13 -0700 (PDT)
Date: Wed, 5 Jun 2013 11:49:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: disable noattr2/attr2 mount options for CRC
	enabled filesystems
Message-ID: <20130605014911.GI29338@dastard>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-6-git-send-email-david@fromorbit.com>
	<51AD0CD6.80404@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51AD0CD6.80404@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 04:38:30PM -0500, Mark Tinguely wrote:
> On 06/03/13 00:28, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >attr2 format is always enabled for v5 superblock filesystems, so the
> >mount options to enable or disable it need to be cause mount errors.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> >  Documentation/filesystems/xfs.txt |    3 +++
> >  fs/xfs/xfs_super.c                |   11 +++++++++++
> >  2 files changed, 14 insertions(+)
> >
> >diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> >index 3e4b3dd..83577f0 100644
> >--- a/Documentation/filesystems/xfs.txt
> >+++ b/Documentation/filesystems/xfs.txt
> >@@ -33,6 +33,9 @@ When mounting an XFS filesystem, the following options are accepted.
> >  	removing extended attributes) the on-disk superblock feature
> >  	bit field will be updated to reflect this format being in use.
> >
> >+	CRC enabled filesystems always use the attr2 format, and so
> Filesystems using the version 5 superblock always use the attr2
> format, and so
> >+	will reject the noattr2 mount option if it is set.
>  reject the noattr2 mount option if it is set.
> >+

I'm going to leave that as "CRC enabled" as the mkfs option that
turns on V5 superblocks is "-m crc=1". IOWs, users aren't going to
know that V5 superblocks == CRC enabled, so the docco reflects
that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
