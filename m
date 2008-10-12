Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 15:31:23 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9CMVGVF026726
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:31:16 -0700
Message-ID: <48F28911.606@sgi.com>
Date: Mon, 13 Oct 2008 09:32:33 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: don't put null inode
References: <48F02BB0.2030107@sandeen.net> <48F02C74.8080902@sandeen.net>
In-Reply-To: <48F02C74.8080902@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>, John Willis <John.Willis@Distant-earth.com>

Thanks Eric (and John). Barry, can you please rv and pull this into libxfs

Cheers

Eric Sandeen wrote:
> Ugh subject should be xfs_db of course :/
> 
> Eric Sandeen wrote:
>> John Willis pointed this out:
>>
>> $ sudo xfs_db -x /dev/evms/RAID5-SATA-1 
>> cache_node_purge: refcount was 1, not zero (node=0x80dd660)
>> xfs_db: cannot read root inode (22)
>> cache_node_purge: refcount was 1, not zero (node=0x80e0008)
>> xfs_db: cannot read realtime bitmap inode (22)
>> Segmentation fault
>>
>> it dies when pthread code gets a null ptr, like this:
>>
>> (gdb) bt
>> #0  0x0000003ef1c08309 in pthread_mutex_lock () from /lib64/libpthread.so.0
>> #1  0x000000000044f5af in cache_node_put (cache=0x25a2030, node=0x0) at cache.c:368
>> #2  0x000000000041ff7e in libxfs_mount (mp=0x0, sb=<value optimized out>, dev=<value optimized out>, logdev=<value optimized out>, 
>>     rtdev=<value optimized out>, flags=1) at init.c:680
>> #3  0x0000000000416157 in init (argc=2, argv=0x7fffd9e19798) at init.c:125
>> #4  0x000000000041635a in main (argc=48, argv=0x7fffd9e19798) at init.c:153
>> (gdb) 
>>
>> when reading the root inode fails, and we try to libxfs_iput it anyway.
>>
>> The following seems to fix it ...
>>
>> -Eric
>>
>> Index: xfsprogs/libxfs/init.c
>> ===================================================================
>> --- xfsprogs.orig/libxfs/init.c
>> +++ xfsprogs/libxfs/init.c
>> @@ -677,7 +677,8 @@ libxfs_mount(
>>  		ASSERT(mp->m_rootip != NULL);
>>  	}
>>  	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp)) {
>> -		libxfs_iput(mp->m_rootip, 0);
>> +		if (mp->m_rootip)
>> +			libxfs_iput(mp->m_rootip, 0);
>>  		return NULL;
>>  	}
>>  
>>
>>
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
