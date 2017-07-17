Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46426 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751461AbdGQXsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2017 19:48:18 -0400
Date: Tue, 18 Jul 2017 09:48:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Collecting aged XFS profiles
Message-ID: <20170717234814.GK17762@dastard>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: Saurabh Kadekodi <saukad@cs.cmu.edu>, linux-xfs@vger.kernel.org

On Mon, Jul 17, 2017 at 09:00:19PM +0200, Stefan Ring wrote:
> On Sun, Jul 16, 2017 at 2:11 AM, Saurabh Kadekodi
> <saukad@cs.cmu.edu> wrote:
> > Hi,
> >
> > I am a PhD student studying file and storage systems and I am
> > currently conducting research on local file system aging. My
> > research aims at understanding realistic aging patterns and
> > analyzing the effects of aging on file system data structures
> > and its performance. For this purpose, I would like to capture
> > characteristics of naturally aged file systems (i.e. not aged
> > via synthetic workload generators).

Hi Saurabh - it's a great idea to do this, but I suspect you might
want to spend some more time learning about the mechanisms
and policies XFS uses to prevent aging and maintain performance. I'm
suggesting this because knowing what the filesystem is trying to do
will drastically change your idea of what information needs to be
gathered....

> > In order to facilitate this profile capture, I have written a shell / python based profiling tool (fsagestats - https://github.com/saurabhkadekodi/fsagestats)  that does a file system tree walk and captures different characteristics (file age, file size and directory depth) of files and directories and produces distributions. I do not care about file names or data within each file. It also runs xfs_db in order to capture the free space fragmentation, file fragmentation, directory fragmentation and overall fragmentation; all of which are directly correlated with the file system performance. It dumps the results in the results dir, which is to be specified when you run fsagestats. You can send me the aging profile by tarring up the results directory and sending it via email.
> >
> > Since I do not have access to XFS systems that see a lot of churn, I am reaching out to the XFS community in order to find volunteers willing to run my script and capture their XFS aging profile. Please feel free to modify the script as per your installation or as you see fit. Since fsagestats collects no private information, I eventually intend to host these profiles publicly (unless explicitly requested not to) to aid other researchers / enthusiasts.
> >
> > In case you have any questions on concerns, please let me know.
> 
> I have a nicely aged filesystem (1 TB) on our dev server with around
> 10 million files on it. I will not run a script that executes two
> xfs_io calls *for each file* on it. Why don't you just use Python's
> stat.stat to get at the ctime and the size?

Ok, had a look at the script. You can replace most of it with
pretty much one line.

$ find <dir> -exec stat -c "%n %Z %s" {} \;

Processing the dirents to get the "distribution stats" could be done
by piping the output into a five line awk script. I'll leave that
as an exercise for the reader.

IMO, the script is not gathering anything particularly useful about
how the filesystem has aged. The information being gathered doesn't
tell us anything useful about how the allocator is performing for
the given workload, nor does it provide insight into the locality
characteristics and fragmentation of related files and directories
which directly influence IO (and hence filesystem) performance.

e.g. if the inode64 allocator is in use, then all the files in a
directory should be in the same physical region. As such, a key sign
of an aged filesystem is that the allocator is not able to maintain
the desired locality relationships between files.

To analyse such things, maybe consider gathering obfuscated metadump
images rather asking people to run scripts that gather limited
information.  That way you can develop scripts to extract the
information your research requires from the filesystem images you
received, rather than try to draw tenuous conclusions from a limited
data set...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
