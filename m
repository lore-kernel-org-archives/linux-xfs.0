Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 00:43:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L7h4fB026948
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 00:43:05 -0700
Date: Mon, 21 May 2007 17:42:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <20070521074257.GW86004887@sgi.com>
References: <455CB54F.8080901@sandeen.net> <464C69A4.6050605@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C69A4.6050605@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, May 17, 2007 at 09:41:40AM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> >see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201
> >
> >Bugzilla Bug 212201: Cannot build sysem with XFS file system.
> >
> >I turned on attr2 in FC6 at nathan's suggestion, for selinux goodness 
> >with more efficient xattr space usage.
> >
> >But, many reports that this was totally broken in fc6, on x86_64.
> 
> Although it turned out to be a different issue, not the packing issue, 
> is the packing/alignment (below) still something that needs to be fixed...?

The problem of the screwed up structure should be fixed. however,
packing the structure is not the correct solution IMO. I think we discussed
the correct fx back when this was first brought up - blacklist the bad
bits in the superblock, do on the fly detection and correction of the problem
and make sure in future that we always leave padding in the structure
so that it is always correctly translated....

Patches are welcome ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
