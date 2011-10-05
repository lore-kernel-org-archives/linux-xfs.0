Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95DLCIU116880 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 08:21:12 -0500
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS
	operations
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
	<1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
Date: Wed, 5 Oct 2011 08:20:40 -0500
Message-ID: <1317820840.2226.12.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sun, 2011-09-18 at 18:54 +0400, Dmitry Monakhov wrote:
> Add two new operations:
> - getattr: ioctl(fd, EXT2_IOC_GETFLAGS, &fl)
> - setattr: ioctl(fd, EXT2_IOC_SETFLAGS, &random_flags)
> By default IOC_SET_SETFLAGS has zero probability because
> it may produce inodes with APPEND or IMMUTABLE flags which
> are not deletable by default. Let's assumes that one who
> enable it knows how to delete such inodes.
> For example like follows:
> find $TEST_PATH -exec chattr -i -a {} \;
> rm -rf $TEST_PATH
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

I have a question below.  I think this is probably
a good addition, though it should be made so it
works for more than EXTx.

If I understand the way it would be used, this will
simply be another operation that gets randomly performed
by fsstress while it operates, right?

I have not done any testing with this yet.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> @@ -1729,6 +1738,58 @@ setxattr_f(int opno, long r)
>  }
>  
>  void
> +getattr_f(int opno, long r)
> +{
> +#ifdef HAVE_EXT2_INCLUDE
> +	int		fd;
> +	int		e;
> +	pathname_t	f;
> +	uint		fl;
> +	int		v;
> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
> +		append_pathname(&f, ".");

I don't understand the purpose of appending a "." to the
end of the path.  Do you intend to just use "." if
no other file matches?  (That may not be a good thing to
do--it might not be testing the intended target.)
  
Or are you intending to append "/." so for a directory
its "." link gets used in the open?  If so that's not
what this does (it simply makes "a/b/x" become "a/b/x.").

Same comments apply to setattr_f().

> +	fd = open_path(&f, O_RDWR);
> +	e = fd < 0 ? errno : 0;
> +	check_cwd();
> +
> +	e = ioctl(fd, EXT2_IOC_GETFLAGS, &fl);
> +	if (v)
> +		printf("%d/%d: getattr %s %u %d\n", procid, opno, f.path, fl, e);
> +	free_pathname(&f);
> +	close(fd);
> +#endif
> +}
> +
> +void
> +setattr_f(int opno, long r)
> +{


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
