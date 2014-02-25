Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C62DD7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:03:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA92E304071
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:03:30 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9Kf85StrONazFZbo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 14:03:29 -0800 (PST)
Date: Tue, 25 Feb 2014 14:03:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_metadump: include F in getopts string
Message-ID: <20140225220328.GA5450@infradead.org>
References: <530CC371.8030005@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530CC371.8030005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 25, 2014 at 10:23:13AM -0600, Eric Sandeen wrote:
> I added an F case, but didn't add it to the bash
> getopts string last go-round.
> 
> /usr/sbin/xfs_metadump: illegal option -- F
> 
> I sure thought I tested this, I'm not sure how it got lost.

Well, better write a test for xfstests so that we can test it as part of
the regression test run.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
