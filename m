Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJImWPi075053 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:48:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1B4E1DBED8A
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 10:48:31 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iiJKv07dhA4uzdZj for <xfs@oss.sgi.com>;
	Sat, 19 Nov 2011 10:48:31 -0800 (PST)
Date: Sat, 19 Nov 2011 13:48:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS with project quota support in Kernel 2.6.28(.9)
Message-ID: <20111119184830.GA14564@infradead.org>
References: <CAFhwj5=N_yLUxthheD8+3bYO8UTxJgHujZJLe73NFJZqtWqU1A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFhwj5=N_yLUxthheD8+3bYO8UTxJgHujZJLe73NFJZqtWqU1A@mail.gmail.com>
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
To: Maarten Vergouwe <Maarten.Vergouwe@tass.be>
Cc: xfs@oss.sgi.com

On Mon, Nov 14, 2011 at 03:36:51PM +0100, Maarten Vergouwe wrote:
> Hi
> 
> I have problems in writes that hang for more than 7 seconds because of the
> the kthreadd daemon keeping a mutex locked for too long.
> Is there someone who might be able to help me with that?
> I saw that a lot of changes were done on the XFS quota support in later
> kernels, but the patch list is too long between my kernel and the changed
> quota system.

Did you manage to check if you can reproduce the issue with a recent
kernel?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
