Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.bravenet.com ([65.39.176.20]:46564 "EHLO mail.bravenet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757291AbcLWWCM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Dec 2016 17:02:12 -0500
Reply-To: ncoulson-ml@ncoulson.com
Subject: Re: Switching from group to project quota's
References: <8f374ce3da8517c472b897b07ec28517@ncoulson.com>
 <d69ca26d-4c6c-e5a6-1c36-9d28f0b53a5a@sandeen.net>
 <d684dc35-cc2a-b582-18d7-d9a7c30cd38c@ncoulson.com>
 <20161219212636.GO4326@dastard>
 <09e1f03d-3c33-7aa5-9e14-22038811d63a@ncoulson.com>
From: Nathan Coulson <ncoulson-ml@ncoulson.com>
Message-ID: <6b6e56ec-675a-123c-a01f-762ee4ee2249@ncoulson.com>
Date: Fri, 23 Dec 2016 14:02:09 -0800
MIME-Version: 1.0
In-Reply-To: <09e1f03d-3c33-7aa5-9e14-22038811d63a@ncoulson.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 2016-12-19 03:52 PM, Nathan Coulson wrote:
> On 2016-12-19 01:26 PM, Dave Chinner wrote:
>> On Mon, Dec 19, 2016 at 11:23:19AM -0800, Nathan Coulson wrote:
>>> With the long quotacheck time (+1wk,  I think one test I left
>>> running for a few weeks) with our filesystem (not sure if that is
>>> due to the number of files we have, or if something else is at
>>> play),  I was hoping to find an alternative.
>> It's hung. output of sysrq-w please.
>>
>> Cheers,
>>
>> Dave.
>
> I will need to setup the test again,  (machine has since been 
> rebooted).  I should be able to get resetup again tomorrow.

Got it resetup.

Ran as time mount /dev/medusa.32.vg/customers.lv z -o 
nosuid,nodev,noexec,uqnoenforce,pquota,logbufs=8,logbsize=256k,rw. 
(Snapshot made on a equallogic unit, copy on write based iscsi)

(state ran off our live vm, but probably similar to the snapshot I wrote).

xfs_quota> state
User quota state on /medusa (/dev/sda)
   Accounting: ON
   Enforcement: OFF
   Inode: #131 (1663 blocks, 1639 extents)
Group quota state on /medusa (/dev/sda)
   Accounting: ON
   Enforcement: OFF
   Inode: #132 (1664 blocks, 1648 extents)
Project quota state on /medusa (/dev/sda)
   Accounting: OFF
   Enforcement: OFF
   Inode: #132 (1664 blocks, 1648 extents)
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [7 days 00:00:30]
Realtime Blocks grace time: [7 days 00:00:30]

root@medusa32 [/root]# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sda             279209456 7732832 271476624    3% /medusa

root@medusa32 [/root]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda             1000G  936G   65G  94% /medusa


Mount started on Dec 21 at 4:29 PM PST,  and this email was posted as of 
Dec 23, 1:47pm PST.


The mount is still in progress.

Nathan Coulson

Bravenet Web Services

