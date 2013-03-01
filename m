Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B6797F9F
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 21:03:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 849898F8049
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 19:03:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pYEQSZo7n9s0rbUA for
	<xfs@oss.sgi.com>; Thu, 28 Feb 2013 19:03:49 -0800 (PST)
Message-ID: <51301A92.2080104@redhat.com>
Date: Thu, 28 Feb 2013 21:03:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: don't remove trailing zeros from integers
References: <20130301002637.GB5016@wallace>
In-Reply-To: <20130301002637.GB5016@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: xfs@oss.sgi.com

On 2/28/13 6:26 PM, Eric Whitney wrote:
> _within_tolerance strips trailing zeros from the min and max range
> values it outputs.  This leads to damage if the min or max value is
> an integer containing trailing zeros rather than a real number with
> a fractional part containing trailing zeros. Xfstest 289 can exhibit
> this problem when its input is out of range.  Modify the code so it
> will only remove trailing zeros found after a decimal point.

whoops, that's not too good.

It's only for the output message in a failure case though, correct?
But it makes the error output unhelpful.

Seems a little weird that it still leaves the trailing decimal:

$ echo 20000.00 | sed -e '/\./s/0*$//'
20000.

but that's not a big deal. The patch makes it better and
the output is understandable even if it has a trailing
decimal (which it had before anyway) so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  common.filter |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/common.filter b/common.filter
> index 9e4c90c..1df2f97 100644
> --- a/common.filter
> +++ b/common.filter
> @@ -106,8 +106,10 @@ EOF
>  
>    # fix up min, max precision for output
>    # can vary for 5.3, 6.2
> -  _min=`echo $_min | sed -e 's/0*$//'` # get rid of trailling zeroes
> -  _max=`echo $_max | sed -e 's/0*$//'` # get rid of trailling zeroes
> +
> +  # remove any trailing zeroes from min, max if they have fractional parts
> +  _min=`echo $_min | sed -e '/\./s/0*$//'`
> +  _max=`echo $_max | sed -e '/\./s/0*$//'`
>  
>    if [ $_in_range -eq 1 ] 
>    then
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
