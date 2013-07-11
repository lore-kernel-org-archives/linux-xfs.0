Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D64DD7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 16:41:47 -0500 (CDT)
Date: Thu, 11 Jul 2013 16:41:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix the logic check for all quotas being turned off
Message-ID: <20130711214144.GD20932@sgi.com>
References: <1373497236.6020.36.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373497236.6020.36.camel@chandra-dt.ibm.com>
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
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed, Jul 10, 2013 at 06:00:36PM -0500, Chandra Seetharaman wrote:
> 
> During the review of seperate pquota inode patches, David noticed
> that the test to detect all quotas being turned off was
> incorrect, and hence the block was not freeing all the quota
> information.
> 
> The check made sense in Irix, but in Linux, quota is turned off
> one at a time, which makes the test invalid for Linux.
> 
> This problem existed since XFS was ported to Linux.
> 
> David suggested to fix the problem by detecting when all quotas are
> turned off by checking m_qflags.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

This looks ok to me. 

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
