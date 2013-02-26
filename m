Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 795377CBF
	for <linux-xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:01:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93439AC009
	for <linux-xfs@oss.sgi.com>; Tue, 26 Feb 2013 13:01:17 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	O7Z9EVs22nQTFbhS for <linux-xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 13:01:15 -0800 (PST)
Date: Wed, 27 Feb 2013 08:01:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: test case no.256 in xfs test suite, makes gnome 3 to fall back
	to emergency mode
Message-ID: <20130226210114.GV5551@dastard>
References: <1361899850527-34994.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361899850527-34994.post@n7.nabble.com>
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
To: "praneethu.u" <praneethu.u@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Feb 26, 2013 at 09:30:50AM -0800, praneethu.u wrote:
> I have installed opensuse 12.2 and made 5 different partitions to test xfs
> tests. I have followed instruction as provided in 
> http://en.opensuse.org/SDB:XFStests <http://en.opensuse.org/SDB:XFStests>  .
> After executing test case no.254 i.e.,btrfs snapshot. in the next reboot,
> GNOME 3 will not load, instead it falls back to emergency mode. When i tried
> to see what is happening, in verbose mode of loading os, i saw scratch
> device did not mount and then emergency mode started.
> Is this a bug or i am doing any mistake ? please help.

xfstests regularly corrupts filesystems and leaves their corpses
hanging out to dry - if xfstests causes your machine to crash (and it
will) then trying to automatically mount the filesystems it uses on
reboot is just plain silly. Corrupt filesystems will fail to mount,
and you'll see problems like this.

Indeed, xfstests should only be run on a machine that you don't care
about losing everything on. If you must test on your desktop/laptop,
create a VM and run xfstests inside the VM...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
