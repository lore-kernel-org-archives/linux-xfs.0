Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38F8F7F47
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:08:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27176304051
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 01:08:21 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id IS3Fbw8apE9rLfKn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 01:08:20 -0800 (PST)
Date: Tue, 4 Nov 2014 10:08:14 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: your patch "mm: Remove false WARN_ON from
	pagecache_isize_extended()"
Message-ID: <20141104090814.GA2953@quack.suse.cz>
References: <5457BE390200007800044838@mail.emea.novell.com>
	<20141103221849.GB23575@dastard>
	<545890F40200007800044A31@mail.emea.novell.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <545890F40200007800044A31@mail.emea.novell.com>
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
To: Jan Beulich <JBeulich@suse.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue 04-11-14 07:40:20, Jan Beulich wrote:
> >>> On 03.11.14 at 23:18, <david@fromorbit.com> wrote:
> > On Mon, Nov 03, 2014 at 04:41:13PM +0000, Jan Beulich wrote:
> >> having run into that warning too, I looked into it a little, and now
> >> having found that patch am pretty uncertain: Both truncate_setsize()
> >> and pagecache_isize_extended() document that they want to be
> >> called with i_mutex held, so removing the WARN_ON() alone seems
> >> either incomplete or wrong. What I found to work without violating
> >> this documented requirement is the patch below.
> > 
> > Or, just perhaps, the comments are wrong....
> 
> Right - that's what I was suggesting with the option of the patch
> being incomplete (rather than just removing the WARN_ON() it
> should also remove the respective comments then).
  Yeah, I'll update the comments to mention there are filesystem which use
serialization different from i_mutex. Thanks for catching this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
