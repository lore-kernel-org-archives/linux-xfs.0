Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47D297CA1
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:07:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CA9E304048
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:07:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sXyViL0yX5into3d for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 09:07:02 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 41E9D873
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:07:02 -0500 (CDT)
Subject: Re: [PATCH] xfs/133 134: filter redundant projid 0 quota report
References: <1462979156-7648-1-git-send-email-zlang@redhat.com>
	<e0126658-70f7-f8f9-d3bd-a47df2c6ce96@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2114d344-c6bb-8580-81c4-cda68f7e2bc2@sandeen.net>
Date: Wed, 11 May 2016 11:07:00 -0500
MIME-Version: 1.0
In-Reply-To: <e0126658-70f7-f8f9-d3bd-a47df2c6ce96@sandeen.net>
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



On 5/11/16 11:04 AM, Eric Sandeen wrote:
> +_filter_project_quota()
> +{
> +	# Project ID 0 is always present on disk but was not reported
> +	# until the GETNEXTQUOTA ioctl came into use.  Filter it out.
> +	_filter_quota | grep -v "^\#0"
> +}

or perhaps that should be 

	grep -v "^\#0\|^(null)"

because at one point we reported "(null)" not "#0" right?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
