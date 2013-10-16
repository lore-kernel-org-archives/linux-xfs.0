Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 068607F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 16:52:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B6EB304048
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 14:51:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fv9JpmHhF3MEV3KE for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 14:51:56 -0700 (PDT)
Date: Thu, 17 Oct 2013 08:51:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
Message-ID: <20131016215153.GK4446@dastard>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
	<525EAC5F.3040201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525EAC5F.3040201@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, Filipe David Borba Manana <fdmanana@gmail.com>, jbacik@fusionio.com, dsterba@suse.cz

On Wed, Oct 16, 2013 at 10:10:23AM -0500, Eric Sandeen wrote:
> On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
> > This test is motivated by an issue found by a btrfs user, addressed
> > and described by the following GNU/Linux kernel patch:
> > 
> > https://patchwork.kernel.org/patch/3046931/
> 
> Hi Filipe, thanks for the patch.
> 
> Usually we don't want to add new, possibly-failing cases to old tests;
> that makes it harder to identify when the code regressed vs. when
> the test changed to test new things.
> 
> It would be better to just copy the framework of tests/shared/051
> to a new test in shared/ and test only this new inheritance
> problem.
> 
> Also, I'm confused about this hunk:
> 
> > @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
> >  getfacl --numeric largeaclfile | _filter_aces
> >  
> >  echo "1 above xfs acl max"
> > -chacl $acl3 largeaclfile
> > +if [ "$FSTYP" != "btrfs" ]; then
> > +	chacl $acl3 largeaclfile
> > +else
> > +	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
> > +fi
> > +
> >  getfacl --numeric largeaclfile | _filter_aces
> >  
> >  echo "use 16 aces"
> 
> What's that about?

That's working around the "XFS only supports 25 ACLs test".

Another reason for making this a separate, generic test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
