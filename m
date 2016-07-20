Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B08897CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 17:25:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25000AC001
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 15:25:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DtynQNSdQ8Ra7zCF for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 15:25:14 -0700 (PDT)
Date: Thu, 21 Jul 2016 08:25:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Document error handling behavior
Message-ID: <20160720222512.GM16044@dastard>
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
	<94b928aa-70f7-dbf4-66a8-a5f6ca2a4944@sandeen.net>
	<c1db85e5-5537-0105-4fa5-4b6512333d96@sandeen.net>
	<20160720090406.GA3094@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160720090406.GA3094@redhat.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 11:04:06AM +0200, Carlos Maiolino wrote:
> On Tue, Jul 19, 2016 at 11:18:01PM -0700, Eric Sandeen wrote:
> > 
> > 
> > On 7/19/16 2:15 PM, Eric Sandeen wrote:
> > > On 7/19/16 3:04 AM, Carlos Maiolino wrote:
> > >> This is the first try to document the implementation of error handlers into
> > >> sysfs.
> > >>
> > >> Reviews and comments are appreciated, please also notice I'm not english-native,
> > >> so, spelling corrections are also appreciated :)
> > > 
> > > Thanks for doing this! 
> > > 
> > > There seems to be a specific sysfs documentation format, see for example
> > > Documentation/ABI/testing/sysfs-fs-ext4 
> > > 
> > > It might be better to follow that format, and refer to it after a brief
> > > explanation of the functionality in the xfs.txt file?
> > 
> > Or not; Dave doesn't like this location, so perhaps best not to take
> > my suggestion.  ;)
> 
> Oh, I can see now why he doesn't like that, I've never seen such directory until
> you mentioned it, why should it be so hidden, and why should we split filesystem
> information into different locations.
> 
> IMHO, if someone want to take a look into filesystem documentation, the person
> goes directly to Documentation/filesystems, I honestly think splitting
> information into two different directories are wrong, and, even though you point
> to there in some other place, it is still bad, sounds like a RPG book... Start
> here...now go to page X...now go to page Y...now go to page Z.
> 
> I can re-format the documentation to the same format from sysfs-fs-ext4, but I
> believe keeping it under Documentation/filesystems is still the best to do. To
> be honest, I actually think we should create an XFS directory under it and put
> everything xfs related there.

I'd just add it to Doc/fs/xfs.txt right now, and we can work out
restructuring details later. Especially as we really need this documentation
added to the xfs-documentation repo (along with a "how to use"
guide). It's a similar situation to the libxfs code shared between
kernel and userspace, I think...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
