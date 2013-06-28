Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA8AB7F7D
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 14:58:28 -0500 (CDT)
Date: Fri, 28 Jun 2013 14:58:27 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
Message-ID: <20130628195827.GB15447@sgi.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
	<20130627144814.GM20932@sgi.com> <20130627190831.GN20932@sgi.com>
	<20130628020912.GI32195@dastard> <20130628023204.GJ32195@dastard>
	<20130628153950.GA9164@sgi.com> <51CDBE90.5090309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51CDBE90.5090309@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Jun 28, 2013 at 12:49:20PM -0400, Eric Sandeen wrote:
| On 6/28/13 11:39 AM, Geoffrey Wehrman wrote:
| > On Fri, Jun 28, 2013 at 12:32:04PM +1000, Dave Chinner wrote:
| > | On Fri, Jun 28, 2013 at 12:09:12PM +1000, Dave Chinner wrote:
| > | > Mount options are perfectly fine to be removed - they've been given
| > | > deprecated warnings for quite some time now (the most recent is the
| > | > delaylog which has been doing that since 3.1 IIRC). So they are all
| > | > fine to actually remove - 12 months warning is usually considered
| > | > sufficient.
| > 
| > I hardly consider 12 years to be sufficient.  I have no problem with
| 
| 12 years, really?  Maybe you meant months.  I hope you meant months!

I really did mean 12 years.  About as long as my dog lived.

| > | > I think you're being overly paranoid here - I'm simply following the
| > | > normal deprecation protocol here....
| > | 
| > | Documenation/ABI/README:
| > | 
| > | We have four different levels of ABI stability, as shown by the four
| > | different subdirectories in this location.  Interfaces may change levels
| > | of stability according to the rules described below.
| > | ....
| > |  obsolete/
| > |          This directory documents interfaces that are still remaining in
| > | 	 the kernel, but are marked to be removed at some later point in
| > | 	 time.  The description of the interface will document the reason
| > | 	 why it is obsolete and when it can be expected to be removed.
| > 
| > 
| > | I think you'll find that what I done follows this policy. If you
| > | really want, I'll move them to Documenation/ABI/obsolete.  And, of
| > | course, if removing them proves to be a problem, as Eric said we can
| > | always reinstate them or remove the deprecation notices.

Please move the mount options and sysctl interfaces removed to
Documenation/ABI/obsolete.  In return, I'll refrain from ranting further
about the ABI instability of Linux.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
