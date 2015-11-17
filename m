Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 068E87F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 16:16:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA0D98F8050
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 14:16:15 -0800 (PST)
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249]) by
	cuda.sgi.com with ESMTP id YoO2uY1RAK7T1LLv for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 14:16:13 -0800 (PST)
Date: Wed, 18 Nov 2015 09:16:09 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: Disk error, then endless loop
Message-ID: <20151117221609.GA3563@onthe.net.au>
References: <20151117080332.GA28936@onthe.net.au>
	<20151117124148.GA20118@bfoster.bfoster>
	<20151117162802.GA28374@onthe.net.au>
	<20151117173724.GA18963@bfoster.bfoster>
	<20151117193534.GA1514@onthe.net.au>
	<20151117202131.GA43800@bfoster.bfoster>
	<20151117203455.GB43800@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117203455.GB43800@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 17, 2015 at 03:34:55PM -0500, Brian Foster wrote:
> On Tue, Nov 17, 2015 at 03:21:31PM -0500, Brian Foster wrote:
>> On Wed, Nov 18, 2015 at 06:35:34AM +1100, Chris Dunlop wrote:
>>> On Tue, Nov 17, 2015 at 12:37:24PM -0500, Brian Foster wrote:
>>>> If the device has already dropped and reconnected as a new dev node,
>>>> it's probably harmless at this point to just try to forcibly shut down
>>>> the fs on the old one. Could you try the following?
>>>> 
>>>>   xfs_io -x -c shutdown <mnt>
>>> 
>>> # xfs_io -x -c shutdown /var/lib/ceph/osd/ceph-18
>>> foreign file active, shutdown command is for XFS filesystems only
>>> 
>>> # grep ceph-18 /etc/mtab
>>>   <<< crickets >>>
>>> 
>>> I don't know when the fs disappeared from mtab, it could have been when I
>>> first did the umount I guess, I didn't think to check at the time. But the
>>> umount is still there:
>>> 
>>> # date; ps -opid,lstart,time,stat,wchan='WCHAN-xxxxxxxxxxxxxxxxxx',cmd -C umount
>>> Wed Nov 18 06:23:21 AEDT 2015
>>>   PID                  STARTED     TIME STAT WCHAN-xxxxxxxxxxxxxxxxxx CMD
>>> 23946 Tue Nov 17 17:30:41 2015 00:00:00 D+   xfs_ail_push_all_sync    umount /var/lib/ceph/osd/ceph-18
>> 
>> Ah, so it's already been removed from the namespace. Apparently it's
>> stuck at some point after the mount is made inaccessible and before it
>> actually finishes with I/O. I'm not sure we have any other option other
>> than a reset at this point, unfortunately. :/

Yes, I thought this would likely be the case.

> One last thought... it occurred to me that scsi devs have a delete
> option under the /sysfs fs. Does the old/stale device still exist under
> /sys/block/<dev>? If so, perhaps an 'echo 1 >
> /sys/block/<dev>/device/delete' would move things along..?

Unfortunately, no, it's not there.

> Note that I have no idea what effect that will have beyond removing the
> device node (so if it is still accessible now, it probably won't be
> after that command). I just tried it while doing I/O to a test device
> and it looked like it caused an fs shutdown, so it could be worth a try
> as a last resort before a system restart.
> 
> Brian

Thanks again,

Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
