Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB1E07CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 11:09:18 -0500 (CDT)
Message-ID: <51546B33.6090608@sgi.com>
Date: Thu, 28 Mar 2013 11:09:23 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix common rc file path in new
References: <1364478683-6752-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1364478683-6752-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 03/28/2013 08:51 AM, Eryu Guan wrote:
> After the re-factor common.rc has been renamed to common/rc, fix the
> path in script new, otherwise ./new reports
>
> ./new: line 26: ./common.rc: No such file or directory
> Building include
> Building lib
> Building ltp
> Building src
> Building m4
> ./new: line 70: BEGIN{printf "%03d\n",+1}: command not found
> Next test is
> Error: test  already exists!
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> After applying this patch, ./new generates new test starting from 001,
> so we have to maintain the seq number manually? Do we need an updated
> version of new? eg. takes an argument to specify the test type like
>
> 	./new generic
That's a good idea, and numbers based on the next number for that test type.
>
> and generates new test based on existing seq number in generic dir.
>
>   new | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/new b/new
> index 94638f6..b21e75b 100755
> --- a/new
> +++ b/new
> @@ -23,7 +23,7 @@
>
>   # generic initialization
>   iam=new
> -. ./common.rc
> +. ./common/rc
>
>   trap "rm -f /tmp/$$.; exit" 0 1 2 3 15
>
>

You caught the first one but I think you should also change the template 
entries too:

123 # get standard environment, filters and checks
124 . ./common/rc
125 . ./common/filter

Other than that looks good.

--Rich


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
