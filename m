Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5AGmRKp085003 for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 11:48:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC9073BB2EF
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 09:51:00 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id QGI5lUteOATQ4imm for
	<xfs@oss.sgi.com>; Thu, 10 Jun 2010 09:51:00 -0700 (PDT)
Message-ID: <4C1117F3.2010008@sandeen.net>
Date: Thu, 10 Jun 2010 11:50:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
References: <1274710459-11446-1-git-send-email-jack@suse.cz>	<1274710459-11446-5-git-send-email-jack@suse.cz>	<4C0FD43D.3040803@sandeen.net>
	<20100610105813.GB10827@quack.suse.cz>
In-Reply-To: <20100610105813.GB10827@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

Jan Kara wrote:
> On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
>> Jan Kara wrote:
>>> Run fsx (and also several fsx threads in parallel) and verify that
>>> quota accounting is correct after they finish.
>> Jan, I'm having trouble with this one on XFS for some reason, with our 
>> RHEL6 kernel and quota-3.17...
>>
>> +Disabling group quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
>> +Disabling user quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
>> +repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
>> +repquota: Not all specified mountpoints are using quota.
>> +repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
>> +repquota: Not all specified mountpoints are using quota.
>>
>> ...
>>
>> however if I remove the quotaon calls (off / on settings) in check_usage()
>> then it works:
>>
>> check_usage()
>> {
>>         # quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>>         repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
>>                 >$tmp.orig
>>         quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>>         repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
>>                 >$tmp.checked
>>         # quotaon -u -g $SCRATCH_MNT 2>/dev/null
>>         diff $tmp.orig $tmp.checked
>> }
>>
>>
>> Seems like 2 issues: noisy disable messages, and repquota failing when disabled.
>   I've fixed noisy disable messages in quotaon (without -v flag only errors
> should be printed) in CVS. 

Ok, we should probably just add a filter for these so that it'll work
on older versions.

> With repquota & disabled quotas it's a bit more
> complicated. 

Hm I'm still woefully unfamiliar with quota intricacies.

It seems that after quotaon -f, repquota fails on xfs but works for ext*?

Not sure if that's intended...

Also is there a reason to disable quota before repquota?  Is disable/enable
around quotacheck enough?

Hm on ext* I'm also getting differences from the expected output; I suspect
due to selinux xattrs.  I'll try to get that fixed up.

> The problem is that for ext?, reiserfs,... you have to disable
> quotas before running quotacheck. Also quotacheck is NOP for XFS - we'd
> rather need to call something to really recompute quota usage for XFS. How
> that can be done?

It's regenerated at mount time if needed.  I don't know that we have a
method to force this recalculation...  I guess mounting with quotas disabled,
unmounting, then mounting again w/ quotas on will do it.

Thanks,
-Eric

> 									Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
