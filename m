Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 241447CA4
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:23:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8BDA8F8033
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:23:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pvkRiqyOLKk6NBTa for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 09:23:12 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DEE934A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:23:11 -0500 (CDT)
Subject: Re: [PATCH] mkfs: test that -l su is a multiple of block size
References: <1465479700-14111-1-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5f6ee8a0-b704-5aa6-ff67-f7a5f6761732@sandeen.net>
Date: Thu, 9 Jun 2016 11:23:11 -0500
MIME-Version: 1.0
In-Reply-To: <1465479700-14111-1-git-send-email-jtulak@redhat.com>
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



On 6/9/16 8:41 AM, Jan Tulak wrote:
> lsunit was already tested, but lsu was not. So a thing like -l su=4097 was
> possible. This commit adds a check to fix it.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 455bf11..b9b50fe 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2875,6 +2875,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  		lsunit = dsunit;
>  	}
>  
> +	if (lsu) {
> +		if (lsu % blocksize != 0) {
> +			fprintf(stderr,
> +	_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
> +			lsu, blocksize);
> +			exit(1);
> +		}
> +	}
> +


Hm, I'm not quite seeing the behavior you say you're fixing;
you give the example of -l su=4097, but:

# mkfs/mkfs.xfs -f -dfile,name=fsfile,size=128m -l su=4097
Illegal value 4097 for -l su option. value is too small

So that's really not the relevant test case.


And in these cases it is caught and does fail:

# mkfs/mkfs.xfs -f -dfile,name=fsfile,size=128m -l su=63k
log stripe unit (64512) must be a multiple of the block size (4096)

# mkfs/mkfs.xfs -f -dfile,name=fsfile,size=128m -l su=64512
log stripe unit (64512) must be a multiple of the block size (4096)

But in this case it does not:

# mkfs/mkfs.xfs -f -dfile,name=fsfile,size=128m -l su=16385
meta-data=fsfile                 isize=512    agcount=4, agsize=8192 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=32768, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=552, version=2
         =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So what's going on here...?  It has something to do with how
calc_stripe_factors() operates, and when that happens vs. the checks.

lsu and lsunit are really specifying the same thing, just in different
units.

Your patch does fix it up, but I wonder if these tests are in the
wrong place; with your patch we essentially do this:

1) Parse lsu value
2) Convert lsu to lsunit
3) Check lsunit (it's ok)
4) Go back and check lsu (it's not ok)

It seems to me that we should recognize either lsu or lsunit
as the "one true value" and convert the other to it as soon as possible,
rather than carrying around both, and checking both at various times.

calc_stripe_factors() does do some validity checks; perhaps it should
check against blocksize multiples as well, so it's all in one place?
And a comment about what that function is doing (converting su's to
sunit's, really) would be helpful.

What do you think?

Your patch does resolve the problem but I think it adds a little more
confusion to already confusing code.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
