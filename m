Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B963EC352A4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 22:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882872072C
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 22:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBJWhU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 17:37:20 -0500
Received: from xes-mad.com ([162.248.234.2]:53681 "EHLO mail.xes-mad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgBJWhU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Feb 2020 17:37:20 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2020 17:37:19 EST
Received: from zimbra.xes-mad.com (zimbra.xes-mad.com [10.52.0.127])
        by mail.xes-mad.com (Postfix) with ESMTP id 07D8D201D2;
        Mon, 10 Feb 2020 16:31:39 -0600 (CST)
Date:   Mon, 10 Feb 2020 16:31:32 -0600 (CST)
From:   Aaron Sierra <asierra@xes-inc.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Vincent Fazio <vfazio@xes-inc.com>, linux-xfs@vger.kernel.org
Message-ID: <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
In-Reply-To: <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
References: <20200210211037.1930-1-vfazio@xes-inc.com> <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
Subject: Re: [PATCH 1/1] xfs: fallback to readonly during recovery
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.0.127]
X-Mailer: Zimbra 8.7.5_GA_1764 (ZimbraWebClient - GC79 (Linux)/8.7.5_GA_1764)
Thread-Topic: fallback to readonly during recovery
Thread-Index: kVR+DZo4tt6Bsl94dGlwWIGS0bzAOg==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> From: "Eric Sandeen" <sandeen@sandeen.net>
> Sent: Monday, February 10, 2020 3:43:50 PM

> On 2/10/20 3:10 PM, Vincent Fazio wrote:
>> Previously, XFS would fail to mount if there was an error during log
>> recovery. This can occur as a result of inevitable I/O errors when
>> trying to apply the log on read-only ATA devices since the ATA layer
>> does not support reporting a device as read-only.
>> 
>> Now, if there's an error during log recovery, fall back to norecovery
>> mode and mark the filesystem as read-only in the XFS and VFS layers.
>> 
>> This roughly approximates the 'errors=remount-ro' mount option in ext4
>> but is implicit and the scope only covers errors during log recovery.
>> Since XFS is the default filesystem for some distributions, this change
>> allows users to continue to use XFS on these read-only ATA devices.
> 
> What is the workload or scenario where you need this behavior?
> 
> I'm not a big fan of ~silently mounting a filesystem with latent errors,
> tbh, but maybe you can explain a bit more about the problem you're solving
> here?

Hi Eric,

We use SSDs from multiple vendors that can be configured at power-on (via
GPIO) to be read-write or write-protected. When write-protected we get I/O
errors for any writes that reach the device. We believe that behavior is
correct.

We have found that XFS fails during log recovery even when the log is clean
(apparently due to metadata writes immediately before actual recovery).
Vincent and I believe that mounting read-only without recovery should be
fine even when the log is not clean, since the filesystem will be consistent,
even if out-of-date.

Our customers' use often requires nonvolatile memory to be write-protected
or not based on the device being installed in a development or deployed
system. It is ideal for them to be able to mount their filesystems read-
write when possible and read-only when not without having to alter mount
options.

Aaron

> Thanks,
> -Eric
> 
>> Reviewed-by: Aaron Sierra <asierra@xes-inc.com>
>> Signed-off-by: Vincent Fazio <vfazio@xes-inc.com>
>> ---
>>  fs/xfs/xfs_log.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index f6006d94a581..f5b3528ee028 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -739,7 +739,6 @@ xfs_log_mount(
>>  			xfs_warn(mp, "log mount/recovery failed: error %d",
>>  				error);
>>  			xlog_recover_cancel(mp->m_log);
>> -			goto out_destroy_ail;
>>  		}
>>  	}
>>  
>> @@ -3873,10 +3872,17 @@ xfs_log_force_umount(
>>  	/*
>>  	 * If this happens during log recovery, don't worry about
>>  	 * locking; the log isn't open for business yet.
>> +	 *
>> +	 * Attempt a read-only, norecovery mount. Ensure the VFS layer is updated.
>>  	 */
>>  	if (!log ||
>>  	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
>> -		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
>> +
>> +		xfs_notice(mp,
>> +"Falling back to no-recovery mode. Filesystem will be inconsistent.");
>> +		mp->m_flags |= (XFS_MOUNT_RDONLY | XFS_MOUNT_NORECOVERY);
>> +		mp->m_super->s_flags |= SB_RDONLY;
>> +
>>  		if (mp->m_sb_bp)
>>  			mp->m_sb_bp->b_flags |= XBF_DONE;
>>  		return 0;
