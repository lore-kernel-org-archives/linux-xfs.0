Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C60D67CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:46:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A19B3304039
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:46:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5MBnycVMqfGUDBIV for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 14:46:28 -0700 (PDT)
Date: Sat, 27 Apr 2013 07:46:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs module insert fails with "xfs: Unknown symbol
	exportfs_decode_fh (err 0)"
Message-ID: <20130426214626.GB30622@dastard>
References: <1366997050.4098.14.camel@chandra-dt.ibm.com>
	<20130426181624.GG29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130426181624.GG29359@sgi.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, XFS mailing list <xfs@oss.sgi.com>

On Fri, Apr 26, 2013 at 01:16:24PM -0500, Ben Myers wrote:
> Hey Chandra,
> 
> On Fri, Apr 26, 2013 at 12:24:09PM -0500, Chandra Seetharaman wrote:
> > When I tried to insert xfs module in my test machine it failed with 
> > 
> > 	xfs: Unknown symbol exportfs_decode_fh (err 0).
> > 
> > Found out that I did not have CONFIG_EXPORTFS enabled in my kernel
> > config. 
> 
> Most people are running with NFS enabled in their kernel config, I think.
> 
> > All .*by_handle code in XFS is open coded. Wondering if they should be
> > under #ifdef CONFIG_EXPORTFS ?
> >
> > I can create a patch, but wanted to find out if it is indeed needed :)
> 
> foo_by_handle
>   xfs_handlereq_to_dentry
>     xfs_handle_to_dentry
>       exportfs_decode_fh
> 
> xfsdump does open by handle, so making that conditional on CONFIG_EXPORTFS will
> break things.  I think would be better to just make CONFIG_XFS depend upon
> CONFIG_EXPORTFS in fs/xfs/Kconfig.  Looks like we'll have the same problem with
> libcrc32c.

AFAIK, "select" isthe right keyword for these dependencies. They are
like saying "depends on", but instead of having the XFS config options
only appear in the menus if CONFIG_EXPORTFS is selected, it will
select CONFIG_EXPORTFS=y when CONFIG_XFS_FS=y....

So I don't think there are any problems here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
