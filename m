Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC49F7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 04:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 91ABF8F8035
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 02:23:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wwLMVLMFsNJWllQP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 02:23:27 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0F9303B758
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 09:23:27 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.52] (may be forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4C9NNE4006118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 12 May 2016 05:23:26 -0400
Date: Thu, 12 May 2016 11:23:23 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_db: defang frag command
Message-ID: <20160512092323.GB28780@redhat.com>
References: <2d21b9ba-6db7-e239-3be8-a7bd5e1c39cc@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2d21b9ba-6db7-e239-3be8-a7bd5e1c39cc@sandeen.net>
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

On Wed, May 11, 2016 at 02:41:28PM -0500, Eric Sandeen wrote:
> Too many people freak out about this fictitious "fragmentation
> factor."  As shown in the fact, it is largely meaningless, because
> the number approaches 100% extremely quickly for just a few
> extents per file.
> 
> I thought about removing it altogether, but perhaps a note
> about its uselessness, and a more soothing metric (avg extents
> per file) might be useful.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/frag.c b/db/frag.c
> index 36bb689..e11b140 100644
> --- a/db/frag.c
> +++ b/db/frag.c
> @@ -172,6 +172,10 @@ frag_f(
>  		answer = 0.0;
>  	dbprintf(_("actual %llu, ideal %llu, fragmentation factor %.2f%%\n"),
>  		extcount_actual, extcount_ideal, answer);
> +	dbprintf(_("Note, this number is largely meaningless.\n"));
> +	answer = (double)extcount_actual / (double)extcount_ideal;
> +	dbprintf(_("Files on this filesystem average %.2f extents per file\n"),
> +		answer);
>  	return 0;
>  }

I'm not quite comfortable with it, in my mind, if it's meaningless, why should
we print it?

I agree with printing the average though.

>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
