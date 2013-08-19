Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 755B47F87
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 12:34:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 452B4304077
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 10:34:30 -0700 (PDT)
Date: Mon, 19 Aug 2013 13:34:34 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH 3/3] xfstests 314: user namespace uid/gids in an ACL
Message-ID: <20130819133434.2749dfe8@oracle.com>
In-Reply-To: <5212277D.2070307@sgi.com>
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
	<20130627120340.20e494ad@oracle.com> <5212277D.2070307@sgi.com>
Mime-Version: 1.0
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 19 Aug 2013 09:11:09 -0500
Rich Johnston <rjohnston@sgi.com> wrote:

> 
> 
> On 06/27/2013 11:03 AM, Dwight Engen wrote:
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> 
> > +#! /bin/bash
> > +# FS QA Test No. 314
> > +#
> > +# Check get/set ACLs to/from disk with a user namespace. A new file
> > +# will be created and ACLs set on it from both inside a userns and
> > +# from init_user_ns. We check that the ACL is is correct from both
> > +# inside the userns and also from init_user_ns. We will then
> > unmount +# and remount the file system and check the ACL from both
> > inside the +# userns and from init_user_ns to show that the correct
> > uid/gid in +# the ACL was flushed and brought back from disk.
> > +#
> ...
> > +
> > +_print_getfacls()
> > +{
> > +    echo "From init_user_ns"
> > +    getfacl -n $file 2>/dev/null | _getfacl_filter_id | sed -e
> > "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
> 
> I think you need to loose the last sed command and use the getfacl
> flag --absolute-names and pipe it to _filter_scratch like this:
> 
> getfacl --absolute-names -n $file 2>/dev/null | _filter_scratch | 
> _getfacl_filter_id

Yep good catch, the scratch mount point was making it into the .out file.

> > +
> > +    echo "From user_ns"
> > +    $nsexec -U -M "0 $acl1 1000" -G "0 $acl2 1000" getfacl -n
> > $file  2>/dev/null | _getfacl_filter_id | sed -e
> > "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
> Same as above.
> ...
> Also need to update 314.out
> 
> I tested with these changes as test 316 but not sure if the new
> output is correct.

Yes it looks correct with these changes, updated patch to follow.

> --Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
