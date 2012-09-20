Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KNAf7j146277 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 18:10:42 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gTKXwrfrzd9ytH4i
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 16:11:54 -0700 (PDT)
Message-ID: <505BA2B8.6030303@hardwarefreak.com>
Date: Thu, 20 Sep 2012 18:11:52 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Questions on RAID alignment
References: <505AF9EA.7030603@shiftmail.org>
In-Reply-To: <505AF9EA.7030603@shiftmail.org>
Reply-To: stan@hardwarefreak.com
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On 9/20/2012 6:11 AM, Spelic wrote:
> Hello list
> a few questions
> 
> 1- Does XFS support alignment to concatenation RAIDs (e.g. linear over
> raid1) similarly to striped ones? 

XFS has a stripe alignment feature for writeout of metadata and data.
It is used to optimize writeout to striped devices.  If you concatenate
striped arrays then you can use XFS stripe alignment, AS LONG AS EACH
ALLOCATION GROUP IS WHOLLY CONTAINED WITHIN A CONCAT MEMBER ARRAY, and
doesn't cross concat member boundaries.

Thus, more consideration and planning must go into designing such a
storage stack.  In this situation you will need to specify agcount
manually so AGs don't spill over boundaries.  Drive size and array
configuration will dictate how many AGs you need to use.

> I am guessing probably su and sw
> should not be specified and the agcount should be multiple of the number
> of the concatenated devices, is that correct?

If your concat member devices are mirrors, then you don't specify su/sw.
 If they are striped arrays, you would specify su/sw as you would if
using just one of those striped arrays.  Again, in the latter case your
AGs must not spill.  For example:

24x 300GB SAS drive FC SAN box, 4x 6 drive RAID6, 1.2TB/concat member.
Max agsize is 1TB, not evenly divisible into 1.2TB.  Specify su/sw to
match the RAID6 parms.  Specify agcount of 16.  Each AG is fully
contained within a concat device.

12x 3TB drive JBOD on RAID card, 2x 6 drive RAID6, 12TB/concat member.
Max agsize is 1TB, evenly divisible into 12TB.  Specify su/sw to match
RAID6 parms.  Specify agcount of 24.  Each AG is fully contained within
a concat device.

> 2- Can mkfs parameters be altered after creation, e.g. after growing a
> RAID and then growing the XFS fs, can I also alter su, sw, agcount somehow?

mkfs parms can't be altered, but the XFS writeout geometry can with
mount options.  See 'man mount'.  However, if you're using striped
arrays as concat members, you must expand the concat with identical
striped array members so your geometry remains the same.  Thus you won't
modify su/sw because they haven't changed.

xfs_growfs will create new AGs in the new space made available by adding
a new device (array) to the concat.  NOTE that xfs_growfs doesn't allow
manual control of agcount as mkfs.xfs does.  However, if you expand your
concat only one array at a time, it shouldn't matter how many AGs are
created, as they will all be contained within that concat member array,
and thus su/sw parms are still correct.  If you add 2 or more arrays to
the concat the grow operation may spill AGs across member boundaries.

> 3- I seem to remember there was an xattr that one could attach to /home
> (if /home was under XFS) so that every user (subdir of /home) would get
> a different AG in a different RAID device. I cannot find that
> information anymore on the internet; could you refresh my mind?

What you're referring to is the inode64 mount option.  Every directory
created in the XFS will go into the next AG, round robin, until you hit
the last AG, then it wraps back to AG0, rinse, repeat.  There is no way
to control what dirs get created on what RAID devices within a concat,
but for the techniques I described above.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
