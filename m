Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 11:52:01 -0700 (PDT)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6HIphDW020875
	for <xfs@oss.sgi.com>; Mon, 17 Jul 2006 11:51:43 -0700
Received: from HANAFORD.eng.exegy.net (hanaford.eng.exegy.net [10.19.1.4])
	by service.eng.exegy.net (8.13.1/8.13.1) with ESMTP id k6HHQFj7010524
	for <xfs@oss.sgi.com>; Mon, 17 Jul 2006 12:26:15 -0500
Message-ID: <44BBC836.7020503@exegy.com>
Date: Mon, 17 Jul 2006 12:26:14 -0500
From: Dave Lloyd <dlloyd@exegy.com>
MIME-Version: 1.0
Subject: Re: Stripe alignment with RAID volumes
References: <e692861c0607161423o552588a3yd603a423afc71004@mail.gmail.com> <20060717144623.GA2114946@melbourne.sgi.com>
In-Reply-To: <20060717144623.GA2114946@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

David Chinner wrote:

 >
 > Device mapper is your friend - you can offset the start of the volume
 > on each device you use.
 >
 > We've done this in the past to allow multiple volume managers to coexist
 > on the same luns. e.g. first volume manager exists in 0-4MiB of each
 > lun, so we tell dm that each device starts at offset 4MiB rather than
 > at 0....

Device Mapper?  I haven't heard about this.

 >> Would it be possible to add a stripe start offset to XFS?
 >
 > Maybe, but I can't see how it would be a simple thing to do because
 > it would require on-disk format changes...
 >
 > Anyway, if you were configuring an XFS filesystem to do this, you
 > still need to understand the underlying geometry to get it right.
 > You may as well get your volume manager configuration correct, and
 > then we don't have to worry about it in XFS.

The latest parted will let you use bytes to size the partitions.  Stripe
aligning the begining and the end of the partition does give better
performance.

-- 
Dave Lloyd
Test Engineer, Exegy, Inc.
314.450.5342
dlloyd@exegy.com
