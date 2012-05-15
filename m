Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FKRNQF212215 for <xfs@oss.sgi.com>; Tue, 15 May 2012 15:27:23 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id k1IIq1gwB35B69vZ for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 13:27:22 -0700 (PDT)
Message-ID: <4FB2BC2A.6000900@sandeen.net>
Date: Tue, 15 May 2012 15:27:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix failure in 273 due to lack of inodes
References: <1337113229-9714-1-git-send-email-jack@suse.cz>
In-Reply-To: <1337113229-9714-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On 5/15/12 3:20 PM, Jan Kara wrote:
> Test 273 fails for me due to lack of inodes (ext? filesystem is not configured
> to have enough inodes for being filled up by 4k files). So change the test
> to create larger files so that we don't hit this limit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  273 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
>  I'm not sure if this fix isn't also just lurking somewhere in the pipeline
> but I didn't find anything...
> 
> diff --git a/273 b/273
> index 2965132..0bf7167 100755
> --- a/273
> +++ b/273
> @@ -43,7 +43,7 @@ _cleanup()
>  . ./common.filter
>  
>  threads=50
> -count=1
> +count=2
>  
>  _threads_set()
>  {

It seems harmless; I never quite knew what this test was testing, so I can't say whether or not it breaks the purpose of the test ;)

I'll give it a 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

and (try to remember to) merge it in a bit, if nobody speaks up against it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
