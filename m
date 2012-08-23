Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NLuZvm079141
	for <linux-xfs@oss.sgi.com>; Thu, 23 Aug 2012 16:56:35 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4UzCWTPb4vi1N8kw for <linux-xfs@oss.sgi.com>;
	Thu, 23 Aug 2012 14:57:18 -0700 (PDT)
Date: Fri, 24 Aug 2012 07:57:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: some questions aoout =?utf-8?Q?extende?=
	=?utf-8?Q?d_attribute_in_my_developmen=E2=80=8Bt?=
Message-ID: <20120823215716.GV19235@dastard>
References: <CAPRu15CvOKd=1405rerOMAy7vVQGuf0fAimPP9=0CinRSNboiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPRu15CvOKd=1405rerOMAy7vVQGuf0fAimPP9=0CinRSNboiQ@mail.gmail.com>
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
To: jinxiu su <sujinxiu@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Thu, Aug 23, 2012 at 05:16:47PM +0800, jinxiu su wrote:
> Hi....I am su, a new linuxer.
> 
> I am doing some development on linux security modules(LSM), and I use
> extended attribute to store the security information.
> 
> But problems encountered..
> 
> when the kernel module that I developed is working a long time ,the
> extended attribute of this file named /lib/ld-2.5.so lost.Exactly, it 's
> replace by zero.
> 
> and in my kernel module ,there is a policy, when create a inode, the
> extended attribute will be initialized to zero. But when I check /lib/
> ld-2.5.so, the inode is not changed, exactly it's not a new inode. I am
> becoming confused....
> 
> I think there must be some fatal bugs in my kernel module.But I am just
> wondering  in which condition  can make a file's extended attribute field
> to be replaced by zero? in which condition can make /lib/ld-2.5.so extended
> attribute to be zero?

No idea. What filesystem did this happen on, and what kernel? it
sounds like the attribute got deleted, or a system upgrade replaced
the file with a new, possibly identical version...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
