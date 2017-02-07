Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:46865 "EHLO
        m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754175AbdBGMsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 07:48:13 -0500
Subject: Re: xfs wrongly report ENOSPACE
References: <58986E06.5050500@xtaotech.com>
 <20170206131435.GA57865@bfoster.bfoster>
From: "peng.hse" <peng.hse@xtaotech.com>
Message-ID: <5899C016.70308@xtaotech.com>
Date: Tue, 7 Feb 2017 20:39:50 +0800
MIME-Version: 1.0
In-Reply-To: <20170206131435.GA57865@bfoster.bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 2017年02月06日 21:14, Brian Foster wrote:
> Please use the XFS list, updated cc.
>
> On Mon, Feb 06, 2017 at 08:37:26PM +0800, peng.hse wrote:
>> Hi DJ and xfs developers,
>>
>> i am ceph developer, build the OSD on top of the xfs mount point. the kernel
>> xfs module i used was build from the 4.9.8 kernel release from
>> kernel.org, that includes your recent changes in Dec, 2016.
>>
>> recently, i found our cluster will get faulted due to the xfs mount wrongly
>> report there is no space to create the new file as
>>   " No space left on device ", but apparently the xfs mount point only be
>> around 50% full.
>>
>> i used the systemtap to narrow it down the the function xfs_ialloc_ag_select
>> which reports no free ag selected, the problem seems
>> still exist, not sure your recent patches will fix it or not.
>>
>> i am very glad to provide more info if your like to assist you to identify
>> the problem.
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> In this case, please at least provide the output from 'df -i <mnt>,'
> 'xfs_info <mnt>' and 'xfs_db -c "freesp -s" <dev>.'
>
> Chances are that this is caused by free space fragmentation. This means
> that while there might be plenty of free space, there isn't a contiguous
> free extent large enough to allocate an inode chunk. We've seen this
> kind of thing before with Ceph and it can be exacerbated by the use of
> large inodes. Potential workarounds may be to use the default inode size
> and/or enable the use of sparse inodes ('mkfs.xfs -i sparse <dev>').
>
> Another possible cause is that you've simply hit the maximum inode
> allocation limit (see the xfs_growfs manpage and the '-m' option)...
>
> Brian
>

the problematic mnt point is /mnt/819f7954-bf88-430d-a637-a08bad56cf6e/

[root@xt1 ~]# touch /mnt/819f7954-bf88-430d-a637-a08bad56cf6e/xx
touch: cannot touch ‘/mnt/819f7954-bf88-430d-a637-a08bad56cf6e/xx’: No 
space left on device

[root@xt1 ~]# df -i /mnt/819f7954-bf88-430d-a637-a08bad56cf6e/
Filesystem     Inodes    IUsed   IFree       IUse%  Mounted on
/dev/sdc2      982848  47296  935552    5% 
/mnt/819f7954-bf88-430d-a637-a08bad56cf6e



[root@xt1 ~]# xfs_info /mnt/819f7954-bf88-430d-a637-a08bad56cf6e
meta-data=/dev/sdc2              isize=2048    agcount=4, agsize=491455 blks
                  =                             sectsz=512   attr=2, 
projid32bit=1
                  =                             crc=0 finobt=0
data          =                             bsize=4096 blocks=1965819, 
imaxpct=25
                  =                             sunit=0 swidth=0 blks
naming     =version 2               bsize=4096   ascii-ci=0 ftype=0
log            =internal                  bsize=4096   blocks=2560, 
version=2
                  =                              sectsz=512   sunit=0 
blks, lazy-count=1
realtime    =none                      extsz=4096   blocks=0, rtextents=0



[root@xt1 ~]# xfs_db -r '-c freesp -s' /dev/sdc2
    from      to extents  blocks    pct
       1       1      80      80   0.01
       2       3      61     159   0.02
       4       7      88     483   0.06
       8      15     146    1680   0.21
      16      31   34312  788594  99.70
total free extents 34687
total free blocks 790996
average free extent size 22.8038

the total number of files underneath the mnt is
[root@xt1 819f7954-bf88-430d-a637-a08bad56cf6e]# find . |wc -l
47294



