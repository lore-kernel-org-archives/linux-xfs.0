Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD0AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 15:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44811221E5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 15:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbhADPRc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbhADPRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 10:17:32 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF373C061793
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 07:16:51 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id q75so19678275wme.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 07:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sOnYgD89qi6X0yPE/lUNBNGTX1wkGbrbs94PCa7znTc=;
        b=IwbYWUAVpzgTW7q7UEbk8yxN95zfGMluFUP/V0KmxaTkoFXn7IUFot6Fzn/HK9zLbr
         YaSrXbtWS0WQgRxFtqdTjjnbkMwoyERaaKEPBnnl9ls1rRJkcKYqOfsrtG3iL+duJ3jb
         ueUKI+zODzb91o6yVKithjxqpHNSTKuqOFXxyGE6Tyqe5xWp0wW8rbVCHu98hv9HI9Dp
         G064uBllSg/DfveUtFGxcD/SR2FyBYRYHOQON1ikcEanKn6Bk+G7ayGJr/UqBKMkD5ah
         +X4k3WlQtsQNqRyZI+SBM/WmVBa7W8J3mWbNQ9kFnAxI61IGX8CVO7MeWBoAbxqcxcxU
         Jgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=sOnYgD89qi6X0yPE/lUNBNGTX1wkGbrbs94PCa7znTc=;
        b=Y4zXL5B/xow8dU8ugnvdYsWWm9DnD+OvRelouBi0nGjEVgKyQiY4w10LIGpizq8to8
         lgkAKUCZFa/RmbfuUJD+gkUU/FhFoNoRacy0C41HgUc+BttxYVheVGQhy+8xbjRiuTCw
         aERRDBfIAvYN9ONMJjHjBP+QzCbXdtp83BEtNSsjmpJHQ6eAj2FG62/r86O5WZJNSZXy
         LnKClK3gJdjO+GoTrn97JOPRrHF9FFMSvMkClhwqdA2KpCmlnOj/jvRKq0J5RfY312fK
         +/y++odL8nSCjYtVBzLgdcb8QLCsP6KAifbdLIykf2CNBUpqmV3wCD6XacWAVv0hvmsK
         nyfA==
X-Gm-Message-State: AOAM533nYvnVV0kZTBWHshmSq3kfG2EwC7Dn3LDBrzsCDVZJd5vqc7jg
        7bDQQIYsc9fd7+/YMbzzGT80kw==
X-Google-Smtp-Source: ABdhPJyD+jQ29yzxAscD8rsVkFTE/6cji6CJEomMwrj7rDjXE+qgYvlTWWV/KOLdfPnRtV7BzmcQkQ==
X-Received: by 2002:a1c:2785:: with SMTP id n127mr27615094wmn.148.1609773410565;
        Mon, 04 Jan 2021 07:16:50 -0800 (PST)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id l8sm101309278wrb.73.2021.01.04.07.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 07:16:49 -0800 (PST)
Subject: Re: Disk aligned (but not block aligned) DIO write woes
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20ce6a14-94cf-c8ef-8219-7a051fb6e66a@scylladb.com>
 <20210104150601.GA130750@bfoster>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <c337a32a-30a1-db21-587e-8913aee7c61e@scylladb.com>
Date:   Mon, 4 Jan 2021 17:16:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104150601.GA130750@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04/01/2021 17.06, Brian Foster wrote:
> On Mon, Dec 28, 2020 at 05:57:29PM +0200, Avi Kivity wrote:
>> I observe that XFS takes an exclusive lock for DIO writes that are not block
>> aligned:
>>
>>
>> xfs_file_dio_aio_write(
>>
>> {
>>
>> ...
>>
>>         /*
>>           * Don't take the exclusive iolock here unless the I/O is unaligned
>> to
>>           * the file system block size.  We don't need to consider the EOF
>>           * extension case here because xfs_file_aio_write_checks() will
>> relock
>>           * the inode as necessary for EOF zeroing cases and fill out the new
>>           * inode size as appropriate.
>>           */
>>          if ((iocb->ki_pos & mp->m_blockmask) ||
>>              ((iocb->ki_pos + count) & mp->m_blockmask)) {
>>                  unaligned_io = 1;
>>
>>                  /*
>>                   * We can't properly handle unaligned direct I/O to reflink
>>                   * files yet, as we can't unshare a partial block.
>>                   */
>>                  if (xfs_is_cow_inode(ip)) {
>>                          trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos,
>> count);
>>                          return -ENOTBLK;
>>                  }
>>                  iolock = XFS_IOLOCK_EXCL;
>>          } else {
>>                  iolock = XFS_IOLOCK_SHARED;
>>          }
>>
>>
>> I also see that such writes cause io_submit to block, even if they hit a
>> written extent (and are also not size-changing, by implication) and
>> therefore do not require a metadata write. Probably due to "|| unaligned_io"
>> in
>>
>>
>>          ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
>>                             &xfs_dio_write_ops,
>>                             is_sync_kiocb(iocb) || unaligned_io);
>>
>>
>> Can this be relaxed to allow writes to written extents to proceed in
>> parallel? I explain the motivation below.
>>
>  From the above code, it looks as though we require the exclusive lock to
> accommodate sub-block zeroing that might occur down in the dio code.
> Without it, concurrent sector granular I/Os to the same block could
> presumably cause corruption if the data bios and associated zeroing bios
> were reordered between two requests.
>
> Looking down in the iomap/dio code, iomap_dio_bio_actor() triggers
> sub-block zeroing if the associated range is unaligned and the mapping
> is either unwritten or new (i.e. newly allocated for this write). So as
> you note above, there is no such zeroing for a pre-existing written
> block within EOF. From that, it seems reasonable to me that in principle
> the filesystem could check for these conditions in the higher layer and
> further restrict usage of the exclusive lock. That said, we'd probably
> have to rework the above code to acquire the shared lock first,
> read/check the extent state for the start/end blocks of the I/O and then
> cycle out to the exclusive lock in the cases where it is required. It's
> not immediately clear to me if we'd still want to set the wait flag in
> those unaligned-but-no-zeroing cases. Perhaps somebody who knows the dio
> code a bit better can chime in further on all of this..
>
>

Thanks. I'll try to convince someone to attempt to do this.


Meanwhile we'll try using -b size=1024. I have hopes that the 
extent-based nature of the filesystem will not cause this to increase 
overhead too much.


