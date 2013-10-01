Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 407BB7F75
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 16:06:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 112A6304059
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 14:06:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nC9IZtK9jM6JI4XO for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 14:06:37 -0700 (PDT)
Message-ID: <524B395C.6030705@sandeen.net>
Date: Tue, 01 Oct 2013 16:06:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: add locks around the inventory put
References: <524AF8C3.8020904@sgi.com>
In-Reply-To: <524AF8C3.8020904@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

hi Rich -

On 10/1/13 11:30 AM, Rich Johnston wrote:
> From: Phil White <cerise-xfs@l.armory.com>
> 
> Add locks around the inventory put to prevent inventory
> corruption.
> 
> Signed-off-by: Phil White <cerise-xfs@l.armory.com>

Similar questions here; it says it's thread-safe, but apparently
not.  But why not?  what happens?  Is there a testcase?

(you guys probably have longer history in ptools, maybe you
can see what if anything changed since the original comment
was added - or maybe when it was added, etc?)

Thanks,
-Eric

> diff --git a/dump/content.c b/dump/content.c
> index ac19021..b8977bb 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -2550,8 +2550,11 @@ decision_more:
>                         scwhdrp->cih_startpt.sp_offset );
>              }
> 
> -            /* already thread-safe, don't need to lock
> +            /* Supposedly already thread-safe, according to the
> +             * previous revisions, but corruption of inventory
> +             * objects can occur.
>               */
>               */
> +            lock();
>              ok = inv_put_mediafile( inv_stmt,
>                          &mwhdrp->mh_mediaid,
>                          mwhdrp->mh_medialabel,
> @@ -2565,6 +2568,7 @@ decision_more:
>                          &&
>                          ! empty_mediafile,
>                          BOOL_FALSE );
> +            unlock();
>              if ( ! ok ) {
>                  mlog( MLOG_NORMAL, _(
>                        "inventory media file put failed\n") );
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
