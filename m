Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 20:29:01 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0V4Suqw024714
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 20:28:57 -0800
Subject: Re: TAKE 959451 -
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <1170217442.18017.306.camel@edge>
References: <200701310412.l0V4Cusv14683285@clink.americas.sgi.com>
	 <1170217442.18017.306.camel@edge>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 15:27:53 +1100
Message-Id: <1170217673.18017.310.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Madan Valluri <mvalluri@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 2007-01-31 at 15:24 +1100, Nathan Scott wrote:
> Hi Madan,
> 
> On Tue, 2007-01-30 at 22:12 -0600, Madan Valluri wrote:
> > xfs_repair - 031 QA failure with platform that don't use the uuid field
> > in the super block.
> 
> You mean "uuid in the log", I think - all platforms would have it in the
> super block.
> 
> > QA 033 failing due to root inode being put in lost+found
> 
> Ahahahaa - now thats funny; you just made my day... ;)
> 

Actually, you'll want to make sure that the 2 realtime inodes, and
the 2 optional quota inodes also don't ever get put in lost+found;
I've not looked at these fixes (I missed the request for review :),
but they could be in the same boat as the root inode I imagine.

cheers.

-- 
Nathan
