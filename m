Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C59B7FF7
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:47:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7709AC00B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:47:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AViQDJEKglHssYYM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:47:53 -0800 (PST)
Date: Tue, 10 Dec 2013 23:47:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] xfstests: check O_DIRECT support before testing
	direct I/O
Message-ID: <20131211074752.GH19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-9-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-9-git-send-email-jayr@google.com>
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
To: Junho Ryu <jayr@google.com>
Cc: hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 12:11:59PM -0800, Junho Ryu wrote:
> Some filesystems do not support O_DIRECT.  Check whether TEST_DIR supports it
> by running xfs_io with and without -d flag.

should be _require_odirect as we don't really care about xfs_io features
but kernel/filesystem features.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
