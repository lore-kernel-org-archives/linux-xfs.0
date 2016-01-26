Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4625B7CA3
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 13:13:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7B198F8039
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 11:13:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w9EGrlQcQWXlDhz0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 11:13:14 -0800 (PST)
Date: Tue, 26 Jan 2016 14:13:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix endianness error when checking log block crc on
	big endian platforms
Message-ID: <20160126191310.GA54800@bfoster.bfoster>
References: <20160126180500.GA5852@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160126180500.GA5852@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <xfs@oss.sgi.com>

On Tue, Jan 26, 2016 at 10:05:00AM -0800, Darrick J. Wong wrote:
> Since the checksum function and the field are both __le32, don't
> perform endian conversion when comparing the two.  This fixes mount
> failures on ppc64 in 4.5-rc1.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

So somehow this first got munged in commit:

  b94fb2d1 xfs: refactor and open code log record crc check

... which was intended to only be a refactoring patch. Instead, it
removes the following line:

-       if (crc != rhead->h_crc) {

... and replaces it with:

+       if (crc != le32_to_cpu(rhead->h_crc)) {

No idea how that happened. Maybe I was just looking at the log message
code and had a thinko. Anyways, it was followed up with commit:

	6528250b xfs: support a crc verification only log record pass

... which adds the code you've fixed here and probably just copied the
busted check.

>  fs/xfs/xfs_log_recover.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ac80f39..52dd946 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4502,7 +4502,7 @@ xlog_recover_process(
>  	 * know precisely what failed.
>  	 */
>  	if (pass == XLOG_RECOVER_CRCPASS) {
> -		if (rhead->h_crc && crc != le32_to_cpu(rhead->h_crc))
> +		if (rhead->h_crc && crc != rhead->h_crc)
>  			return -EFSBADCRC;
>  		return 0;
>  	}

There's another check a few lines after this that is also broken, based
on the first commit referenced above. Do you want me to send a v2 patch
or would you like to? I'll run some ppc64 testing either way...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
