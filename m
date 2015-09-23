Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11D067F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 12:53:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0142B8F8052
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 10:53:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZnznbKesAkWGMiB6 for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 10:53:46 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1CB0761F81DE
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 12:53:46 -0500 (CDT)
Subject: Re: [PATCH 09/13] xfs_repair: better checking of v5 attributes
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-10-git-send-email-sandeen@sandeen.net>
	<20150914194412.GJ34083@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5602E729.3010500@sandeen.net>
Date: Wed, 23 Sep 2015 12:53:45 -0500
MIME-Version: 1.0
In-Reply-To: <20150914194412.GJ34083@bfoster.bfoster>
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
To: xfs@oss.sgi.com



On 9/14/15 2:44 PM, Brian Foster wrote:
> On Wed, Sep 09, 2015 at 02:34:07PM -0500, Eric Sandeen wrote:
>> The commit:
>>
>> 0519f66 xfs_repair: better checking of v5 metadata fields
>>
>> added new corruption checks to dir2.c but missed the similar
>> code in attr_repair.c; add that here.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>  repair/attr_repair.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
>> index 2aafdf6..c8ba484 100644
>> --- a/repair/attr_repair.c
>> +++ b/repair/attr_repair.c
>> @@ -201,6 +201,15 @@ traverse_int_dablock(xfs_mount_t	*mp,
>>  			goto error_out;
>>  		}
>>  
>> +		/* corrupt node; rebuild the dir. */
>> +		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
>> +			libxfs_putbuf(bp);
>> +			do_warn(
>> +_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
>> +				bno, da_cursor->ino);
>> +			goto error_out;
>> +		}
>> +
> 
> Hmm, well this certainly looks similar, but is it the right thing to do
> for xattrs? I haven't followed through how exactly directories are
> rebuilt, but there does appear to be a recovery path in the dir2
> context. A failure there simply puts the inode on a "bad" list to be
> rebuilt later, presumably from data collected from all of the inodes.
> 
> If we fail here, it looks like we just clear the attribute fork. So are
> we failing too hard, too soon here if a dablock crc happens to be
> incorrect?

Brian & I talked about this briefly on IRC.  The upshot:

attr checking already has many failure points, and if any one fails, the attr
may get nuked.

dir checking already has many failure points, and if any one fails, the dir
can get rebuilt.

All this patch does is add another check to several existing checks in the
attr code, and if it fails, whatever action was taken before for any other
error will also be taken for a bad CRC or a verifier failure.  So, this 
doesn't really introduce any new or more draconian behavior; it simply adds
one more check (the CRC, which had previously been ignored) to a host of other
verifications in this code, with the same results as before if this new check
fails.  So I think it's fine as it is.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
