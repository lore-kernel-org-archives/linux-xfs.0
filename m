Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35233 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbfGARU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:20:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so359275wml.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 10:20:57 -0700 (PDT)
Subject: Re: [PATCH v6 0/4] vfs: make immutable files actually immutable
References: <156174687561.1557469.7505651950825460767.stgit@magnolia>
From: Boaz Harrosh <boaz@plexistor.com>
Message-ID: <72f01c73-a1eb-efde-58fa-7667221255c7@plexistor.com>
Date: Mon, 1 Jul 2019 20:20:51 +0300
MIME-Version: 1.0
In-Reply-To: <156174687561.1557469.7505651950825460767.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 28/06/2019 21:34, Darrick J. Wong wrote:
> Hi all,
> 
> The chattr(1) manpage has this to say about the immutable bit that
> system administrators can set on files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> Given the clause about how the file 'cannot be modified', it is
> surprising that programs holding writable file descriptors can continue
> to write to and truncate files after the immutable flag has been set,
> but they cannot call other things such as utimes, fallocate, unlink,
> link, setxattr, or reflink.
> 
> Since the immutable flag is only settable by administrators, resolve
> this inconsistent behavior in favor of the documented behavior -- once
> the flag is set, the file cannot be modified, period.  We presume that
> administrators must be trusted to know what they're doing, and that
> cutting off programs with writable fds will probably break them.
> 

This effort sounds very logical to me and sound. But are we allowed to
do it? IE: Is it not breaking ABI. I do agree previous ABI was evil but
are we allowed to break it?

I would not mind breaking it if %99.99 of the time the immutable bit
was actually set manually by a human administrator. But what if there
are automated systems that set it relying on the current behaviour?

For example I have a very distant and vague recollection of a massive
camera capture system, that was DMAing directly to file (splice). And setting
the immutable bit right away on start. Then once the capture is done
(capture file recycled) the file becomes immutable. Such program is now
broken. Who's fault is it?

I'm totally not sure and maybe you are right. But have you made a
survey of the majority of immutable uses, and are positive that
the guys are not broken after this change?

For me this is kind of scary. Yes I am known to be a SW coward ;-)

Thanks
Boaz
