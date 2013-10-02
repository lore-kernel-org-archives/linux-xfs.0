Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 812CD7FA1
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 15:54:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5BFD78F8054
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 13:54:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DwrMzGaaJr1LWj5q for <xfs@oss.sgi.com>;
	Wed, 02 Oct 2013 13:54:06 -0700 (PDT)
Message-ID: <524C87EC.7070909@sandeen.net>
Date: Wed, 02 Oct 2013 15:54:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] misc kernel leak patches
References: <20131002125110.745269864@sgi.com>
In-Reply-To: <20131002125110.745269864@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 10/2/13 7:51 AM, Mark Tinguely wrote:
> Here are a couple patches to free leaked memory.
> 
> First patch is v2 of a Coverity found leak in xfs_dir2_node_removename().
> 
> Second patch arose from an eariler leak found by Coverity. In looking
> at that patch, Eric noted that it appeared that the transaction's
> item list is also leaked if recovery fails. I tested this patch by forcing
> errors into the recovery code to verify that the items are now being released.
> 
> I will send patches for xfsprogs equivalent.

Good plan w.r.t. kernel first, progs 2nd, I think.  Makes it less likely
to accidentally send a free(); or similar upstream.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
