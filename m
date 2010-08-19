Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7J9fwdV164450 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 04:42:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9612172EE37
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 02:42:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tLjgliocMh8CuWXK for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 02:42:28 -0700 (PDT)
Date: Thu, 19 Aug 2010 05:42:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: page discard on page error
Message-ID: <20100819094226.GA15610@infradead.org>
References: <AANLkTimHBE_9pD1wWOkryOnqBgL2bJQTKoe52wYjfNw3@mail.gmail.com>
	<20100818155043.GL7362@dastard>
	<20100818161728.GA3511@infradead.org>
	<AANLkTimsDB=Za=fF3Rk-oMFf7=pKSGR7Pg6uSKSC-4Q1@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimsDB=Za=fF3Rk-oMFf7=pKSGR7Pg6uSKSC-4Q1@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

Hi Mike,

Adding Dave and the list back to the cc list, given that mail didn't 
contain private information and was addressed to Dave and me.

On Wed, Aug 18, 2010 at 01:28:12PM -0500, Mike Gao wrote:
> I copied two video files (260M and 400M). The 260M one is done and cmp the
> same. But the 400M cmp doesn't match.
> cmp /mnt/USB0disk1/data/iCarly-4.ts ./iCarly-4.ts
> /mnt/USB0disk1/data/iCarly-4.ts ./iCarly-4.ts differ: char 112919977, line
> 516965
> try again
> /mnt/USB0disk1/data/iCarly-4.ts ./iCarly-4.ts differ: char 78496169, line
> 368800
> 
> Do you remember if there is still somewhere discard the page silence? I will
> try the latest sync to see if this is still the same.

There shouldn't be silent discards. Did you just do a straight copy
from a usb device to a local filesystem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
