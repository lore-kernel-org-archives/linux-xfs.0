Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48860 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeCTRlw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 13:41:52 -0400
Subject: Re: [RFC][PATCH] xfs: adjust size/used/avail information for quota-df
References: <1520601355-180600-1-git-send-email-cgxu519@gmx.com>
 <20180315142549.GC45325@bfoster.bfoster>
 <F2C6F369-B24B-4383-8987-50C0F64155AD@gmx.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <efc15a82-1b9b-3e58-136a-ac6c3468e35f@sandeen.net>
Date: Tue, 20 Mar 2018 12:41:50 -0500
MIME-Version: 1.0
In-Reply-To: <F2C6F369-B24B-4383-8987-50C0F64155AD@gmx.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: cgxu519@gmx.com, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On 3/20/18 9:49 AM, cgxu519@gmx.com wrote:

...

> No, not really. Assume if we have 100GB xfs filesystem(/mnt/test2) and we have
> 3 directories(pq1, pq2, pq3) inside the fs, each directory sets project quota. 
> (size limit up to 10GB)
> 
> When avail space of total filesystem is only left 3.2MB, but when running df for
> pg1,pg2,pg3 then avail space is 9.5GB, this is much more than real filesystem. 
> What do you think?
> 
> Detail output [1]. (without this fix patch)
> 
> $ df -h /mnt/test2
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
> 
> $ df -h /mnt/test2/pq1
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
> 
> $ df -h /mnt/test2/pq2
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
> 
> $ df -h /mnt/test2/pq3
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2

I agree that this is a confusing result.
 
> Detail output [2]. (with this fix patch)
> 
> $ df -h /mnt/test2
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
> 
> $ df -h /mnt/test2/pq1
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
                   ^           ^
                   |           |
                   |           +-- This makes sense 
                   |
                   +-- This is a little bit odd

So you cap the available project space to host filesystem
available space, and also use that to compute the
total size of the "project" by adding used+available.

The slightly strange result is that "size" will shrink
as more filesystem space gets used, but I'm not
sure I have a better suggestion here... would the below
result be too confusing?  It is truthful; the limit is 10G,
570M are used, and only 3.2M is currently available due to
the host filesystem freespace constraint:

$ df -h /mnt/test2/pq1
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb2       10G   570M  3.2M 100% /mnt/test2

-Eric
