Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SB7Wco103925 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 06:07:32 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 464EF196879
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 04:07:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EDC6Bedw26PJwWjG for <xfs@oss.sgi.com>;
	Wed, 28 Sep 2011 04:07:30 -0700 (PDT)
Date: Wed, 28 Sep 2011 21:07:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 64-bit inodes and back again
Message-ID: <20110928110726.GG3159@dastard>
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
	<20110928053539.GF3159@dastard> <4E82C5AF.8040203@cchtml.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E82C5AF.8040203@cchtml.com>
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
To: Michael Cronenworth <mike@cchtml.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 28, 2011 at 01:58:55AM -0500, Michael Cronenworth wrote:
> On 09/28/2011 12:35 AM, Dave Chinner wrote:
> >It has to be able to access the files with inode numbers>  32 bit,
> >so you need to run it on the 2.6.38 kernel. Once you've done that,
> >you should be able to read all the files back on the .35 kernel,
> >too.
> 
> I tried that. It fails on the newer kernel, too. (32-bit inode mode)
> 
> # xfs_reno -vv /var/lib/mock.save
> Scanning directory tree...
> Processing 31 directories...
> xfs_reno: directory: 4298768443 1 /var/lib/mock.save/dist-5E-build-377-1401
> xfs_reno: unable to duplicate directory attributes:
> /var/lib/mock.save/dist-5E-build-377-1401
> 0 seconds elapsed
> Done.
> # ls -i
> 12884946465 dist-5E-build-373-1401   17200292312 dist-f15-build-383-1416
>  8612299211 dist-5E-build-375-1401    8626045248 dist-f15-build-384-1416
>  4298768443 dist-5E-build-377-1401   12884946478 dist-f15-build-385-1417
> 17196739302 dist-5E-build-378-1401   12885555358 dist-f15-build-386-1417
>     3226235 dist-5E-build-379-1401    4298161997 dist-f15-build-387-1417
> 17197934889 dist-5E-build-380-1401   30082488692 dist-f15-build-388-1417
> 12917432680 dist-5E-build-381-1415   17196807090 dist-f15-build-389-1417
>  4295007704 dist-6E-build-374-1403          1460 xfs_reno.recover
> 21502499833 dist-f15-build-382-1416

It's failing trying to copy the attributes on a directory. What are
the attributes on the specific directory?

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
