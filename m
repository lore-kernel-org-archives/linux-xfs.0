Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 00:00:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H6xtmM028663
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 23:59:56 -0700
Received: from sorrow.cyrius.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D27150AD25
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 00:01:39 -0700 (PDT)
Received: from sorrow.cyrius.com (sorrow.cyrius.com [65.19.161.204]) by cuda.sgi.com with ESMTP id S0YCgWeucCN79vO9 for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 00:01:39 -0700 (PDT)
Date: Fri, 17 Oct 2008 09:01:09 +0200
From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081017070109.GA30726@deprecation.cyrius.com>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7BC9F.4080909@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

* Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> So is this a regression?  did it used to work?  If so, when? :)

The original report was with 2.6.18 but that was with the old ABI:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
I just installed a 2.6.22 kernel with EABI and I can also trigger
the bug.  So it's not a (recent) regression.

> What's a little odd is that the buffer it dumped out looks like the
> beginning of a perfectly valid superblock for your filesystem
> (magic, block size, and block count all match).   If you printk the
> "bno" variable right around line 2106 in xfs_da_btree.c, can you see
> what you get?

bno is 0.

> creating an xfs_metadump of the filesystem for examination on a
> non-arm box might also be interesting.

http://www.cyrius.com/tmp/dump5
(11 MB)
-- 
Martin Michlmayr
http://www.cyrius.com/
