Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E15BB7F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 05:34:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4ED3304051
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 03:34:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 6J6vV9fHo3VSyWwD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 03:34:44 -0700 (PDT)
Date: Sun, 4 May 2014 03:34:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: xfs_copy: use exit() to replace killall()
Message-ID: <20140504103443.GA25154@infradead.org>
References: <1399189455-29890-1-git-send-email-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399189455-29890-1-git-send-email-junxiao.bi@oracle.com>
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
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: joe.jin@oracle.com, xfs@oss.sgi.com

On Sun, May 04, 2014 at 03:44:15PM +0800, Junxiao Bi wrote:
> Sending a SIGKILL signal to child thread will terminate the whole process,
> xfs_copy will return an error value 137. This cause confuse for script to
> know whether the copy successes.
> 
> Calling exit() in main thread can terminate the whole process and return the
> right value.

Looks generally good to me, but the changelog should have some more
details:

>  	if (buf->length > buf->size)  {
>  		do_warn(_("assert error:  buf->length = %d, buf->size = %d\n"),
>  			buf->length, buf->size);
> -		killall();
> -		abort();
> +		exit(1);

You're replacing the killall with an exit here and removing the abort()
call.  I can see arguments for keeping either the abort or exit, but please
document why you did in the patch description.  If the exit was
intentional should we return a different value for an assertation
failure?

> -	killall();
> -	pthread_exit(NULL);
> -	/*NOTREACHED*/
> -	return 0;
> +
> +	exit(0);

You're also replacing the return 0 from main with an exit which
seem superflous.

Btw, I think the reason for this cruft is that xfs_copy was originally
written using the IRIX sproc interface, and the port to pthreads didn't
remove this gem:

http://marc.info/?l=linux-xfs&m=99535721110020&w=2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
