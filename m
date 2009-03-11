Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2BH4sWV019270
	for <linux-xfs@oss.sgi.com>; Wed, 11 Mar 2009 12:05:15 -0500
Received: from mail-ew0-f170.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC2B818B64B
	for <linux-xfs@oss.sgi.com>; Wed, 11 Mar 2009 10:04:10 -0700 (PDT)
Received: from mail-ew0-f170.google.com (mail-ew0-f170.google.com
	[209.85.219.170]) by cuda.sgi.com with ESMTP id
	XXSB8MHaOOyKRiEQ for <linux-xfs@oss.sgi.com>;
	Wed, 11 Mar 2009 10:04:10 -0700 (PDT)
Received: by ewy18 with SMTP id 18so84233ewy.20
	for <linux-xfs@oss.sgi.com>; Wed, 11 Mar 2009 10:04:09 -0700 (PDT)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20090302133609.GD23880@duck.suse.cz>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org> <20090210104304.GP8830@disturbed>
	<1234432077.9204.15.camel@champagne.cantina>
	<20090226165838.GA9602@atrey.karlin.mff.cuni.cz>
	<1235763895.5743.3.camel@champagne>
	<20090302133609.GD23880@duck.suse.cz>
Date: Wed, 11 Mar 2009 18:04:06 +0100
Message-Id: <1236791046.5814.12.camel@champagne>
Mime-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2009-03-02 at 14:36 +0100, Jan Kara wrote:
.....

>   Such bit flips are usually caused by faulty memory or other HW (io
> controler etc.) so I suggest trying to shuffle the hardware somehow -
> change memory DIMMs as a starter, running memtest if you don't have a spare
> DIMMs but it is not an exception that even though memtest runs just fine
> for a long time, memory is really at fault.

Hi

I changed DIMMs on my laptop and after that I can't reproduce bug
So at the end it's an hardware problem

Many thanks to you, Dave and Christoph for your time and patience 

-- 
Cordiali Saluti
Alessandro Bono

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
