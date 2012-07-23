Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NBn9el136491 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 06:49:10 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mPlJtcvr1RYHUChJ for <xfs@oss.sgi.com>;
	Mon, 23 Jul 2012 04:49:06 -0700 (PDT)
Date: Mon, 23 Jul 2012 21:48:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Delay in folder access
Message-ID: <20120723114853.GK23387@dastard>
References: <assp.1551ac5709.500CEF4B.8020400@amfes.com>
	<500D2731.5050004@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <500D2731.5050004@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 23, 2012 at 05:28:01AM -0500, Stan Hoeppner wrote:
> On 7/23/2012 1:29 AM, Daniel L. Miller wrote:
> > I have an XFS partition on simple 4-disk RAID-10 array.  The array is
> > mounted at /raid.  I have a variety of subfolders - one of which is
> > /raid/data - which in turn has a number of subfolders.
> > 
> > Doing a simple "ls /raid" has no problems.  Similarly, no issues with
> > "ls /raid/data/stuff".  But ... executing "ls /raid/data" results in a
> > delay, sometimes in minutes, before it returns.
> 
> How many files are in /raid/data, excluding subdirs?  If it's many tens
> of thousands ls will be slow, but I'd not think multiple minutes worth
> of slow.

depends. ls, by default, stats all the inodes as well to determine
what colour to make the output. If the inodes are randomly
distributed around the place, then ls can easily run at a seek per
file....

> Please post output of 'df /raid'
> 
> Likewise, 'xfs_db -c frag /dev/[device] -r'

Probably irrelevant.

What you really want is to determine inode location and directory
fragmentation, not the state of file fragmentatio. i.e. the inode
numbers of all the files and the xfs_bmap output of the directory
itself will give you an idea of the expected seek patterns on read...

And, of course, iostat -x -d -m 5 output will actually tell you what
the seek load is....

If it's a small directory, then there is something else happening,
and the output of 'echo w > /proc/sysrq-trigger' in dmesg woul dbe
useful. Yep, it's a FAQ and answer again:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> > Also, I do have a ".fsr" folder under /raid.  All the folders listed,
> > which appear empty, are dated 11/1/2010.  Is it safe to delete ".fsr"?
> 
> That may be related to xfs_fsr. 

It is a directory left behind by xfs_fsr. it either crashed or was
killed without the proper signal handlers set up so left it behind.

> I've never seen such a file and I use
> xfs_fsr regularly.  I'd wait for one of the devs to respond here before
> deleting it.

>From xfsprogs:fsr/xfs_fsr.c:

/*
 * Initialize a directory for tmp file use.  This is used
 * by the full filesystem defragmentation when we're walking
 * the inodes and do not know the path for the individual
 * files.  Multiple directories are used to spread out the
 * tmp data around to different ag's (since file data is
 * usually allocated to the same ag as the directory and
 * directories allocated round robin from the same
 * parent directory).
 */
static void
tmp_init(char *mnt)
{
        int     i;
        static char     buf[SMBUFSZ];
        mode_t  mask;

        tmp_agi = 0;
        sprintf(buf, "%s/.fsr", mnt);
....

It's quite safe to delete it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
