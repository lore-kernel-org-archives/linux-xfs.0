Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S2Cvru164543 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 21:12:57 -0500
Message-ID: <506507F5.5020707@tlinx.org>
Date: Thu, 27 Sep 2012 19:14:13 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: more efficient way to print out inode->block mappings?
References: <50643AF7.7060106@tlinx.org> <20120927153415.GI13214@sgi.com>
In-Reply-To: <20120927153415.GI13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Ben Myers wrote:
> Hey Linda,
> 
> On Thu, Sep 27, 2012 at 04:39:35AM -0700, Linda Walsh wrote:
>> I want to be able to rapidly determine the diffs between 2 volumes.
>>
>> Special note 1 is an active lvm snapshot of the other -- meaning it is
>> frozen in time, but otherwise should look identical the the file system
>> as it was when it was snapped.
>>
>> Sooo... a way of speeding checks is finding out what blocks allocated to the indoes
>> are different, since as the new volume gets used, I had hoped that differing
>> block numbers might give me a clue as to what had changed..
> 
> Differing block maps for the same inode on the two filesystems will give you a
> clue that there are changes but it isn't perfect:
> 
> Consider xfs_fsr.  This might change block numbers for a file but the contents
> stayed the same.
----
	Yeah -- I figured out the downsides (like a rewrite -- but I was going
to try to use the mtime/filesize and block allocs to indicated stuff...

But neverthless-- it wouldn't be perfect, so sorta a moot point.

What I really need is to look at the block mappings of the underlying lvm --
and see what parts of the FS have been changed due to 'COW'....o


What i'm doing is taking successive daily snapshots that overlap each other and
picking up the differences and putting them into a tiny static volume I'll probably
keep around for a few weeks.


The reason -- is that when mounted under a 'special dir', @GMT-time/date,
Windows will see those "differences" as previous versions of the files  --
unlike the windows version, it keeps active snapshots going... lvm isn't quite
so efficient to keep them going for weeks or so.. so I'm only keeping "sparse"
trees of the differences.

The RUB in all of this is making the "difference" -- rsync takes anywhere
from 80-100 minutes running local-local using no compression, and telling it to
NOT try to checksum diffs, or send differences - but whole files only... (as
anything that would do a checksum of the file will take longer than actually
copying the file 2-3 times.  It's a 1T partition with usually .8-2.5GB of
change/day.  I figure anything would be faster than rsync, which is why
I'm trying to build up a diff-detector.

The resulting 'diff' only takes 30-100 seconds in 'cp' -- that's how little data
is usually there... So I figured if any inodes or blocknumbers or sizes or 
timestamps
change, that would be a good basis for finding any builk of changes.


It's NOT meant to be a backup mechanism, but a convenience mechanism. -- i.e.
It's alot easier to browse to a file on the desktop, and right click and ask
for previous versions than it is to restore the file from daily towerhanoi-xfs 
backups.

That's just so much effort, I really have to want the file -- but a right click
and look for yesterday's copy?  pretty simple.



> 
> Also consider an overwrite situation.  The contents of the file are overwritten
> and have changed but the block map stayed the same.  To detect that we'd need
> some kind of generation number on every extent, and we don't have that.
> 
> At this time I don't think we have a solid way to tell you which blocks of a
> file are different without actually comparing them.  I think you are stuck
> looking at the mtime and then doing a full comparison.
---
	Yeah, and I'm sure I can do it faster than rsync, BUT.. I'd rather take
a shortcut if I can catch most of the cases -- and leave the absolute catch
everything to the dailies...  But I could go either way for this type of 
application.
Given it's known that it isn't going to keep exact backups, but is trying to keep
snapshot of files that change -- if something is really written-to, as subtly as
writing in place, from a windows client... and it takes 5 times as long... it might
not be worth it to catch it.

	But knowing how to dump the blocks could still be useful in walking
the directory and/or comparing files -- the directory walk alone -- if I know the
blocks numbers of the dirs, I could walk the directory in the order of the next 
nearest
block -- and when I encounter new dirs, do some type of binary-insertion based 
on the
block numbers .. might get some benefit that way...

	while my top speed is 1GB/s, I'm lucky to get 100MB on small random
i/o's with 20-50 being not-atypical.

	Certainly an rsync that takes 90 minutes /day to run is a a bit of a pain --
though no one is really 'waiting  on it' (other than me to see if I run into a new
bug to fix! ;-) ).

	OTOH, if I could do a snap and diff of the vol in 5 minutes... then doing
multiple snapshots in a day might be practical.



> Have you looked into using the xfs bulkstat ioctl interfaces?
> XFS_IOC_FSBULKSTAT won't get you the block map, but maybe it would be useful to
> you.  xfs_bmap is using XFS_IOC_GETBMAP*, but it sounds like you've already
> considered that.  Maybe a creative invocation of xfsdump?
---
	Yeah... my script is in perl right now ~ 2500 lines or so...mixing required 'C'
in with that would be a drag...


> 
> Let me know if I misunderstood and went off the rails.  ;)
---
not so much -- considering how far off the rails my app is... ;-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
