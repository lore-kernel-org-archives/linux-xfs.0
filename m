Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF647801D
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 09:13:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92486304032
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 07:13:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gA3uCEYfunk6dFYu for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 07:13:47 -0700 (PDT)
Message-ID: <51432C9A.2010407@sandeen.net>
Date: Fri, 15 Mar 2013 09:13:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 14/18] xfstests: remove -x functionality
References: <20130314130611.A163253DEAFB@polaris-admin.engr.sgi.com>
In-Reply-To: <20130314130611.A163253DEAFB@polaris-admin.engr.sgi.com>
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
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On 3/14/13 8:06 AM, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> Now that there are no tests in the top level directory, the exlude
> group functionality no longer works (-x group) as it cannot find
> tests to build an initial list of tests. Rework the the exclude
> group implementation to operate correctly on the new test locations.
> 
> Also, swtich from sed to grep for exclusion because sed has problems
> distnguishing the '/' in path names from regex control...
> -----------------
> This one is mildly different from the original as it modifies infrastructure
> which remains in common.  In Dave's original patch, that had all been moved
> into check.

And the rationale for the change from the original is what?  Changelogs are better with reasoning, than with just descriptions of change.

Just a style note - it's not great form to take someone else's large body of work, tweak it, then claim authorship (From:) and sign-off (Signed-off-by:).  If it were me, I might be a little tweaked.  It's probably an oversight, and maybe Dave doesn't even care, but it's my pet peeve.

Since Dave has rebased & resent the original patchset he wrote, it might be better, going forward, for you guys to try to reach agreement on any necessary changes to his body of work, and get that committed.  Unless we want to carry on w/ dueling patchsets, which doesn't sound optimal to me.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
