Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 20:17:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9H3HVaG013869
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 20:17:33 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47871D134415
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 20:16:48 -0700 (PDT)
Subject: Re: [PATCH 1/2] Make stuff static
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061017030908.GP11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net>
	 <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
	 <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net>
	 <20061016232250.GM11034@melbourne.sgi.com>
	 <1161042943.5723.117.camel@xenon.msp.redhat.com>
	 <20061017005038.GN11034@melbourne.sgi.com> <45342BF3.8020609@sandeen.net>
	 <20061017030908.GP11034@melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 17 Oct 2006 13:18:04 +1000
Message-Id: <1161055084.17754.7.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Russell Cattelan <cattelan@thebarn.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Tue, 2006-10-17 at 13:09 +1000, David Chinner wrote:
> On Mon, Oct 16, 2006 at 08:03:47PM -0500, Eric Sandeen wrote:
> > David Chinner wrote:
> > 
> Of course, no plan ever survives contact with the enemy. :/
> 
> STATIC is also used for defining various structure tables.
> And variables.  They'll all get changed to "static"....
> 
> Then there's __inline and __inline__ still used in places.....
> 
> The patch that follows does the noinline change, de-inlines
> xfs_cleanup_inode() and cleans up all the inline cruft hanging around.
> 
> Comments?
> 

Be careful of userspace, where much of this code is also compiled in
libxfs, and STATIC is always #defined away to nothingness there (as
there's need for some routines to be accessed outside of one source
file there, differently to the kernel, IIRC).

cheers.

-- 
Nathan
