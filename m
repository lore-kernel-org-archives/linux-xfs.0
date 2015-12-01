Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C018D7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:31:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9EA3E304053
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:31:03 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KI6Fj4phpDAZUMGV for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 12:31:01 -0800 (PST)
Date: Wed, 2 Dec 2015 07:30:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201203048.GW19199@dastard>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130231027.GO26718@dastard>
	<CAD-J=zZoYovR3GK_VihmikrcEiMK_3EQvVPqauhNB4RgYYLf2w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD-J=zZoYovR3GK_VihmikrcEiMK_3EQvVPqauhNB4RgYYLf2w@mail.gmail.com>
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
To: Glauber Costa <glauber@scylladb.com>
Cc: Avi Kivity <avi@scylladb.com>, xfs@oss.sgi.com

On Mon, Nov 30, 2015 at 06:51:51PM -0500, Glauber Costa wrote:
> On Mon, Nov 30, 2015 at 6:10 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Let me have a think about how we can implement lazytime in a sane
> > way, such that fsync() works correctly, we don't throw away
> > timstamp changes in memory reclaim and we don't write unlogged
> > changes to the on-disk locations....
> 
> I trust you fully for matters related to speed.
> 
> Keep in mind, though, that at least for us the fact that it blocks is
> a lot worse than the fact that it is slow. We can work around slow,
> but blocking basically means that we won't have any more work to push
> - since we don't do threading. The processor that stales just sits
> idle until the lock is released. So any non-blocking solution to this
> would already be a win for us.

Right, the blocking is on the inode lock needed to do the
transactional update of the timestamp. lazytime would need to avoid
the timestamp update transaction completely, but we still need to
capture the timestamp and run the transaction later or capture it in
a subsequent change before we write back the inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
