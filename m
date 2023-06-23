Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBA3EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 20:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjFWUFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 16:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjFWUFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 16:05:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D842720
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687550651;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QpVuIsOGv8ZhuqrW73xWCHdShINOoQmfaZT2crgQ4wQ=;
        b=eaXhPJMjuyR6AeLRuLR28xvc3Fe3f8E2ET3UHD2Kamj1aPOP2CzHRvOYML+Nl+HmDREe9u
        3BXOU9b+iQotji6jje3COmIRh14gAhp861o7hhYS3ATeg2iL8zvYvxWkAF/sS9JvP5lcC8
        rCW9dKMB7mzS2lQ37Safu11zXuUl9lI=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-MZzApE5fPlOzlWx2zojq1A-1; Fri, 23 Jun 2023 16:04:09 -0400
X-MC-Unique: MZzApE5fPlOzlWx2zojq1A-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77e2c123e8aso66726839f.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 13:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687550649; x=1690142649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QpVuIsOGv8ZhuqrW73xWCHdShINOoQmfaZT2crgQ4wQ=;
        b=TMYfc6VHvrhPaYPoTlhhEx5cHN606SICsf8qSU6fwt53F/BrQCLig/15jsXOvfzkgV
         wpNAckgU8Us2LRwvBzsVHER36984iwly4VN7WWqvpPvKrb+BYZMXtGoTtf6Zyg4pycV/
         2kbM95AqDa9C3bgR2qGfD0qTlkBiS1mL8Qagit+VXfF4ue0waHbpsG27F12IKu7YZBij
         nNYiLdncPmd6oeYJy5nYgZ+Nr7GwVi4vkbtdErKBN9Oc1rV1TPhgnYufQtSC82uoINdE
         XUA13cZuCk6JG1RpqAie7B8h9SwPiNxwffDm5LThD04q0wGYFmdGtMoDIuWyWa2pVplp
         qGcw==
X-Gm-Message-State: AC+VfDyXvfai6kepyWG72WM+1V9WXH5f8negz721pfY9CDTFgx8UKGoO
        0UcUZ0vTqxtyZzidWVr692RMhNjCMiOozTOcF0xLP3dV0nRDxEaxTqmovQDwSMgzdTkEWG+ED6Q
        dBOXdntucCgQ5sVWvrFsQ
X-Received: by 2002:a6b:ec0c:0:b0:780:a8bb:8f09 with SMTP id c12-20020a6bec0c000000b00780a8bb8f09mr10888592ioh.3.1687550648704;
        Fri, 23 Jun 2023 13:04:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7GU7W1CJ46oMALuT/Bko1h/SZac/6us0L33QB0fMev7KbQeztvSPC3Nn+igmuD5H0G2ufaog==
X-Received: by 2002:a6b:ec0c:0:b0:780:a8bb:8f09 with SMTP id c12-20020a6bec0c000000b00780a8bb8f09mr10888572ioh.3.1687550648290;
        Fri, 23 Jun 2023 13:04:08 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id m5-20020a924a05000000b00326bd11f5d1sm44285ilf.11.2023.06.23.13.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 13:04:07 -0700 (PDT)
Message-ID: <cdc8001d-56fb-eb0d-c01b-28810997ce17@redhat.com>
Date:   Fri, 23 Jun 2023 15:04:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Reply-To: sandeen@redhat.com
Subject: Re: Question on slow fallocate
Content-Language: en-US
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>, linux-xfs@vger.kernel.org
References: <871qi24cwf.fsf@doe.com>
From:   Eric Sandeen <esandeen@redhat.com>
In-Reply-To: <871qi24cwf.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/23/23 6:49 AM, Ritesh Harjani (IBM) wrote:
> Sorry, but I still haven't understood the real problem here for which
> XFS does filemap_write_and_wait_range(). Is it a stale data exposure
> problem?

(Hopefully I get this right by trying to be helpful, here. It's been a 
while).

Not really. IIRC the original problem was that the file size could get 
updated (transactionally) before the delayed allocation and IO happened 
at writeback time, leaving a hole before EOF where buffered writes had 
failed to land before a crash. This is what people originally called the 
"NULL files problem" because reading the hole post-crash returned zeros. 
It wasn't stale date, it was no data.

Some commits that dealt with this explain it fairly well I think:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c32676eea19ce29cb74dba0f97b085e83f6b8915

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ba87ea699ebd9dd577bf055ebc4a98200e337542

> Now, in this code here in fs/xfs/xfs_iops.c we refer to the problem as
> "expose ourselves to the null files problem".
> What is the "expose ourselves to the null files problem here"
> for which we do filemap_write_and_wait_range()?
> 
> 
> 	/*
> 	 * We are going to log the inode size change in this transaction so
> 	 * any previous writes that are beyond the on disk EOF and the new
> 	 * EOF that have not been written out need to be written here.  If we

i.e. force the writeback of any pending buffered IO into the hole 
created up to the new EOF

> 	 * do not write the data out, we expose ourselves to the null files
> 	 * problem. Note that this includes any block zeroing we did above;
> 	 * otherwise those blocks may not be zeroed after a crash.

and I suppose this relates a little to stale date, IIRC this is 
referring to zeroing partial blocks past the old EOF.

> 	 */
> 	if (did_zeroing ||
> 	    (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)) {
> 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> 						ip->i_disk_size, newsize - 1);
> 		if (error)
> 			return error;
> 	}
> 
> 
> Talking about ext4, it handles truncates to a file using orphan
> handline, yes. In case if the truncate operation spans multiple txns and
> if the crash happens say in the middle of a txn, then the subsequent crash
> recovery will truncate the blocks spanning i_disksize.
> 
> But we aren't discussing shrinking here right. We are doing pwrite
> followed by fallocate to grow the file size. With pwrite we use delalloc
> so the blocks only get allocated during writeback time and with
> fallocate we will allocate unwritten extents, so there should be no
> stale data expose problem in this case right?

yeah, it's not a stale data problem. I think that the extended EOF 
created by fallocate is being treated exactly the same as if we had 
extended it with ftruncate(). Indeed, replacing the posix_fallocate with 
ftruncate to the same size in the test program results in a similarly 
slow run, slightly faster probably because unwritten conversion doesn't 
have to happen in that case.

> Hence my question was to mainly understand what does "expose ourselves to
> the null files problem" means in XFS?

Hopefully the above explains it; that said, I'm not sure this is 
anything more than academically interesting. As Dave mentioned, 
fallocating tiny space and then writing into it is not at all the 
recommended or efficient use of fallocate.

The one thing I'm not remembering exactly here is why we have the 
heuristic that a truncate up requires flushing all pending data behind it.

I *think* it's because most users knew enough to expect buffered writes 
could be lost on a crash, but they expected to see valid data up to the 
on-disk EOF post-crash. Without this heuristic, they'd get some valid 
data that made it out followed by a hole ("NULLS") up to the new EOF, 
and they Did Not Like It.

-Eric

