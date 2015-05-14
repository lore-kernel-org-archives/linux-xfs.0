Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA97E7F3F
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 11:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CFAC8F8066
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 09:29:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XmltayiaQdxsx5Gf for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 09:29:23 -0700 (PDT)
Message-ID: <5554CD63.1060407@sandeen.net>
Date: Thu, 14 May 2015 11:29:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: Add new sb_meta_uuid field, update userspace
	tools to manipulate it
References: <55525356.1020807@sandeen.net> <555254C7.8000705@sandeen.net>
	<20150514133946.GC23489@bfoster.bfoster>
In-Reply-To: <20150514133946.GC23489@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 5/14/15 8:39 AM, Brian Foster wrote:
> On Tue, May 12, 2015 at 02:30:15PM -0500, Eric Sandeen wrote:
>> This adds a new superblock field, sb_meta_uuid.  This allows us to
>> change the use-visible UUID on crc-enabled filesytems from userspace
>> if desired, by copying the existing UUID to the new location for
>> metadata comparisons.  If this is done, an incompat flag must be
>> set to prevent older filesystems from mounting the filesystem, but
>> the original UUID can be restored, and the incompat flag removed,
>> with a new xfs_db / xfs_admin UUID command, "restore."
>>
>> Much of this patch mirrors the kernel patch in simply renaming
>> the field used for metadata uuid comparison; other bits:
>>
>> * Teach xfs_db to print the new meta_uuid field
>> * Allow xfs_db to generate a new UUID for CRC-enabled filesystems
>> * Allow xfs_db to revert to the original UUID and clear the flag
>> * Fix up xfs_copy to work with CRC-enabled filesystems
>> * Update the xfs_admin manpage to show the UUID "restore" command
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> This version makes the UUID "restore" command silent if there
>> is nothing to do.
>>
>> Still open to bike-shedding on the "restore" name.  Maybe "revert?"
>>
> 
> Restore seems fine to me...
> 
>> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
>> index 279527c..a58eee5 100644
>> --- a/copy/xfs_copy.c
>> +++ b/copy/xfs_copy.c
>> @@ -466,6 +466,34 @@ write_wbuf(void)
>>  	sighold(SIGCHLD);
>>  }
>>  
>> +void
>> +sb_update_uuid(
>> +	xfs_sb_t	*sb,
>> +	ag_header_t	*ag_hdr,
>> +	thread_args	*tcarg)
>> +{
>> +	/*
>> +	 * If this filesystem has CRCs, the original UUID is stamped into
>> +	 * all metadata.  We need to copy the original UUID into the meta_uuid
>> +	 * slot and set the incompat flag if that hasn't already been done.
>> +	 */
>> +	if (xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb)) {
>> +		__be32 feat;
>> +
>> +		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
>> +		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
>> +		ag_hdr->xfs_sb->sb_features_incompat = cpu_to_be32(feat);
>> +		platform_uuid_copy(&ag_hdr->xfs_sb->sb_meta_uuid,
>> +				   &ag_hdr->xfs_sb->sb_uuid);
>> +	}
>> +
>> +	platform_uuid_copy(&ag_hdr->xfs_sb->sb_uuid, &tcarg->uuid);
>> +
>> +	/* We changed the UUID, so update the superblock CRC if needed */
>> +	if (xfs_sb_version_hascrc(sb))
>> +		xfs_update_cksum((char *)&ag_hdr->xfs_sb, sb->sb_sectsize,
>> +							 XFS_SB_CRC_OFF);

> xfs_copy doesn't work for me (crc=1,finobt=1)...
> 
> # ./copy/xfs_copy /dev/vdb1 /dev/vdb2 
>  0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ... 80%  ... 90%  ... 100%
> 
> All copies completed.
> # mount /dev/vdb2 /mnt/
> mount: mount /dev/vdb2 on /mnt failed: Structure needs cleaning
> # dmesg | tail
> ...
> [ 4145.609403] XFS (vdb2): Metadata CRC error detected at xfs_sb_read_verify+0x112/0x170 [xfs], block 0xffffffffffffffff
> [ 4145.611224] XFS (vdb2): Unmount and run xfs_repair
> [ 4145.611945] XFS (vdb2): First 64 bytes of corrupted metadata buffer:
> [ 4145.612873] ffff8800d8def000: 58 46 53 42 00 00 10 00 00 00 00 00 00 25 40 00  XFSB.........%@.
> [ 4145.615047] ffff8800d8def010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 4145.616359] ffff8800d8def020: 73 68 6d 76 a1 6d 43 96 8f 35 cb 98 2c ff fd 8d  shmv.mC..5..,...
> [ 4145.617926] ffff8800d8def030: 00 00 00 00 00 20 00 05 00 00 00 00 00 00 00 60  ..... .........`
> [ 4145.619267] XFS (vdb2): SB validate failed with error -74.
> 
> The same thing occurs with -d. It looks like the crc might not have
> updated..?

yeargh,

-		xfs_update_cksum((char *)&ag_hdr->xfs_sb, sb->sb_sectsize,
+		xfs_update_cksum((char *)ag_hdr->xfs_sb, sb->sb_sectsize,

will fix up, test harder, and resend :(

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
