Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42530 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfDEUba (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 16:31:30 -0400
Subject: Re: [PATCH v2 43/36] xfs_db: refactor multi-fsb object detection
 decision making
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193721.GG1183@magnolia> <20190405000924.GW5147@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ddd0e467-a245-025e-9378-5f33d20bd874@sandeen.net>
Date: Fri, 5 Apr 2019 15:31:28 -0500
MIME-Version: 1.0
In-Reply-To: <20190405000924.GW5147@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 4/4/19 7:09 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pull the "is this a multi-fsb object" decision into a separate function
> that we can keep close to the actual multi-fsb object dispatcher.  We
> will soon make the machinery more complex so we do this to avoid having
> a big hairy if statement.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c |   22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 83a257d0..23ecf3b7 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1979,6 +1979,16 @@ process_multi_fsb_dir(
>  	return ret;
>  }
>  
> +static bool
> +is_multi_fsb_object(
> +	struct xfs_mount	*mp,
> +	typnm_t			btype)
> +{
> +	if (btype == TYP_DIR2 && mp->m_dir_geo->fsbcount > 1)
> +		return true;
> +	return false;
> +}
> +
>  static int
>  process_multi_fsb_objects(
>  	xfs_fileoff_t	o,
> @@ -2011,6 +2021,7 @@ process_bmbt_reclist(
>  	xfs_fileoff_t		last;
>  	xfs_agnumber_t		agno;
>  	xfs_agblock_t		agbno;
> +	bool			is_multi_fsb = is_multi_fsb_object(mp, btype);
>  	int			error;
>  
>  	if (btype == TYP_DATA)
> @@ -2074,11 +2085,12 @@ process_bmbt_reclist(
>  		}
>  
>  		/* multi-extent blocks require special handling */
> -		if (btype != TYP_DIR2 || mp->m_dir_geo->fsbcount == 1) {
> -			error = process_single_fsb_objects(o, s, c, btype, last);
> -		} else {
> -			error = process_multi_fsb_objects(o, s, c, btype, last);
> -		}
> +		if (is_multi_fsb)
> +			error = process_multi_fsb_objects(o, s, c, btype,
> +					last);
> +		else
> +			error = process_single_fsb_objects(o, s, c, btype,
> +					last);
>  		if (error)
>  			return 0;
>  	}
> 
