Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NGBI04099912 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 10:11:18 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 236293040E8
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 08:10:45 -0800 (PST)
Message-Id: <DCA2D97E-F9A4-4A9E-BC39-CFFF1D0AD2CD@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090223072207.GA4112@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: xfsprogs/xfsdump release process
Date: Mon, 23 Feb 2009 10:10:44 -0600
References: <200902221348.51905.vapier@gentoo.org>
	<200902221539.26143.vapier@gentoo.org>
	<FE09F2E2-54EC-41C8-9145-7B89C6E62AC2@sgi.com>
	<20090223072207.GA4112@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Feb 23, 2009, at 1:22 AM, Christoph Hellwig wrote:

> On Sun, Feb 22, 2009 at 11:00:45PM -0600, Felix Blyakher wrote:
>> Mike, you're absolutely right here. The config files got into the
>> dmapi tarball by mistake, sorry for this. I verified that neither
>> xfsprogs nor xfsdump have any extra files. New (clean) dmapi tarball
>> will be on the oss site shortly.
>
> Please don't overwrite already uploaded tarballs.  Let's make a 2.2.10
> release instead.  We might just use the Makepkgs script for it after
> fixing it.  See the question and patch on the list for xfsprogs for
> that, haven't checked dmapi works right yet.

Didn't think that removing the unneeded files from the package
justifies the version bump. It doesn't change anything for people
who already downloaded unclean dmapi tarballs.
Though, if opinion on this matter is that strong, I'd definitely
bump the version, and will use updated Makepkgs.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
