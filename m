Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 68B647FA0
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 21:42:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D41C8F804B
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 19:42:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	a91IdV7JIUjB0CLB for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 19:42:31 -0700 (PDT)
Date: Sat, 29 Jun 2013 12:42:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/15] xfs: dquot log reservations are too small
Message-ID: <20130629024205.GF9047@dastard>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-15-git-send-email-david@fromorbit.com>
	<1372439902.8341.155.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372439902.8341.155.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 28, 2013 at 12:18:22PM -0500, Chandra Seetharaman wrote:
> 
> some nits below on commit log and comments.
> 
> otherwise consider
> 
> Reviewed-by: Chandra Seethraman <sekharan@us.ibm.com>
> 
> On Thu, 2013-06-27 at 16:04 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > During review of the separate project quota inode patches, it bcame
> became(typo)
> 
> > obvious that the dquot log reservation calculation underestimated
> > the number dquots that can be modified in a transaction. This has
> > it's roots way back in the Irix quota implementation.
> > 
> > That is, when quotas were first implemented in XFS, it only
> > supported user and project quotas as Irix did not have group quotas.
> > Hence the worst case operation involving dquot modification was
> > calculated to involve 2 user dquots and 1 project dquot or 1 user
> > dequot and 2 project dquots. i.e. 3 dquots. This was determined back
> > in 1996, and has remained unchanged ever since.
> 
> How about the missing reservation for the log format header ? It is a
> day one problem, right ?

Yup.

> > However, back in 2001, the Linux XFS port dropped all support for
> > project quota and implmented group quotas over the top. This was
> 
> implemented(typo)
> 
> > effectively done with a search-and-replace of project with group,
> > and as such the log reservation was not changed. However, with the
> > advent of group quotas, chmod and rename now could modify more than
> > 3 dquots in a single transaction - both could modify 4 dquots. Hence
> > this log reservation has been wrong for a long time.
> > 
> > In 2005, project quotas were reintroduced into Linux, but they were
> 
> introduced ? (it was mentioned above that 2001 Linux port removed
> project quota, so it never existed in Linux ?!)

I'm talking from a code perspective, not whether they worked or not
from a user persepctive.....

> > implemented to be mutually exclusive to group quotas, and so this
> > didn't add any new changes to the dquot log reservation. hence when
> > project quotas were in use, everything was still fine, just like
> > in the Irix days.
> 
> you can say that... but, when the group quota is used the problem
> mentioned above exists.

Yes, it does. All this points out was that group quotas were broken,
not project quotas....

I'll fix up the various typos and clarify the comments as you've
suggested.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
