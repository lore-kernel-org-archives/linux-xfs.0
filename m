Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D20C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Dec 2020 15:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0873720829
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Dec 2020 15:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387995AbgL1P6U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Dec 2020 10:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393238AbgL1P6N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Dec 2020 10:58:13 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01463C061794
        for <linux-xfs@vger.kernel.org>; Mon, 28 Dec 2020 07:57:33 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id w1so14676407ejf.11
        for <linux-xfs@vger.kernel.org>; Mon, 28 Dec 2020 07:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:organization:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=NcRCWnnwE+H8MivsnAWQfYI0nUGtIR3xTMp18e05J5c=;
        b=OKJGGN2ydibsGxBwH1XdQlK60B0Mh6dF1+NVG342iPWFdwqFXJY88y0N8u2L3iEdtS
         +3khlAbDL0DvVFHmaOHKsV1qxwSPAkSIM0kXqqtb4u6kPUkmMw5FTP22XYeZJ5XD4v0e
         3MHhyfgGdZEYHrL3TZ+rhyI+KLldIXNf5yDEuC8mVbVZocBlcGjqYRBsYmvYosWs2rCu
         DwuNHpmH4+y+EEh4D8WmzvXRNc2yMI7MgVyTfuDvG4gcmtKFA3IDiTLtHJRVbveOIK9z
         D/YDLqDUXKHqLpwbgR4avGSQqTYEoDGOEPTmxNn0gpm2qT7hotCrlifto2yuWmgLetr2
         KM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:organization:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=NcRCWnnwE+H8MivsnAWQfYI0nUGtIR3xTMp18e05J5c=;
        b=Qc3X1/p+4Lzquofrzq2q5BSZ+Qb6lE55Kz05vG56c7IpDN6UJXJEgdwwQTbEGhdqIW
         WgUzY4a3tDlSV4jKq9mEVz9pc9xByAjVD7Hg9xRLKJLziNml79PwYxVjeKJhyNY3Je5s
         nce57ga1VPPspEd5CCRcxVx6oc8B0bybIbNG7Evi2pePyF04Vx73vpfCzCfPaDAxdsip
         k9+1YbQJaUmKA5TF0M9sYIuBjWoGwMgsCynGMJm7nDA4AZfbzkZXmUIEXzzODIyW2UqP
         x8jPFmCJZ4G3elJIA18yjtPEcxBNPukUZfg1lLIgSTCkC6cRn01ujWSnoRr1sdZ9Ssey
         vu/Q==
X-Gm-Message-State: AOAM5318YqKWpA75q/9iA8eyv4m4so773QtJ7RhYU3sAINq+MWdEJwIR
        spoH0PsO9Yws1pV5EdHkISfOgQ==
X-Google-Smtp-Source: ABdhPJx9iuJoameYazzbL/Z+MEtaiB98ERBGvogOGJPuW5lzGDj3wgMJjP7FmvuaUEkWbyuv5PjaTA==
X-Received: by 2002:a17:907:2071:: with SMTP id qp17mr42570476ejb.110.1609171051672;
        Mon, 28 Dec 2020 07:57:31 -0800 (PST)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id c16sm11250598ejk.91.2020.12.28.07.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 07:57:30 -0800 (PST)
To:     linux-xfs@vger.kernel.org
From:   Avi Kivity <avi@scylladb.com>
Subject: Disk aligned (but not block aligned) DIO write woes
Organization: ScyllaDB
Message-ID: <20ce6a14-94cf-c8ef-8219-7a051fb6e66a@scylladb.com>
Date:   Mon, 28 Dec 2020 17:57:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I observe that XFS takes an exclusive lock for DIO writes that are not 
block aligned:


xfs_file_dio_aio_write(

{

...

        /*
          * Don't take the exclusive iolock here unless the I/O is 
unaligned to
          * the file system block size.  We don't need to consider the EOF
          * extension case here because xfs_file_aio_write_checks() will 
relock
          * the inode as necessary for EOF zeroing cases and fill out 
the new
          * inode size as appropriate.
          */
         if ((iocb->ki_pos & mp->m_blockmask) ||
             ((iocb->ki_pos + count) & mp->m_blockmask)) {
                 unaligned_io = 1;

                 /*
                  * We can't properly handle unaligned direct I/O to reflink
                  * files yet, as we can't unshare a partial block.
                  */
                 if (xfs_is_cow_inode(ip)) {
                         trace_xfs_reflink_bounce_dio_write(ip, 
iocb->ki_pos, count);
                         return -ENOTBLK;
                 }
                 iolock = XFS_IOLOCK_EXCL;
         } else {
                 iolock = XFS_IOLOCK_SHARED;
         }


I also see that such writes cause io_submit to block, even if they hit a 
written extent (and are also not size-changing, by implication) and 
therefore do not require a metadata write. Probably due to "|| 
unaligned_io" in


         ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
                            &xfs_dio_write_ops,
                            is_sync_kiocb(iocb) || unaligned_io);


Can this be relaxed to allow writes to written extents to proceed in 
parallel? I explain the motivation below.


My thinking (from a position of blissful ignorance) is that if the 
extent is already written, then no metadata changes and block zeroing 
are needed. If we can detect that favorable conditions exists (perhaps 
with the extra constraint that the mapping be already cached), then we 
can handle this particular case asynchronously.


My motivation is a database commit log. NVMe drives can serve small 
writes with ridiculously low latency - around 20 microseconds. Let's say 
a commitlog entry is around 100 bytes; we fill a 4k block with 41 
entries. To achieve that in 20 microseconds requires 2 million 
records/sec. Even if we add artificial delay and commit every 1ms, 
filling this 4k block require 41,000 commits/sec. If the entry write 
rate is lower, then we will be forced to pad the rest of the block. This 
increases the write amplification, impacting other activities using the 
disk (such as reads).


41,000 commits/sec may not sound like much, but in a thread-per-core 
design (where each core commits independently) this translates to 
millions of commits per second for the entire machine. If the real 
throughput is below that, then we are forced to either increase the 
latency to collect more writes into a full block, or we have to tolerate 
the increased write amplification.


