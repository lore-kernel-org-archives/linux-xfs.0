Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 188A27F5E
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:42:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A0EAAC001
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 16:42:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NavKZd9xe9DOTzWY for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 16:42:11 -0700 (PDT)
Date: Wed, 30 Jul 2014 09:41:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Delaylog information enquiry
Message-ID: <20140729234151.GJ26465@dastard>
References: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
	<20140729123815.GA13120@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140729123815.GA13120@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "Frank ." <frank_1005@msn.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 29, 2014 at 08:38:16AM -0400, Brian Foster wrote:
> On Tue, Jul 29, 2014 at 10:53:09AM +0200, Frank . wrote:
> > Hello. 
> > 
> > I just wanted to have more information about the delaylog feature. 
> > From what I understood it seems to be a common feature from different FS. It's supposed to retain information such as metadata for a time ( how much ?). Unfortunately, I could not find further information about journaling log section in the XFS official documentation. 
> > I just figured out that delaylog feature is now included and there is no way to disable it (http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/xfs.txt?id=HEAD). 
> > 
> 
> There is a design document for XFS delayed logging co-located with the
> xfs doc:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/xfs-delayed-logging-design.txt?id=HEAD

Or, indeed, here:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=blob;f=design/xfs-delayed-logging-design.asciidoc

> I'm not an expert on the delayed logging infrastructure so I can't give
> details, but it's basically a change to aggregate logged items into a
> list (committed item list - CIL) and "local" areas of memory (log
> vectors) at transaction commit time rather than logging directly into
> the log buffers. The benefits and tradeoffs of this are described in the
> link above. One tradeoff is that more items can be aggregated before a
> checkpoint occurs, so that naturally means more items are batched in
> memory and written to the log at a time.
> 
> This in turn means that in the event of a crash, more logged items are
> lost than the older, less efficient implementation. This doesn't effect
> the consistency of the fs, which is the purpose of the log.

In a nutshell.

Basically, logging in XFS is asynchronous unless directed by the
user application, specific operational constraints or mount options
to be synchronous.

> > Whatever the information it could be, I understood that this is a temporary memory located in RAM. 
> > Recently, I had a crash on a server and I had to execute the repair procedure which worked fine. 
> > 
> 
> A crash should typically only require a log replay and that happens
> automatically on the next mount. If you experience otherwise, it's a
> good idea to report that to the list with the data listed here:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> > But I would like to disable this feature to prevent any temporary data not to be written do disk. (Write cache is already disabled on both hard drive and raid controller). 
> > 
> > Perhaps it's a bad idea disabling it. If so, I would like to have your opinion about where memory corruption could happen. 
> > 
> 
> Delayed logging is not configurable these days. The original
> implementation was optional via a mount option, but my understanding is
> that might have been more of a precaution for a new feature than a real
> tuning option.
> 
> If you want to ensure consistency of certain operations, those
> applications should issue fsync() calls as appropriate. You could also
> look into the 'wsync' mount option (and probably expect a significant
> performance hit).

Using the 'wsync' or 'dirsync' mount options effectively cause the
majority of transactions to be synchronous - it always has, even
before delayed logging was implemented - so that once a user visible
namespace operation completes, it is guaranteed to be on stable
storage. This is necessary for HA environments so that failover from
one server to another doesn't result in files appearing or
disappearing on failover...

Note that this does not change file data behaviour. In this case you
need to add the "sync" mount option, which forces all buffered IO to
be synchronous and so will be *very slow*. But if you've already
turned off the BBWC on the RAID controller then your storage is
already terribly slow and so you probably won't care about making
performance even worse...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
