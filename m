Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UGCdbK220850 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 10:12:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665971C9210C
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:13:46 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id WsZE3P54Rn6AEBBN for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:13:46 -0800 (PST)
Message-ID: <4B645AB9.8050508@sandeen.net>
Date: Sat, 30 Jan 2010 10:13:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 223 - test file alignment on stripe geometry
References: <4B621529.20708@sandeen.net> <20100130105236.GA18286@infradead.org>
In-Reply-To: <20100130105236.GA18286@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
>> +# real QA test starts here
>> +_supported_fs xfs ext4
> 
> I'd make this generic and just do the notrun in scratch_mkfs_geom for
> non-supported filesystems.

fair enough

>> +scratch_mkfs_geom()
>> +{
> 
> And I'd throw this one into common.rc.

ok

>> +=== Testing size 1073745920 falloc on 128k stripe ===
>> +SCRATCH_MNT/file-1073745920-falloc: well-aligned
>> diff --git a/common.rc b/common.rc
>> index 6424871..97513cc 100644
>> --- a/common.rc
>> +++ b/common.rc
>> @@ -292,7 +292,7 @@ _scratch_mkfs()
>>          $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>>  	;;
>>      *)
>> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>> +	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
> 
> Hmm, doesn't this change break other testcase?  Anyway needs some
> rationale in the changelog.

didn't break anything for me; I wanted to be able to see the mkfs
results w/ geometry, is all.  Will re-double-check but it was fine AFAIK.

>> index 0000000..fa005b2
>> --- /dev/null
>> +++ b/src/fibmap.c
> 
> This is a bit misnamed as it's not a generic fibmap tool but rather
> a specific tool comparing the bmap to the sunit alignment.
> 

good point .. how about making it more generic, something like:

fibmap -o <file offset> -l <length> -s <stripe alignment> <filename>

hmm though I hate to reqwrite filefrag ... :)

I suppose something like this could go into xfs_io as well, but that
makes this test unavailable to the masses until another release, at least.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
