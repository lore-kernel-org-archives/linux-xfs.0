Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7D677F66
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 03:08:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8947304053
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 01:07:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eCLaUDGU5EYlMIq3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 01:07:56 -0800 (PST)
Date: Mon, 24 Nov 2014 01:07:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v2 0/5] add support for a lazytime mount option
Message-ID: <20141124090755.GA28534@infradead.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416675267-2191-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

What's the test coverage for this?  xfstest generic/192 tests that
atime is persisted over remounts, which we had a bug with when XFS
used to have a lazy atime implementation somewhat similar to the
proposal.

We should have something similar for c/mtime as well.  Also a test to
ensure timestamps are persisted afer a fsync, although right now I can't
imagine how to do that genericly as no other filesystem seems to have
an equivaent to XFS_IOC_GOINGDOWN.

It seems you also handle i_version updates lazily. although that's
not mentioned anywhere.  I actually have a clarification request out on
the IETF NFSv4 list about the persistance requirements for the change
counter but I've not seen an answer to it yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
