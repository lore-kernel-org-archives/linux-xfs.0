Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25745 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752607AbdHQLWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 07:22:21 -0400
Date: Thu, 17 Aug 2017 21:22:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: add sectsize/sectlog to the man page
Message-ID: <20170817112217.GS21024@dastard>
References: <20170817073844.1351-1-jtulak@redhat.com>
 <20170817083538.GQ21024@dastard>
 <CACj3i7301p_NZJpaATZG-YCf-AAuvnh05kWhXHjMc3GTBQm2Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i7301p_NZJpaATZG-YCf-AAuvnh05kWhXHjMc3GTBQm2Hg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Aug 17, 2017 at 11:45:34AM +0200, Jan Tulak wrote:
> On Thu, Aug 17, 2017 at 10:35 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Aug 17, 2017 at 09:38:44AM +0200, Jan Tulak wrote:
> >> The man page is missing description of these options.
> >> Add it.
> >
> > Just remove the options. They are redundant as they cannot be
> > different from the values set by the "-s" sector size options.
> > They aren't documented, so just remove them from mkfs.
> >
> 
> The code doesn't look like that. From what it does:
> 
> -d sectsize: will set data section sector size
> -l sectsize: will set log section sector size (and as I see now, this
> is not in man page as well)
> -s size: will set both data and log sector size

If you just look at the option parsing, then it appears that way.

But go an look at the code that validates and uses these options.
It will only take a log sector size specification for external logs,
other wise it will use the global sector size. Which is the same as
the data section sector size.

Hence for internal log filesystems, "-l sectsize" is ignored, and
"-s size" and "-d sectsize" set exactly the same variable.  And for
external logs, having "-s size" override the "-l sectsize" is
completely wrong, but that's what it does....

IOWs, the way the sector size parsing and validation is done is an
utter mess - it's not surprising that nobody can work out what it
does exactly because the code is even more messy and hard to
understand than the CLI interface....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
