Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:49718 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756494AbdIRRwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 13:52:33 -0400
Received: by mail-ua0-f169.google.com with SMTP id 97so778974uai.6
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 10:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170914211519.aieumj734uazwlmj@thunk.org>
References: <20170914140619.29826-1-agruenba@redhat.com> <20170914211519.aieumj734uazwlmj@thunk.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 18 Sep 2017 19:52:32 +0200
Message-ID: <CAHc6FU6X29Pr6gA+d0L3WuoCY1XwNjQ9aTYUuAp84-O-ff_xGQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 14, 2017 at 11:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 14, 2017 at 04:06:19PM +0200, Andreas Gruenbacher wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> Here we go, after another round of xfstests.
>>
>> The next question, since it touches vfs infrastructure, is which tree
>> this patch queue should be merged through.  Al?
>
> Discussions with Darrick before he went on vacation/honeymoon was that
> up until now changes to fs/iomap.c had been going through XFS, but
> since these changes didn't affect XFS, and the rest of the patch
> series touches ext4 and ext4 functionality, that he was OK with
> running this patch series through the ext4 tree.

That sure works for me.

Andreas
