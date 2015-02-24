Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CF5F7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 11:59:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 275F88F80D8
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 09:59:54 -0800 (PST)
Message-ID: <54ECBC10.2090001@pythonanywhere.com>
Date: Tue, 24 Feb 2015 17:59:44 +0000
From: Harry Percival <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EC958E.2000001@pythonanywhere.com>
	<20150224173305.GE4015@sgi.com>
In-Reply-To: <20150224173305.GE4015@sgi.com>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

Hi Ben,  thanks for replying.

We're using project quotas, and we'd be prepared to wipe the slate clean 
and start by saying there are no projects and no quotas at all, to start 
with.  Is there still no way of starting from scratch and avoiding that 
quotacheck?

HP

On 24/02/15 17:33, Ben Myers wrote:
> Hi Harry,
>
> On Tue, Feb 24, 2015 at 03:15:26PM +0000, Harry wrote:
>> Hi there,
>>
>> We've got a moderately large disk (~2TB) into an inconsistent state,
>> such that it's going to want a quotacheck the next time we mount it
>> (it's currently mounted with quota accounting inactive).  Our tests
>> suggest this is going to take several hours, and cause an outage we
>> can't afford.
> The 'noquota' mount option will disable quotacheck at mount time.  That
> may do what you need.
>   
>> We're wondering whether there's a 'nuke the site from orbit' option
>> that will let us avoid it.  The plan would be to:
>> - switch off quotas and delete them completely, using the commands:
>>    -- disable
>>    -- off
>>    -- remove
>> - remount the drive with -o prjquota, hoping that there will not be
>> a quotacheck, because we've deleted all the old quota data
>> - run a script gradually restore all the quotas, one by one and in
>> good time, from our own external backups (we've got the quotas in a
>> database basically).
>>
>> So the questions are:
>> - is there a way to remove all quota information from a mounted drive?
>> (the current mount status seems to be that it tried to mount it with
>> -o prjquota but that quota accounting is *not* active)
>> - will it work and let us remount the drive with -o prjquota without
>> causing a quotacheck?
> Quotacheck is implemented by truncating the quota inode and then
> rebuilding the dquots from scratch as it traverses all the inodes in the
> filesystem.  Unfortunately the filesystem needs to be idle during this
> process or the accounting could be incorrect, so there is no gradual
> option for restoring quotas.
>
> Regards,
> 	Ben

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
