Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3D3C7F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 18:15:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 664ABAC001
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 16:15:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VwVypviRdWm0GaHQ for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 16:15:26 -0700 (PDT)
Date: Mon, 28 Apr 2014 09:15:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
Message-ID: <20140427231523.GZ18672@dastard>
References: <535ABA9D.2060305@redhat.com> <20140427212026.GX18672@dastard>
	<535D7CF7.2070409@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535D7CF7.2070409@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Apr 27, 2014 at 04:56:07PM -0500, Eric Sandeen wrote:
> On 4/27/14, 4:20 PM, Dave Chinner wrote:
> > On Fri, Apr 25, 2014 at 02:42:21PM -0500, Eric Sandeen wrote:
> >> Add a heuristic to flush data to a file which looks like it's
> >> going through a tmpfile/rename dance, but not fsynced.
> >>
> >> I had a report of a system with many 0-length files after
> >> package updates; as it turns out, the user had basically
> >> done 'yum update' and punched the power button when it was
> >> done.
> > 
> > So yum didn't run sync() on completion of the update? That seems
> > rather dangerous to me - IMO system updates need to be guaranteed to
> > be stable by the update mechanisms, not to leave the system state to
> > chance if power fails or the system crashes immediately after an
> > update...
> > 
> > 
> >> Granted, the admin should not do this.  Granted, the package
> >> manager should ensure persistence of files it updated.
> > 
> > Yes, yes it should. Problem solved without needing to touch XFS.
> 
> Right, I first suggested it 5 years or so ago for RPM.  But hey, who
> knows, someday maybe.

grrrrr.

> So no need to touch XFS, just every godawful userspace app out there...
> 
> Somebody should bring up the topic to wider audience, I'm sure they'll
> all get fixed in short order.  Wait, or did we try that already?  :)

I'm not talking about any random application. Package managers are
*CRITICAL SYSTEM INFRASTRUCTURE*. They should be architectected to
handle failures gracefully; following *basic data integrity rules*
is a non-negotiable requirement for a system upgrade procedure.
Leaving the system in an indeterminate and potentially inoperable
state after a successful upgrade completion is reported is a
completely unacceptable outcome for any system management operation.

Critical infrastructure needs to Do Things Right, not require other
people to hack around it's failings and hope that they might be able
to save the system when shit goes wrong.  There is no excuse for
critical infrastructure developers failing to acknowledge and
address the data integrity requirements of their infrastructure.

> >> Ext4, however, added a heuristic like this for just this case;
> >> someone who writes file.tmp, then renames over file, but
> >> never issues an fsync.
> > 
> > You mean like rsync does all the time for every file it copies?
> 
> Yeah, I guess rsync doesn't fsync either.  ;)

That's because rsync doesn't need to sync until it completes all of
the data writes. A failed
rsync can simply be re-run after the system comes back up and
nothing is lost. That's a very different situation to a package
manager replacing binaries that the system may need to boot, yes?

> >> Now, this does smack of O_PONIES, but I would hope that it's
> >> fairly benign.  If someone already synced the tmpfile, it's
> >> a no-op.
> > 
> > I'd suggest it will greatly impact rsync speed and have impact on
> > the resultant filesystem layout as it guarantees interleaving of
> > metadata and data on disk....
> 
> Ok, well, based on the responses thus far, sounds like a non-starter.
> 
> I'm not wedded to it, just thought I'd float the idea.
> 
> OTOH, it is an interesting juxtaposition to say the open O_TRUNC case
> is worth catching, but the tempfile overwrite case is not.

We went through this years ago - the O_TRUNC case is dealing with
direct overwrite of data which we can reliably detect, usually only
occurs one file at a time, has no major performance impact and data
loss is almost entirely mitigated by the flush-on-close behaviour.
It's a pretty reliable mitigation mechanism.

Rename often involves many files (so much larger writeback delay on
async flush), it has cases we can't catch (e.g. rename of a
directory containing unsynced data files) and has much more
unpredictable behaviour (e.g. rename of files being actively written
to). There's nothing worse than having unpredictable/non-repeatable
data loss scenarios - if we can't handle all rename cases with the
same guarantees, then we shouldn't provide any data integrity
guarantees at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
