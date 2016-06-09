Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CE4F7CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 10:44:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D31748F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 08:44:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ijf5eFSfM4MyEfzT for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 08:44:53 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E51784A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 10:44:52 -0500 (CDT)
Subject: Re: [PATCH v2] mkfs: better error with incorrect b/s value suffix
	usage
References: <1465475195-19149-1-git-send-email-jtulak@redhat.com>
	<1465478861-8714-1-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c18cd9f0-29b7-5ad4-ef2e-fd3151202bdd@sandeen.net>
Date: Thu, 9 Jun 2016 10:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <1465478861-8714-1-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

On 6/9/16 8:27 AM, Jan Tulak wrote:
> If user writes a value using b or s suffix without explicitly stating the size
> of blocks or sectors, mkfs ends with a not helpful error about the value being
> too small. It happens because we read the physical geometry after all options
> are parsed.

It's probably worth putting an example of the current error in the commitlog,
i.e.:

# mkfs.xfs -dfile,name=fsfile,size=128m -l su=10b -b
Illegal value 10b for -l su option. value is too small
...


> So, tell the user exactly what is wrong with the input.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
> 
> While adding entries into the mkfs input test, I found this issue, though it
> may be only a documentation thing. When I give some option block/sector suffix
> without specifying explicitly its size (for example, -l su=10b without -b
> size=4096), I get an error that value 10b is too small.  Of course it is,
> because, at the time, mkfs did not read physical geometry yet, so blocksize is
> 0. And 10*0 = 0.
> 
> I think that this is not something we need to change, but it should be better
> documented. Maybe not manpage (where it can be overlooked if not written to
> every option using the size and it might be that it already is somewhere down
> there), but an error message should warn the user in case of using b or s
> suffix incorrectly.
> 
> I'm open to suggestions for a better solution, though.
> 
> UPDATE:
> Add { and } to fix a gcc warning about ambigious else branch.
> 
> Cheers,
> Jan
> ---
>  mkfs/xfs_mkfs.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ed7800f..455bf11 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3614,10 +3614,24 @@ cvtnum(
>  	if (sp[1] != '\0')
>  		return -1LL;
>  
> -	if (*sp == 'b')
> -		return i * blksize;
> -	if (*sp == 's')
> -		return i * sectsize;
> +	if (*sp == 'b') {
> +		if (!blksize) {
> +			fprintf(stderr,
> +_("Blocksize must be explicitly provided when using 'b' suffix.\n"));

I'd fix the warning text a little bit, because:

# mkfs.xfs -dfile,name=fsfile,size=128m -l su=10b -b size=4k
Blocksize must be explicitly provided when using 'b' suffix.

But I *did* provide it!  No fair! ;)

Perhaps:

+_("Blocksize must be specified prior to using the 'b' suffix.\n"));

and

+_("Sectorsize must be specified prior to using the 's' suffix.\n"));

?

(old mkfs said "blocksize not available yet." which is a bit cryptic
as well, but at least we clearly have the same behavior now, just
different messages.)

-Eric

> +			usage();
> +		} else {
> +			return i * blksize;
> +		}
> +	}
> +	if (*sp == 's') {
> +		if (!sectsize) {
> +			fprintf(stderr,
> +_("Sectorsize must be explicitly provided when using 's' suffix.\n"));
> +			usage();
> +		} else {
> +			return i * sectsize;
> +		}
> +	}
>  
>  	c = tolower(*sp);
>  	switch (c) {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
