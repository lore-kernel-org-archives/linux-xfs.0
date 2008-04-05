Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Apr 2008 11:05:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m35I5ECd032400
	for <xfs@OSS.SGI.com>; Sat, 5 Apr 2008 11:05:18 -0700
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A9B293CA26
	for <xfs@OSS.SGI.com>; Sat,  5 Apr 2008 11:05:51 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id EWGuEURodumKHof6 for <xfs@OSS.SGI.com>; Sat, 05 Apr 2008 11:05:51 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JiClN-0004zF-Fo
	for <xfs@OSS.SGI.com>; Sat, 05 Apr 2008 19:05:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18423.48984.905157.301030@tree.ty.sabi.co.uk>
Date: Sat, 5 Apr 2008 19:05:12 +0100
Subject: Re: suggested tuning for XFS on RAID system
In-Reply-To: <4f52331f0804041100g696ba02er47c3642c56a24cf7@mail.gmail.com>
References: <4f52331f0804041100g696ba02er47c3642c56a24cf7@mail.gmail.com>
From: pg_xfs2@xfs2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Fri, 4 Apr 2008 11:00:27 -0700, "Fong Vang"
>>> <sudoyang@gmail.com> said:

sudoyang> Anyone has any suggestion on tuning XFS for more
sudoyang> stability and reliability on a 1TB and 7TB XFS file
sudoyang> system that holds potentially millions of small files?
sudoyang> [ ... ]

Use this tuning tool:

  mysqladmin create MEGA

or this optimization script:

  perl -e 'use BerkeleyDB; my %db; tie %db,"BerkeleyDB::Hash",
             -Flags => DB_CREATE,-Filename => "MEGA"; untie %db;'

BTW, similar discussions have happened in the past. It is a sign
of respect for a mailing list to look into the archives before
asking the same questions again and again and again and again.
