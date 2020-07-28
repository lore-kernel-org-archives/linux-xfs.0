Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E534C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328E12078E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VUybRPyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgG1PfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 11:35:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58324 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730930AbgG1PfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 11:35:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SFMQpP070606;
        Tue, 28 Jul 2020 15:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=GrLnXWOKNPBvf5rKJ954gJDLwR7i7lgMI8Rs35QRT6M=;
 b=VUybRPyb7RzeVeRQ9cqEeZSQihhegX9sssuWxDasO1uxzuuj5cORi5MMnfBfimuflisf
 XOsMzTHsuwMQ25skBNu18Ii34PsQENYsyoaHogHG72EzmnnD4UgsQsDVJyXt3L0xqiwt
 ySS7nrUQOTwFSdVvyJkXk5S9uyPQrc8lDYz+F0YquzFE1l49lGcRG1LxbkiDhU0vP7UJ
 jqeJ4tjrQgaEd2isB87OQ6i+nk1dm/ePoZHgbxwtJ+e45W9LZRIRHPLv9c4u0U+g9KqT
 whXmWgVlrxPbXaJmqUPVAk+ulvgQmClRh+aObVWko5X4h/8H26MeOpv+MicFePGX4/le Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32hu1jg8q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 15:34:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SFIafY154357;
        Tue, 28 Jul 2020 15:34:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32hu5t45my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 15:34:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06SFYsE5029415;
        Tue, 28 Jul 2020 15:34:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 08:34:54 -0700
Date:   Tue, 28 Jul 2020 08:34:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zhengyuan Liu <liuzhengyuang521@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200728153453.GC3151642@magnolia>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=1 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[add hch and willy to cc]

On Tue, Jul 28, 2020 at 07:34:39PM +0800, Zhengyuan Liu wrote:
> Hi all,
> 
> When doing random buffer write testing I found the bandwidth on EXT4 is much
> better than XFS under the same environment.
> The test case ,test result and test environment is as follows:
> Test case:
> fio --ioengine=sync --rw=randwrite --iodepth=64 --size=4G --name=test
> --filename=/mnt/testfile --bs=4k
> Before doing fio, use dd (if=/dev/zero of=/mnt/testfile bs=1M
> count=4096) to warm-up the file in the page cache.
> 
> Test result (bandwidth):
>          ext4                   xfs
>        ~300MB/s       ~120MB/s
> 
> Test environment:
>     Platform:  arm64
>     Kernel:  v5.7
>     PAGESIZE:  64K
>     Memtotal:  16G
>     Storage: sata ssd(Max bandwidth about 350MB/s)
>     FS block size: 4K
> 
> The  fio "Test result" shows that EXT4 has more than 2x bandwidth compared to
> XFS, but iostat shows the transfer speed of XFS to SSD is about 300MB/s too.
> So I debt XFS writing back many non-dirty blocks to SSD while  writing back
> dirty pages. I tried to read the core writeback code of both
> filesystem and found
> XFS will write back blocks which is uptodate (seeing iomap_writepage_map()),

Ahhh, right, because iomap tracks uptodate separately for each block in
the page, but only tracks dirty status for the whole page.  Hence if you
dirty one byte in the 64k page, xfs will write all 64k even though we
could get away writing 4k like ext4 does.

Hey Christoph & Matthew: If you're already thinking about changing
struct iomap_page, should we add the ability to track per-block dirty
state to reduce the write amplification that Zhengyuan is asking about?

I'm guessing that between willy's THP series, Dave's iomap chunks
series, and whatever Christoph may or may not be writing, at least one
of you might have already implemented this? :)

--D

> while EXT4 writes back blocks which must be dirty (seeing
> ext4_bio_write_page() ) . XFS had turned from buffer head to iomap since
> V4.8, there is only a bitmap in iomap to track block's uptodate
> status, no 'dirty'
> concept was found, my question is if this is the reason why XFS writes many
> extra blocks to SSD when doing random buffer write? If it is, then why don't we
> track the dirty status of blocks in XFS?
> 
> With the questions in brain, I start digging into XFS's history, and found a
> annotations in V2.6.12:
>         /*
>          * Calling this without startio set means we are being asked
> to make a dirty
>          * page ready for freeing it's buffers.  When called with
> startio set then
>          * we are coming from writepage.
>          * When called with startio set it is important that we write the WHOLE
>          * page if possible.
>          * The bh->b_state's cannot know if any of the blocks or which block for
>          * that matter are dirty due to mmap writes, and therefore bh
> uptodate is
>          * only vaild if the page itself isn't completely uptodate.  Some layers
>          * may clear the page dirty flag prior to calling write page, under the
>          * assumption the entire page will be written out; by not
> writing out the
>          * whole page the page can be reused before all valid dirty data is
>          * written out.  Note: in the case of a page that has been dirty'd by
>          * mapwrite and but partially setup by block_prepare_write the
>          * bh->b_states's will not agree and only ones setup by BPW/BCW will
>          * have valid state, thus the whole page must be written out thing.
>          */
>         STATIC int　xfs_page_state_convert()
> 
> From above annotations, It seems this has something to do with mmap, but I
> can't get the point , so I turn to you guys to get the help. Anyway, I don't
> think there is such a difference about random write between XFS and EXT4.
> 
> Any reply would be appreciative, Thanks in advance.
