Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B169A7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 20:24:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F24A304067
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 18:24:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pFUfpTdDZUAnStHh for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 18:24:26 -0700 (PDT)
Message-ID: <533620C8.1010204@sandeen.net>
Date: Fri, 28 Mar 2014 20:24:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Exponential memory usage?
References: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
In-Reply-To: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
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
To: Tap <tap@anti-paladin.com>, xfs@oss.sgi.com

On 3/28/14, 12:53 PM, Tap wrote:
> I have a Linux CentOs-based (6.5) system, running Linux 3.10.29
> beneath xen 4.2.3-26 with a raid array as follows:

<snip>

> Anyway at some point the system had become unusable.  Something as
> simple as:
> 
> find  /raid -type f -- or -- ls -lR /raid
> 
> Would walk the entire system out of RAM.  Looking at slabtop it looks
> like this is due mostly to xfs_inode memory usage.  Note that since
> these problems began I stopped running all sub-ordinate domains and
> am now only running dom0.  In fact I've allocated all 32 GB to that
> domain, and memory problems still persist.

Out of?  Did the OOM-killer actually show up, or did you simply see
memory usage rise?

The dcache is tenacious.  dentries are cached pretty aggressively, and
those in turn will pin the vfs/xfs inodes.

But memory is there to be used; unless you actually see problems,
then the system is likely working as it should be.

<snip>

> Note:  FWIW Un-mounting the filesystem also recovers the memory.

Yep, that would clear out the cache.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
