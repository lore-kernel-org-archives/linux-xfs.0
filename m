Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15LDlAT161896 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 15:13:47 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 870891C8D607
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 13:14:57 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 0VBlrhgJjtOsyToy for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 13:14:57 -0800 (PST)
Message-ID: <4B6C8A50.6090108@sandeen.net>
Date: Fri, 05 Feb 2010 15:14:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: to -DDEBUG or not to -DDEBUG?
References: <4B6AFB83.1070309@sandeen.net>
	<20100205023134.GA11483@discord.disaster>
In-Reply-To: <20100205023134.GA11483@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Feb 04, 2010 at 10:53:23AM -0600, Eric Sandeen wrote:
>> Fedora, long ago, disabled debug in the xfsprogs specfile:
>>
>> http://cvs.fedoraproject.org/viewvc/F-12/xfsprogs/xfsprogs.spec?r1=1.5&r2=1.6
>>
>> * Wed Apr 20 2005 Dave Jones <davej@redhat.com>
>> - Disable debug. (#151438)
>>
>> per this bug:  https://bugzilla.redhat.com/show_bug.cgi?id=151438
>>
>> referencing this email thread:
>>
>> http://oss.sgi.com/archives/linux-xfs/2005-03/msg00038.html
>> which no longer exists (grrrr) but is probably now here:
>>
>> http://oss.sgi.com/archives/xfs/2005-03/msg00416.html
>>
>> Fedora still builds with -DNDEBUG, but the upstream tarball has
>> it on by default.  I have seen several occasions where other
>> distros had failing xfs_repairs which were "fixed" by disabling
>> debug.  I'd like to make a decision on whether DEBUG should be
>> on or off by default for upstream releases.  Any thoughts?
> 
> Personally I'd prefer the repair process to stop if it comes across
> inconsistencies it can't handle. Ignoring them is as likely to "fix"
> the crash as it is to corrupt the filesystem more.
> 
> On top of that we get bug reports when those problems are hit so
> we can look into what caused the problem. We don't really have a
> repair test suite that covers all the possible corruptions that
> can occur, so we are kind of reliant on users reporting conditions
> we've never had to handle before so we can fix them...
> 
> Cheers,
> 
> Dave.

Hrm.  Well, that makes sense.

OTOH, Debian turns it off too:

$ grep DEBUG debian/rules 
options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \

and for some reason when I take this out of the Fedora specfile,
it fails to build because:

xfs_bmap.c:23: warning: 'xfs_bmap_check_leaf_extents' used but never defined

and indeed there is a forward declaration:

#ifdef DEBUG
STATIC void
xfs_bmap_check_leaf_extents(xfs_btree_cur_t *cur, xfs_inode_t *ip, int whichfork);
#endif

but no definition that I can find ....

Something must be odd w/ the way this flag works though because a simple "make"
in the git tree, w/o any -DNDEBUG, works fine for me ...

Meanwhile I'm leaving DEBUG=-DNDEBUG on in Fedora just for now :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
