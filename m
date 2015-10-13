Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A0987F37
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 19:23:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC4268F8035
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 17:23:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AiDdeHQLmTPYG7Y4 for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 17:23:47 -0700 (PDT)
Date: Tue, 13 Oct 2015 11:23:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs -n size=65536
Message-ID: <20151013002308.GI27164@dastard>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
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
To: "Al Lau (alau2)" <alau2@cisco.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Oct 09, 2015 at 10:40:00PM +0000, Al Lau (alau2) wrote:
> I am looking for more details on the "-n size=65536" option in
> mkfs.xfs.  The question is the memory allocation this option
> generates.  The system is Redhat EL 7.0
> (3.10.0-229.1.2.el7.x86_64).
> 
> We have been getting this memory allocation deadlock message in
> the /var/log/messages file.  The file system is used for ceph OSD
> and it has about 531894 files.

So, if you only have half a million files being stored, why would you
optimised the directory structure for tens of millions of files in a
single directory?

> Oct  6 07:11:09 abc-ceph1-xyz kernel: XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)

mode = ___GFP_WAIT | ___GFP_IO | ___GFP_NOWARN | ___GFP_ZERO
     = GFP_NOFS | GFP_ZERO | GFP_NOWARN

which means it's come through kmem_zalloc() and so is a heap
allocation and hence probably quite small.

Hence I doubt that has anything to do with the directory
block size, as the directory blocks are allocated as single pages
through a completely allocation different path and them virtually
mapped...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
