Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B0EF7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 11:32:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 186C6304070
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 09:32:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OAmWlmQ1XkXWoSEp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Sep 2016 09:32:35 -0700 (PDT)
Date: Tue, 13 Sep 2016 09:32:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs_repair: update the manual content about
	xfs_repair exit status
Message-ID: <20160913163226.GE9314@birch.djwong.org>
References: <1473782076-9137-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1473782076-9137-1-git-send-email-zlang@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 11:54:36PM +0800, Zorro Lang wrote:
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
>  will return a status of 1 if filesystem corruption was detected and
>  0 if no filesystem corruption was detected.
> +.TP
>  .B xfs_repair
> -run without the \-n option will always return a status code of 0.
> +run without the \-n option will return a status code of 2 if it finds a
> +filesystem log which needs to be replayed(by a mount/umount cycle) or
> +cleared(by -L option), 1 if a runtime error is encountered, and 0 in all
> +other cases, whether or not filesystem corruption was detected.

So... I'd rather the documentation about the return code reflect the
status of the filesystem -- 2 means "unclean log, replay it or zap it",
1 means "errors encountered, fs may not be correct", and 0 /should/ mean
"fs is correct".

OTOH I don't know for sure that xfs_repair always cleans up the fs on
the first try.  From my fuzzing experiments a few years ago this seems
to be the case nearly all the time (unlike e2fsck) but not 100%.  ISTR
asking Dave about this, and I think he said that the FS should be clean
if repair returns 0.  But I'll let him reiterate that if it's true;
don't trust my crummy memory, that's why I have filesystems. ;)

--D

>  .SH BUGS
>  The filesystem to be checked and repaired must have been
>  unmounted cleanly using normal system administration procedures
> -- 
> 2.7.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
