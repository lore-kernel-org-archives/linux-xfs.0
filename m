Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Sep 2006 16:50:39 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8FNoTZd026063
	for <linux-xfs@OSS.SGI.com>; Fri, 15 Sep 2006 16:50:32 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1GONR8-0002lz-Ue
	for <linux-xfs@OSS.SGI.com>; Sat, 16 Sep 2006 00:49:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17675.15374.698393.232722@base.ty.sabi.co.UK>
Date: Sat, 16 Sep 2006 00:49:34 +0100
Subject: Re: swidth with mdadm and RAID6
In-Reply-To: <Pine.LNX.4.10.10609151652070.31539-100000@limpet.umeoce.maine.edu>
References: <Pine.LNX.4.10.10609151652070.31539-100000@limpet.umeoce.maine.edu>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Fri, 15 Sep 2006 17:07:07 -0400 (EDT), Steve Cousins
>>> <cousins@limpet.umeoce.maine.edu> said:

cousins> I have a RAID6 array of 11 500 GB drives using mdadm.
cousins> There is one hot-spare so the number of data drives is
cousins> 8.  I used mkfs.xfs with defaults to create the file
cousins> system and it seemed to pick up the chunk size I used
cousins> correctly (64K) but I think it got the swidth wrong.

Worrying about the impact on performance of a relatively small
thing like 'swidth' for something like an 8+2 RAID6 is quite
funny. http://WWW.BAARF.com/
