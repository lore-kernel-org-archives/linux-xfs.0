Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD2367F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 07:00:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ABE748F808F
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 05:00:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rhaQ24if5WWJjBnf for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 05:00:17 -0700 (PDT)
Date: Thu, 6 Jun 2013 22:00:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130606120015.GA29338@dastard>
References: <20130528161230.GA7577@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130528161230.GA7577@redhat.com>
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
To: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, May 28, 2013 at 12:12:30PM -0400, Dave Jones wrote:
> box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
> xfs chose to spew and then hang instead of replaying the journal and mounting :(
> 
> 	Dave

Dave kindly provided me with a metadump of the filesystem yesterday
after reproducing the problem, and I've worked out the cause of the
verification issue being triggered by log reovery.

It's good and it's bad.

It's good in that there is no on-disk corruption either in the log
or on disk before log recovery takes place so it's not a bug in the
directory code.

It's bad because log recovery is causing the buffer to go through an
intermediate corrupt state on disk.

It's good because if log recovery completes successfully, there is
no on-disk corruption on disk.

It's bad because this verification error is something I've long
suspected causes on-disk corruption when log recovery fails for some
other reason.

It's good because this is the confirmation I've been looking
for that that log recovery can cause on-disk corruption when it
fails. Score another win for the verifier infrastructure....

And finally, it's good because this failure just completely
justified the LSN I'm stamping in every piece of metadata when it is
written to disk in the new on-disk format, because this is *exactly*
the problem it enables us to avoid completely.

So, what is the problem? Well, quite simply this: the on-disk
metadata is more recent that some of the changes in the log. That
is, we have buffer @ bno = 0x88 modified in checkpoint @ LSN
87/25163, and again in the subsequent checkpoint @ LSN 87/25192.
The on-disk version of the buffer matches the changes that are in
the second checkpoint @ LSN 87/25192.

IOWs, the directory buffer has been written to disk after the last
change, but there is some other metadata that still pins the tail of
the log @ 87/25163. Hence log recovery comes along and -assumes-
that the buffer it is replaying the changes into does not have any
of the changes in this transaction or subsequent transactions in it.

It replays the modified regions over the top of the buffer, which
results in parts of the buffer matching the changes from 87/25163,
while the rest matches the changes in 87/25192. After the checkpoint
@ 87/25163 is fully replayed, the buffer is then written to disk,
the verifier is run, and the verifier (rightly) detects that the
buffer contents are inconsistent and that's where the EFSCORRUPTED
error comes from.

Now, if we ignore this inconsistent state (i.e. don't run the
verifier), the replay of the dirty regions in the chekpoint at
87/25192 will return the buffer to a consistent state. This - I
*think* - is guaranteed because of the relogging that we do for
items that are in the AIL - it covers all the regions from the
previous changes (i.e. those in 87/25163) as well as any newly
dirtied regions. Hence replaying the later transaction then returns
the buffer to a consistent state.

The real problem is the intermediate corrupt state that log recovery
makes the buffer go through. For non-CRC enabled filesystems, we can
probably just ignore this and live with the problem because it's
fairly rare that log recovery gets interrupted in a way that results
in this intermediate corrupt state being exposed. In general, anyone
who hits a failed log recovery is going to need to run repair to
blow away the log anyway, but this problem will result in there
potentially being more damage that needs to be fixed than there
should have been...

Essentially, the fix for non-CRC filesystems is simply to stop
running the verifiers as part of log recovery as we simply cannot
safely avoid this false positive corruption detection. We might be
able to turn errors into warnings (we can check if log recovery is
active) so we still have some idea about potential corruptions
coming through log recovery, though that requires more work.

For CRC enabled filesystems, though, the fix is *simple*. If the
object being recovery is of the correct type (i.e. it's already been
initialised) and the LSN in the object is more recent that then
current transaction being replayed, just skip replaying of the
changes. That way the object never goes through an inconsistent
state during log recovery.

This is exactly why I put the LSN in every object - so we could
ensure log recovery never tries to take objects backwards in
time. I haven't implemented that checking in log recovery yet, but
it's not that hard to do and will be done in the not-to-distant
future...

Anyway, I'll have a think about the best way to fix the non-CRC
filesystems, as this fix will need to be backported to the
3.9-stable kernel as well as this is one of the problems Cai has
been reporting during his 3.9.x testing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
