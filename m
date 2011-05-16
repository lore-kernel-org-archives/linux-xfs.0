Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4G9JlEm126337 for <xfs@oss.sgi.com>; Mon, 16 May 2011 04:19:47 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5417CBB482
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 02:19:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vJpxBqtQO3i805MF for
	<xfs@oss.sgi.com>; Mon, 16 May 2011 02:19:46 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4G9Jjdt009332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 05:19:45 -0400
Date: Mon, 16 May 2011 11:19:44 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests 251: fix fitrim support test
In-Reply-To: <4DCDA43A.30502@redhat.com>
Message-ID: <alpine.LFD.2.00.1105161112290.3670@dhcp-27-109.brq.redhat.com>
References: <4DCDA43A.30502@redhat.com>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, 13 May 2011, Eric Sandeen wrote:

> On my ext4 filesystem, the simple "did fstrim work" test passes,
> because it asks to free all blocks in the first 10m of the fs,
> and those 10m are full of filesystem metadata.  Because no blocks
> are free, no blocks are trimmed, and we get success returned.
> 
> But then when the test runs I'm flooded with error messages, because
> it's a hard drive not an ssd...
> 
> So we need to step through the fs until we either free a block,
> or encounter an error.
> 
> I think this is ugly bash, if anyone has a better plan I'm all ears.
> 
> (also change FSTRIM to FITRIM in the failure message, it seems
> to be intended to print the ioctl name ...)

Hi Eric,

this is actually a filesystem bug found unintentionally by this test :)
and it is already fixed upstream 4143179218960a70d821a425e3c23ce44aa93dee
for ext4.. So I think we better leave it as it is, since this is
unwanted behaviour and should be detected.

What we should fix however, is when fstrim fails after successful fist
test, so the test exits and report failure, rather than printing tons of
error messages.

Thanks!
-Lukas

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/251 b/251
> index fa3d74a..5ab0a87 100755
> --- a/251
> +++ b/251
> @@ -73,7 +73,19 @@ _fail()
>  
>  _check_fstrim_support()
>  {
> -	$here/src/fstrim -l 10M $SCRATCH_MNT &> /dev/null
> +	# Go until error or until something gets trimmed
> +	step=1048576
> +	start=0
> +	retval=0
> +	nonetrimmed=1
> +
> +	while [ $retval -eq 0 ] && [ $nonetrimmed -ne 0 ]; do
> +		result=`$here/src/fstrim -v -s $start -l $step $SCRATCH_MNT 2>&1`
> +		retval=$?
> +		[ "${result:0:1}" -eq "0" ] && nonetrimmed=1
> +		start=$(( $start + $step ))
> +	done
> +	return $retval
>  }
>  
>  ##
> diff --git a/src/fstrim.c b/src/fstrim.c
> index f1f37ec..ad7fd6a 100644
> --- a/src/fstrim.c
> +++ b/src/fstrim.c
> @@ -236,7 +236,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	if (ioctl(fd, FITRIM, opts->range)) {
> -		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
> +		fprintf(stderr, "%s: FITRIM %s\n", program_name,
>  			strerror(errno));
>  		goto free_opts;
>  	}
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
