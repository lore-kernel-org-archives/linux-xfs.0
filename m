Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4E6C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4A822258
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i+6+yGrZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgJNVEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728427AbgJNVEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 17:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602709475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YkZfcXKoB9SLJKFx+SJf9XQRHCtH/J9OSnIr7afmbgM=;
        b=i+6+yGrZVC1XE6J2UPUuQvN6z05htVffwncliw33Jf04gCEC88kCcoy0cM7KfMfWVUgHHp
        gmtYhrfzszm1iSTSJPwaLt3A5LephmmFr6nbjyVdfuQAhbqLRCyH1VnSrz/SsW0mzLneLe
        x6jWBHD/KumYFRZOCNc5B6FGBrky3DE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-gdQ8UV3UPDWiWcs4sIzjiQ-1; Wed, 14 Oct 2020 17:04:34 -0400
X-MC-Unique: gdQ8UV3UPDWiWcs4sIzjiQ-1
Received: by mail-wr1-f72.google.com with SMTP id a15so282367wrx.9
        for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2020 14:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YkZfcXKoB9SLJKFx+SJf9XQRHCtH/J9OSnIr7afmbgM=;
        b=GQL2EIOPbHCYWfVOtAh6vm7ulXl51iRR/aOX7O9gCpjELBPV326vt/Y9Lg0Dhdsz7H
         VezkFUnDb+bMEnFVswC8RROnHYYLVqSR+XqjvEs/IKeeMAFe89Phd3cc4VK8QOaB9mYY
         oYuTaHnsv87p9iDehya/H++y0kXWgloBrv0V8ceERRHnwC7/OmVkRGAdk6pzCvqeTScT
         0jkZotOcKXU67Ffl4LuCFqIYQkaRKZ/b3sjrb1HPsOdeqHfLMvd7nzWRRDtN+pDnxUWK
         R9Vc1/az+M1TS02uPjNam29rjuy6P7z8oMd4II2GaxT5utlQtHav6gpetZlGmU/S3Dks
         GF9A==
X-Gm-Message-State: AOAM531xAw/wzT8+5pVMFPwunEwpeNjP0toXVDjec7paHDlTzgCbm6x7
        Jycv7cwMGzhyF2VOoktokLeNF0aMtFe2pZ2cI7omDvsKR9lRsPciF9MlpfIAXoFVUXfa7QjO5ql
        FvcA58aH2TShX26yewy8y
X-Received: by 2002:adf:a553:: with SMTP id j19mr586159wrb.349.1602709472605;
        Wed, 14 Oct 2020 14:04:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNOt2CyFf1oepGXqsqonc42eOJ+B1koyev1RwN0dx1UBe56NfHN4q+eCozBF+WGpgG8rA4Cw==
X-Received: by 2002:adf:a553:: with SMTP id j19mr586146wrb.349.1602709472333;
        Wed, 14 Oct 2020 14:04:32 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id j9sm816481wrp.59.2020.10.14.14.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 14:04:31 -0700 (PDT)
Subject: Re: [PATCH v11 1/4] xfs: Refactor xfs_isilocked()
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-2-preichl@redhat.com> <20201012160308.GH917726@bfoster>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <fbbead0a-c691-f870-a33d-b80a6177ce4f@redhat.com>
Date:   Wed, 14 Oct 2020 23:04:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201012160308.GH917726@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/12/20 6:03 PM, Brian Foster wrote:
> On Fri, Oct 09, 2020 at 09:55:12PM +0200, Pavel Reichl wrote:
>> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
>> __xfs_rwsem_islocked() is a helper function which encapsulates checking
>> state of rw_semaphores hold by inode.
>>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> Suggested-by: Dave Chinner <dchinner@redhat.com>
>> Suggested-by: Eric Sandeen <sandeen@redhat.com>
>> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  fs/xfs/xfs_inode.c | 48 ++++++++++++++++++++++++++++++++++++++--------
>>  fs/xfs/xfs_inode.h | 21 +++++++++++++-------
>>  2 files changed, 54 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index c06129cffba9..7c1ceb4df4ec 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -345,9 +345,43 @@ xfs_ilock_demote(
>>  }
>>  
>>  #if defined(DEBUG) || defined(XFS_WARN)
>> -int
>> +static inline bool
>> +__xfs_rwsem_islocked(
>> +	struct rw_semaphore	*rwsem,
>> +	int			lock_flags)
>> +{
>> +	int			arg;
>> +
>> +	if (!debug_locks)
>> +		return rwsem_is_locked(rwsem);
>> +
>> +	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
>> +		/*
>> +		 * The caller could be asking if we have (shared | excl)
>> +		 * access to the lock. Ask lockdep if the rwsem is
>> +		 * locked either for read or write access.
>> +		 *
>> +		 * The caller could also be asking if we have only
>> +		 * shared access to the lock. Holding a rwsem
>> +		 * write-locked implies read access as well, so the
>> +		 * request to lockdep is the same for this case.
>> +		 */
>> +		arg = -1;
>> +	} else {
>> +		/*
>> +		 * The caller is asking if we have only exclusive access
>> +		 * to the lock. Ask lockdep if the rwsem is locked for
>> +		 * write access.
>> +		 */
>> +		arg = 0;
>> +	}
...
> 
> Also, I find the pattern of shifting in the caller slightly confusing,
> particularly with the 'lock_flags' name being passed down through the
> caller. Any reason we couldn't pass the shift value as a parameter and
> do the shift at the top of the function so the logic is clear and in one
> place?
> 

Hi Brian, is following change what you had in mind? Thanks!


>> @@ -349,14 +349,16 @@ xfs_ilock_demote(
 static inline bool
 __xfs_rwsem_islocked(
 	struct rw_semaphore	*rwsem,
-	int			lock_flags)
+	int			lock_flags,
+	int			shift)
 {
 	int			arg;
+	const int		shifted_lock_flags = lock_flags >> shift;
 
 	if (!debug_locks)
 		return rwsem_is_locked(rwsem);
 
-	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
+	if (shifted_lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
 		/*
 		 * The caller could be asking if we have (shared | excl)
 		 * access to the lock. Ask lockdep if the rwsem is
@@ -387,20 +389,20 @@ xfs_isilocked(
 {
 	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
 		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
-		return __xfs_rwsem_islocked(&ip->i_lock,
-				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
+		return __xfs_rwsem_islocked(&ip->i_lock, lock_flags,
+				XFS_ILOCK_FLAG_SHIFT);
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
 		ASSERT(!(lock_flags &
 			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
-		return __xfs_rwsem_islocked(&ip->i_mmaplock,
-				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
+		return __xfs_rwsem_islocked(&ip->i_mmaplock, lock_flags,
+				XFS_MMAPLOCK_FLAG_SHIFT);
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
-				(lock_flags >> XFS_IOLOCK_FLAG_SHIFT));
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem, lock_flags,
+				XFS_IOLOCK_FLAG_SHIFT);
 	}
 
 	ASSERT(0);

