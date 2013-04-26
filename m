Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 374637CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:16:25 -0500 (CDT)
Date: Fri, 26 Apr 2013 13:16:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs module insert fails with "xfs: Unknown symbol
	exportfs_decode_fh (err 0)"
Message-ID: <20130426181624.GG29359@sgi.com>
References: <1366997050.4098.14.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366997050.4098.14.camel@chandra-dt.ibm.com>
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

Hey Chandra,

On Fri, Apr 26, 2013 at 12:24:09PM -0500, Chandra Seetharaman wrote:
> When I tried to insert xfs module in my test machine it failed with 
> 
> 	xfs: Unknown symbol exportfs_decode_fh (err 0).
> 
> Found out that I did not have CONFIG_EXPORTFS enabled in my kernel
> config. 

Most people are running with NFS enabled in their kernel config, I think.

> All .*by_handle code in XFS is open coded. Wondering if they should be
> under #ifdef CONFIG_EXPORTFS ?
>
> I can create a patch, but wanted to find out if it is indeed needed :)

foo_by_handle
  xfs_handlereq_to_dentry
    xfs_handle_to_dentry
      exportfs_decode_fh

xfsdump does open by handle, so making that conditional on CONFIG_EXPORTFS will
break things.  I think would be better to just make CONFIG_XFS depend upon
CONFIG_EXPORTFS in fs/xfs/Kconfig.  Looks like we'll have the same problem with
libcrc32c.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
