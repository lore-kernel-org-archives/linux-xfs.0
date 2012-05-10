Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AKOA6W060530 for <xfs@oss.sgi.com>; Thu, 10 May 2012 15:24:10 -0500
Date: Thu, 10 May 2012 15:28:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity test
Message-ID: <20120510202810.GQ16881@sgi.com>
References: <4F410ABF.7070001@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F410ABF.7070001@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Feb 19, 2012 at 10:44:15PM +0800, Jeff Liu wrote:
> Introduce 279 for SEEK_DATA/SEEK_HOLE sanity tests.
> 
> Changes to v3:
> --------------
> * Redirect seek sanity test run log to 279.full.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

...

> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> new file mode 100644
> index 0000000..8f36dee
> --- /dev/null
> +++ b/src/seek_sanity_test.c
> @@ -0,0 +1,683 @@

...

> +static void get_file_system(int fd)
> +{
> +	struct statfs buf;
> +
> +	if (!fstatfs(fd, &buf))
> +		fprintf(stdout, "File system magic#: 0x%x\n", buf.f_type);

Hrm...

# make
Building include
Building lib
Building ltp
Building src
[DEP]
[CC]    seek_sanity_test
seek_sanity_test.c: In function 'get_file_system':
seek_sanity_test.c:46: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long int'
Building aio-dio-regress
Building m4

I'll fix that up for you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
