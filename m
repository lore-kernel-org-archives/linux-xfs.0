Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE1017F3F
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 12:55:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E377FAC00A
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:55:44 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id pOqLiWPsjkKFsTkD
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:55:50 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: higher agcount on LVM2 thinp volumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130830033800.GX12779@dastard>
Date: Fri, 30 Aug 2013 11:55:50 -0600
Message-Id: <F4A27AB5-EDCA-42A3-8D9D-D5F0B992630A@colorremedies.com>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<521FF8F4.9040009@hardwarefreak.com>
	<DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
	<20130830025819.GB23571@dastard>
	<B40ABF48-E2CB-4C02-9DF9-B68BB84341C3@colorremedies.com>
	<20130830033800.GX12779@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com


On Aug 29, 2013, at 9:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> =

> So, what dm-thinp is trying to tell us is that the minimum
> *physical* IO size is 512 bytes (i.e. /sys/.../physical_block_size)
> but the efficient IO size is 256k. So dm-thinp is exposing the
> information incorrectly. What it shoul dbe doing is setting both the
> minimum_io_size and the optimal_io_size to the same value of 256k=85

Should I file a bug? Against lvm2?



Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
