Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523AAC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0102322248
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jspb2R3Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgJOFbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:31:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgJOFbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:31:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5Drno142358;
        Thu, 15 Oct 2020 05:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GN/JHAek1u0eE8ICF7qm0sX8xKApthLCPw59ai1czQk=;
 b=jspb2R3Zfs0UuDCGwSga7h6vtI7Jo64h4TH1xZ1ZW0uRZeJBtcpMHVs32tXJ+cUyewg+
 yO8nWmiyPI4nvu5b11CVG3hTKS/Hn3rWsuUEpH/JWzuZus5gaR00RdeRX3D+yZjsSHcB
 j8l7sN0QMbPegG4i2VFV5ojPD67HHjUAuU6rnkuq/jihFI5ih7rlV9fPafmgNktUdmCU
 U7P+aMsXAQ3vKNqMqeOnec0rrZX3AGk19PeNjpPxR7SzQzfk1hpb+SAK0nY2yWhmHukE
 iYUQEEfbvZXs5zCg27iROMLRDmV57IhBhAU5tcBevsdIF2ll2CSB8iw0bulkuaajogl5 eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 343vaeh5qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:31:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5FZ6u049702;
        Thu, 15 Oct 2020 05:31:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 344by4p0hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:31:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09F5Vnmt031472;
        Thu, 15 Oct 2020 05:31:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:31:49 -0700
Date:   Wed, 14 Oct 2020 22:31:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] mkfs: constify various strings
Message-ID: <20201015053148.GO9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015032925.1574739-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015032925.1574739-4-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150038
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 02:29:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because the ini parser uses const strings and so the opt parsing
> needs to be told about it to avoid compiler warnings.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/linux.h |  2 +-
>  mkfs/xfs_mkfs.c | 28 ++++++++++++++--------------
>  2 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 57726bb12b74..03b3278bb895 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -92,7 +92,7 @@ static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
>  	uuid_unparse(*uu, buffer);
>  }
>  
> -static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
> +static __inline__ int platform_uuid_parse(const char *buffer, uuid_t *uu)
>  {
>  	return uuid_parse(buffer, *uu);
>  }
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e84be74fb100..99ce0dc48d3b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -975,8 +975,8 @@ respec(
>  
>  static void
>  unknown(
> -	char		opt,
> -	char		*s)
> +	const char	opt,
> +	const char	*s)
>  {
>  	fprintf(stderr, _("unknown option -%c %s\n"), opt, s);
>  	usage();
> @@ -1387,7 +1387,7 @@ getnum(
>   */
>  static char *
>  getstr(
> -	char			*str,
> +	const char		*str,
>  	struct opt_params	*opts,
>  	int			index)
>  {
> @@ -1396,14 +1396,14 @@ getstr(
>  	/* empty strings for string options are not valid */
>  	if (!str || *str == '\0')
>  		reqval(opts->name, opts->subopts, index);
> -	return str;
> +	return (char *)str;

Hmm do any of the getstr callers actually change the return value?

Er... holy $bovine you have to change a lot of stuff everywhere to make
the const stick.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  }
>  
>  static int
>  block_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1420,7 +1420,7 @@ static int
>  cfgfile_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1437,7 +1437,7 @@ static int
>  data_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1506,7 +1506,7 @@ static int
>  inode_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1541,7 +1541,7 @@ static int
>  log_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1587,7 +1587,7 @@ static int
>  meta_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1621,7 +1621,7 @@ static int
>  naming_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1650,7 +1650,7 @@ static int
>  rtdev_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1680,7 +1680,7 @@ static int
>  sector_opts_parser(
>  	struct opt_params	*opts,
>  	int			subopt,
> -	char			*value,
> +	const char		*value,
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> @@ -1700,7 +1700,7 @@ static struct subopts {
>  	struct opt_params *opts;
>  	int		(*parser)(struct opt_params	*opts,
>  				  int			subopt,
> -				  char			*value,
> +				  const char		*value,
>  				  struct cli_params	*cli);
>  } subopt_tab[] = {
>  	{ 'b', &bopts, block_opts_parser },
> -- 
> 2.28.0
> 
