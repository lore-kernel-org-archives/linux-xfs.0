Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8A7F7F58
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 01:10:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95887304043
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 23:10:21 -0800 (PST)
Date: Sun, 8 Dec 2013 23:10:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
Message-ID: <20131209071003.GA2736@infradead.org>
References: <5294A469.1060000@oracle.com>
	<20131128104336.GE26927@infradead.org>
	<52986001.9040101@oracle.com> <20131206210137.GT1935@sgi.com>
	<52A2B75C.3040803@oracle.com> <20131209012642.GO31386@dastard>
	<20131209023655.GQ31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209023655.GQ31386@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

The hint removal gets my vote.  I actually had it written up the last
time I touch the quota code, but for some reasons I stopped before
sumitting it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
