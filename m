Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BECA87F37
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 22:42:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38FF6AC004
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 20:42:17 -0700 (PDT)
Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	by cuda.sgi.com with ESMTP id PqwJf8Of2gjrGIHC (version=TLSv1
	cipher=IDEA-CBC-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 20:42:15 -0700 (PDT)
From: "Al Lau (alau2)" <alau2@cisco.com>
Subject: RE: mkfs.xfs -n size=65536
Date: Tue, 13 Oct 2015 03:42:01 +0000
Message-ID: <4b186a62d5f64c4fbbbe25e1bf4b6883@XCH-ALN-020.cisco.com>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
	<20151013002308.GI27164@dastard>
	<8a1b26a3b869448e805485c529c447a4@XCH-ALN-020.cisco.com>
	<20151013033304.GL27164@dastard>
In-Reply-To: <20151013033304.GL27164@dastard>
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

Hi Dave,

I can try the dev kernel with your change.  How do I go about getting the new bits?

# uname -a 
Linux abc.company.com 3.10.0-229.1.2.el7.x86_64 #1 SMP Fri Mar 6 17:12:08 EST 2015 x86_64 x86_64 x86_64 GNU/Linux

Thanks,
-Al

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Monday, October 12, 2015 8:33 PM
To: Al Lau (alau2)
Cc: xfs@oss.sgi.com
Subject: Re: mkfs.xfs -n size=65536

On Tue, Oct 13, 2015 at 01:39:13AM +0000, Al Lau (alau2) wrote:
> Have a 3 TB file.  Logically divide into 1024 sections.  Each section 
> has a process doing dd to a randomly selected 4K block in a loop.  
> Will this test case eventually cause the extent fragmentation that 
> lead to the kmem_alloc message?
> 
> dd if=/var/kmem_alloc/junk of=/var/kmem_alloc/fragmented obs=4096 
> bs=4096 count=1 seek=604885543 conv=fsync,notrunc oflag=direct

If you were loking for a recipe to massively fragment a file, then you found it. And, yes, when you start to get millions of extents in a file such as this workload will cause, you'll start having memory allocation problems.

But I don't think that sets the GFP_ZERO flag anywhere, so that's not necessarily where the memroy shortage is coming from. I just committed some changes to the dev tree that allow for more detailed information from this allocation error point to be obtained - perhaps if woul dbe worthwhile trying a kernel build form the current for-next tree and turning the error level up to 11?

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
