Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C66047CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 17:11:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E7A9AC003
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 15:11:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	k1MR51CaOJwDrHh5 for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 15:11:03 -0700 (PDT)
Date: Thu, 23 Jun 2016 08:09:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug (?) : cumulative xfsrestore does not restore files and
	folders in a directory which was renamed
Message-ID: <20160622220959.GV12670@dastard>
References: <a08ae222-7654-4a6f-d9ba-f70017784f74@recia.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a08ae222-7654-4a6f-d9ba-f70017784f74@recia.fr>
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
To: Damien Gombault <damien.gombault@recia.fr>
Cc: xfs@oss.sgi.com

[please line wrap your email at 68-72 columns]

On Wed, Jun 22, 2016 at 04:45:19PM +0200, Damien Gombault wrote:
> Hi.
> 
> I have reported few weeks ago a bug on the Red Hat Bugzilla for
> CentOS 7 : https://bugzilla.redhat.com/show_bug.cgi?id=1341126 I
> had to restore a level0+level1 dump for my ownCloud server, but
> during the level1 restoration, xfsrestore showed many warnings and
> some directories/files were not restored.  I recently tried to
> restore a more recent level0+level1 dump and I get the same
> results with other directories/files.  I tried to figure out why
> and now I am able to reproduce the problem with a minimal test
> case.
> 
> Here is the test case :

<snip test case>

It's hard to understand xfsrestore problems without the xfsdump
output that generated the dumps being restored.

What is the (verbose) output of xfsdump under this test?

....
> xfsrestore: level: 0
> xfsrestore: session label: "test"
> xfsrestore: media label: "test"
...
> xfsrestore: directory 2048 0 (0): updating
> xfsrestore: dirent dira 2051 0: adding (new)
> xfsrestore: directory 2051 0 (0): upgrading to dir
> xfsrestore: dirent filea 2052 0: adding (new)
> xfsrestore: 2 directories and 2 entries processed

Which is correct.

....

> xfsrestore: level: 1
> xfsrestore: session label: "test"
> xfsrestore: media label: "test"
....
> xfsrestore: directory 2048 0 (0): updating
> xfsrestore: dirent dirA 2051 0: renaming (name)
> xfsrestore: directory 2051 0 (0): updating
> xfsrestore: dirent filea 2052 0: retaining (nondir)
> xfsrestore: dirent dirb 526336 1283006502: adding (new)
> xfsrestore: directory 526336 1283006502 (1283006502): upgrading to dir
> xfsrestore: dirent fileb 526337 1283006502: adding (new)
> xfsrestore: 3 directories and 4 entries processed

So the inventory looks ok....

> xfsrestore: rename dir dira to orphanage/2051.0
> xfsrestore: making new directories
> xfsrestore: performing directory renames
> xfsrestore: rename dir orphanage/2051.0 to dirA

And the rename occurs...

> xfsrestore: processing hard links
> xfsrestore: processing hardlinks to 2052 0
> xfsrestore: processing hardlinks to 526337 1283006502
> xfsrestore: getting next media file for non-dir restore
> xfsrestore: Media_mfile_next: purp==2 pos==3
> xfsrestore: dump session label: "test"
> xfsrestore: dump session id: 27606c57-7b3b-43ff-83b9-69158e75f612
> xfsrestore: stream 0, object 0, file 0
> xfsrestore: restoring non-directory files
> xfsrestore: media file 0 in object 0 of stream 0
> xfsrestore: file 0 in stream, file 0 in dump 0 on object
> xfsrestore: restoring dirA/dirb/fileb (526337 1283006502)
> xfsrestore: restoring regular file ino 526337 dirA/dirb/fileb
> xfsrestore: WARNING: open of dirA/dirb/fileb failed: Aucun fichier ou dossier de ce type: discarding ino 526337

But it seems that dirb hasn't been created before the file in it
is being restored. THis can happen because the inventory is not
correct, whichmay in fact be a problem with dump rather than
restore...

I'll have a bit of a play around here, see if I can reproduce it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
