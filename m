Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 20:22:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E3LxI6009532
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:22:01 -0700
Date: Mon, 14 Apr 2008 13:22:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW XFSQA test out xfs_attr_shortform_bytesfit attr2/attr1 fix
Message-ID: <20080414032229.GV103491721@sgi.com>
References: <47FC79FC.5020803@sgi.com> <20080410053601.GK108924158@sgi.com> <4802B4E8.3070807@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4802B4E8.3070807@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, "bnaujok@sgi.com via BugWorks" <bnaujok@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asgqa@sgi.com>

On Mon, Apr 14, 2008 at 11:35:36AM +1000, Timothy Shimmin wrote:
> Hi Dave and Barry,
> 
> David Chinner wrote:
> >On Wed, Apr 09, 2008 at 06:10:36PM +1000, Timothy Shimmin wrote:
> >>Hi there,
> >>
> >>A test to test out Eric's fix for xfs_attr_shortform_bytesfit
> >>bug when going from attr2 to attr1.
> >>
> >>With TOT kernel, without patch, one can see the corrupted inline
> >>dirents. With patch, all is well.
> >>
> >>The 186.out _should_ be output'ing ATTR2 for the db version
> >>command but I'm awaiting Barry's xfsprogs checkin to fix that one -
> >>and then I will regenerate it.
> >
> >Really? I'm seeing it fail with ATTR2 in the xfs_db output...
> >
> That's what I used to see until I updated to TOT kernel.
> That's weird.

It's likely due to Eric's change to make sb_badfeatures2 =
sb_features2. That will make userspace pick up the attr2 feature
properly regardless of where it is. Perhaps xfs_db is b0rked
w.r.t. reporting attr vs attr2....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
