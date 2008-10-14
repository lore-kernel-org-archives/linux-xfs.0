Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 19:13:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E2DuZ8009547
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:13:57 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E58613F2733
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:15:37 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id mGEtb1V90DQLvjAT for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:15:37 -0700 (PDT)
Date: Tue, 14 Oct 2008 13:15:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Stale XFS mount for Kernel 2.6.25.14
Message-ID: <20081014021534.GI10716@disturbed>
References: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com> <20081013035939.GB10716@disturbed> <8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com> <8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Ngo, Andrew" <andrew.ngo@lmco.com>
Cc: v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>

[Andrew, Please don't top post replies - it makes it
completely impossible to folow the thread. ]

> -----Original Message-----
On Mon, Oct 13, 2008 at 10:04:27PM -0400, Ngo, Andrew wrote:
On Mon, Oct 13, 2008 at 10:04:27PM -0400, Ngo, Andrew wrote:
> 
> Dave,
> 
> Do you know of a solution to this problem?  Currently this is a major
> impact for my system.  Thanks in advance.

I don't know what the problem is, so I certainly don't have
a solution for you. You'll need to provide a whole lot more detail
about your system and problem for us to make any sense of it.
Such as:

What hardware do you have (including storage)?

What's the storage structure (DM, MD, iSCSI, etc)?

Output of 'xfs_info <mtpt>'?

What are you really trying to acheive with the remount command?

Is the filesystem busy at the time the ro,remount is run?
(e.g. any large background writes occurring?)

Does the problem go away if you do:

# xfs_freeze -f <mtpt>
# xfs_freeze -u <mtpt>
# mount -o ro,remount <mtpt>

Or does the first freeze command trigger the same problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
