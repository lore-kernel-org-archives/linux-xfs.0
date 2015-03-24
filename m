Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B3C5D7F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 23:27:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 305E2AC002
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 21:27:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fiMvZzVT8tjHtKKW for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 21:27:38 -0700 (PDT)
Date: Tue, 24 Mar 2015 15:27:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
Message-ID: <20150324042727.GR28621@dastard>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
	<54F6D9E4.9050803@gmail.com> <20150304130100.GU18360@dastard>
	<54F71CBA.2@gmail.com> <20150304220348.GW18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304220348.GW18360@dastard>
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
To: Boaz Harrosh <openosd@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Thu, Mar 05, 2015 at 09:03:48AM +1100, Dave Chinner wrote:
> On Wed, Mar 04, 2015 at 04:54:50PM +0200, Boaz Harrosh wrote:
> > On 03/04/2015 03:01 PM, Dave Chinner wrote:
> > > On Wed, Mar 04, 2015 at 12:09:40PM +0200, Boaz Harrosh wrote:
> > <>
> > > 
> > > So, we definitely need splice to/from DAX enabled inodes to be
> > > rejected. I'll have a look at that...
> > > 
> > 
> > default_file_splice_read uses kernel_readv which I think might actually
> > work. Do you know what xfstest(s) exercise splice?
> 
> We have a rudimentary one only because I discovered a while back
> none existed at all. i.e. splice is effectively untested by
> xfstests. If you want to write some tests to execise it, that'd be
> great....

Turns out there's no great need to write splice tests for xfstests -
the current loopback device uses splice, and so all of the tests
that run on loopback are exercising the splice path through the
filesystem.

I found this out by disabling splice on dax altogether, and then finding out
that lots of tests failed badly, then narrowing it down to:

$ sudo mount -o dax /dev/ram0 /mnt/test
$ sudo mkfs.xfs -dfile,name=/mnt/test/foo1,size=1g
meta-data=/mnt/test/foo1         isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount -o loop /mnt/test/foo1 /mnt/test/foo
mount: /dev/loop0: can't read superblock
$

because the splice read returned EINVAL rather than data. So, yes,
splice canbe made to work with dax if we pass it through the paths
that aren't interacting directly with the page cache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
