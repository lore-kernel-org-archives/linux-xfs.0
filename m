Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44377 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390081AbfFKEyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 00:54:08 -0400
MIME-Version: 1.0
References: <20190610173657.4655-1-amir73il@gmail.com> <CAH2r5mtQObwvdtaNr31fd-wDpjrZi5YLZ+ZcaW0ECVvTR-ByXQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtQObwvdtaNr31fd-wDpjrZi5YLZ+ZcaW0ECVvTR-ByXQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 11 Jun 2019 07:53:55 +0300
Message-ID: <CAOQ4uxhS6153+bo+JKen7E++1cNquGG2Eir1uc37UEcGFyck5w@mail.gmail.com>
Subject: Re: [PATCH] cifs: copy_file_range needs to strip setuid bits and
 update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steve French <smfrench@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>

On Mon, Jun 10, 2019 at 11:39 PM Steve French <smfrench@gmail.com> wrote:
>
> Looks good in my testing so far - but also want to do a little more
> testing with the copy_file_range xfstest cases because your patches
> fixed one additional test (not cross mount copy) so we can understand
> why it fixed that test case.

I know which of my patches fixed generic/43[01].
It was 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
More specifically this code:

        /* Shorten the copy to EOF */
        size_in = i_size_read(inode_in);
        if (pos_in >= size_in)
                count = 0;
        else
                count = min(count, size_in - (uint64_t)pos_in);

If CIFS sends an out of range value of copy length to Windows server,
server replies with an error. That is inconsistent with the semantics of
copy_file_range(2) syscall, which expects "short copy", hence need
to shorten length before passing on to server.

I verified with Aurelien that this is the case and I was under the impression
that he was going to create a similar local fix to cifs code for stable.
I thought he told you, so I forgot to report back myself.

Thanks,
Amir.
