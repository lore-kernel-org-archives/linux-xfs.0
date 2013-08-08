Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3A847F8D
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 18:34:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE775304066
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:34:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id L0POOjoFT0oQajNK for <xfs@oss.sgi.com>;
	Thu, 08 Aug 2013 16:34:30 -0700 (PDT)
Message-ID: <52042B04.7070707@sandeen.net>
Date: Thu, 08 Aug 2013 18:34:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [v2 PATCH 8/14] xfsprogs: fix issues with e0607266f23
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808215330.GV3111@sgi.com> <52041686.4040703@sandeen.net>
	<5204183E.2000902@sandeen.net> <20130808222821.GY3111@sgi.com>
	<52042937.6050702@sandeen.net>
In-Reply-To: <52042937.6050702@sandeen.net>
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
Cc: xfs@oss.sgi.com

On 8/8/13 6:26 PM, Eric Sandeen wrote:
> On 8/8/13 5:28 PM, Ben Myers wrote:
>> * remove unused uuid unparse in xfs_agf_verify
>> * fix an unnecessary loop in clear_dinode_core
> 
> These should be 2 commits (they do 2 different things),
> with properly descriptive summaries & changelogs.
> 
> For the 2nd, it's not an unnecessary loop, it's a memory
> corruptor; that should be noted in the changelog.
> 
> TBH I've only reviewed the latter, I need to look at
> the first.

Yup the first is fine too, but should be a separate commit.

Thanks,
-Eric

> -Eric
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
