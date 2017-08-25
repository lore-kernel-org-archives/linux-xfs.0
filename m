Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753492AbdHYACI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 20:02:08 -0400
Date: Fri, 25 Aug 2017 02:02:05 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170825000205.GW27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
 <87a82ok45i.fsf@notabene.neil.brown.name>
 <20170824233453.eqxxlckkelp334yi@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824233453.eqxxlckkelp334yi@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: NeilBrown <neilb@suse.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, Dmitri Pal <dpal@redhat.com>

On Thu, Aug 24, 2017 at 07:34:53PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 25, 2017 at 08:11:05AM +1000, NeilBrown wrote:
> > 
> > Just to provide contrast, NFS has a config file which can provide
> > certain defaults for mounted filesystems.  However it doesn't require a
> > udev event to achieve this.
> 
> I think we're mixing multiple things, and that may be confusing the
> discussion.  A config file parser is a technology.  *How* you use the
> config file parser can be quite different even if it is using the same
> config file parser or config file format.
> 
> From what I've seen in this e-mail thread, there are at least three
> different use cases:
> 
> 1)  How mkfs uses to create the file system
> 2)  How the file system should be configured when/while it is mounted
> 3)  Message marshalling and unmarshalling when communicating with the
>     kernel via uevents

Right, its perhaps easier to relate them to the tools used for
interfacing with filesystems:

a) mkfs.<filesystem>
b) mount.<filesystem>
c) new but in this particular use case it was to parse a configuration
   file to tweak a set of sysfs knobs which tune the filesystem

c) is somewhat related to b) which begs the question if some of these
parameters can instead be set at mount time, and if not why not. This
is also why the question came up about making some of these knobs
generic.

> The question of using the same parser for uevents is yet another can
> of worms.  And there, I think we need to be careful about what the
> requirements are for these uevents.  Uevents is just the technology.
> There are many use cases for that technology; are you using them to
> signal mounts/unmounts?  And at the file system level or at the mount
> namespace level?

In the given use case which brought this up it was to tweak specific
filesystems with XFS syfs knobs for error handling, as an example
shut down the filesyste on any IO error, for a careful pedantic
and paranoid admin/setup.

> Are you using them to single file system corruption problems?  And if
> so, are you trying to trying to send a single bit of information ---
> "the file system is corrupted"?  Or are you trying to send much more
> information --- for example, sending each inode that file system found
> that was corrupted, and each block number where the SCSI device found
> a media error?  (We have a solution that does this inside Google, and
> it uses a netlink socket to do the delievery.  I'm pretty sure that if
> you used uevents, udev could melt down if there are a large number of
> errors reported.)

Such uses seem rather advanced and perhaps should be considered in the
future.  I agree netlink is much more suitable in that case (or generic
netlink), that was designed to scale, at least at the networking level.

> And then the final question here is how much does standardization
> help?

One aspect here was the syfs knobs and whether or not we wanted
a shared set of errors for which we want to grant admins a way
to say easily "Hey for these types of errors please shutdown the
filesystem". Let's start off with that as it stays a bit more on
topic for now.

For the rest (mkfs.<filesystem>, mount.<filesystem>) I think that
those already have generic attributes figured out, and that custom
stuff has been thought out as well.

  Luis
