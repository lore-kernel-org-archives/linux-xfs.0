Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9HNm0cJ119754 for <xfs@oss.sgi.com>; Sun, 17 Oct 2010 18:48:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AD6DF8A8A
	for <xfs@oss.sgi.com>; Sun, 17 Oct 2010 16:49:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	IBsM4B4FVh9mivx3 for <xfs@oss.sgi.com>;
	Sun, 17 Oct 2010 16:49:09 -0700 (PDT)
Date: Mon, 18 Oct 2010 10:49:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/2] xfs: dynamic speculative preallocation for
	delalloc
Message-ID: <20101017234905.GG29677@dastard>
References: <C8DCC927.48D3%ivan.novick@emc.com> <201010150914.55604@zmi.at>
	<20101015114508.GI4681@dastard> <201010171631.53183@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010171631.53183@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Sun, Oct 17, 2010 at 04:31:48PM +0200, Michael Monnerie wrote:
> On Freitag, 15. Oktober 2010 Dave Chinner wrote:
> > On Fri, Oct 15, 2010 at 09:14:54AM +0200, Michael Monnerie wrote:
> > > The question is: what is a good value for preallocation?
> > 
> > If you can't answer that, use the defaults.
> 
> Who can really without testing? For a webserver, hosting hundreds of 
> different websites, with many ftp uploads and where the rest of the 
> writes are webservers temp and log files, do you know the best value 
> without investigation? That's what I meant.

Yes, I do know that - the best value is the default value.

> > > I'd guess for a database 1GB seems reasonable,
> > 
> > depends on  your database. If it does direct IO, then allocsize is
> > completely meaningless....
> 
> True, I was thinking of postgresql and mysql (innodb, 1 file per table). 
> Both increment file sizes when needed.

MySQL can do direct IO, so you can't just assume that the database
app will tell you what type of IO it is doing.

> > IIRC, that is the default behaviour for _physical_ extent allocation
> > on files larger than one stripe unit (i.e stripe aligned and sized
> > allocation). That is very different from speculative allocation done
> > at delayed allocation time, which is purely in-memory until physical
> > allocation occurs.
> 
> Together with your other answer (swalloc...) I get the picture now. So 
> delalloc, speculative prealloc, and physical allocation are done, where 
> the first two are in-memory. And the mount option allocsize sets the 
> delalloc size.
>  
> Now something comes to my mind: When I make an ftp upload, it's very 
> slow in terms of disk speed. Say 2MB/s. How long would delalloc wait 
> before flushing buffers on disk? 

delalloc does not do any waiting. The system decides when to flush
data to disk. We even do delalloc for sync writes - the system
flushes the data to disk immediately instead of via memory pressure
or background writeback.

> Isn't that controlled by the values of 
> vm.dirty_background_bytes and vm.dirty_expire_centisecs and 
> vm.dirty_writeback_centisecs?

Exactly.

> Then dirty_background_bytes would be the 
> maximum possible delalloc size?

No. Those numbers control the amount of dirty pages in memory, not
the amount of space we've allocated speculatively. Indeed, by
definition speculative allocation past EOF means it is space that
currently has no dirty pages.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
