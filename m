Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9CA9529DF8
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 21:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3975BAC001
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 19:06:44 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id kWHZSzGKIf4BBPnv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 19:06:41 -0700 (PDT)
Message-ID: <51ABFA1F.2050402@tlinx.org>
Date: Sun, 02 Jun 2013 19:06:23 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: latest xfsdump page allocation failure order:4 in 3.9.2
References: <51ABEA86.9060008@tlinx.org> <20130603014220.GW29466@dastard>
In-Reply-To: <20130603014220.GW29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Sun, Jun 02, 2013 at 05:59:50PM -0700, Linda A. Walsh wrote:
>> [123342.934683] xfsdump: page allocation failure: order:4, mode:0x10c0d0
> Fixed in 3.10-rc1 by: 
> dd700d9 xfs: fallback to vmalloc for large buffers in xfs_attrlist_by_handle 
> Cheers, 
> Dave.
----
Why does this often sound like patch is in the mail...?
:-)

Thanks..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
