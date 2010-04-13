Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DEqQxN240600 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 09:52:26 -0500
Received: from capella.opentrend.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAF3F2BC582
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 07:54:20 -0700 (PDT)
Received: from capella.opentrend.net (capella.opentrend.net [64.22.125.103])
	by cuda.sgi.com with ESMTP id l38HZ6HZNtdJtoG5 for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 07:54:20 -0700 (PDT)
Date: Tue, 13 Apr 2010 10:58:22 -0400 (EDT)
From: Robert Brockway <robert@timetraveller.org>
Subject: Re: XFS-filesystem corrupted by defragmentation
In-Reply-To: <87r5mjpn8l.fsf@workstation006.office.ice-sf.at>
Message-ID: <alpine.DEB.1.10.1004131022140.32213@castor.opentrend.net>
References: <87r5mjpn8l.fsf@workstation006.office.ice-sf.at>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bernhard Gschaider <bgschaid_lists@ice-sf.at>
Cc: xfs@oss.sgi.com

On Tue, 13 Apr 2010, Bernhard Gschaider wrote:

>> xfs_db -r /dev/mapper/VolGroup00-LogVol04
> xfs_db: unexpected XFS SB magic number 0x00000000
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> cache_node_purge: refcount was 1, not zero (node=0x2a25c20)
> xfs_db: cannot read root inode (22)

Hi Bernhard.  Hmm that doesn't sound good.

> The file-system is still mounted and working and I don't dare to do
> anything about it (am in a mild state of panic) because I think it
> might not come back if I do.

I think your choice to sit back and evaluate your options before acting is 
a wise one, especially since the filesystem is apparently mounted and 
functioning.

Depending on how worried you are there are various options available.   Eg 
you could declare an emergency on the server and use xfs_freeze to freeze 
the filesystem while you take a backup.  Note - I have never used 
xfs_freeze like this, it is just a suggestion.  Naturally this will cause 
an outage and problems for users.

Alternatively you could use xfsdump to capture an incremental or full 
backup on the running system. (depending on whether you already have a 
level 0 xfs dump file or not).  The developers have confirmed (on this 
list) that xfsdump will provide a consistent backup on a live filesystem.

Please note that any heavy I/O (like a backup) has the potential to cause 
problems on a sick filesystem.  In my experience xfs is inclined to 
automatically remount read-only if it detects problems.  While this can be 
catastrophic for running processes it is helpful in protecting data so I'm 
happy it works this way.

One last note.  I hope you have good backups already.  If you don't then 
this is the time to start taking good backups.

These are the notes from my backup talk:

http://www.timetraveller.org/talks/backup_talk.pdf

> I swear to god: I did not do anything else with the xfs_*-commands
> than the stuff mentioned above

I defrag XFS filesystems from cron as recommended by SGI and I've never 
had a problem.  Maybe defragmentation didn't cause the problem - maybe it 
just revealed an underlying problem.

Cheers,

Rob

-- 
Email: robert@timetraveller.org
IRC: Solver
Web: http://www.practicalsysadmin.com
Open Source: The revolution that silently changed the world

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
