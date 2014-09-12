Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 998887F3F
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 11:22:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7912530406A
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 09:22:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XjBhZXmsZBDPYAEX for <xfs@oss.sgi.com>;
	Fri, 12 Sep 2014 09:22:09 -0700 (PDT)
Message-ID: <54131DB9.9010307@sandeen.net>
Date: Fri, 12 Sep 2014 11:22:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_io: add mremap command
References: <54111610.4080604@redhat.com> <5411171F.6010704@sandeen.net>
In-Reply-To: <5411171F.6010704@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 9/10/14 10:29 PM, Eric Sandeen wrote:
> This adds a simple mremap command to xfs_io.
>
> It does not take a start address; it uses the existing
> start address, so the sized passed will be the new total
> size of the mapping.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---


> +int
> +mremap_f(
> +    int        argc,
> +    char        **argv)
> +{
> +    ssize_t        new_length;
> +    void        *new_addr;
> +    int        flags = 0;
> +    int        c;
> +    size_t        blocksize, sectsize;
> +

Crap, and I just realized my mailer has started swapping tabs for spaces; my last several patches are probably corrupted this way.  Grumble.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
