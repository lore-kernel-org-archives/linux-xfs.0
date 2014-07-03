Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4BAB29DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 18:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A54538F8040
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 16:12:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7xNvBhusmQHZ0eL7 for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 16:12:17 -0700 (PDT)
Date: Fri, 4 Jul 2014 09:12:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Changing label of a mounted XFS filesystem
Message-ID: <20140703231212.GV4453@dastard>
References: <20140703112911.GA9806@citd.de> <53B54779.40108@oracle.com>
	<20140703141408.GA17657@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140703141408.GA17657@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On Thu, Jul 03, 2014 at 04:14:08PM +0200, Matthias Schniedermeyer wrote:
> On 03.07.2014 20:07, Jeff Liu wrote:
> > Hi,
> > 
> > On 07/03/2014 07:29 PM, Matthias Schniedermeyer wrote:
> > > Hi
> > > 
> > > 
> > > Is there a particular reason that the label of a mounted XFS fileystem
> > > can't be changed?
> > 
> > Maybe since we have no user request for this function? :)

Most likely. It's currently done by xfs_db, which is an offline
tool.

> > > The man-page of xfs_admin gives a blanket "Devices that are mounted
> > > cannot be modified" but no explanation for why that is.
> > > 
> > > In my case it's the label of the root-filesystem i want to change. So to
> > > change it i would have to boot the computer with some kind of live or
> > > rescure-system. Or i would need to temporarily connect the device to
> > > another computer, both aren't really nice hoops to jump through just to
> > > change a few characters.
> > > 
> > > The only thing i can compare this to is ext2 and with ext2 (/boot
> > > partition, so it really is ext2) i can change the label to my hearts
> > > content, even the device is mounted.
> > > 
> > > For my case i could live with it if i could remount the filesystem RO,
> > > change the label and then having to reboot the machine, still nicer than
> > > the other 2 options.
> > 
> > Btrfs support set/change label on a mounted file system via ioctl(2), maybe we
> > can implement it if that sounds useful to our users.
> 
> I would vote for that, i've run into this particular brickwall several 
> times over the years.

There's a bunch of things I'd like to make online modifiable that
currently can only be done offline by xfs_db and other tools. I'll
add this to the list, and hopefully when I get a little time I'll do
something about it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
