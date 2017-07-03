Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34404 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932069AbdGCPLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2017 11:11:46 -0400
Received: by mail-ua0-f178.google.com with SMTP id z22so111281514uah.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jul 2017 08:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170629185320.GA31467@lst.de>
References: <20170629135420.21357-1-hch@lst.de> <20170629184751.GH5874@birch.djwong.org>
 <20170629185320.GA31467@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 3 Jul 2017 17:11:44 +0200
Message-ID: <CAHc6FU55dj_VBwWq=s1tgbp6nnD333PfRO_hY98GbkzqYSyTiQ@mail.gmail.com>
Subject: Re: lseek SEEK_HOLE / SEEK_DATA fixes and switch to iomap V3.2-hch
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Jun 29, 2017 at 8:53 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Jun 29, 2017 at 11:47:51AM -0700, Darrick J. Wong wrote:
>> On Thu, Jun 29, 2017 at 06:54:15AM -0700, Christoph Hellwig wrote:
>> > Here is my take on all the current seek work.  It has my XFS quota changes
>>
>> I think the quota change patch fell out of this series, but I can grab
>> it from the previous iteration if it hasn't changed.
>
> It hasn't, please do.

We haven't heard from the ext4 folks on this yet: is everyone happy
with the vfs changes in this series at least? Can those be merged
through the xfs tree? That would allow us to move ahead on the gfs2
side.

Thanks,
Andreas
