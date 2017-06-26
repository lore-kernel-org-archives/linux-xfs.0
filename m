Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:35644 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdFZKva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 06:51:30 -0400
Received: by mail-ua0-f180.google.com with SMTP id j53so64965363uaa.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 03:51:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170626104156.GA23149@infradead.org>
References: <1498177173-30798-1-git-send-email-agruenba@redhat.com> <20170626104156.GA23149@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 26 Jun 2017 12:51:29 +0200
Message-ID: <CAHc6FU4FdeceDTZHDN4NtH2oA2Yq-XcmAceVaSJY3y2g40-w0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] vfs: Add page_cache_seek_hole_data helper
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

On Mon, Jun 26, 2017 at 12:41 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jun 23, 2017 at 02:19:31AM +0200, Andreas Gruenbacher wrote:
>> Both ext4 and xfs implement seeking for the next hole or piece of data
>> in unwritten extents by scanning the page cache, and both versions share
>> the same bug when iterating the buffers of a page: the start offset into
>> the page isn't taken into account, so when a page fits more than two
>> filesystem blocks, things will go wrong.  For example, on a filesystem
>> with a block size of 1k, the following command will fail:
>>
>>   xfs_io -f -c "falloc 0 4k" \
>>             -c "pwrite 1k 1k" \
>>             -c "pwrite 3k 1k" \
>>             -c "seek -a -r 0" foo
>
> Can you wire this up for xfstests, please?

I did:

  https://marc.info/?l=fstests&m=149817668119033

Andreas
