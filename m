Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56910 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753312AbcIMQRs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Sep 2016 12:17:48 -0400
Subject: Re: [PATCH v2] xfs_repair: update the manual content about xfs_repair
 exit status
References: <1473782076-9137-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <df581259-c96e-879d-4406-d909cc3a81d3@sandeen.net>
Date: Tue, 13 Sep 2016 11:17:46 -0500
MIME-Version: 1.0
In-Reply-To: <1473782076-9137-1-git-send-email-zlang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

On 9/13/16 10:54 AM, Zorro Lang wrote:
> The man 8 xfs_repair said "xfs_repair run without the -n option will
> always return a status code of 0". That's not correct.
> 
> xfs_repair will return 2 if it finds a fs log which needs to be
> replayed or cleared, 1 if runtime error is encountered, and 0 for
> all other cases.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> V2 patch did below things:
>  - change the description for xfs_repair
>  - remove the description for "xfs_repair -L"
> 
> Thanks,
> Zorro
> 
>  man/man8/xfs_repair.8 | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> index 1b4d9e3..e45fd90 100644
> --- a/man/man8/xfs_repair.8
> +++ b/man/man8/xfs_repair.8
> @@ -504,12 +504,17 @@ that is known to be free. The entry is therefore invalid and is deleted.
>  This message refers to a large directory.
>  If the directory were small, the message would read "junking entry ...".
>  .SH EXIT STATUS
> +.TP
>  .B xfs_repair \-n
>  (no modify node)

s/node/mode/, maybe Dave can fix that on commit.  Sorry I missed it the first time.

>  will return a status of 1 if filesystem corruption was detected and
>  0 if no filesystem corruption was detected.
> +.TP
>  .B xfs_repair
> -run without the \-n option will always return a status code of 0.
> +run without the \-n option will return a status code of 2 if it finds a
> +filesystem log which needs to be replayed(by a mount/umount cycle) or

space after replayed

> +cleared(by -L option), 1 if a runtime error is encountered, and 0 in all

space after cleared

> +other cases, whether or not filesystem corruption was detected.

Yep, I think this is ok with the small fixes above.  I hope the "whether or
not" is not more confusing, but I think it probably clarifies.

Dave, if you don't mind the small fixups on the way in,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric


>  .SH BUGS
>  The filesystem to be checked and repaired must have been
>  unmounted cleanly using normal system administration procedures
> 
