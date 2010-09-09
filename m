Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89M6AmC119374 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 17:06:11 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD52D1E6203C
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 15:06:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lp4NeUBkqwdRWe87 for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 15:06:56 -0700 (PDT)
Message-ID: <4C895A7D.1030208@sandeen.net>
Date: Thu, 09 Sep 2010 17:06:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: fragmentation question
References: <C8AEA6E3.6E2E%bchang@greenplum.com>
In-Reply-To: <C8AEA6E3.6E2E%bchang@greenplum.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brady Chang <bchang@greenplum.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 09/09/2010 04:59 PM, Brady Chang wrote:
> thanks guys for the feedback.
> iostat shows balanced io between two filesystems.
> testing with RHEL 54, no issues there. seems to be happening on RHEL 55
> only.

There were no xfs changes between 5.4 and 5.5 that should be relevant,
only a single bugfixes for 5.5, related to fallocate error returns.

Just FWIW.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
