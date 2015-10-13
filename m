Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88FFA7F59
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 17:05:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4ABAB8F8065
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 15:05:26 -0700 (PDT)
Received: from alln-iport-1.cisco.com (alln-iport-1.cisco.com [173.37.142.88])
	by cuda.sgi.com with ESMTP id aU3h2g5AByAGXRrx (version=TLSv1
	cipher=IDEA-CBC-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 15:05:24 -0700 (PDT)
From: "Al Lau (alau2)" <alau2@cisco.com>
Subject: RE: mkfs.xfs -n size=65536
Date: Tue, 13 Oct 2015 22:05:09 +0000
Message-ID: <f73d29c82bc74555a203914c72bb04e0@XCH-ALN-020.cisco.com>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
	<20151013002308.GI27164@dastard>
In-Reply-To: <20151013002308.GI27164@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

With xfs file system that has about 1 million files, would the default value for the directory structure be sufficient?  We can remove the "-n size=<value>'" option and just use the default.

Thanks,
-Al

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Monday, October 12, 2015 5:23 PM
To: Al Lau (alau2)
Cc: xfs@oss.sgi.com
Subject: Re: mkfs.xfs -n size=65536

On Fri, Oct 09, 2015 at 10:40:00PM +0000, Al Lau (alau2) wrote:
> I am looking for more details on the "-n size=65536" option in 
> mkfs.xfs.  The question is the memory allocation this option 
> generates.  The system is Redhat EL 7.0 (3.10.0-229.1.2.el7.x86_64).
> 
> We have been getting this memory allocation deadlock message in the 
> /var/log/messages file.  The file system is used for ceph OSD and it 
> has about 531894 files.

So, if you only have half a million files being stored, why would you optimised the directory structure for tens of millions of files in a single directory?

> Oct  6 07:11:09 abc-ceph1-xyz kernel: XFS: possible memory allocation 
> deadlock in kmem_alloc (mode:0x8250)

mode = ___GFP_WAIT | ___GFP_IO | ___GFP_NOWARN | ___GFP_ZERO
     = GFP_NOFS | GFP_ZERO | GFP_NOWARN

which means it's come through kmem_zalloc() and so is a heap allocation and hence probably quite small.

Hence I doubt that has anything to do with the directory block size, as the directory blocks are allocated as single pages through a completely allocation different path and them virtually mapped...

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
