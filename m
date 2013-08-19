Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D8177F84
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 09:10:25 -0500 (CDT)
Message-ID: <5212277D.2070307@sgi.com>
Date: Mon, 19 Aug 2013 09:11:09 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests 314: user namespace uid/gids in an ACL
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
	<20130627120340.20e494ad@oracle.com>
In-Reply-To: <20130627120340.20e494ad@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com



On 06/27/2013 11:03 AM, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

> +#! /bin/bash
> +# FS QA Test No. 314
> +#
> +# Check get/set ACLs to/from disk with a user namespace. A new file
> +# will be created and ACLs set on it from both inside a userns and
> +# from init_user_ns. We check that the ACL is is correct from both
> +# inside the userns and also from init_user_ns. We will then unmount
> +# and remount the file system and check the ACL from both inside the
> +# userns and from init_user_ns to show that the correct uid/gid in
> +# the ACL was flushed and brought back from disk.
> +#
...
> +
> +_print_getfacls()
> +{
> +    echo "From init_user_ns"
> +    getfacl -n $file 2>/dev/null | _getfacl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"

I think you need to loose the last sed command and use the getfacl flag 
--absolute-names and pipe it to _filter_scratch like this:

getfacl --absolute-names -n $file 2>/dev/null | _filter_scratch | 
_getfacl_filter_id

> +
> +    echo "From user_ns"
> +    $nsexec -U -M "0 $acl1 1000" -G "0 $acl2 1000" getfacl -n $file  2>/dev/null | _getfacl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
Same as above.
...
Also need to update 314.out

I tested with these changes as test 316 but not sure if the new output 
is correct.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
