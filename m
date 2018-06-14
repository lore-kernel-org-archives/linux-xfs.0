Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11151 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964876AbeFNWWv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 18:22:51 -0400
Date: Fri, 15 Jun 2018 08:22:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180614222248.GL10363@dastard>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard>
 <20180614062949.GA6825@magnolia>
 <20180614174640.GE7508@wotan.suse.de>
 <20180614175909.GB8128@magnolia>
 <3c6ec372-3941-386c-37b5-3e7415cf8b67@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c6ec372-3941-386c-37b5-3e7415cf8b67@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 02:05:02PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/14/18 12:59 PM, Darrick J. Wong wrote:
> > On Thu, Jun 14, 2018 at 07:46:40PM +0200, Luis R. Rodriguez wrote:
> >> On Wed, Jun 13, 2018 at 11:29:49PM -0700, Darrick J. Wong wrote:
> >>> On Thu, Jun 14, 2018 at 03:08:44PM +1000, Dave Chinner wrote:
> >>>> On Wed, Jun 13, 2018 at 11:23:09PM -0500, Eric Sandeen wrote:
> >>>>> On 6/13/18 11:06 PM, Dave Chinner wrote:
> >>>>>> With this change, we'll have code to maintain it to ensure that the
> >>>>>> file gets updated properly, and it will probably take more time and
> >>>>>> effort to validate that the generated file is correct (and debug if
> >>>>>> it's not!) compared to the 30s it will take to hand edit the
> >>>>>> template file to change or add a new default...
> >>
> >> If we had an xfstest to *test* that same generated file, this would not
> >> be an issue and from what I gather we need quite a bit of work to get there.
> >>
> >> I'm working on a test for config stuff but that will just test for now
> >> (and this reveals some future work needed):
> >>
> >> a) a set of config files we know should work and ensure they produce the
> >>    same filesystem as if we had used CLI params. We can use xfs_db -c version
> >>    against both filesystems and check that each differences. Since this would
> >>    use the same xfsprogs for the results of a config based filesystem and
> >>    the CLI based filesystem the diff would only generate if there really
> >>    was a change between both runs, and you can use any xfsprogs version
> >>    for it.
> > 
> > Hmm, just out of curiosity, are there any mkfs cli/config options that
> > do /not/ show up in the output of mkfs and/or 'xfs_db -c info'?
> 
> Of the options that actually write [meta]data to disk, these don't show
> up in the info output:
> 
> -m uuid=
> -l agnum=
> -L <label>

And the extent size hints and other attributes written to the root
inode. And anything in the protofile.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
