Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 08:45:01 -0700 (PDT)
Received: from smtp121.sbc.mail.sp1.yahoo.com (smtp121.sbc.mail.sp1.yahoo.com [69.147.64.94])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TFisj3010581
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 08:44:56 -0700
Date: Mon, 29 Oct 2007 08:44:56 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071029154456.GA25142@puku.stupidest.org>
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725FBB4.1010400@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

On Mon, Oct 29, 2007 at 10:26:44AM -0500, Eric Sandeen wrote:

> What would you think of a mkfs conf file like e2fsprogs has, which
> defines filesystem classes, and defaults for each?  (small, news,
> largefile, etc...)

That makes more sense for ext2/3 where some meta-data isn't
dynamically allocated as needed, for example, historically nntp
servers used one file per article and would often run out of inodes.
