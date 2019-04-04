Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36892 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfDDXtL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 19:49:11 -0400
Subject: Re: [PATCH 43/36] xfs_db: refactor multi-fsb object detection
 decision making
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193721.GG1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <409dcab4-bd6f-59e4-ff7e-c84d1fe53ff0@sandeen.net>
Date: Thu, 4 Apr 2019 18:49:10 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193721.GG1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pull the "is this a multi-fsb object" decision into a separate function
> that we can keep close to the actual multi-fsb object dispatcher.  We
> will soon make the machinery more complex so we do this to avoid having
> a big hairy if statement.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/metadump.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 83a257d0..57216291 100644
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
> @@ -2074,7 +2085,7 @@ process_bmbt_reclist(
>  		}
>  
>  		/* multi-extent blocks require special handling */
> -		if (btype != TYP_DIR2 || mp->m_dir_geo->fsbcount == 1) {
> +		if (!is_multi_fsb) {
>  			error = process_single_fsb_objects(o, s, c, btype, last);
>  		} else {
>  			error = process_multi_fsb_objects(o, s, c, btype, last);
> 

kind of a dumb nitpick, but "if not is" seems kind of backwards, perhaps

		if (is_multi_fsb) {
 			error = process_multi_fsb_objects(o, s, c, btype, last);
 		} else {
 			error = process_single_fsb_objects(o, s, c, btype, last);
 		}

is more natural?
