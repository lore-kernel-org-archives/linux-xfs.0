Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2459F7F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 17:03:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06C3D304043
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 15:03:08 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8N6aKRUyhnBxgD7c for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 15:03:03 -0800 (PST)
Date: Mon, 10 Feb 2014 10:02:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Btrfs: add test for large metadata blocks
Message-ID: <20140209230259.GK13647@dastard>
References: <1391793285-935-1-git-send-email-koen.de.wit@oracle.com>
	<20140207224934.GH13647@dastard> <52F5EB3B.5030902@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F5EB3B.5030902@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Sat, Feb 08, 2014 at 09:30:51AM +0100, Koen De Wit wrote:
> On 02/07/2014 11:49 PM, Dave Chinner wrote:
> >On Fri, Feb 07, 2014 at 06:14:45PM +0100, Koen De Wit wrote:
> >	echo -n "$xattr_value" | md5sum
> >	${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
> >	${ATTR_PROG} -Lq -g attr_$char $file | md5sum
> >	${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum
> >
> >is all that neds to be done here.
> 
> The problem with this is that the length of the output will depend on the page size. The code above runs for every valid leafsize, which can be any multiple of the page size up to 64KB, as defined in the loop initialization:
>     for leafsize in `seq $pagesize_kb $pagesize_kb 64`; do

That's only a limit on the mkfs leafsize parameter, yes? An the
limiation is that the leaf size can't be smaller than page size?

So really, the attribute sizes that are being tested are independent
of the mkfs parameters being tested. i.e:

	for attrsize in `seq 4 4 64`; do
		if [ $attrsize -lt $pagesize ]; then
			leafsize=$pagesize
		else
			leafsize=$attrsize
		fi
		$BTRFS_MKFS_PROG -l $leafsize $SCRATCH_DEV

And now the test executes a fixed loop, testing the same attribute
sizes on all the filesystems under test. i.e. the attribute sizes
being tested are *independent* of the mkfs parameters being tested.
Always test the same attribute sizes, the mkfs parameters simply
vary by page size.

> >>+_scratch_unmount + +# Some illegal leafsizes + +_scratch_mkfs
> >>-l 0 2>> $seqres.full +echo $?
> >Same again - you are dumping the error output into a different
> >file, then detecting the error manually. pass the output of
> >_scratch_mkfs through a filter, and let errors cause golden
> >output mismatches.
> 
> I did this to make the golden output not depend on the output of
> mkfs.btrfs, inspired by
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commit;h=fd7a8e885732475c17488e28b569ac1530c8eb59
> and
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commit;h=78d86b996c9c431542fdbac11fa08764b16ceb7d
> However, in my opinion the test should simply be updated if the
> output of mkfs.btrfs changes, so I agree with you and I fixed this
> in v2.

While I agree with the sentiment, I'm questioning the
implementation. i.e. you've done this differently to every other
test that needs to check for failures. run_check woul dbe just
fine, as would be simply filtering the output of mkfs.

FWIW, the method for detecting the cp error in the second commit
is for a very specific case. It could have also been done with a
filter, as we have done in the past with such error messages. So
what's good for one case is not necessarily the right way to handle
the output for another.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
