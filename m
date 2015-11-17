Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9AAF77F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:33:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87050304032
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:33:31 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id Pu8FVDFUfkhnoDBO (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:33:30 -0800 (PST)
Date: Tue, 17 Nov 2015 15:33:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: clone ioctl return values
Message-ID: <20151117153320.GU22011@ZenIV.linux.org.uk>
References: <20151116120431.GA2860@infradead.org>
	<20151117002822.GA32467@birch.djwong.org>
	<20151117105433.GA18093@infradead.org>
	<20151117135745.GF17545@ret.masoncoding.com>
	<20151117152251.GA5392@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117152251.GA5392@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Nov 17, 2015 at 07:22:52AM -0800, Christoph Hellwig wrote:

> Yes, I saw that.  So so far I'd suggest something like the following
> for btrfs:
> 
>  - return EBADFD for missing read/wite permissions

Yowwwch...  What the hell does that have to do with STREAMS?  Or are you
using EBADFD as "nobody uses that error value anyway, let's assign it
whatever meaning we need"?

Besides, that'll be confused with EBADF all the time.  I strongly
recommend against that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
