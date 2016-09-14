Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50057 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755671AbcINRTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 13:19:00 -0400
Date: Wed, 14 Sep 2016 10:18:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs_repair: update the manual content about
 xfs_repair exit status
Message-ID: <20160914171845.GF9314@birch.djwong.org>
References: <1473872451-17249-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473872451-17249-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 15, 2016 at 01:00:51AM +0800, Zorro Lang wrote:
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
> V3 add more description for return status 1, suggest the user to run
> xfs_repair again if it return 1.
> 
> Thanks,
> Zorro
> 
>  man/man8/xfs_repair.8 | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> index 1b4d9e3..314f2c2 100644
> --- a/man/man8/xfs_repair.8
> +++ b/man/man8/xfs_repair.8
> @@ -504,12 +504,18 @@ that is known to be free. The entry is therefore invalid and is deleted.
>  This message refers to a large directory.
>  If the directory were small, the message would read "junking entry ...".
>  .SH EXIT STATUS
> +.TP
>  .B xfs_repair \-n
> -(no modify node)
> +(no modify mode)
>  will return a status of 1 if filesystem corruption was detected and
>  0 if no filesystem corruption was detected.
> +.TP
>  .B xfs_repair
> -run without the \-n option will always return a status code of 0.
> +run without the \-n option will return a status code of 2 if it finds a
> +filesystem log which needs to be replayed (by a mount/umount cycle) or
> +cleared (by -L option), 1 if a runtime error is encountered, filesystem
> +may be even more broken than before, so repair needs to be run again,
> +and 0 in all other cases, whether or not filesystem corruption was detected.

Hm.  I never did manage to reply with any suggested wording of my own
yesterday.  I dislike the runon sentence that this is becoming.  How
about this?

"xfs_repair -n (no modify mode) will return a status code of 1 if it is
unable to show that the filesystem is clean, whether due to corruption
or runtime errors.  A status code of 0 is returned if the filesystem
was clean.

"xfs_repair run without the -n option will return one of three status
codes.  If the filesystem log is dirty, a status code of 2 will be
returned.  The dirty log must be replayed by a mount/umount cycle or
cleared with the -L option.  If xfs_repair was unable to fix corruption
or encountered a runtime error, a status code of 1 will be returned.
A status code of 0 is returned if the filesystem is now clean."

--D

>  .SH BUGS
>  The filesystem to be checked and repaired must have been
>  unmounted cleanly using normal system administration procedures
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
