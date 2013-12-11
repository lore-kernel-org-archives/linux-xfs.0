Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1ACE68006
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:51:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02A63304043
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:51:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yFEJP0mkEU4Ut3YH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:51:26 -0800 (PST)
Date: Tue, 10 Dec 2013 23:51:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] xfstests: skip parts of tests which cannot work on
	tmpfs
Message-ID: <20131211075125.GJ19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-11-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-11-git-send-email-jayr@google.com>
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

On Tue, Dec 10, 2013 at 12:12:01PM -0800, Junho Ryu wrote:
> Skip generic/076 which tests concurrent access while testing tmpfs
> because there are other tests cover the case using fsstress.

Should check if SCRATCH_DEV is a block device.

> Skip generic/277 which requires chattr.

Add a feature test to see if the filesystem supports chattr.  Might
be worth to have a common _require_chattr helper chared with generic/079

> 
> Even if generic/053 will not be able to test exactly what the test has
> been intended to test, it will be still useful to have this test to try
> out some functionality on tmpfs rather than always failing or being
> skipped.

I'd rather add a simple ACL tests that covers this without the unmount
an repair and maybe more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
