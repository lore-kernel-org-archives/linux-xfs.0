Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50215 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdGGPgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jul 2017 11:36:44 -0400
Date: Fri, 7 Jul 2017 08:36:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170707153633.GG4103@magnolia>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
 <20170706232803.GF17762@dastard>
 <20170707135009.68c22182@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170707135009.68c22182@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Fri, Jul 07, 2017 at 01:50:09PM +0200, Emmanuel Florac wrote:
> Le Fri, 7 Jul 2017 09:28:03 +1000
> Dave Chinner <david@fromorbit.com> écrivait:
> 
> > > disconnected inode 26417468, moving to lost+found
> > > disconnected inode 26417469, moving to lost+found
> > > disconnected inode 26417470, moving to lost+found
> > > 
> > > fatal error -- name create failed in lost+found (117), filesystem
> > > may be out of space  
> > 
> > Error 117. That's EFSCORRUPTED, not ENOSPC.  IOWs, lost+found was
> > corrupted as it was being modified by xfs_repair.
> > 
> > > Even stranger, after mounting back the image, there is no lost+found
> > > anywhere to be found! However the filesystem has lots of free space
> > > and free inodes, how come?  
> > 
> > Because lost+found was corrupted.
> 
> Actually with xfs_repair 4.11 it's a different error in the end:
> 
> disconnected inode 180399699751, moving to lost+found
> disconnected inode 180399699752, moving to lost+found
> 
> fatal error -- name create failed in lost+found (28), filesystem may be
> out of space

Would be helpful to have a metadump of this goobered-up lost+found fs...

--D

> 
> 
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


