Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Dec 2007 20:07:04 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBE46vOS024185
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 20:07:00 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4D8347F655
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 20:07:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id fRq24CegEShWHJ1Y for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 20:07:06 -0800 (PST)
Message-ID: <47620148.2060401@sandeen.net>
Date: Thu, 13 Dec 2007 22:06:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount: Function not implemented
References: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com> <20071213224749.GJ4396912@sgi.com>
In-Reply-To: <20071213224749.GJ4396912@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: KE Liew <ke.liew@gmail.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Thu, Dec 13, 2007 at 04:46:18PM +0100, KE Liew wrote:

>> The hexdump:
>> ===================
>> # dd if=/dev/hdb bs=512 count=1 | hexdump -C
>> 1+0 records in
>> 1+0 records out
>> 00000000  58 46 53 42 00 01 00 00  00 00 00 00 00 3a 38 b0
>> |XFSB.........:8.|
> 
> This kind of indicates that you did a 'mkfs.xfs /dev/hdb' not
> the partition you created. If that is the case, then rebooting
> may have written who-knows-what to disk.

although if it was a) new and b) he made a whole-disk partition, it was
probably not a busy disk and I wouldn't expect a reboot was necessary.

>> The xfs_db:
>> ===================
>> # xfs_db -r -c "sb 0" -c p /dev/hdb
>> cache_node_purge: refcount was 1, not zero (node=0x80ca410)
>> xfs_db: cannot read root inode (22)
> 
> EINVAL.

Hm, that should probably use perror or something, silly me read that as
the inode *number* and then thought "hmm I bet something stuck EINVAL
into the inode number, oops!"  :)

>> cache_node_purge: refcount was 1, not zero (node=0x80da608)
>> xfs_db: cannot read realtime bitmap inode (22)
>> Segmentation fault
>> ===================
> 
> That tends to indicate that the filesystem superblock is ok but
> the contents are not.
> 
> Without knowing exactly what you did and what errors came up, it's
> going to be hard reconstructing what went wrong. Perhaps a metadump
> of the filesysetm woul dbe useful in working out how it is broken....

Metadump failed with the same errors as xfs_db

-Eric
