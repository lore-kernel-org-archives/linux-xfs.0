Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0JJdmIQ037452 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 13:39:48 -0600
Date: Thu, 19 Jan 2012 13:39:47 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [LSF/MM TOPIC] [ATTEND] HSM, DMAPI, and external media filesystems
Message-ID: <20120119193947.GA6688@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

I would like to discuss how to get DMAPI accepted into the mainline
kernel.  DMAPI is or was supported by a number of filesystems which are
included in linux (including XFS) and also is supported by a number of
proprietary filesystems.  However, the DMAPI implementation has not yet
been accepted into the main line.

- What are the barriers to inclusion and how can they be resolved?

- What FOSS HSM projects are available to use the interface?
	* xfstests/dmapi/sample_hsm
	* openhsm (opensms)
	* tinyhsm (unfinished, unreleased)

- Who are the interested parties (if any), and how could we split up the
  work?

In the end I'd like to come up with a plan that seems reasonable toward
getting DMAPI included mainline.  I know that Alex Elder and others have
done work in this area and I would like to see it bear fruit.

---

Secondly, I'd enjoy a discussion of an old idea from back in the day
when I worked as a sysadmin and became a storage software hobbyist.
Having recently lost a great deal of data due to disk failure and failed
backups, I struck upon the idea of turning the backup paradigm on it's
head:

I'd rather have the authoritative copy of my data on an external medium
and only cache it on spinning rust.  The filesystem would log every
transaction (WORM style) to removable media and the set of discs or
tapes would be replayable onto new hard disks when I had a failure.
Checkpoints would ensure that the number of discs/tapes necessary to
replay the filesystem remained manageable, and the write performance
problem would be mitigated by maintaining a temporary log on spinning
disk to spool up enough data to keep the tape from having to rewind.
One could choose to recycle media from before a checkpoint, or save it
off for posterity.

My choice of medium at the time was cd-rom since I couldn't afford a
tape drive.  I went about trying to implement such a thing using DMAPI,
which isn't suitable (you can't set an event mask on a file quickly
enough to log the first writes).  Then I tried a stacking filesystem,
fuse, got a job, and lost interest.

This is almost certainly not a new idea.  If there is already something
like this implemented, I'd like to hear about it.  If there isn't, maybe
we could come up with a rough design on a cocktail napkin and pique
enough interest to make a start.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
