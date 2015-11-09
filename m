Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37D8A7CBF
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 12:33:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE9FFAC005
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 10:33:47 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mx4Yea3Ei3YItmTE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 10:33:46 -0800 (PST)
Date: Mon, 9 Nov 2015 10:33:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 03/51] xfs_io: support reflink and dedupe of file ranges
Message-ID: <20151109183311.GA3255@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050533.1504.66249.stgit@birch.djwong.org>
	<20151014053656.GJ10397@birch.djwong.org>
	<20151109075438.GA17974@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151109075438.GA17974@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Nov 08, 2015 at 11:54:38PM -0800, Christoph Hellwig wrote:
> Any reason why the dedup command is called 'dedupe'?  Is this a revenge
> for the missing 'e' in the creat syscall? :)

Heh, sure! :)

I stuck on the 'e' because the btrfs tool is 'duperemove', not 'dupremove'.

(I have no preference either way.)

> Either way it would be good to get this support in ASAP so we can have
> the command ready for xfstests and we can merge the test.  They are
> useful for btrfs and NFS already, so I'd love to fast track them.

<nod>

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
