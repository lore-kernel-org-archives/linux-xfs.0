Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71FD57F63
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 15:48:12 -0500 (CDT)
Message-ID: <5345B209.5040906@sgi.com>
Date: Wed, 09 Apr 2014 15:48:09 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: fix random pread/pwrite to honor offset
References: <53459C4E.9030902@sandeen.net>
In-Reply-To: <53459C4E.9030902@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/09/14 14:15, Eric Sandeen wrote:
> xfs_io's pread & pwrite claim to support a random IO mode
> where it will do random IOs between offset & offset+len.
>
> However, offset was ignored, and we did the IOs between 0
> and len instead.
>
> Clang caught this by pointing out that the calculated/normalized
> "offset" variable was never read.
>
> (NB: If the range is larger than RAND_MAX, these functions don't
> work, but that's always been true, so I'll leave it for another
> day...)
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> I haven't tested this w/ xfstests but I don't see anyone who calls
> pread/pwrite with "-R" (and it's not documented in the manpage!)
>
> diff --git a/io/pread.c b/io/pread.c
> index a42baed..465c22b 100644
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -246,7 +246,7 @@ read_random(

offset can be the end of file offset. Do we care that the read (/write)
could start or end past the end of file?

>
>   	*total = 0;
>   	while (count > 0) {
> -		off = ((random() % range) / buffersize) * buffersize;
> +		off = ((offset + (random() % range)) / buffersize) * buffersize;
>   		bytes = do_pread(fd, off, buffersize, buffersize);
>   		if (bytes == 0)
>   			break;

Looks like this was introduced in:
commit 8fb2237e65555ff540e8b6108ffccfffefe239ac
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Nov 11 14:25:18 2005 +0000

Provide further debugging options and tweaks for analysing the 
read/write paths.
Merge of master-melb:xfs-cmds:24372a by kenmcd.

  ---

If it was broken for 8.5 years, I think it could be removed.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
