Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JME6Kb012343 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 17:14:06 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FE198F8050
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 15:13:59 -0700 (PDT)
Message-Id: <4A888B06-6722-49B2-BE3D-84F0DB6DA5D6@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49EB8F90.20705@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfstests: skip dump tests if dump utils not found
Date: Sun, 19 Apr 2009 17:13:58 -0500
References: <49EB8F90.20705@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On Apr 19, 2009, at 3:54 PM, Eric Sandeen wrote:

> I was running xfstests on a NAS box which had no xfsdump,
> and any tests which required xfsdump were failing in not-so-nice
> ways:
>
>> xfsdump not found
> 038      [failed, exit status 1] - output mismatch (see 038.out.bad)
>
> I think using _notrun is a lot better:
>
> 038      [not run] xfsdump not found
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Seems good.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
