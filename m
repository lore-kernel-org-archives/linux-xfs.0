Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15NimM1085523 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 17:44:48 -0600
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) by cuda.sgi.com
	with ESMTP id 2qEFNwUrPI3wwy5C for <xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 15:44:46 -0800 (PST)
Message-ID: <4F2F146B.6050003@msgid.tls.msk.ru>
Date: Mon, 06 Feb 2012 03:44:43 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com> <4F2D90B6.4070008@redhat.com>
In-Reply-To: <4F2D90B6.4070008@redhat.com>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 05.02.2012 00:10, Eric Sandeen wrote:
[]

Just a very quick look:

>  * sparsify - utility to punch out blocks of 0s in a file
> int main(int argc, char **argv)
> {
[]
> 	if (optind == argc) {
> 		printf("Error: no filename specified\n");
> 		usage();
> 	}
> 
> 	fname = argv[optind++];

There's no handling of the case when there are more than one file
specified on the command line.


> 	/*
> 	 * Normalize to blocksize-aligned range:
> 	 * round start down, round end up - get all blocks including the range specified
> 	 */
> 
> 	punch_range_start = round_down(punch_range_start, blocksize);
> 	punch_range_end = round_up(punch_range_end, blocksize);
> 	min_hole = round_up(min_hole, blocksize);
> 	if (!min_hole)
> 		min_hole = blocksize;

I think this deserves some bold warning if punch_range_start
or punch_hole_end is not a multiple of blocksize.

[]
> 	/*
> 	 * Read through the file, finding block-aligned regions of 0s.
> 	 * If the region is at least min_hole, punch it out.
> 	 * This should be starting at a block-aligned offset
> 	 */
> 
> 	while ((ret = read(fd, readbuf, min_hole)) > 0) {
> 
> 		if (!memcmp(readbuf, zerobuf, min_hole)) {

Now this is interesting.  Can ret be < min_hole?  Can a read
in a middle of a file be shorter than specified?

How it will work together with some other operation being done
at the same file -- ftruncate anyone?

Thanks!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
