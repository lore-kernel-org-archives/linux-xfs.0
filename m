Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RBcKH9089427 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 06:38:20 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id CGbwcZ9s5TMGnJCk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 04:39:38 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q8RBdZfP002223 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 04:39:37 -0700
Message-ID: <50643AF7.7060106@tlinx.org>
Date: Thu, 27 Sep 2012 04:39:35 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: more efficient way to print out inode->block mappings?
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
To: xfs-oss <xfs@oss.sgi.com>

I want to be able to rapidly determine the diffs between 2 volumes.

Special note 1 is an active lvm snapshot of the other -- meaning it is
frozen in time, but otherwise should look identical the the file system
as it was when it was snapped.

Sooo... a way of speeding checks is finding out what blocks allocated to the indoes
are different, since as the new volume gets used, I had hoped that differing
block numbers might give me a clue as to what had changed..

I'm thinking though, that the block numbers that will change will be the ones
in lvm -- not xfs.  So this probably isn't as useful as i'd hoped.

Nevertheless, trying to read the blocks allocated/inode with bmap is sorta slow.
I've tried to optimize it by starting a pty session to xfs_db and issuing inode/bmap
commands -- but I have to wait for a prompt to come back to know that the command
has finished, and I'm not really sure it's really returning more than 1 line
for any file. -- though interactively, I can find a file with a large ACL, and see
it has both a data and attr bmap.  I also haven't seen what output would look like
if the file(or dir) was split -- as, so far, have only seen files/dirs returned 
that
have 1 allocation/file,

So what the means is that I'm not sure about synchronization between commands output
and the input I read in -- even though I read in the input after every command. 
-- but even with
a minimal timeout of 1ms, and keeping track of commands outstanding and replies 
(as measured
by 'prompts' recieved, I'm far from convinced it's doing the right thing -- and 
it still
slow going 1 inode at a time over a pty interface.

I thought of trying to use blockget -v and parsing the output.  I figured that 
would
have the least latency and likely be the fastest way to dump the mappings -- BUT
it seems I can't get it to work on an active file system.  So how can I get that 
block
info dumped without blockget?  I've already told blockget it's in -r only 
mode... so it
shouldn't try to repair inconsistencies...and 99.999% is going to be what I want 
and any
inconsistencies, I can check manually be checking the files through the mounted 
interface.

Oddly, and likely I'm confused about something, but when  i try to print the 
log/log_print,
it says it is an invalid log 1 byte long, so even if it were played out, I don't
think it would make much difference in the final results.

Is it possible to do what I want w/o writing a special util/C prog to dump this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
