Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD2547F51
	for <xfs@oss.sgi.com>; Sat, 20 Jul 2013 12:21:50 -0500 (CDT)
Message-ID: <51EAC72B.905@sgi.com>
Date: Sat, 20 Jul 2013 12:21:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4> <51E9AB80.4000700@sgi.com>
	<20130720031840.GA11674@dastard>
In-Reply-To: <20130720031840.GA11674@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On 07/19/13 22:18, Dave Chinner wrote:
> On Fri, Jul 19, 2013 at 04:11:28PM -0500, Mark Tinguely wrote:
>> On 07/19/13 07:22, Markus Trippelsdorf wrote:
>>>
>>> I've bisected this issue to the following commit:
>>>
>>>   commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
>>>   Author: Dave Chinner<dchinner@redhat.com>
>>>   Date:   Thu Jun 27 16:04:49 2013 +1000
>>>
>>>       xfs: don't do IO when creating an new inode
>>>
>>> Reverting this commit on top of the Linus tree "solves" all problems for
>>> me. IOW I no longer loose my KDE and LibreOffice config files during a
>>> crash. Log recovery now works fine and xfs_repair shows no issues.
>>>
>>> So users of 3.11.0-rc1 beware. Only run this version if you have
>>> up-to-date backups handy.
>>>
>>
>> I reviewed the above patch and liked it but, I think I recreated the
>> above mentioned problem with a simple script:
>>
>> cp /root/.bash_history /root/.lesshst /root/.pwclientrc
>> /root/.viminfo /root/.bash_profile  /root/.lesshst.YCJCDz
>> /root/.quiltrc /somexfsdir
>> sync
>> echo 'c'>  /proc/sysrq-trigger
>> .... reboot, remount ...
>> cd /somexfsdir
>
> I've only reproduced the problem *once* with this method - the first
> time I tried. Then I mkfs'd the filesystem rather than repairing it
> and I haven't been able to reproduce it since.  So the problem is
> far more subtle that just copying some files, running sync and
> crashing the machine - there's some kind of initial or timing
> condition that we are missing that triggers it...
>
> The one interesting thing I noticed was that the generation number
> in the crash case was non-zero. That's an important piece of
> information, and:
>
>> # cat .bash_history
>> cat: .bash_history: No such file or directory
>>
>> xfs_db>  inode 131
>> xfs_db>  p
>> core.magic = 0x494e
>> core.mode = 0
>
> That's a "free" inode, and why XFS considers it invalid when the
> lookup sees it.
>
>> core.gen = 3707503345
>
> You saw it as well, Mark.
>
> That means it has actually been allocated and written to disk at
> some point in time. That is, inodes allocated by mkfs in the root
> inode chunk have a generation number of zero. For this to have a
> non-zero generation number, it means that had to be written after
> allocation - either before the sync or during log recovery.
>
> Unfortunately, without the 'xfs_logprint -t -i<dev>' output from
> prior to mounting the filesystem which demonstrates te problem, I
> can't tell if the issue is a recovery problem or something that
> happened before the crash....
>
>> revert the above commit and the problem goes away.
> ....
>> core.mode = 0100600
>
> Not an free inode...
>
>> core.gen = 0
>
> And, importantly, the generation number is zero, as would be
> expected for an inode in the root chunk.
>
> FWIW, if you can reproduce this on demand, Mark, is to see if
> mounting "-o ikeep" makes the problem go away as this optimisation
> is only used on filesystems that are configured to free inode
> chunks...
>
> Cheers,
>
> Dave.


Yeah, I thought of the logprint and the ikeep afterwards.

I tried the script today and it did not reproduce the problem. The 
logprint and the mounted filesystem was empty. I will rebuild the 
sources to eliminate some patched kernel versions on that box and 
experiment with the sync and the shooting of the kernel.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
