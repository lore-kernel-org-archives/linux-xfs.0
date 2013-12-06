Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C8C929E12
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 03:40:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33B99AC005
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 01:40:17 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id t65hp12WhxtxzxKA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 01:39:46 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB69djFk005474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 09:39:45 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB69diia026313
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 09:39:44 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB69dhiT002032 for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 09:39:43 GMT
Message-ID: <52A19B5D.8040802@oracle.com>
Date: Fri, 06 Dec 2013 13:39:41 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] generic: require filesize to be greater than fs block
	size in generic/240
References: <1386321845-9221-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1386321845-9221-1-git-send-email-stanislav.kholmanskikh@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: vasily.isaenko@oracle.com


On 12/06/2013 01:24 PM, Stanislav Kholmanskikh wrote:
> If we execute generic/240 on a fs which has its fs block size greater
> than 64k (for example, NFS), this test will fail with:
>
>    io_submit failed: Invalid argument
>
> This will happen because in src/aio-dio-regress/aiodio_sparse2.c this
> expression
>
>    num_aio = filesize / step;
>
> will set num_aio to 0 and this means that no io_setup() will happen
> before calling io_submit().
Actually, I mean "... no io_prep_pwrite() will happen before calling 
io_submit()". It's a typo.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
