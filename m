Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 119B17FF7
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:46:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF07B8F804C
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:46:58 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id zMkMEvDyWr8FwN30 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:46:58 -0800 (PST)
Date: Tue, 10 Dec 2013 23:46:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] xfstests: fix generic/225 to check fiemap support
Message-ID: <20131211074657.GF19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-7-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-7-git-send-email-jayr@google.com>
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

On Tue, Dec 10, 2013 at 12:11:57PM -0800, Junho Ryu wrote:
> generic/225 runs fiemap.  It would be nice to call
> _require_xfs_io_fiemap like other tests which use fiemap.

It's not exactly correct as it doesn't require xfs_io.  If you have some
spare cycles it would be good to factor out a _require_fiemap from it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
