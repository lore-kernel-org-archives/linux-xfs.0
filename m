Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14099 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbeLKV1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 16:27:07 -0500
Date: Wed, 12 Dec 2018 08:27:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I got file system corruption with XFS
Message-ID: <20181211212701.GE6311@dastard>
References: <20181211183203.7fdbca0f@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211183203.7fdbca0f@lud1.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 11, 2018 at 06:32:03PM -0200, Luciano ES wrote:
> I needed to restore something from my backups, an external hard disk 
> that is kept separately, always disconnected until I really need it. 
> 
> But the file system refused to be mounted: "structure needs cleaning," 
> it said.
> 
> I googled and didn't find much hope about it. I followed what little 
> advice I found: I ran xfs_repair and it didn't work. So I ran it 
> again with -L and it worked, but the software itself warned me that 
> some files could not be recovered. I'll never know which ones.
> 
> I always liked XFS and thought those dreaded days of file system 
> corruption and lost files were far behind. So my only question is: 
> Why does that happen? The disk is not even used 99% of the time.
> How does an XFS file system go belly up just like that?

What was the actual error message?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
