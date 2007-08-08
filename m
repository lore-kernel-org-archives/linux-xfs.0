Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 09:22:41 -0700 (PDT)
Received: from moving-picture.com (mpc-26.sohonet.co.uk [193.203.82.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78GMYbm000519
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 09:22:36 -0700
Message-ID: <46B9E98D.9070401@moving-picture.com>
Date: Wed, 08 Aug 2007 17:04:29 +0100
From: James Pearson <james-p@moving-picture.com>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, James Braid <jamesb@loreland.org>
Cc: Eric Sandeen <sandeen@sandeen.net>

>> That's odd.  You have the module on the server, exporting an xfs
>> filesystem, and you're getting permission denied on the client?
> 
> Yep. And rmmod'ing the updated XFS module and insmod'ing the older  
> module makes it work again.

The 'stock' RHEL4/CentOS4 kernels don't have xfs modules - so, I guess 
you have rebuilt your kernel with the XFS code that is there by default?

If this is the case, then this _may be_ the cause of the problem ... the 
updated xfs module code uses any existing XFS configs in the kernel you 
are building against - the Makefile states:

# Set up our config.
#
# If the kernel already has an XFS config, use it.
# Else if config.xfs is here, use it for our config.  Otherwise,
# Else default to only CONFIG_XFS_FS=m (simplest config)

The problem is that the 'stock' 2.6.9 kernel doesn't define (or use) 
CONFIG_XFS_EXPORT - but the updated xfs module code requires this to 
allow NFS exports of a XFS file system ...

So my guess is that your re-built updated xfs modules don't use
CONFIG_XFS_EXPORT

I guess with a bit of hacking to the Makefile, you could force 
'CONFIG_XFS_EXPORT=y' to be added - you might even be able to do this 
via the rpmbuild command line ... although I don't know how.

James Pearson
