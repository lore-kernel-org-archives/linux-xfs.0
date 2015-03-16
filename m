Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86FA17CBF
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 01:00:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61E198F804C
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2015 23:00:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MTw4x2ebXcXQ0N2W for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2015 23:00:23 -0700 (PDT)
Date: Mon, 16 Mar 2015 17:00:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Message-ID: <20150316060020.GB28557@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Hi Folks,

As I told many people at Vault last week, I wrote a document
outlining how we should modify the on-disk structures of XFS to
support host aware SMR drives on the (long) plane flights to Boston.

TL;DR: not a lot of change to the XFS kernel code is required, no
specific SMR awareness is needed by the kernel code.  Only
relatively minor tweaks to the on-disk format will be needed and
most of the userspace changes are relatively straight forward, too.

The source for that document can be found in this git tree here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation

in the file design/xfs-smr-structure.asciidoc. Alternatively,
pull it straight from cgit:

https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/design/xfs-smr-structure.asciidoc

Or there is a pdf version built from the current TOT on the xfs.org
wiki here:

http://xfs.org/index.php/Host_Aware_SMR_architecture

Happy reading!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
