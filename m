Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27E6F7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 12:25:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA3D88F8033
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 10:25:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id b1pVns0A7OIykNDh for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 10:25:47 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7F63116C152
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 12:25:47 -0500 (CDT)
Subject: Re: [PATCH 08/19] mkfs: getbool is redundant
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-9-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706981A.9090904@sandeen.net>
Date: Thu, 7 Apr 2016 12:25:46 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-9-git-send-email-jtulak@redhat.com>
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



On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CHANGELOG:
> o Add description of a new member of opt_params
> o Fix in the subopts tables
> o All boolean subopts should use getnum_checked
> o Edit man8 page where it missed the information about optional value of a flag
> 
> getbool() can be replaced with getnum_checked with appropriate
> min/max values set for the boolean variables. Make boolean
> arguments consistent - all accept 0 or 1 value now.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  man/man8/mkfs.xfs.8 |  11 ++-
>  mkfs/xfs_mkfs.c     | 223 ++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 164 insertions(+), 70 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 8b068ef..5a2a20a 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -118,6 +118,9 @@ option or the
>  option first needs to be added to the command line.
>  Failure to specify the size of the units will result in illegal value errors
>  when parameters are quantified in those units.
> +.PP
> +Many options allows for optional argument of value 0 or 1, to explicitly

"Many options allow for an optional argument of 0 or 1, ..."

> +disable or enable the functionality, in a forward-compatible syntax.

What does "forward-compatible syntax" mean?  I'm not sure that clarifies
anything for the reader.

Otherwise this looks ok to me; Dave explained that it is intentional to
make every single option accept a value, whether it is now
boolean or a numeric value, so there is no such thing as a bare "--flag"
anymore; such flags are always "--flag [0|1]" now, right?

> @@ -312,10 +315,12 @@ and
>  .B swidth
>  values.
>  .TP
> -.BI noalign
> -This option disables automatic geometry detection and creates the filesystem
> +.BI noalign[= value ]
> +If the
> +.I value
> +is 1, this option disables automatic geometry detection and creates the filesystem
>  without stripe geometry alignment even if the underlying storage device provides
> -this information.
> +this information. 0 disables this option, that is, enables automatic detection.
>  .RE
>  .TP
>  .B \-f

The realtime section of the manpage needs this same fixup now too, I guess.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
