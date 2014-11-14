Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 769AE7F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:57:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54AB38F8040
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 10:57:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6bAOPCI1P9kaFnXG for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 10:57:46 -0800 (PST)
Message-ID: <546650A8.9030002@sandeen.net>
Date: Fri, 14 Nov 2014 12:57:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V7
References: <1415989940-20004-1-git-send-email-cmaiolino@redhat.com>
	<1415989940-20004-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1415989940-20004-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 11/14/14 12:32 PM, Carlos Maiolino wrote:
> Adds a new function named xfs_cross_rename(), responsible to handle requests
> from sys_renameat2() using RENAME_EXCHANGE flag.

I really hate to do this, but, here:

> +	/*
> +	* If we're renaming one or more directories across different parents,
> +	* update the respective ".." entries (and link counts) to match the new
> +	* parents.
> +	*/

and here:
 
>  	/*
> +	 * Handle RENAME_EXCHANGE flags
> +	*/

there are whitespace issues w/ the comments (need a " " before the "*")

who knows, maybe Dave can fix them on commit ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
