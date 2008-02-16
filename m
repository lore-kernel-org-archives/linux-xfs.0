Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Feb 2008 04:37:46 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1GCbd5b024624
	for <xfs@OSS.SGI.com>; Sat, 16 Feb 2008 04:37:41 -0800
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B82E9E381F9
	for <xfs@OSS.SGI.com>; Sat, 16 Feb 2008 04:38:03 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id GZu7P0V7fNwApF8O for <xfs@OSS.SGI.com>; Sat, 16 Feb 2008 04:38:03 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JQM4L-0004Uy-Ms
	for <xfs@OSS.SGI.com>; Sat, 16 Feb 2008 12:23:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18358.54692.381632.107791@tree.ty.sabi.co.UK>
Date: Sat, 16 Feb 2008 12:23:00 +0000
Subject: Re: tuning, many small files, small blocksize
In-Reply-To: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
From: pg_xfs2@xfs2.for.sabi.co.UK
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Fri, 15 Feb 2008 21:01:10 -0800, "Jeff Breidenbach"
>>> <jeff@jab.org> said:

jeff> I'm testing xfs for use in storing 100 million+ small
jeff> files (roughly 4 to 10KB each) and some directories will
jeff> contain tens of thousands of files. There will be a lot of
jeff> random reading, and also some random writing, and very
jeff> little deletion. The underlying disks use linux software
jeff> RAID-1 manged by mdadm with 5X redundancy. E.g. 5 drives
jeff> that completely mirror each other.

Reading this was quite entertaining :-).

jeff> [ ... ] The general consensus was xfs does pretty good
jeff> tuning itself, but almost none of the published benchmarks
jeff> or recommendation go with small blocksizes and I want to
jeff> make sure I'm not about to do something totally stupid. [
jeff> ... ]

Makes me wonder why silly people come up with pointless stuff
like this :-)

  http://WWW.Oracle.com/database/berkeley-db.html
