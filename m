Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45410 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754914AbdDDTTM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 15:19:12 -0400
Subject: Re: [PATCH] repair: handle reading superblock from image on larger
 sector size filesystem
References: <1488998407-9094-1-git-send-email-zlang@redhat.com>
 <41576a80-2f48-14e3-78c0-7425afe402c3@sandeen.net>
 <20170310162859.GA21915@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <265ed269-a818-f814-3581-59ecb580b835@sandeen.net>
Date: Tue, 4 Apr 2017 14:19:11 -0500
MIME-Version: 1.0
In-Reply-To: <20170310162859.GA21915@dhcp12-143.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 3/10/17 10:28 AM, Zorro Lang wrote:
> On Thu, Mar 09, 2017 at 08:58:07PM -0600, Eric Sandeen wrote:
>> On 3/8/17 12:40 PM, Zorro Lang wrote:
>>> Due to xfs_repair uses direct IO, sometimes it can't read superblock
>>> from an image file has smaller sector size than host filesystem.
>>> Especially that superblock doesn't align with host filesystem's
>>> sector size.
>>>
>>> To avoid this, when direct read returns EINVAL, turn off direct IO,
>>> then try to read again.
>>
>> Ok, so the problem is that while we already do this after phase1,
>> you're running into trouble /during/ phase1.
> 
> Yes,
> 
>>
>>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>>> ---
>>>
>>> Hi,
>>>
>>> I found this bug when I try to modify xfstests' xfs/078 on s390x,
>>> manually reproduce this bug by below steps:
>>
>> I bet you could write an xfstest for this using scsi_debug, yes?
> 
> xfs/078 (after my patch can be merged) can reproducer this bug on
> s390x or other machines with 4k sector size disk. Do you think we
> need a separate one case to test that?

Yes, because 0.000001% of the world tests on S390x ;)

> Hmm... but maybe I can write a case to test all some XFS commands
> that do buffer IO on 4k sector size device (created by scsi_debug)?

*nod*

Were you planning an update to this patch?

Thanks,
-Eric
 
>>
>>>     [root@ibm-z-32 ~]# blockdev --getss --getpbsz --getbsz  /dev/dasda1
>>>     4096
>>>     4096
>>>     4096
>>>     [root@ibm-z-32 ~]# truncate -s $((168024*1024)) fsfile
>>>     [root@ibm-z-32 ~]# echo $((168024*1024))
>>>     172056576
>>>     [root@ibm-z-32 ~]# losetup /dev/loop0 fsfile
>>>     [root@ibm-z-32 ~]# mkfs.xfs -f -b size=1k /dev/loop0
>>>     meta-data=/dev/loop0             isize=512    agcount=4, agsize=42006 blks
>>>              =                       sectsz=512   attr=2, projid32bit=1
>>>              =                       crc=1        finobt=0, sparse=0
>>>     data     =                       bsize=1024   blocks=168024, imaxpct=25
>>>              =                       sunit=0      swidth=0 blks
>>>     naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>>>     log      =internal log           bsize=1024   blocks=2573, version=2
>>>              =                       sectsz=512   sunit=0 blks, lazy-count=1
>>>     realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> presumably a repair of the file (not the loop dev) fails here as well?
> 
> Hmm, right, if it makes someone superblock on unaligned offset.
> 
>>
>> ... snip ...
>>
>>>     [root@ibm-z-32 ~]# xfs_repair -f -n fsfile
>>>     Phase 1 - find and verify superblock...
>>>     superblock read failed, offset 43014144, size 131072, ag 1, rval -1
>>>      
>>>     fatal error -- Invalid argument
>>>
>>>
>>> To avoid this problem, I use the same way as Dave did in:
>>>
>>>   f63fd26 repair: handle repair of image files on large sector size filesystems
>>>
>>> So there're some duplicate code in "fcntl" part, I want to pick up
>>> this part to be a common function in xfsprogs or xfsprogs/repair,
>>> but I don't know where's the proper place and if that's necessary?
>>
>>
>>> Thanks,
>>> Zorro
>>>
>>>  repair/sb.c | 25 +++++++++++++++++++++++--
>>>  1 file changed, 23 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/repair/sb.c b/repair/sb.c
>>> index 77e5154..617ad98 100644
>>> --- a/repair/sb.c
>>> +++ b/repair/sb.c
>>> @@ -567,11 +567,32 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
>>>  	}
>>>  
>>>  	if ((rval = read(x.dfd, buf, size)) != size)  {
>>> +		/*
>>> +		 * If file image sector is smaller than the host filesystem
>>> +		 * sector, this O_DIRECT read will return EINVAL. So turn
>>> +		 * off O_DIRECT and try to buffer read.
>>
>> Ok, thinking this through...
>>
>> In your case bsize is 1024, and agblocks is 42006, so our supers are at
>> these offsets:
>>
>> 0 -> OK
>> 43014144 -> not 4k aligned
>> 86028288 -> OK
>> 129042432 -> not 4k aligned
>>
>> so: the DIO is failing due to an unaligned offset, just to be clear.
>>
>>> +		 */
>>> +		if (errno == EINVAL) {
>>> +			long old_flags;
>>> +
>>> +			old_flags = fcntl(x.dfd, F_GETFL, 0);
>>> +			if (fcntl(x.dfd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
>>> +				do_warn(
>>> +        _("Sector size on host filesystem larger than image sector size.\n"
>>> +          "Cannot turn off direct IO, so exiting.\n"));
>>> +				exit(1);
>>> +			} else if ((rval = read(x.dfd, buf, size)) == size) {
>>> +				errno = 0;
>>> +			}
>>> +		}
>>>  		error = errno;
>>> -		do_warn(
>>> +		if (error != 0) {
>>> +			do_warn(
>>>  	_("superblock read failed, offset %" PRId64 ", size %d, ag %u, rval %d\n"),
>>>  			off, size, agno, rval);
>>> -		do_error("%s\n", strerror(error));
>>> +			do_error("%s\n", strerror(error));
>>> +		}
>>> +
>>
>> I agree that we should not duplicate this code here.  Also,
>> we really should only be handling DIO vs buffered if (isa_file) is true...
>> if we got EINVAL from a device, this filesystem has bigger problems.
> 
> Yes, I suddently realized the "isa_file" problem after I sent this patch for
> a while (after I waked up next morning :)
> 
>>
>> So for starters I'd probably move the if (!isa_file) double checking
>> in main() up above phase1(), so we have that information during phase1.
>>
>> Then I'd probably encapsulate the geometry checks and O_DIRECT disabling
>> into its own function.
>>
>> Then we need to figure out when to call the check - this is a little tricky,
>> because the filesystem geometry comes from the superblock, which we are still
>> trying to validate.
>>
>> So I think that before we start either the superblock verification or
>> discovery loops in verify_set_primary_sb() or find_secondary_sb(),
>> check whether the sector size or block size is less than the host
>> filesystem's geometry, and if so, turn off DIO.
>>
>> It probably doesn't hurt to call it again after phase1, when we have
>> a valid superblock (same place as we do today)
>>
>> I think that'll work...
> 
> Hmm, that sounds good, but I need to read the code to make sure how
> to do this change :)
> 
> Thanks,
> Zorro
> 
>>
>> -Eric
>>
>>>  	}
>>>  	libxfs_sb_from_disk(sbp, buf);
>>>  
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
