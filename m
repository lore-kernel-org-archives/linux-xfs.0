Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JC2XL9104967 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 06:02:33 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5EB41BBEFAD
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 04:02:00 -0800 (PST)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2]) by cuda.sgi.com with
	ESMTP id EhKVIzbL4tmrRXLG for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2009 04:02:00 -0800 (PST)
Date: Thu, 19 Feb 2009 13:01:58 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: xfs problems (possibly after upgrading from linux kernel
	2.6.27.10 to .14)
Message-ID: <20090219120158.GA1747@wotan.suse.de>
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed>
	<499BD6BB.2000406@aei.mpg.de> <20090219061925.GE8830@disturbed>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090219061925.GE8830@disturbed>
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
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 05:19:25PM +1100, Dave Chinner wrote:
> On Wed, Feb 18, 2009 at 10:36:59AM +0100, Carsten Aulbert wrote:
> > >> plus a few more nodes showing the same characteristics 
> > > 
> > > Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
> > > after you upgraded from .10 to .14?
> > 
> > As far as I can see this only happened after the upgrade about 14 days
> > ago. What strikes me odd is that we only had this occurring massively on
> > Monday and Tuesday this week.
> > 
> > I don't know if a certain access pattern could trigger this somehow.
> 
> I suspect so. We've already had XFS trigger one bug in the new
> lockless pagecache code, and the fix for that went in 2.6.27.11 -
> between the good version and the version that you've been seeing
> these memory corruptions on. I'm wondering if that fix exposed or
> introduced another bug that you've hit....

Highly unlikely. It only introduces constraints on how the
compiler may generate code, so it would have to be a compiler
bug to cause a bug I think.

I wonder how long you've been running with 2.6.27 based kernels
without corruption?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
