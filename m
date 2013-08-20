Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8AFD57FB4
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 17:25:32 -0500 (CDT)
Date: Tue, 20 Aug 2013 17:25:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/3] Add a new quotactl command to support 3 quota
	types in XFS
Message-ID: <20130820222528.GG5262@sgi.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Abhijith Das <adas@redhat.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Hi Chandra,

On Tue, Aug 06, 2013 at 05:27:06PM -0500, Chandra Seetharaman wrote:
> XFS now supports simultaneous use of 3 quota types (user, group,
> and project).
> 
> In order to support this a new quotactl command is introduced
> in this patch series.

I've applied patches 1 and 2 at git://oss.sgi.com/xfs/xfs.git, master branch.
I think patch 3 should go through the gfs2 tree.

Steven, I think if you want to pull in patch 3 you'll also need patch 1.  Maybe
the easiest way is to cherry pick it from the xfs tree?  If you do we'll have a
trivial merge conflict.  Anyway, it's af30cb446dd5 if you want.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
