Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7GD682233255 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 10:13:06 -0600
Received: from relay01.pair.com (relay01.pair.com [209.68.5.15]) by
	cuda.sgi.com with SMTP id 0UJPC7Jqq1H2MFG1 for
	<xfs@oss.sgi.com>; Fri, 07 Dec 2012 08:15:31 -0800 (PST)
References: <CCE505AA.B05B7%jellis@dhnet.us>
	<50BFF726.6090006@hardwarefreak.com>
	<68036B67-6AE6-4056-89F5-9549B4E476FD@dhnet.us>
	<50C00583.6000804@hardwarefreak.com>
	<6F909666-9DFE-43F1-973D-170B892F9C5B@gmail.com>
	<50C0657D.5050903@hardwarefreak.com>
	<20121207101620.GK27172@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121207101620.GK27172@dastard>
Message-Id: <AF36BD3F-712A-455E-AA2C-96F74B7F0440@dhnet.us>
From: Jeffrey Ellis <jellis@dhnet.us>
Subject: Re: xfsdump INTERRUPT issue
Date: Fri, 7 Dec 2012 11:15:30 -0500
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jeffrey Ellis <grndlvl@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

That's it exactly. You mean I could use xfs_rtcp?

Best,
J. 

On Dec 7, 2012, at 5:16 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Dec 06, 2012 at 03:29:33AM -0600, Stan Hoeppner wrote:
>> On 12/5/2012 9:01 PM, Jeffrey Ellis wrote:
>> BTW, if your goal in all of this is simply copying all the directories
>> and files from one disk to another disk, you could have used "cp -a" and
>> been done already.  It takes longer to execute than xfsdump/xfsrestore,
>> but given you've been at this for many days now, "cp -a" would have
>> already completed--long ago.
> 
> Unfortunately, using cp or rsync is not possible because the
> filesystem has a real-time device attached to it. It's basically a
> ~10GB data device and a ~500GB real-time device. I'd say it's from a
> DVR or something like that, and that Jeffrey is trying to put
> a bigger disk in the DVR....
> 
> Hence there are various DVR forums that suggest xfsdump/xfsrestore
> is the best method for copying such filesystems to a larger disk.
> I'd guess that people haven't found xfs_rtcp, or maybe they saw the
> caveat in the man page(*) and didn't use it....
> 
> Cheers,
> 
> Dave.
> 
> (*) CAVEATS
>       Currently, realtime partitions are not supported under the
>       Linux version of XFS, and use of a realtime partition WILL
>       CAUSE CORRUPTION on the data partition. As such, this command
>       is made available for curious DEVELOPERS  ONLY at  this
>       point  in time.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
