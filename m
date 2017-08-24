Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43075 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753627AbdHXWjF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 18:39:05 -0400
Date: Fri, 25 Aug 2017 00:39:03 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170824223903.GV27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
 <87a82ok45i.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a82ok45i.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neilb@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

On Fri, Aug 25, 2017 at 08:11:05AM +1000, NeilBrown wrote:
> On Thu, Aug 24 2017, Luis R. Rodriguez wrote:
> >
> > Just saying, we better damn be sure this is the way we want to go.
> >
> 
> Just to provide contrast, NFS has a config file which can provide
> certain defaults for mounted filesystems.  However it doesn't require a
> udev event to achieve this.
> 
> Instead, it provides "/sbin/mount.nfs" which imposes the defaults at
> mount time, rather than just after mount time.
> 
> There could, conceivably, be an "/sbin/mount.xfs" which read the config
> file and set all the defaults concurrently with the mount operation.
> 
> I'm not necessarily saying this is a better way to go, but I agree with
> the need to be sure, and this provides evidence that other approaches
> are possible and worth considering.

I like the NFS approach given:

  o It would mean you can keep things contained within each filesystem
    userspace tool. This would not escalate the requirements for what
    parser to use, ie we would not need to pick one for a higher level
    language for udev rules. Tools which already have a parser
    like e2fsprogs can keep on chugging with libprofile, meanwhile XFS and
    others can choose whatever library their own heart pleases and the
    requirement still remains just simple file parsing, not needing
    higher level language support.

 o One advantage of having things like /sbin/mount.<filesystem> is
   shared filesystems between a type of system can be kept separately
   from host specific mount points. This could allow sharing *one* file
   for a type of target system (database, development, etc). There
   would not be any need to look for your own filesystem in /etc/fstab,
   or adding entries, then /etc/fstab would just become very host specific.

 o Custom entries can be supported without having to worry about
   breaking parsing of the general /etc/fstab, it also removes clutter
   from complex lines and entries out of /etc/fstab

Are there other needs for uevents which could not be addressed through
a filesystem configuration file or which prove more efficient or provide
more flexibility?

  Luis
