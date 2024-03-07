Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD65823BF;
	Thu,  7 Mar 2024 09:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709803347; cv=none; b=a9R9uFS0JFu4j6BRB/ZGdFYv8dTqYmVz7ndtk16ijJ5nzPyJCMeviPLuMwzktRzzAlfs7uHkwEk9AWTxgl4zwl0zCw8uWRpERkEEdERDOQHP4f3p/i/rdkn+aR87eanUIODQdyytzEOWEVje6UIy4lsjaAUkYbUUduoKPp+Dp8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709803347; c=relaxed/simple;
	bh=nRTGRZJR+CJA2g+im+wvzNNH46i6JZY4UCMbEy3EXPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNlnjvhTTd22gDGYbWR0O2wy1AfckQQGu+YurRnC1vZmtd2lXo09SGZ7yXOzsDlqP4iUvS3YpFdGMnZxBfZ54joNgNOvV4UBn/T+By02IEAHXTVmPdg7rPNm7YaZdlL+L2yOoZk52tk5UKuIl9lZOgC7kVGR1o9Bsot+MGh4bKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FO+sgywv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FO+sgywv"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4278Vh39002189;
	Thu, 7 Mar 2024 09:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kyitMC0c8lijPK0qjojMJvc+SZYasLMZEIdem7xGTpw=;
 b=FO+sgywvbI4+5uS0Z2tvn1QwNXt2xsqpQzB7d3HlaMoKEwu1sS88O7ZGA5/LhyF/LmPo
 wZcSYmZ74A/sDCKqlDU9lFBpe5/mLcMRORDhkJ/3gU7bQH37KEi+bNfMwMKmj1Q33mzo
 mpzjig1TBePevZckNxUYxQilR8JTAfGmlSppl78FJe61wzHIjgukin5WMh5/0OWTLHmD
 j40XcByVS6Q05VO3QW19OyOVUE0asimM0N5dQVeqkCyfGiipmY02ftYjpmCG6Ea3Mhy2
 p6ewklqPQdIK4kGp/WYUPfXkyRFABhZoD3nXsKw/WeXtyryOaW52d5YaPwW/kBdTfd53 1w== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wq9qs1g5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 09:22:19 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4276NTtm025376;
	Thu, 7 Mar 2024 09:22:18 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wmetyvs5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 09:22:18 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4279MGtL22086292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Mar 2024 09:22:18 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 143C258051;
	Thu,  7 Mar 2024 09:22:16 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E5F55805A;
	Thu,  7 Mar 2024 09:22:12 +0000 (GMT)
Received: from [9.171.91.129] (unknown [9.171.91.129])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Mar 2024 09:22:11 +0000 (GMT)
Message-ID: <574b1ec6-9f48-45b0-9bca-acb8c139764f@linux.ibm.com>
Date: Thu, 7 Mar 2024 14:51:36 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG REPORT] General protection fault while discarding extents on
 XFS on next-20240305
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Keith Busch <kbusch@kernel.org>, Chandan Babu R <chandanbabu@kernel.org>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org> <Zeh_e2tUpx-HzCed@kbusch-mbp>
 <ZeiAQv6ACQgIrsA-@kbusch-mbp> <ZeiBmGXgxNmgyjs4@infradead.org>
 <ZeiJKmWQoE6ttn6L@infradead.org> <ZejXV1ll+sbgBP48@dread.disaster.area>
 <ZejrR3-aLJy3ere7@infradead.org>
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <ZejrR3-aLJy3ere7@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CpPUbddc6PBM2FSuXfoFrii7_KZvnIHe
X-Proofpoint-ORIG-GUID: CpPUbddc6PBM2FSuXfoFrii7_KZvnIHe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-07_05,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403070067



On 3/7/24 03:46, Christoph Hellwig wrote:
> On Thu, Mar 07, 2024 at 07:51:35AM +1100, Dave Chinner wrote:
>> On Wed, Mar 06, 2024 at 07:18:02AM -0800, Christoph Hellwig wrote:
>>> Lookings at this a bit more I'm not sure my fix is enough as the error
>>> handling is really complex.  Also given that some discard callers are
>>> from kernel threads messing with interruptibility I'm not entirely
>>> sure that having this check in the common helper is a good idea.
>>
>> Yeah, this seems like a problem. The only places that userspace
>> should be issuing discards directly and hence be interruptible from
>> are FITRIM, BLKDISCARD and fallocate() on block devices.
> 
> Yes.
> 
>> Filesystems already handle fatal signals in FITRIM (e.g. see
>> xfs_trim_should_stop(), ext4_trim_interrupted(),
>> btrfs_trim_free_extents(), etc), so it seems to me that the only
>> non-interruptible call from userspace are operations directly on
>> block devices which have no higher level iteration over the range to
>> discard and the user controls the range directly.
> 
> Yeah.
> 
>> Perhaps the solution is to change BLKDISCARD/fallocate() on bdev to
>> look more like xfs_discard_extents() where it breaks the range up
>> into smaller chunks and intersperses bio chaining with signal
>> checks.
> 
> Well, xfs_discard_extents has different extents from the higher
> layers.  __blkdev_issue_discard than breaks it up based on what
> fits into the bio (and does some alignment against our normal
> rule of leaving that to the splitting code).  But I suspect moving
> the loop in __blkdev_issue_discard into the callers could really
> help with this.
> 
>>
>> I suspect the same solution is necessary for blkdev_issue_zeroout()
>> and blkdev_issue_secure_erase(), because both of them have user
>> controlled lengths...
> 
> Yes.  (or rather two sub cases of the former and the latter)
> 
How about adding a new parameter named "interruptible" to __blkdev_issue_discard()
and then using that parameter to deduce whether we need to intercept fatal
signal or not? We can ensure that it's only when __blkdev_issue_discard() is
invoked from the userspace (BLKDISCARD/fallocate()) we would have "interruptible"
set to "1" otherwise for all other code path it could be set to "0".

Yes we may need one helper which would help set the "interruptible" to "1" 
when invoked from BLKDISCARD/fallocate(). 

Probably the code should look as below (not tested):

diff --git a/block/blk-lib.c b/block/blk-lib.c
index dc8e35d0a51d..4b17f8b9dec1 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -56,7 +56,7 @@ static void await_bio_chain(struct bio *bio)
 }
 
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-               sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
+               sector_t nr_sects, gfp_t gfp_mask, struct bio **biop, int interruptible)
 {
        struct bio *bio = *biop;
        sector_t bs_mask;
@@ -97,8 +97,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
                 * is disabled.
                 */
                cond_resched();
-               if (fatal_signal_pending(current)) {
+               if (interruptible && fatal_signal_pending(current)) {
                        await_bio_chain(bio);
+                       *biop = NULL;
                        return -EINTR;
                }
        }
@@ -126,7 +127,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
        int ret;
 
        blk_start_plug(&plug);
-       ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+       ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio, 0);
        if (!ret && bio) {
                ret = submit_bio_wait(bio);
                if (ret == -EOPNOTSUPP)
@@ -139,6 +140,26 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+int blkdev_issue_discard_interruptible(struct block_device *bdev, sector_t sector,
+               sector_t nr_sects, gfp_t gfp_mask)
+{
+       struct bio *bio = NULL;
+       struct blk_plug plug;
+       int ret;
+
+       blk_start_plug(&plug);
+       ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio, 1);
+       if (!ret && bio) {
+               ret = submit_bio_wait(bio);
+               if (ret == -EOPNOTSUPP)
+                       ret = 0;
+               bio_put(bio);
+       }
+       blk_finish_plug(&plug);
+
+       return ret;
+}
+
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
                sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
                struct bio **biop, unsigned flags)
diff --git a/block/fops.c b/block/fops.c
index 0cf8cf72cdfa..f9399a59cf4e 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -828,7 +828,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
                if (error)
                        goto fail;
 
-               error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
+               error = blkdev_issue_discard_interruptible(bdev, start >> SECTOR_SHIFT,
                                             len >> SECTOR_SHIFT, GFP_KERNEL);
                break;
        default:
diff --git a/block/ioctl.c b/block/ioctl.c
index 438f79c564cf..e869f2859eb1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -117,7 +117,8 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
        err = truncate_bdev_range(bdev, mode, start, start + len - 1);
        if (err)
                goto fail;
-       err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
+       err = blkdev_issue_discard_interruptible(bdev, start >> 9,
+                       len >> 9, GFP_KERNEL);
 fail:
        filemap_invalidate_unlock(inode->i_mapping);
        return err;


And yes we would need similar changes for  blkdev_issue_zeroout() and 
blkdev_issue_secure_erase().

Thanks,
--Nilay





