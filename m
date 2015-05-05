Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DD0C7F51
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 09:26:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E993A30404E
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 07:25:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tkmQmN0KDyl343Ql (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 07:25:56 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t45EPsOx014748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 5 May 2015 10:25:55 -0400
Date: Tue, 5 May 2015 10:25:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_db: report FINOBT in version output
Message-ID: <20150505142552.GB43235@bfoster.bfoster>
References: <5541A20B.2080607@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5541A20B.2080607@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 29, 2015 at 10:31:23PM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/db/sb.c b/db/sb.c
> index 23ec87c..974abd2 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -658,6 +658,8 @@ version_string(
>  		strcat(s, ",CRC");
>  	if (xfs_sb_version_hasftype(sbp))
>  		strcat(s, ",FTYPE");
> +	if (xfs_sb_version_hasfinobt(sbp))
> +		strcat(s, ",FINOBT");
>  	return s;
>  }
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
