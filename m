Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53NJUvY201555 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 18:19:31 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95DDE121102A
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 16:19:40 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id 4YOjIooJFqWjvZBC for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 16:19:40 -0700 (PDT)
Date: Wed, 3 Jun 2009 19:19:39 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH, RFC] xfstests: random fallocate calls in fsx
Message-ID: <20090603231939.GA9167@josefsipek.net>
References: <4A0B420E.3070908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A0B420E.3070908@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Good idea.

On Wed, May 13, 2009 at 04:56:30PM -0500, Eric Sandeen wrote:
> Seems to work for me.  Any comments/suggestions?
> 
> I can probably make it fall back to the xfs ioctl if fallocate
> isn't supported, if strongly desired.

Is the ioctl going away anytime soon? If not, it might be worth having fsx
use _both_ if possible, or just the ioctl if fallocate doesn't seem to be
available.

> @@ -770,6 +788,64 @@ dotruncate(unsigned size)
>  	}
>  }
>  
> +#ifdef FALLOCATE
> +/* fallocate is basically a no-op unless extending, then a lot like a truncate */
> +void
> +dofallocate(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int keep_size;
> +
> +        if (length == 0) {
> +                if (!quiet && testcalls > simulatedopcount)
> +                        prt("skipping zero length fallocate\n");
> +                log4(OP_SKIPPED, OP_FALLOCATE, offset, length);
> +                return;
> +        }
> +
> +	keep_size = random() % 2;
> +
> +	end_offset = keep_size ? 0 : offset + length;

I prefer seeing explicit ( ) in this case.

...
-- 
Reality is merely an illusion, albeit a very persistent one.
		- Albert Einstein

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
