Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46906 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfBTRYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 12:24:14 -0500
Date: Wed, 20 Feb 2019 09:23:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs_io: fix TOCTOU in openfile()
Message-ID: <20190220172359.GN32253@magnolia>
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
 <acf1deea-a637-571b-e501-c7cbcde95c38@redhat.com>
 <20190220015034.GI14116@dastard>
 <6af42461-f96e-9902-1edb-a71f023843a7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6af42461-f96e-9902-1edb-a71f023843a7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 19, 2019 at 10:41:57PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/19/19 7:50 PM, Dave Chinner wrote:
> > On Tue, Feb 19, 2019 at 05:23:38PM -0600, Eric Sandeen wrote:
> >> openfile() stats a path to determine whether it is a pipe, and then
> >> opens it with flags based on the type it saw during the stat.  It's
> >> possible that the file at that path changes in between, and Coverity
> >> points this out.
> >>
> >> Instead, always open O_NONBLOCK, stat the fd we got, and turn the
> >> flag back off via fcntl() if it's not a pipe.
> >>
> >> Addresses-Coverity-ID: 1442788 ("Time of check time of use")
> > 
> > For O_NONBLOCK I think there is zero harm in the code as it stands,
> > but I don't really care about it tht much.
> > 
> > I do wonder what happens if need to conditionally use O_NONBLOCK on
> > open(), though....
> > 
> >> @@ -112,6 +106,22 @@ openfile(
> >>  		}
> >>  	}
> >>  
> >> +	if (fstat(fd, &st) < 0) {
> >> +		perror("stat");
> >> +		close(fd);
> >> +		return -1;
> >> +	}
> >> +
> >> +	/* We only want to keep nonblocking behavior for pipes */
> >> +	if (!S_ISFIFO(st.st_mode)) {
> >> +		oflags &= ~O_NONBLOCK;
> >> +		if (fcntl(fd, F_SETFL, oflags) < 0) {
> > 
> > Don't you need to do oflags = fcntl(fd, F_GETFL, NULL) first?
> 
> maybe? We just opened it with oflags, but *shrug* I guess it doesn't
> hurt?

The kernel can set O_ flags on the file (e.g. O_LARGEFILE) for you,
which means that if you try to F_SETFL with the original oflags, the
kernel will think you're trying to clear those flags and misunderstand.

--D

> > 
> >> +			perror("fcntl");
> >> +			close(fd);
> >> +			return -1;
> >> +		}
> > 
> > can you add a "goto out_close;" error jump to this function now that
> > this is the fourth and fifth places that have this same close/return
> > on error...
> 
> yeah, good point.
> 
> > CHeers,
> > 
> > Dave.
> > 
