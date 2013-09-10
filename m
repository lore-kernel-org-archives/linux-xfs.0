Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 957887F54
	for <linux-xfs@oss.sgi.com>; Tue, 10 Sep 2013 10:21:53 -0500 (CDT)
Message-ID: <522F390D.20809@sgi.com>
Date: Tue, 10 Sep 2013 10:21:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: don't break from growfs ag update loop on error
References: <520D1AAC.8090701@redhat.com> <522E3142.7090501@sandeen.net>
In-Reply-To: <522E3142.7090501@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 09/09/13 15:36, Eric Sandeen wrote:
> On 8/15/13 1:15 PM, Eric Sandeen wrote:
>> When xfs_growfs_data_private() is updating backup superblocks,
>> it bails out on the first error encountered, whether reading or
>> writing:
>
> Any thoughts on this one?  W/ the verifiers, we have a higher
> chance of encountering an error, and leaving the rest of the
> supers un-updated.  Repair will then possibly revert the fs to
> it's pre-growfs state, and data loss will ensue...
>
> Thanks,
> -Eric
>
>> * If we get an error writing out the alternate superblocks,
>> * just issue a warning and continue.  The real work is
>> * already done and committed.
>>
>> This can cause a problem later during repair, because repair
>> looks at all superblocks, and picks the most prevalent one
>> as correct.  If we bail out early in the backup superblock
>> loop, we can end up with more "bad" matching superblocks than
>> good, and a post-growfs repair may revert the filesystem to
>> the old geometry.
>>
>> With the combination of superblock verifiers and old bugs,
>> we're more likely to encounter read errors due to verification.
>>
>> And perhaps even worse, we don't even properly write any of the
>> newly-added superblocks in the new AGs.
>>
>> Even with this change, growfs will still say:
>>
>>    xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
>>    data blocks changed from 319815680 to 335216640
>>
>> which might be confusing to the user, but it at least communicates
>> that something has gone wrong, and dmesg will probably highlight
>> the need for an xfs_repair.
>>
>> And this is still best-effort; if verifiers fail on more than
>> half the backup supers, they may still "win" - but that's probably
>> best left to repair to more gracefully handle by doing its own
>> strict verification as part of the backup super "voting."
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---

Make sense to me - it could have been any kind of error including not 
being able to get a xfs_buf for the new secondary (a temp ENOMEM).

I wonder if it could be possible to fix corrupt entries rather than just 
skip them...

Probably could test this patch by corrupting a v5 secondary superblock 
and verifying with xfs_db.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
