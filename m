Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4712D7CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 18:02:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE3FF8F8035
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 16:02:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JXU8GdAgT9j08Er9 for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 16:02:18 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 28CBC16C150
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 18:02:18 -0500 (CDT)
Subject: Re: [PATCH 04/19] mkfs: validate all input values
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-5-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57059579.9090900@sandeen.net>
Date: Wed, 6 Apr 2016 18:02:17 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-5-git-send-email-jtulak@redhat.com>
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
> CHANGELOG
> o Fix an unsigned < 0 comparison - save getnum result to another variable
>   and test it, before converting it to unsigned logagno.

...

> @@ -1468,7 +1485,10 @@ main(
>  						respec('l', lopts, L_AGNUM);
>  					if (ldflag)
>  						conflict('l', lopts, L_AGNUM, L_DEV);
> -					logagno = atoi(value);
> +					tmp_num = getnum(value, 0, 0, false);
> +					if (tmp_num < 0)
> +						illegal(value, "l agno");
> +					logagno = (xfs_agnumber_t)tmp_num;
>  					laflag = 1;
>  					break;
>  				case L_FILE:

Why not cast to (__int64_t) like other variables do?  i.e.


+					logagno = getnum(value, 0, 0, false);
+					if ((__int64_t)logagno < 0)
+						illegal(value, "l agno");

or am I missing something?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
