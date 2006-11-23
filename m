Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 10:42:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBKIfwqw005169
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 10:42:00 -0800
Message-Id: <200611232353.KAA09617@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: Unexpected inode type 0160000 causes abort of xfs_repair
Date: Fri, 24 Nov 2006 10:58:08 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20061123131405.GA27453@groll.co.za>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Jonathan Groll' <lists@groll.co.za>, xfs@oss.sgi.com

Yes, this patch will be incorporated in the next xfsprogs update.

And yes, it did blast the inode away, as it wasn't really an inode (or
very very corrupted if it was). 

> -----Original Message-----
> From: Jonathan Groll [mailto:lists@groll.co.za] 
> Sent: Friday, 24 November 2006 12:14 AM
> To: Barry Naujok; xfs@oss.sgi.com
> Subject: Re: Unexpected inode type 0160000 causes abort of xfs_repair
> 
> On Thu, Nov 23, 2006 at 11:51:11AM +1100, Barry Naujok wrote:
> > Can you try the attached patch and see how xfs_repair goes? 
> 
> Many thanks, the patch worked like a charm! Is it going to be
> incorporated into the package in future?
> 
> Luckily I didn't have to blast the inode away, but I suspect that is
> exactly what the effect of the patch was ;-)
> 
> Thanks again,
> Jonathan
