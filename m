Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C2297CA1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 11:45:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B490304032
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 09:44:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id PNu9aHqQDauaEp3C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 09:44:56 -0700 (PDT)
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id u36Git0R015160
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Apr 2016 16:44:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u36GislY018303
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 6 Apr 2016 16:44:55 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u36Gis65032386
	for <xfs@oss.sgi.com>; Wed, 6 Apr 2016 16:44:54 GMT
Date: Wed, 6 Apr 2016 09:44:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: use named array initializers for log item dumping
Message-ID: <20160406164453.GA408@birch.djwong.org>
References: <20160406105657.GA30644@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160406105657.GA30644@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2016 at 01:56:57PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 5110cd82ca90: "xfs: use named array initializers for log
> item dumping" from Mar 7, 2016, leads to the following static checker
> warning:
> 
> 	fs/xfs/xfs_log.c:2085 xlog_print_tic_res()
> 	error: buffer overflow 'trans_type_str' 43 <= 43
> 
> fs/xfs/xfs_log.c
>   2080  
>   2081          xfs_warn(mp, "xlog_write: reservation summary:");
>   2082          xfs_warn(mp, "  trans type  = %s (%u)",
>   2083                   ((ticket->t_trans_type <= 0 ||
>   2084                     ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
>                                                 ^
> Should be >=.

Correct.  Good catch.

>  Why is zero invalid?

There isn't a XFS_TRANS_ code corresponding to zero:

/*
 * Transaction types.  Used to distinguish types of buffers. These never reach
 * the log.
 */
#define XFS_TRANS_SETATTR_NOT_SIZE	1
<etc>

That whole guard expression might as well be:

(ticket->t_trans_type == 0 || ticket->t_trans_type >= XFS_TRANS_TYPE_MAX)

Furthermore, XLOG_REG_TYPE_MAX could be 21 to be consistent with the rest
of XFS, and the checks for res_type_str usage below this could be the same.

(Though personally /me finds it odd that the _MAX values are usually one 
more than the last item in the list.)

(Also I thought there was other discussion of that patch so I'm a little
surprised to see it in mainline?)

--D

> 
>   2085                    "bad-trans-type" : trans_type_str[ticket->t_trans_type]),
>   2086                   ticket->t_trans_type);
>   2087          xfs_warn(mp, "  unit res    = %d bytes",
> 
> 
> regards,
> dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
