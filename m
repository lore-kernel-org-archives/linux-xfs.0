Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 183F77FAF
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 06:14:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED5478F80B7
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 04:14:24 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id HKpngAyEwiqqLIBt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 04:14:22 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.hs.tlinx.org (8.14.9/8.14.4/SuSE Linux 0.8) with ESMTP id
	t53BEJL2012178 for <xfs@oss.sgi.com>; Wed, 3 Jun 2015 04:14:21 -0700
Message-ID: <556EE18A.1080606@tlinx.org>
Date: Wed, 03 Jun 2015 04:14:18 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2 V3] allow UUID changes on V5/CRC filesystems
References: <55525356.1020807@sandeen.net>
In-Reply-To: <55525356.1020807@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>



Eric Sandeen wrote:
> Final version?  This has been through some degree of testing, by changing
> the UUID after a CRC mkfs, and re-setting it in between two xfs_repair runs
> before and after each test in the testsuite.
---
	I think I see my problem.

	Is there some strong technical reason why 'crc' has to 
be on to get -finobt=1 && ftype=1.  I'd like to try the latter two
features, but the 'crc' stuff has me a bit bugged -- for unanticipated
reasons like not being able to set the UUID (I so very often hit
those corner cases...*lucky-me*).

> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
