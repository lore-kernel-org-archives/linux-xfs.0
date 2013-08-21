Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 418407FCB
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 07:42:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1FDAAC001
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 05:42:28 -0700 (PDT)
Subject: Re: [PATCH 0/3] Add a new quotactl command to support 3 quota
	types in XFS
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20130820222528.GG5262@sgi.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<20130820222528.GG5262@sgi.com>
Date: Wed, 21 Aug 2013 13:28:02 +0100
Message-ID: <1377088082.2738.19.camel@menhir>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Abhijith Das <adas@redhat.com>, Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

Hi,

On Tue, 2013-08-20 at 17:25 -0500, Ben Myers wrote:
> Hi Chandra,
> 
> On Tue, Aug 06, 2013 at 05:27:06PM -0500, Chandra Seetharaman wrote:
> > XFS now supports simultaneous use of 3 quota types (user, group,
> > and project).
> > 
> > In order to support this a new quotactl command is introduced
> > in this patch series.
> 
> I've applied patches 1 and 2 at git://oss.sgi.com/xfs/xfs.git, master branch.
> I think patch 3 should go through the gfs2 tree.
> 
> Steven, I think if you want to pull in patch 3 you'll also need patch 1.  Maybe
> the easiest way is to cherry pick it from the xfs tree?  If you do we'll have a
> trivial merge conflict.  Anyway, it's af30cb446dd5 if you want.
> 
> Thanks,
> 	Ben

I think it would be better if all the patches went through the same tree
to save issues with dependencies. I don't mind if you want to put the
gfs2 patches in the xfs tree to keep everything in the same place. There
are no current quota changes in the gfs2 tree, so there should not be a
conflict due to that.

Also, it would be good if Christoph's comments could be addressed too,

Steve.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
