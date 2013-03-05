Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8504E8004
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 13:30:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1507BAC005
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 11:30:44 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vOtSL6A30LDD5tvL for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 11:30:43 -0800 (PST)
Message-ID: <513647E2.1020200@sandeen.net>
Date: Tue, 05 Mar 2013 13:30:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: don't remove trailing zeros from integers
References: <20130305191748.GB3930@wallace>
In-Reply-To: <20130305191748.GB3930@wallace>
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
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On 3/5/13 1:17 PM, Eric Whitney wrote:
> _within_tolerance strips trailing zeros from the min and max range
> values it outputs.  This leads to damage if the min or max value is
> an integer containing trailing zeros rather than a real number with
> a fractional part containing trailing zeros. Xfstest 289 can exhibit
> this problem when its input is out of range.  Modify the code so it
> will only remove trailing zeros found after a decimal point.
> 
> V1->V2: Remove decimal points not followed by digits
> V2->V3: Per Dave Chinner, simplify by using multiple sed expressions
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  common.filter |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/common.filter b/common.filter
> index 9e4c90c..c854a98 100644
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
> +  _min=`echo $_min | sed -e '/\./s/0*$//' -e 's/\.$//'`
> +  _max=`echo $_max | sed -e '/\./s/0*$//' -e 's/\.$//'`
>  
>    if [ $_in_range -eq 1 ] 
>    then
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
