Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26D557F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 17:08:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ACFF7AC002
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 15:08:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YARETjxmZ2OP1gfh for <xfs@oss.sgi.com>;
	Wed, 06 May 2015 15:08:08 -0700 (PDT)
Date: Thu, 7 May 2015 08:07:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: inode/block size error messages confusing
Message-ID: <20150506220752.GF4327@dastard>
References: <1430711548-26441-1-git-send-email-david@fromorbit.com>
	<20150505142816.GC43235@bfoster.bfoster>
	<20150505224846.GI21261@dastard>
	<20150506113615.GA5021@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150506113615.GA5021@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 06, 2015 at 07:36:15AM -0400, Brian Foster wrote:
> On Wed, May 06, 2015 at 08:48:46AM +1000, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > As reported by Brain:
> > 
> > # ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512
> > illegal inode size 512
> > allowable inode size with 512 byte blocks is 256
> > # ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512 -i size=256
> > Minimum inode size for CRCs is 512 bytes
> > Usage: mkfs.xfs
> > ...
> > 
> > Fix mkfs to catch the block size as being too small, rather than
> > leaving it for inode size detection to enforce.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > +	if (crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> > +		fprintf(stderr,
> > +_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
> > +			XFS_MIN_CRC_BLOCKSIZE);
> > +		usage();
> > +	}
> 
> I'd move this down by the crc inode size check a page or so down since
> we already have a crcs_enabled block there (the error messages could
> also be made more uniform I suppose). Otherwise looks good, thanks!

Heh, I put it there to be with the other block size validity checks,
and I made the error message consistent with the inode size error
message:

$ mkfs.xfs -N -i size=256 /dev/ram1
Minimum inode size for CRCs is 512 bytes
Usage: mkfs.xfs
....

I can move it about and change it, but swings and roundabouts,
really ;)

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
