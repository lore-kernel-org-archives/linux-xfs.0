Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 06:00:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5AD0pqZ023458
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 06:00:51 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFB4912C2C81
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 06:01:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id qmZgat7lH9VnDIv7 for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 06:01:47 -0700 (PDT)
Date: Tue, 10 Jun 2008 09:01:46 -0400
From: "'hch@infradead.org'" <hch@infradead.org>
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.
Message-ID: <20080610130146.GA21510@infradead.org>
References: <6A32BC807C106440B7E23208F280DDAF01D3FC9317@bcmail1.VIDMARK.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D3FC9317@bcmail1.VIDMARK.LOCAL>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>
Cc: "'hch@infradead.org'" <hch@infradead.org>, "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

On Tue, Jun 10, 2008 at 08:50:30AM -0400, Lance Reed wrote:
> Thanks!
> 
> Yes the log died and was zeroed already with xfs_repair already.
> 
> So I plan to put a 64bit head on the volumes and leave it that way.
> 
> I asuume I need to still keep it under 16 tb since the fs datastuctures are 32bit?
> 

All XFS data structures (which matter for this) are 64bit.  But the
pagecache size in 32bit x86 systems is indeeed limited, so a larger
filesystem won't work there.
