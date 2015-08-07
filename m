Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA62B7CBE
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 17:55:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C67138F8037
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 15:55:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hsrF07aRJbDjdP35 for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 15:55:33 -0700 (PDT)
Date: Sat, 8 Aug 2015 08:55:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: why crc req on free-inobt & file-type-indir options?
Message-ID: <20150807225531.GG3902@dastard>
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C468F0.2040707@tlinx.org>
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
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 07, 2015 at 01:14:40AM -0700, L.A. Walsh wrote:
> >On 8/6/15 7:52 PM, L.A. Walsh wrote:
> >>Example:
> >>sudo mkfs-xfs-raid SCR /dev/mapper/Data-Home2
> >>mkfs.xfs -mcrc=1,finobt=1 -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/mapper/Data-Home2
> >>meta-data=/dev/mapper/Data-Home2 isize=512    agcount=32, agsize=12582896 blks
> >>       =                       sectsz=4096  attr=2, projid32bit=1
> >>       =                       crc=1        finobt=1
> >>data     =                       bsize=4096   blocks=402652672, imaxpct=5
> >>       =                       sunit=16     swidth=64 blks
> >>naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> >>log      =internal log           bsize=4096   blocks=32752, version=2
> >>       =                       sectsz=4096  sunit=1 blks, lazy-count=1
> >>realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> >ok...
> >
> >>xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.
> >
> >Um, what?  What xfs_admin command generated this?  With what xfsprogs version?
> >/usr/sbin/xfs_admin -V
> xfs_admin version 3.1.11
> ---

The above error message is what old versions of xfs_db emit when
they see a filesystem version they don't understand.

xfsprogs 3.1.11 doesn't support CRCs. 3.2.0 was the first version of
xfsprogs to support CRCs, and 3.2.1 (IIRC) was the first to support
finobt, so the make binary came from a different build to the xfs_db
binary that xfs_admin executes.

Can you please ensure that you are running an up-to-date xfsprogs
and not some mix-and-match of different versions with differing
feature support capabilities?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
