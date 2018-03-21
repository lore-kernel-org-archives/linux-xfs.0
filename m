Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbeCUDg2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 23:36:28 -0400
Content-Type: text/plain;
        charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [RFC][PATCH] xfs: adjust size/used/avail information for quota-df
From: cgxu519@gmx.com
In-Reply-To: <20180320191823.GE6454@bfoster.bfoster>
Date: Wed, 21 Mar 2018 11:36:08 +0800
Content-Transfer-Encoding: 8BIT
Message-Id: <C681DC1C-0621-4EAC-B191-8ACE82124249@gmx.com>
References: <1520601355-180600-1-git-send-email-cgxu519@gmx.com>
 <20180315142549.GC45325@bfoster.bfoster>
 <F2C6F369-B24B-4383-8987-50C0F64155AD@gmx.com>
 <efc15a82-1b9b-3e58-136a-ac6c3468e35f@sandeen.net>
 <20180320191823.GE6454@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

在 2018年3月21日，上午3:18，Brian Foster <bfoster@redhat.com> 写道：
> 
> On Tue, Mar 20, 2018 at 12:41:50PM -0500, Eric Sandeen wrote:
>> On 3/20/18 9:49 AM, cgxu519@gmx.com wrote:
>> 
>> ...
>> 
>>> No, not really. Assume if we have 100GB xfs filesystem(/mnt/test2) and we have
>>> 3 directories(pq1, pq2, pq3) inside the fs, each directory sets project quota. 
>>> (size limit up to 10GB)
>>> 
>>> When avail space of total filesystem is only left 3.2MB, but when running df for
>>> pg1,pg2,pg3 then avail space is 9.5GB, this is much more than real filesystem. 
>>> What do you think?
>>> 
>>> Detail output [1]. (without this fix patch)
>>> 
>>> $ df -h /mnt/test2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
>>> 
>>> $ df -h /mnt/test2/pq1
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>> 
>>> $ df -h /mnt/test2/pq2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>> 
>>> $ df -h /mnt/test2/pq3
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>> 
>> I agree that this is a confusing result.
>> 
> 
> Ditto. Thanks for the example Chengguang.
> 
>>> Detail output [2]. (with this fix patch)
>>> 
>>> $ df -h /mnt/test2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
>>> 
>>> $ df -h /mnt/test2/pq1
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>                   ^           ^
>>                   |           |
>>                   |           +-- This makes sense 
>>                   |
>>                   +-- This is a little bit odd
>> 
>> So you cap the available project space to host filesystem
>> available space, and also use that to compute the
>> total size of the "project" by adding used+available.
>> 
> 
> I think I agree here too. Personally, I'd expect the fs size to remain
> static one way or another (i.e., whether it's the full fs or a sub-fs
> via project quota) and see the user/avail numbers change based on the
> current state rather than see the size float around due to just wanting
> to make the numbers add up. The latter makes it difficult to understand
> the (virtual) geometry of the project.
> 
>> The slightly strange result is that "size" will shrink
>> as more filesystem space gets used, but I'm not
>> sure I have a better suggestion here... would the below
>> result be too confusing?  It is truthful; the limit is 10G,
>> 570M are used, and only 3.2M is currently available due to
>> the host filesystem freespace constraint:
>> 
>> $ df -h /mnt/test2/pq1
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/vdb2       10G   570M  3.2M 100% /mnt/test2
>> 
> 
> Slightly confusing, but I'd rather have accuracy than guarantee that
> size = used + avail. The above at least tells us that something is
> missing, even if it's not totally obvious that the missing space is
> unavailable due to the broader fs free space limitation. It's probably
> the type of thing you'd expect to see if space reporting were truly
> accurate on a thin volume, for example.


Personally, I agree with your suggestions, I’m more care about avail/used
not the size, but unfortunately, statfs seems only collecting f_blocks,
f_bfree, f_bavail then df calculate used space based on those variables,
so I think there is no chance directly specify used space. This is the
reason that I hope to guarantee 'total = used + avail'


If we remain static size 10GB and avail adjust to 3.2MB, then the result
looks like below. :(

$ df -h /mnt/test2
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb2       100G  100G  3.2M 100% /mnt/test2

$ df -h /mnt/test2/pq1
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb2        10G   10G  3.2M 100% /mnt/test2



> 
> FWIW, the other option is just to leave the output as above where we
> presumably ignore the global free space cap and present 9.5GB available.
> I think it's fine to fix/limit that, but I'd prefer an inaccurate
> available number to an inaccurate/variable fs size either way.
> 
> With regard to a soft limit, it looks like we currently size the fs at
> the soft limit and simply call it 100% used if the limit is exceeded.
> That seems reasonable to me if only a soft limit is set, but I suppose
> that could hide some info if both hard/soft limits are set. Perhaps we
> should use the max of the soft/hard limit if both are set (or I guess
> prioritize a hard limit iff it's larger than the soft, to avoid
> insanity)? I suppose one could also argue that some admins might want to
> size an fs with the soft limit, give users a bit of landing room, then
> set a hard cap to protect the broader fs. :/

If we want to remain the size static then we need choose either soft or hard limit.
I think hard limit is a little bit better and meaningful because soft limit
might not directly cause write error even if the limit has already exceeded.



> 
> Brian
> 
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

