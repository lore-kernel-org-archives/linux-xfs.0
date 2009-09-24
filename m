Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8O0qsEV049432 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 19:52:55 -0500
Received: from mail.phy.duke.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AA0C47875F
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 17:54:13 -0700 (PDT)
Received: from mail.phy.duke.edu (mail.phy.duke.edu [152.3.182.2]) by
	cuda.sgi.com with ESMTP id RqGQui78RIjgAfR9 for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 17:54:13 -0700 (PDT)
Date: Wed, 23 Sep 2009 20:54:08 -0400 (EDT)
From: Jimmy Dorff <jdorff@phy.duke.edu>
Subject: Re: problems with xfs_growfs after lvextend
In-Reply-To: <4ABAB6AD.6080604@thebarn.com>
Message-ID: <Pine.LNX.4.64.0909232051460.15004@login2.phy.duke.edu>
References: <4ABA8D56.2040101@phy.duke.edu> <4ABA9523.60909@thebarn.com>
	<Pine.LNX.4.64.0909231918400.14750@login2.phy.duke.edu>
	<4ABAB6AD.6080604@thebarn.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

On Wed, 23 Sep 2009, Russell Cattelan wrote:
> Ok good things look ok.
> run xfs_db -x to put it into expert mode
> use the write cmd to modify your sb 0 values back to what they were.
>
>> sb 0 w dblocks = 1610612736 w agcount = 32
>

That worked perfectly! Much thanks!!

-Jimmy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
