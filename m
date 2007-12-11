Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 15:41:07 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBNetWC011269
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:40:57 -0800
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BED3546EDBC
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:41:06 -0800 (PST)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143]) by cuda.sgi.com with ESMTP id ZxpIwBWytpxjcrFv for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:41:06 -0800 (PST)
Message-ID: <475F2008.5030702@dgreaves.com>
Date: Tue, 11 Dec 2007 23:40:56 +0000
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_sblock
References: <475ED66F.40800@dgreaves.com> <20071211222546.GD4612@sgi.com>
In-Reply-To: <20071211222546.GD4612@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:
> On Tue, Dec 11, 2007 at 06:26:55PM +0000, David Greaves wrote:
>> Once every 2 or 3 cold boots I get this in dmesg as the user logs in and
> So there's a corrupted freespace btree block.
OK, ta

>> I ssh in as root, umount, mount, umount and run xfs_repair.
> repair doesn't check the freespace btrees - it just rebuilds them from
> scratch. use xfs_check to tell you what is wrong with the filesystem, then
> use xfs_repair to fix it....

OK, having repaired it:
haze:~# xfs_check /dev/video_vg/video_lv
haze:~#

So why do I have to do this on a regular basis (ie run xfs_repair)?
I am shutting the machine down cleanly (init 0)

>> It is possible this fs suffered in the 2.6.17 timeframe
>> It is also possible something got broken whilst I was having lots of issues with
>>  hibernate (which is still unreliable).
> 
> Suspend does not quiesce filesystems safely, so you risk filesystem
> corruption every time you suspend and resume no matter what filesystem
> you use.

Well, FWIW, I've not hibernated this machine for a *long* time.
Also my hibernate script used to run xfs_freeze before hibernating (to be on the
safe side). This would regularly hang with an xfs_io process (or some such IIRC)
in an unkillable state.


I was about to edit my init scripts to do a mount, umount, xfs_repair, mount
cycle. But then I thought "this is wrong - I'll report it".
So is there anything else I should do?


David
