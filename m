Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n191aBqJ209351 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 19:36:12 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D40B18F1EF0
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 17:35:34 -0800 (PST)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2]) by cuda.sgi.com with
	ESMTP id EVe2xIhG0jAlTKge for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 17:35:34 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch 1/5] [PATCH] acl: add make test target and use make to run
	tests
Date: Mon, 9 Feb 2009 02:34:55 +0100
References: <20090108015355.613058570@ifup.org>
	<20090108015418.504806823@ifup.org>
In-Reply-To: <20090108015418.504806823@ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902090234.55384.agruen@suse.de>
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
To: xfs@oss.sgi.com
Cc: tes@sgi.com, Brandon Philips <bphilips@suse.de>, brandon@ifup.org

On Thursday, 8 January 2009 2:53:56 brandon@ifup.org wrote:
> The tests are difficult to run. So, this patch adds a Make target that
> sets up the path and runs *.test files in the test/ directory.

Makes sense in principle, except that the patch removes the makefile rules 
that cause the tests to get added to the tarball :-(

Would you mind to fix that?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
