Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0UWuP060654 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:30:42 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D35DD1B68C19
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:31:11 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id PGHHkWebnmPMdB2B for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:31:11 -0700 (PDT)
Message-ID: <4A84B050.4020500@sandeen.net>
Date: Thu, 13 Aug 2009 19:31:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <4A8474D2.7050508@jquigley.com>
	<E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
In-Reply-To: <E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: John Quigley <jquigley@jquigley.com>, XFS Development <xfs@oss.sgi.com>

Felix Blyakher wrote:
> On Aug 13, 2009, at 3:17 PM, John Quigley wrote:
> 
>> Folks:
>>
>> We're deploying XFS in a configuration where the file system is  
>> being exported with NFS.  XFS is being mounted on Linux, with  
>> default options; an iSCSI volume is the formatted media.  We're  
>> working out a failover solution for this deployment utilizing Linux  
>> HA.  Things appear to work correctly in the general case, but in  
>> continuous testing we're getting XFS superblock corruption on a very  
>> reproducible basis.
>> The sequence of events in our test scenario:
>>
>> 1. NFS server #1 online
>> 2. Run IO to NFS server #1 from NFS client
>> 3. NFS server #1 offline, (via passing 'b' to /proc/sysrq-trigger)
>> 4. NFS server #2 online
>> 5. XFS mounted as part of failover mechanism, mount fails
>>
>> The mount fails with the following:
>>
>> <snip>
>> kernel: XFS mounting filesystem sde
>> kernel: Starting XFS recovery on filesystem: sde (logdev: internal)
>> kernel: XFS: xlog_recover_process_data: bad clientid
>> kernel: XFS: log mount/recovery failed: error 5
> 
> This is an IO error. Is the block device (/dev/sde) accessible
> from the server #2 OK? Can you dd from that device?

Are you sure?

                if (ohead->oh_clientid != XFS_TRANSACTION &&
                    ohead->oh_clientid != XFS_LOG) {
                        xlog_warn(
                "XFS: xlog_recover_process_data: bad clientid");
                        ASSERT(0);
                        return (XFS_ERROR(EIO));
                }

so it does say EIO but that seems to me to be the wrong error; loks more
like a bad log to me.

It does make me wonder if there's any sort of per-initiator caching on
the iscsi target or something.  </handwave>

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
