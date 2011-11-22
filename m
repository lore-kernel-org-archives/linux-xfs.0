Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMBtA9174697 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:11:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1495D1D2A4E3
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:11:51 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HbdV34Sni8X9bLqy for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 14:11:51 -0800 (PST)
Date: Tue, 22 Nov 2011 17:11:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EFSCORRUPTED on mount?
Message-ID: <20111122221150.GA21028@infradead.org>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
	<CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
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
To: Gregory Farnum <gregory.farnum@dreamhost.com>
Cc: sandeen@sandeen.net, xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 10:47:24AM -0800, Gregory Farnum wrote:
> Barriers on (at least, nobody turned them off); the RAID card is
> battery-backed; here are megacli dumps:
> http://pastebin.com/yTskgzWG
> http://pastebin.com/ekhczycy

I had a lot of of issues with megaraid cards and their unsafe caching
settings, up to the point that I'd recommend staying away from them
now.  Can you check in the megacli config if the _disk_ write caches
are enabled?  megaraid adapters used to do that a lot, and given that
the disk cache isn't batter backed it's fairly fatal.

I think in your dump this one might be the culprit given that SATA
disks outside of a few niches come with a writeback cache policy:

Disk Cache Policy: Disk's Default

try changing that to an explicit writethrough mode - and maybe try
running a crash data integrity test like

	http://www.complang.tuwien.ac.at/anton/hdtest/

on this controller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
