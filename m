Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35726 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755549AbeEaQYF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:24:05 -0400
Subject: Re: xfs_db and ASSERT fails dur type mismatch
References: <20180509114554.2slvfi3hqt4na6vy@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a34eb2d1-5f1c-eaf0-a892-f91061bb075b@sandeen.net>
Date: Thu, 31 May 2018 11:24:03 -0500
MIME-Version: 1.0
In-Reply-To: <20180509114554.2slvfi3hqt4na6vy@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, sandeen@redhat.com

On 5/9/18 6:45 AM, Carlos Maiolino wrote:
> Hey folks,
> 
> I've been thinking about different ways to fix those crashes on xfs_db due type
> mismatch, based on the previous discussion and a chat I had with Eric on irc.
> 
> After thinking a bit more about it, I do think using unknown header types adds
> unneeded extra complexity to the code, to achieve the same result as an extra
> check on print_flist_1().
> 
> Adding an unknown type, will require a change to all types affected by this
> issue. I am not sure if a single unknown type can be used for all metadata types
> which is affected by this, but I think it requires an unknown type for each of
> these metadata. Or at least an entry for an unknown header type (in case of of
> the known ones are not found).
> 
> While, the crash caused by unrecognized metadata when using these types, can be
> fixed by something like my original change.
> 
> I wrote a slightly different patch like this:

Ok, I'll merge this, with a proper commit log.

> diff --git a/db/print.c b/db/print.c
> index 0da36c27..f8a48281 100644
> --- a/db/print.c
> +++ b/db/print.c
> @@ -160,9 +160,10 @@ print_flist_1(
>                                          (f->flags & FLD_ARRAY) != 0);
>                                  if (neednl)
>                                          dbprintf("\n");
> -                       } else {
> -                               ASSERT(fa->arg & FTARG_OKEMPTY);
> +                       } else if (fa->arg & FTARG_OKEMPTY) {
>                                  dbprintf(_("(empty)\n"));
> +                       } else {
> +                               dbprintf(_("Unrecognized metadata or type mismatch\n"));
>                          }
>                  }
>                  free_strvec(pfx);
> 
> 
> This will still keep printing "(empty)" where it should be printed, or print out
> a hint that something went wrong.
> 
> I honestly think this the best solution for these crashes, what you guys think?
> 
> Cheers
> 
> 
