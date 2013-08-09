Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AEBA7F5D
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 09:00:58 -0500 (CDT)
Date: Fri, 9 Aug 2013 09:00:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [v2 PATCH 8/14] xfsprogs: fix issues with e0607266f23
Message-ID: <20130809140057.GU1681@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808215330.GV3111@sgi.com> <52041686.4040703@sandeen.net>
	<5204183E.2000902@sandeen.net> <20130808222821.GY3111@sgi.com>
	<52042937.6050702@sandeen.net> <52042B04.7070707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52042B04.7070707@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Aug 08, 2013 at 06:34:28PM -0500, Eric Sandeen wrote:
> On 8/8/13 6:26 PM, Eric Sandeen wrote:
> > On 8/8/13 5:28 PM, Ben Myers wrote:
> >> * remove unused uuid unparse in xfs_agf_verify
> >> * fix an unnecessary loop in clear_dinode_core
> > 
> > These should be 2 commits (they do 2 different things),
> > with properly descriptive summaries & changelogs.
> > 
> > For the 2nd, it's not an unnecessary loop, it's a memory
> > corruptor; that should be noted in the changelog.
> > 
> > TBH I've only reviewed the latter, I need to look at
> > the first.
> 
> Yup the first is fine too, but should be a separate commit.

Sounds good, thanks Eric.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
