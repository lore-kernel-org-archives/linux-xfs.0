Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C2217F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 09:37:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1ABE1AC004
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 07:37:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eRpZzG8Er6I8ABBI for
	<xfs@oss.sgi.com>; Tue, 04 Mar 2014 07:36:58 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s24Favhc026798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2014 10:36:58 -0500
Date: Tue, 4 Mar 2014 10:36:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfstests: memset proper length in resvtest.c
Message-ID: <20140304153655.GC51235@bfoster.bfoster>
References: <531563D8.2070007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531563D8.2070007@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2014 at 11:25:44PM -0600, Eric Sandeen wrote:
> sizeof(pointer) is not very relevant; sizeof(*pointer)
> is a bit more so.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/src/resvtest.c b/src/resvtest.c
> index 037d9ea..a07f503 100644
> --- a/src/resvtest.c
> +++ b/src/resvtest.c
> @@ -73,7 +73,7 @@ main(int argc, char **argv)
>  		perror("open");
>  		exit(1);
>  	}
> -	memset(writebuffer, 'A', sizeof(writebuffer));
> +	memset(writebuffer, 'A', sizeof(*writebuffer));
>

It's not clear to me how much this is intending to write/read. If the
entire buffer, we should probably use the buffer size.
sizeof(*writebuffer) is a single byte, no?

Also, there are other instances of the same thing throughout this file.
I think they need to be consistent, in any event, for the test to work.

Brian

>  	unlink(filename);
>  	writefd = open(filename, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
