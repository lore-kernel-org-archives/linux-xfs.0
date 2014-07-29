Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F3B97F37
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 07:29:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C7A2304051
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 05:29:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xdLUVeJS2NDxwMtv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 05:29:02 -0700 (PDT)
Date: Tue, 29 Jul 2014 08:38:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Delaylog information enquiry
Message-ID: <20140729123815.GA13120@bfoster.bfoster>
References: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
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
To: "Frank ." <frank_1005@msn.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 29, 2014 at 10:53:09AM +0200, Frank . wrote:
> Hello. 
> 
> I just wanted to have more information about the delaylog feature. 
> From what I understood it seems to be a common feature from different FS. It's supposed to retain information such as metadata for a time ( how much ?). Unfortunately, I could not find further information about journaling log section in the XFS official documentation. 
> I just figured out that delaylog feature is now included and there is no way to disable it (http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/xfs.txt?id=HEAD). 
> 

There is a design document for XFS delayed logging co-located with the
xfs doc:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/xfs-delayed-logging-design.txt?id=HEAD

I'm not an expert on the delayed logging infrastructure so I can't give
details, but it's basically a change to aggregate logged items into a
list (committed item list - CIL) and "local" areas of memory (log
vectors) at transaction commit time rather than logging directly into
the log buffers. The benefits and tradeoffs of this are described in the
link above. One tradeoff is that more items can be aggregated before a
checkpoint occurs, so that naturally means more items are batched in
memory and written to the log at a time.

This in turn means that in the event of a crash, more logged items are
lost than the older, less efficient implementation. This doesn't effect
the consistency of the fs, which is the purpose of the log.

> Whatever the information it could be, I understood that this is a temporary memory located in RAM. 
> Recently, I had a crash on a server and I had to execute the repair procedure which worked fine. 
> 

A crash should typically only require a log replay and that happens
automatically on the next mount. If you experience otherwise, it's a
good idea to report that to the list with the data listed here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> But I would like to disable this feature to prevent any temporary data not to be written do disk. (Write cache is already disabled on both hard drive and raid controller). 
> 
> Perhaps it's a bad idea disabling it. If so, I would like to have your opinion about where memory corruption could happen. 
> 

Delayed logging is not configurable these days. The original
implementation was optional via a mount option, but my understanding is
that might have been more of a precaution for a new feature than a real
tuning option.

If you want to ensure consistency of certain operations, those
applications should issue fsync() calls as appropriate. You could also
look into the 'wsync' mount option (and probably expect a significant
performance hit).

Brian

> Any help would be much appreciated. 
> Thank you. 
> 
>  		 	   		  

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
