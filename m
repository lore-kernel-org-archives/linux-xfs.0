Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 603B57F6D
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 19:01:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EFFB7AC001
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 17:01:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OxgItKuWLw2XCX2f for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 17:01:40 -0700 (PDT)
Message-ID: <51DB52E1.8030508@sandeen.net>
Date: Mon, 08 Jul 2013 19:01:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: add missing noalign suboption information
References: <1373327110-5533-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1373327110-5533-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 7/8/13 6:45 PM, Carlos Maiolino wrote:
> Adds to the mkfs man page, information about noalign mkfs option which is
> missing until now.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  man/man8/mkfs.xfs.8 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 04c19b4..2435814 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -244,6 +244,12 @@ will automatically query the logical volume for appropriate
>  and
>  .B swidth
>  values.
> +.TP
> +.BI noalign
> +This option is used to bypass data alignment configuration. In rare
> +circunstances, data alignment might decrease performance, for such cases,
> +use this option to avoid data alignment, this will set stripe unit and
> +stripe width to 0.

Thanks for this, Carlos.

I think it might be better to just state plainly that it overrides automatic
stripe unit detection, and leave the tuning / performance parts out.
Most of the manpage today is more "what" than "why."

So maybe simply:

+This option disables automatic stripe geometry detection, and creates
+the filesystem without stripe geometry even if the underlying storage
+device reports this information.

FWIW, there is a 'noalign' option for the realtime subvolume
as well, and that should probably get documented too.

-Eric

>  .RE
>  .TP
>  .B \-f
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
