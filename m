Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 22:13:25 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K6DGsG021457
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 22:13:19 -0800
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC62F5F6A94
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 22:13:40 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id 9mXWlFMeMF0rOZHM for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 22:13:40 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JRZx6-0000Sh-A6
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 21:24:36 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18363.18706.353677.744003@tree.ty.sabi.co.UK>
Date: Tue, 19 Feb 2008 21:24:34 +0000
Subject: Re: tuning, many small files, small blocksize
In-Reply-To: <47BAC139.3000109@theendofthetunnel.de>
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
	<47BA10EC.3090004@tlinx.org>
	<20080218235103.GW155407@sgi.com>
	<47BA2AFD.2060409@tlinx.org>
	<20080219024924.GB155407@sgi.com>
	<e03b90ae0802182058h7a1535c6w749eb46cbe434ef2@mail.gmail.com>
	<18362.37642.577718.529415@tree.ty.sabi.co.UK>
	<47BAC139.3000109@theendofthetunnel.de>
From: pg_xfs2@xfs2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Tue, 19 Feb 2008 12:44:57 +0100, Hannes Dorbath
>>> <light@theendofthetunnel.de> said:

[ ... a collection of millions of small records ... ]

>> That sounds like a good use for a LDAP database, but using
>> Berkeley DB directly may be best. One could also do a FUSE
>> module or a special purpose NFS server that presents a
>> Berkeley DB as a filesystem, but then we would be getting
>> rather close to ReiserFS.

light> During testing of HA clusters some time ago I found BDB
light> to always be the first thing to break. It seems to have
light> very poor recovery and seems not fine with neither file
light> systems snapshots nor power failures. [ ... ]

Sometimes BDB had problems, but that seems in the past. It also
relies critically on some precise behaviour from the storage
layer, filesystem downwards:

  http://WWW.Oracle.com/technology/documentation/berkeley-db/db/ref/transapp/reclimit.html

If all those conditions are not met, then it cannot do recovery.
Fortunately XFS can meet those conditions (I think also the page
size one), if properly configured and if the hardware does not
lie.

light> Personally I ended up doing this for OpenLDAP and never looked back: 
light> http://www.samse.fr/GPL/ldap_pg/HOWTO/x12.html

Well, PostgresQL is of course a much nicer, more scalable DBMS
than BDB. But for a relatively small, mostly-ro collection of
small records the latter may be appropriate. XFS works with it
fairly well too.
