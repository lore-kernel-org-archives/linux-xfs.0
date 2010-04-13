Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DFMFQP242589 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 10:22:15 -0500
Received: from mx.inode.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A7BB153FE02
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 08:24:09 -0700 (PDT)
Received: from mx.inode.at (mx13.lb01.inode.at [62.99.145.15]) by cuda.sgi.com
	with ESMTP id ncGfFRhANNvBql2H for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 08:24:09 -0700 (PDT)
Subject: Re: XFS-filesystem corrupted by defragmentation
References: <87r5mjpn8l.fsf@workstation006.office.ice-sf.at>
	<alpine.DEB.1.10.1004131022140.32213@castor.opentrend.net>
From: Bernhard Gschaider <bgschaid_lists@ice-sf.at>
Date: Tue, 13 Apr 2010 17:24:04 +0200
In-Reply-To: <alpine.DEB.1.10.1004131022140.32213@castor.opentrend.net>
	(Robert Brockway's message of "Tue,
	13 Apr 2010 10:58:22 -0400 (EDT)")
Message-ID: <877hobnzor.fsf@workstation006.office.ice-sf.at>
MIME-Version: 1.0
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
To: Robert Brockway <robert@timetraveller.org>
Cc: xfs@oss.sgi.com


Thanks for the answer

>>>>> On Tue, 13 Apr 2010 10:58:22 -0400 (EDT)
>>>>> "RB" == Robert Brockway <robert@timetraveller.org> wrote:

    RB> On Tue, 13 Apr 2010, Bernhard Gschaider wrote:
    >>> xfs_db -r /dev/mapper/VolGroup00-LogVol04
    >> xfs_db: unexpected XFS SB magic number 0x00000000 xfs_db: read
    >> failed: Invalid argument xfs_db: data size check failed
    >> cache_node_purge: refcount was 1, not zero (node=0x2a25c20)
    >> xfs_db: cannot read root inode (22)

    RB> Hi Bernhard.  Hmm that doesn't sound good.

http://oss.sgi.com/archives/xfs/2007-04/msg00580.html suggests a sync
for that kind of situation. Any thoughts on this? I know that there is
no definite answer to his. Only guesses by people who have more
experience than me

    >> The file-system is still mounted and working and I don't dare
    >> to do anything about it (am in a mild state of panic) because I
    >> think it might not come back if I do.

    RB> I think your choice to sit back and evaluate your options
    RB> before acting is a wise one, especially since the filesystem
    RB> is apparently mounted and functioning.

    RB> Depending on how worried you are there are various options
    RB> available.  Eg you could declare an emergency on the server
    RB> and use xfs_freeze to freeze the filesystem while you take a
    RB> backup.  Note - I have never used xfs_freeze like this, it is
    RB> just a suggestion.  Naturally this will cause an outage and
    RB> problems for users.

They'll have to live with that

    RB> Alternatively you could use xfsdump to capture an incremental
    RB> or full backup on the running system. (depending on whether
    RB> you already have a level 0 xfs dump file or not).  The
    RB> developers have confirmed (on this list) that xfsdump will
    RB> provide a consistent backup on a live filesystem.

    RB> Please note that any heavy I/O (like a backup) has the
    RB> potential to cause problems on a sick filesystem.  In my
    RB> experience xfs is inclined to automatically remount read-only
    RB> if it detects problems.  While this can be catastrophic for
    RB> running processes it is helpful in protecting data so I'm
    RB> happy it works this way.

    RB> One last note.  I hope you have good backups already.  If you
    RB> don't then this is the time to start taking good backups.

I have weekly backups with amanda. The tapes verify OK, but I never
tried a full-scale recover before. 

    RB> These are the notes from my backup talk:

    RB> http://www.timetraveller.org/talks/backup_talk.pdf

    >> I swear to god: I did not do anything else with the
    >> xfs_*-commands than the stuff mentioned above

    RB> I defrag XFS filesystems from cron as recommended by SGI and
    RB> I've never had a problem.  Maybe defragmentation didn't cause
    RB> the problem - maybe it just revealed an underlying problem.

But it doesn't have to do with the hole that the xfs_bmap reported for
that file?

Bernhard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
