Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A88A7F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 16:20:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAFAAAC001
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 14:20:35 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GGHcb8wYJHEVKWf2 for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 14:20:30 -0700 (PDT)
Date: Mon, 28 Apr 2014 07:20:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
Message-ID: <20140427212026.GX18672@dastard>
References: <535ABA9D.2060305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535ABA9D.2060305@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 25, 2014 at 02:42:21PM -0500, Eric Sandeen wrote:
> Add a heuristic to flush data to a file which looks like it's
> going through a tmpfile/rename dance, but not fsynced.
> 
> I had a report of a system with many 0-length files after
> package updates; as it turns out, the user had basically
> done 'yum update' and punched the power button when it was
> done.

So yum didn't run sync() on completion of the update? That seems
rather dangerous to me - IMO system updates need to be guaranteed to
be stable by the update mechanisms, not to leave the system state to
chance if power fails or the system crashes immediately after an
update...


> Granted, the admin should not do this.  Granted, the package
> manager should ensure persistence of files it updated.

Yes, yes it should. Problem solved without needing to touch XFS.

> Ext4, however, added a heuristic like this for just this case;
> someone who writes file.tmp, then renames over file, but
> never issues an fsync.

You mean like rsync does all the time for every file it copies?

> Now, this does smack of O_PONIES, but I would hope that it's
> fairly benign.  If someone already synced the tmpfile, it's
> a no-op.

I'd suggest it will greatly impact rsync speed and have impact on
the resultant filesystem layout as it guarantees interleaving of
metadata and data on disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
