Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D2617F52
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 02:26:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62C4C8F804C
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 00:26:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6e7veEEzZaRt3X3u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 00:26:02 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9S7Q18r028174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 07:26:02 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9S7Q0jx004998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 07:26:01 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9S7Q0xe018662 for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 07:26:00 GMT
Message-ID: <526E1186.5040303@oracle.com>
Date: Mon, 28 Oct 2013 11:25:58 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: tests/generic: added -P option to df
References: <1382444035-9502-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1382444035-9502-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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


On 10/22/2013 04:13 PM, Stanislav Kholmanskikh wrote:
> Otherwise the testcases will fail if the scratch
> device has a long name (for example, if it's an LVM volume).
> Because df outputs its usage stats with two lines:
>
> /dev/mapper/xfstests-disk1
>                         3030800      4608   2868908   1% /tmp/mnt/disk1
>
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---

Hi!

Could anybody review it?

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
