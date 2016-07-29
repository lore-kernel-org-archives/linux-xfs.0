Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EB537CA0
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 21:34:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2ED958F8049
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 19:34:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	e0ANTryCZT9AT63X for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2016 19:34:24 -0700 (PDT)
Date: Fri, 29 Jul 2016 12:33:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Any better way to interact with xfs?
Message-ID: <20160729023333.GB16044@dastard>
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
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
To: Ryan Lindsay <rlindsay@unimelb.edu.au>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jul 28, 2016 at 03:30:16AM +0000, Ryan Lindsay wrote:
> Hi
> 
> I have a bit of a specific requirement.
> 
> I have a server that currently has a 12T worth of data on it on an
> xfs formatted LV.
> 
> currently the file permissions are set via an LDAP, however we are
> having to move to AD for out authentication mechanism. Which will
> change the value of the existing UID's and GID's
> 
> Since XFS has a lot of mechanisms that allow things to happen in
> parallel. I was wondering if there was a way of interacting at the
> file system level to facilitate a change of UID's on files rather
> than having to just chown recursively down the file system. The
> faster I can update the permissions the better basically

The directory structure can be modified in parallel, so simply run
multiple recursive chowns down separate branches of the directory
tree on the filesystem. That will run as fast as your IO subsystem
will let it.

e.g. I can remove a 16-subdirectory wide tree with 50 million files
in it using 16 "rm -rf subdir.$i" commands in about 4 minutes. It
runs at 12,000 read IOPS doing it that. i.e. it runs as fast as the
underlying storage can read the directory and inodes into cache. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
