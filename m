Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6AEwlKa105623 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 09:58:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C22703575A6
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 07:59:24 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Bn4Nx3KSULldxmGA for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 07:59:24 -0700 (PDT)
Message-ID: <4A57574B.2070006@sandeen.net>
Date: Fri, 10 Jul 2009 09:59:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel BUG with xfs_quota
References: <554e24be0907091624s2dd439b2vfd7062f6b866c7f@mail.gmail.com>	
	<4A56BCDE.2010609@sandeen.net>
	<554e24be0907100757g7f891fa1t7517cb0258853779@mail.gmail.com>
In-Reply-To: <554e24be0907100757g7f891fa1t7517cb0258853779@mail.gmail.com>
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
To: Chris Walker <christopher.walker@gmail.com>
Cc: xfs@oss.sgi.com

Chris Walker wrote:
> Thanks a lot for your response Eric, I didn't realize that debugging
> could lead to problems (perhaps the EXPERIMENTAL should have warned
> me!)  I will recompile without debugging.  I'm a bit surprised that
> debugging could lead to general filesystem instability -- I assumed it
> was a 'read-only' process.
> Thanks!
> Chris

Well, in general the asserts should all be valid, but they are
unforgiving, hence the stern warnings in the config help.  Rather than
printing out detailed info (though there is some of that),
CONFIG_XFS_DEBUG will also trigger an intentional BUG(); in any of the
assert conditions... so it's dangerous.  If you are hitting some other
problem, running with CONFIG_XFS_DEBUG may catch the problem sooner, but
I would not recommend running with it in general production.

-Eric


> On Fri, Jul 10, 2009 at 12:00 AM, Eric Sandeen<sandeen@sandeen.net> wrote:
>> Chris Walker wrote:
>>> Hello,
>>>
>>> I ran an xfs_quota command earlier (xfs_quota -x -c 'limit -g
>>> bsoft=2048g bhard=2148g hepl' /seltzer_lab), which triggered a kernel
>>> BUG:
>>>
>>> Assertion failed: dst->d_btimer != 0, file:
>>> fs/xfs/quota/xfs_qm_syscalls.c, line: 927
>> Well, you hit this:
>>
>> #ifdef DEBUG
>>        if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags ==
>> XFS_USER_QUOTA) ||
>>             (XFS_IS_OQUOTA_ENFORCED(mp) &&
>>                        (dst->d_flags & (XFS_PROJ_QUOTA |
>> XFS_GROUP_QUOTA)))) &&
>>            dst->d_id != 0) {
>>                if (((int) dst->d_bcount >= (int) dst->d_blk_softlimit) &&
>>                    (dst->d_blk_softlimit > 0)) {
>>                        ASSERT(dst->d_btimer != 0);
>>                }
>> ...
>>
>> which first raises the question, why are you running with
>> CONFIG_XFS_DEBUG? :)
>>
>> I'm no quota guru, but this is something like...
>>
>> If quota is enabled and the block count is over a non-0 soft limit, then
>> assert that the timer is non-0 (the timer being how much time is left
>> before service is refused.
>>
>> It also got all those values off the disk just prior to the ASSERT.
>>
>> ... and I'm not sure what the problem may be.  But you hit an internal
>> debugging assert which is only on with CONFIG_XFS_DEBUG, you may get
>> away with just running without that for now :)
>>
>> -Eric
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
