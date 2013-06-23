Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F25347F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 18:39:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBF428F8035
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 16:39:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4Nx4xL8SeVLcJocd for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 16:39:35 -0700 (PDT)
Date: Mon, 24 Jun 2013 09:39:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LVM + XFS + external log + snapshots
Message-ID: <20130623233933.GF29376@dastard>
References: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
	<20130623225546.GB29376@dastard> <51C783B7.2040502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C783B7.2040502@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, aurfalien <aurfalien@gmail.com>

On Sun, Jun 23, 2013 at 06:24:39PM -0500, Eric Sandeen wrote:
> On 6/23/13 5:55 PM, Dave Chinner wrote:
> > On Fri, Jun 21, 2013 at 10:30:31PM -0700, aurfalien wrote:
> >> Hi all,
> >>
> >> So I have an XFS file system within LVM  which has an external log.
> >>
> >> My mount option in FSTAB is;
> >>
> >> /dev/vg_spock_data/lv_data	/data	xfs	logdev=/dev/sdc1,nobarrier,logbufs=8,noatime,nodiratime	1 1
> >>
> >> All is well no issues and very fast.
> >>
> >> Now I'd like to snapshot this bad boy and then run rsnapshot to create a few days backup.
> > 
> > You need to snapshot the log device as well.
> > 
> > But that is problematic in that you need to snapshot it at the same
> > time you snapshot the data volume. Hence yo'd have to do:
> > 
> > # xfs_freeze -f <filesystem>
> > # <snapshot data volume>
> > # <snapshot log volume>
> > # xfs_freeze -u <filesystem>
> > 
> > And now you can mount the snapshot with:
> > 
> > # mount /dev/vg_spock_data/datasnapshot /snapshot -o nouuid,ro,logdev=/dev/vg_spock_log/logsnapshot
> > 
> > If you can't snapshot the log device, then you can't snapshot the
> > filesystem. Yet another reason for using internal logs...
> 
> Hm, given that freezing the fs makes the log (almost) completely clean, I wonder
> if he could mount with /dev/zero (or a loopback 0-filled file) to get at the snapshot,
> especially since it's being mounted RO.
> 
> Should be safe & consistent, no?

In theory. Never tried it myself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
