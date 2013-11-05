Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2706229DF9
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 06:41:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C18F1AC002
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 04:41:45 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uWZPfZHjz7fVoOHI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 04:41:44 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rA5Cfh9A016289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 12:41:43 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rA5CfgSB021799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 12:41:43 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rA5Cfgof021785 for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 12:41:42 GMT
Message-ID: <5278E783.6020704@oracle.com>
Date: Tue, 05 Nov 2013 16:41:39 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: src/feature.c: print a number of online CPUs
References: <20131028221540.GF2797@dastard>
	<1383041039-5520-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1383041039-5520-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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


On 10/29/2013 02:03 PM, Stanislav Kholmanskikh wrote:
> For this purpose we use sysconf() as it is the
> preferred platform neutral interface for getting this
> sort of information.
>
> Based on Dave Chinner proposal.
>
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
Hi!

Please, review.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
