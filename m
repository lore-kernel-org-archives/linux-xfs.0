Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 14:05:25 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIM5I3F020394
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 14:05:20 -0800
Received: from sargon.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B536049A8DC
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 14:05:29 -0800 (PST)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251]) by cuda.sgi.com with ESMTP id Fvgw5yqmV2qgFk4H for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 14:05:29 -0800 (PST)
Message-ID: <47684404.6010809@lncsa.com>
Date: Tue, 18 Dec 2007 23:04:52 +0100
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Re: Issue with 2.6.23 and drbd 8.0.7
References: <20071217143655.chiehahh@trusted.lncsa.com> <20071217220354.GU4396912@sgi.com> <4766F58C.8040000@lncsa.com> <20071217233759.GB4396912@sgi.com> <47678124.80906@lncsa.com> <20071218122900.GK4396912@sgi.com>
In-Reply-To: <20071218122900.GK4396912@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:
> Yes, XFS will use more memory - XFS's inodes are substantially larger
> in memory than for reiserfs and so will consume more memory for the
> same number of cached inodes.

Hi,

As a temporary workaround (while finishing tests on the x64 system), is
there a way to decrease the amount of cached inodes to avoid such
"crashes" ?

Thanks
