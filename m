Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.bravenet.com ([65.39.176.20]:52806 "EHLO mail.bravenet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753235AbcLSTao (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Dec 2016 14:30:44 -0500
Reply-To: ncoulson-ml@ncoulson.com
Subject: Re: Switching from group to project quota's
References: <8f374ce3da8517c472b897b07ec28517@ncoulson.com>
 <d69ca26d-4c6c-e5a6-1c36-9d28f0b53a5a@sandeen.net>
From: Nathan Coulson <ncoulson-ml@ncoulson.com>
Message-ID: <d684dc35-cc2a-b582-18d7-d9a7c30cd38c@ncoulson.com>
Date: Mon, 19 Dec 2016 11:23:19 -0800
MIME-Version: 1.0
In-Reply-To: <d69ca26d-4c6c-e5a6-1c36-9d28f0b53a5a@sandeen.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On 2016-12-19 06:07 AM, Eric Sandeen wrote:
> On 12/18/16 7:03 PM, ncoulson-ml@ncoulson.com wrote:
>> We are currently using user and group quota's on multiple xfs
>> filesystem.  When trying to switch to Project Quota's, it attempts to
>> perform a quotacheck.
> I assume that you mean you switched mount -o uquota,gquota for
> mount -o uquota,pquota or something like that?

We are,  (that or alternatively in testing were using xfs_quota -x, off 
-g).
>> Tested on a lvm snapshot of a live volume,  it was still not mounted
>> after about a week (and couldn't find a way to cancel the attempted
>> mount.  dmesg did mention quotacheck, but I can't say it was doing
>> the quotacheck for the full week).
>>
>> Is there a way to convert from Group Quota's to Project Quota's while
>> avoiding the quotacheck?  (There are currently no project quota's
>> defined).  Outside of that, I was curious what scenario's would cause
>> quotacalc to recalculate.
> If any quota is on at mount time, and the "checked" flag is not present
> in the on-disk superblock, then quotacheck gets run.
>
> In general, we do accounting even if we don't do enforcement; i.e.
> having no quotas defined does not man that quota activity isn't
> happening - it is, because accounting happens regardless.
>
>> Thank You
>>
>>
>>
>> 1TB Volumes, Reviewing one of them, we are using 67G of 934GB (they
>> vary from 400GB free to 50GB Free).
>>
>> Inode usage seems to range from 5000000 to 8000000.
>>
>> Using the 2.6.32 kernel from Centos 6.8, but was doing my tests with
>> a snapshot of the volume on a centos 7.2 host (kernel 3.10)
>
>
>> I thought I may be able to work around this by removing the group
>> quota information,  but xfs_quota -x, remove -g with and without
>> group quota's on failed to work.    Everytime I received XFS_QUOTARM:
>> Invalid argument
> This was likely fixed upstream in 3.16
>
> commit 9da93f9b7cdf8ab28da6b364cdc1fafc8670b4dc
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Mon May 5 17:25:50 2014 +1000
>
>      xfs: fix Q_XQUOTARM ioctl
>
> and should be fixed in sufficiently up to date centos7 as well.
>
> but removing quota inodes won't obviate the need for a quotacheck,
> I'm afraid.
>
> -Eric


With the long quotacheck time (+1wk,  I think one test I left running 
for a few weeks) with our filesystem (not sure if that is due to the 
number of files we have, or if something else is at play),  I was hoping 
to find an alternative.  Best idea I have so far is to rsync to a 2nd 
volume with project quota's enabled (a few days per server most likely), 
and some symlink magic to keep things appearing in the same location.


In testing, it looks like disabling group quota support will not cause a 
QuotaCheck.

In the case of mounting a filesystem with pquotas, that previously used 
gquotas does certainly seem to trigger it.

What I was hoping (falsely), was mounting a volume with pquotas where 
there is no group quota information would not need a quotacheck (or at 
least not one that goes on as long as our tests have since there would 
be no projects setup yet).  I noticed it says in dmesg when it does a 
quotacheck, and the following certainly points to it being triggered.


root@test [/mnt]# mount /dev/sys.vg/test.lv z -o uqnoenforce
XFS (dm-8): Mounting Filesystem
XFS (dm-8): Ending clean mount

root@test [/mnt]# mount /dev/sys.vg/test.lv z -o uqnoenforce,pquota
XFS (dm-8): Mounting Filesystem
XFS (dm-8): Ending clean mount
XFS (dm-8): Quotacheck needed: Please wait.
XFS (dm-8): Quotacheck: Done.

But thank you Eric for your time.


Nathan Coulson
>
>> User quota state on /test (/dev/sda) Accounting: ON Enforcement: OFF
>> Inode: #131 (1663 blocks, 1639 extents) Group quota state on /test
>> (/dev/sda) Accounting: ON Enforcement: OFF Inode: #132 (1664 blocks,
>> 1648 extents) Project quota state on /test (/dev/sda) Accounting:
>> OFF Enforcement: OFF Inode: #132 (1664 blocks, 1648 extents) Blocks
>> grace time: [7 days 00:00:30] Inodes grace time: [7 days 00:00:30]
>> Realtime Blocks grace time: [7 days 00:00:30]
>>
>>
>> Nathan Coulson. -- To unsubscribe from this list: send the line
>> "unsubscribe linux-xfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>>

