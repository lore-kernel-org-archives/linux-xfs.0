Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 09:09:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78G9Sbm028949
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 09:09:29 -0700
Message-ID: <46B9EABD.9010901@sandeen.net>
Date: Wed, 08 Aug 2007 11:09:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <46B9E98D.9070401@moving-picture.com>
In-Reply-To: <46B9E98D.9070401@moving-picture.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Pearson <james-p@moving-picture.com>
Cc: xfs@oss.sgi.com, James Braid <jamesb@loreland.org>

James Pearson wrote:
>>> That's odd.  You have the module on the server, exporting an xfs
>>> filesystem, and you're getting permission denied on the client?
>> Yep. And rmmod'ing the updated XFS module and insmod'ing the older  
>> module makes it work again.
> 
> The 'stock' RHEL4/CentOS4 kernels don't have xfs modules - so, I guess 
> you have rebuilt your kernel with the XFS code that is there by default?
> 
> If this is the case, then this _may be_ the cause of the problem ... the 
> updated xfs module code uses any existing XFS configs in the kernel you 
> are building against - the Makefile states:
> 
> # Set up our config.
> #
> # If the kernel already has an XFS config, use it.
> # Else if config.xfs is here, use it for our config.  Otherwise,
> # Else default to only CONFIG_XFS_FS=m (simplest config)
> 
> The problem is that the 'stock' 2.6.9 kernel doesn't define (or use) 
> CONFIG_XFS_EXPORT - but the updated xfs module code requires this to 
> allow NFS exports of a XFS file system ...
> 
> So my guess is that your re-built updated xfs modules don't use
> CONFIG_XFS_EXPORT
> 
> I guess with a bit of hacking to the Makefile, you could force 
> 'CONFIG_XFS_EXPORT=y' to be added - you might even be able to do this 
> via the rpmbuild command line ... although I don't know how.

Ah, that may well be it.  yeah, the rpm needs to set its own config
options since the centos kernel has no xfs config.  (Sorry, I just
haven't had time to look into it yet) - but I bet you're right that
setting the config option in the makefile in the rpm will fix things
right up!

-Eric
