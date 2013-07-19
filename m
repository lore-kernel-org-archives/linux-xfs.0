Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C45B7F4E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:11:32 -0500 (CDT)
Message-ID: <51E9AB80.4000700@sgi.com>
Date: Fri, 19 Jul 2013 16:11:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4>
In-Reply-To: <20130719122235.GA360@x4>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ben Myers <bpm@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 07/19/13 07:22, Markus Trippelsdorf wrote:
>
> I've bisected this issue to the following commit:
>
>   commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
>   Author: Dave Chinner<dchinner@redhat.com>
>   Date:   Thu Jun 27 16:04:49 2013 +1000
>
>       xfs: don't do IO when creating an new inode
>
> Reverting this commit on top of the Linus tree "solves" all problems for
> me. IOW I no longer loose my KDE and LibreOffice config files during a
> crash. Log recovery now works fine and xfs_repair shows no issues.
>
> So users of 3.11.0-rc1 beware. Only run this version if you have
> up-to-date backups handy.
>

I reviewed the above patch and liked it but, I think I recreated the 
above mentioned problem with a simple script:

cp /root/.bash_history /root/.lesshst /root/.pwclientrc  /root/.viminfo 
/root/.bash_profile  /root/.lesshst.YCJCDz  /root/.quiltrc /somexfsdir
sync
echo 'c' > /proc/sysrq-trigger
.... reboot, remount ...
cd /somexfsdir

# ls -la
ls: cannot access .bash_history: No such file or directory
ls: cannot access .lesshst: No such file or directory
ls: cannot access .pwclientrc: No such file or directory
ls: cannot access .viminfo: No such file or directory
ls: cannot access .bash_profile: No such file or directory
ls: cannot access .lesshst.YCJCDz: No such file or directory
ls: cannot access .quiltrc: No such file or directory
total 4
drwxr-xr-x  2 root root  131 Jul 19 15:32 .
drwxr-xr-x 28 root root 4096 Jul 19 15:35 ..
??????????  ? ?    ?       ?            ? .bash_history
??????????  ? ?    ?       ?            ? .bash_profile
??????????  ? ?    ?       ?            ? .lesshst
??????????  ? ?    ?       ?            ? .lesshst.YCJCDz
??????????  ? ?    ?       ?            ? .pwclientrc
??????????  ? ?    ?       ?            ? .quiltrc
??????????  ? ?    ?       ?            ? .viminfo

# cat .bash_history
cat: .bash_history: No such file or directory

xfs_db> inode 131
xfs_db> p
core.magic = 0x494e
core.mode = 0
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 0
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 1
core.atime.sec = Fri Jul 19 15:26:13 2013
core.atime.nsec = 990813003
core.mtime.sec = Fri Jul 19 15:26:13 2013
core.mtime.nsec = 990813003
core.ctime.sec = Fri Jul 19 15:30:34 2013
core.ctime.nsec = 822788719
core.size = 0
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 3707503345
next_unlinked = null
u = (empty)

revert the above commit and the problem goes away.
Output:
The files are small files that I could find on the test box:
-rw-------  1 root root 28158 Jul 19 15:47 .bash_history
-rw-r--r--  1 root root    43 Jul 19 15:47 .bash_profile
-rw-------  1 root root  1046 Jul 19 15:47 .lesshst
-rw-------  1 root root   919 Jul 19 15:47 .lesshst.YCJCDz
-rw-r--r--  1 root root   344 Jul 19 15:47 .pwclientrc
-rw-r--r--  1 root root  2502 Jul 19 15:47 .quiltrc
-rw-------  1 root root 21895 Jul 19 15:47 .viminfo

And they diff the same as the originals.
core.magic = 0x494e
core.mode = 0100600
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 1
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 1
core.atime.sec = Fri Jul 19 15:56:04 2013
core.atime.nsec = 954825196
core.mtime.sec = Fri Jul 19 15:47:18 2013
core.mtime.nsec = 366686434
core.ctime.sec = Fri Jul 19 15:47:18 2013
core.ctime.nsec = 366686434
core.size = 28158
core.nblocks = 7
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 0
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12,7,0]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
