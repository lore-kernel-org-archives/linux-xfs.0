Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 767C37F7B
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:22:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 505E08F8037
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 13:22:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rUqRho4av61heFOy for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 13:21:57 -0800 (PST)
Date: Mon, 3 Feb 2014 08:21:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
Message-ID: <20140202212152.GP2212@dastard>
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
	<52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52ED61C9.8060504@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs <xfs@oss.sgi.com>

On Sat, Feb 01, 2014 at 03:06:17PM -0600, Stan Hoeppner wrote:
> On 1/31/2014 3:14 PM, C. Morgan Hamill wrote:
> > So, basically, --dataalignment is my friend during pvcreate and
> > lvcreate.
> 
> If the logical sector size reported by your RAID controller is 512
> bytes, then "--dataalignment=9216s" should start your data section on a
> RAID60 stripe boundary after the metadata section.
> 
> Tthe PhysicalExtentSize should probably also match the 4608KB stripe
> width, but this is apparently not possible.  PhysicalExtentSize must be
> a power of 2 value.  I don't know if or how this will affect XFS aligned
> write out.  You'll need to consult with someone more knowledgeable of LVM.

You can't do single IOs of that size, anyway, so this is where the
BBWC on the raid controller does it's magic and caches sequntial IOs
until it has full stripe writes cached....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
