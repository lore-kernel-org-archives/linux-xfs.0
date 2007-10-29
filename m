Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 08:26:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TFQetW007552
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 08:26:41 -0700
Message-ID: <4725FBB4.1010400@sandeen.net>
Date: Mon, 29 Oct 2007 10:26:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com>
In-Reply-To: <20071029075657.GA84369978@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

Niv Sardi wrote:
> Hello,
> 
> XFS's default mount options are in most cases sub-optimal, we should try
> to have more sensible defaults, so far I'm following some quick dave-powered
> recomendations:
> 
> - version 2 logs
> - attr2
> - lazy superblock counters
> - less allocation groups for single disk configs
> 
> - imaxpct default can be reduced
> 
> it is currently 25, what would be reasonable ?
> 
> - dropping the ability to turn unwritten extents off completely
> 
> please submit your pet-idea for better defaults here.

Sorry for all the replies ;-)

What would you think of a mkfs conf file like e2fsprogs has, which
defines filesystem classes, and defaults for each?  (small, news,
largefile, etc...)

-Eric
