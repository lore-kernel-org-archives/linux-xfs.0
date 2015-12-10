Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 048BB7F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 20:19:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81C2EAC003
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 18:19:25 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wbbBc4tzLOSSJEF5 for <xfs@oss.sgi.com>;
	Wed, 09 Dec 2015 18:19:22 -0800 (PST)
Date: Thu, 10 Dec 2015 13:18:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: handling device or resource busy errors.
Message-ID: <20151210021831.GJ19802@dastard>
References: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
	<5668DDE0.7050203@opensuse.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5668DDE0.7050203@opensuse.org>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, Dec 10, 2015 at 03:05:20AM +0100, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 2015-12-10 01:25, Ed Peschko wrote:
> > All,
> > 
> > we are 'getting device or resource busy' errors which we *know*
> > are spurious (lsof shows nothing, no multipath daemon, the
> > partition that we are trying to access was just created).
> 
> I don't know if this is the case, but sometimes, when creating
> filesystems under a graphical desktop (like gnome or kde) automatic
> systems on those desktops would probe the new partition and try to
> find its type and mount it, without action on my part. Even in the
> middle of formatting!

Yup, mounts/probing triggered by udev and/or i/d/fanotify events are
a PITA to discover, especially when they are only active for a
short period (like blkid scanning). In general that is enoughtime
to make the command in the script after partitioning fail, but not
enough time to run any diagnostics that will capture the cause...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
