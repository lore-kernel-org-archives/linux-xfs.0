Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 10:00:32 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l15I0I3c025060
	for <linux-xfs@oss.sgi.com>; Mon, 5 Feb 2007 10:00:21 -0800
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HE88I-0007a3-4J
	for linux-xfs@oss.sgi.com; Mon, 05 Feb 2007 19:00:02 +0100
Received: from c-134-232-3.f.dsl.de.ignite.net ([62.134.232.3])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 05 Feb 2007 19:00:02 +0100
Received: from bernd-schubert by c-134-232-3.f.dsl.de.ignite.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 05 Feb 2007 19:00:02 +0100
From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: XFS "no space left" problem
Date: Mon, 05 Feb 2007 18:58:04 +0100
Message-ID: <eq7r7c$b1n$1@sea.gmane.org>
References: <20070203183723.GA1652@dunno.espix.org> <20070203233828.GD44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

David Chinner wrote:

> Or get a 64bit machine and use inode64. ;)

David, can you tell more in detail what you mean with "use inode64"?

We also just migrated our server to xfs, the largest partition has a size of
4TB. Lets say in the future a problem occurs and we could solve this by a
64-bit system? Migrating to 64-bit wouldn't be difficult, since the server
systems are already opterons. Only since we never bothered to migrate the
installation to x86_64 its not 64-bit yet. Would we need to tell xfs
somehow that it update its internal values to 64-bit integers or will it do
that automatically? 
Btw, if you need 64-bit integers, why don't you use long long, or even
better with C99 int64_t?

Thanks,
Bernd
