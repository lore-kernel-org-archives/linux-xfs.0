Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06D227F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:15:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD963304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:15:44 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	86QcfdCbakrxtTk7 for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 12:15:42 -0800 (PST)
Date: Wed, 26 Feb 2014 07:15:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfstests: Add fallocate zero range operation to
	fsstress
Message-ID: <20140225201539.GZ13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355728-12056-2-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 08:15:24PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

commit message?

> @@ -2561,6 +2567,62 @@ punch_f(int opno, long r)
>  }
>  
>  void
> +zero_f(int opno, long r)
> +{
> +#ifdef FALLOCATE
> +	int		e;
> +	pathname_t	f;
> +	int		fd;
> +	__int64_t	lr;
> +	off64_t		off;
> +	off64_t		len;
> +	struct stat64	stb;
> +	int		v;
> +	char		st[1024];

[snip]

We now have 3 copies of this fallocate code, the only difference
between the copies being the mode:

> +	int mode = FALLOC_FL_ZERO_RANGE;

passed into the fallocate function. Please factor.

> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +		if (v)
> +			printf("%d/%d: zero range - no filename\n", procid, opno);
> +		free_pathname(&f);
> +		return;
> +	}
> +	fd = open_path(&f, O_RDWR);
> +	e = fd < 0 ? errno : 0;

while you are there, get rid of the ternary operations and just use

	if (fd < 0)
		e = errno;

> +	check_cwd();

This can go after we've checked for an error on open, which avoids
needing to save the errno....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
