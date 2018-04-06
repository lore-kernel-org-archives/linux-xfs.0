Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:30079 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751573AbeDFBSN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 21:18:13 -0400
Date: Fri, 6 Apr 2018 11:18:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Question] Behaviour of directory listing in XFS with concurrent
 deletes
Message-ID: <20180406011808.GQ23861@dastard>
References: <BLUPR0601MB0929603CF85A26259FA94D32F1BB0@BLUPR0601MB0929.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BLUPR0601MB0929603CF85A26259FA94D32F1BB0@BLUPR0601MB0929.namprd06.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Vairavanathan, Emalayan" <Emalayan.Vairavanathan@netapp.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Thu, Apr 05, 2018 at 11:53:18PM +0000, Vairavanathan, Emalayan wrote:
> Hi There,
> 
> 
> We have an application that  iterates through a large directory
> (that has around 1.2 million files)  and lists the names of all
> the files in the directory. 
> 
> Files stored in the directory could be concurrently deleted by
> another thread in the application while the application lists the
> files. 

XFS complies with Posix requirements for stable directory offsets.
i.e. that dirents don't change offset when other dirents are added
or removed. Hence sequential readdir calls will always start off at
the dirent offset the last call finished at.

However, this guarantees nothing about individual dirent state
when concurrent modifications occur between readdir calls.

> Our application can tolerate false positives when listing a
> directory. However false negatives in directory listing *cannot*
> be tolerated.
> 
> To this end could someone tell  me how directory listing in XFS
> behaves with concurrent deletes? Is it  possible to see false
> negatives ?

What's does "false-negative" mean? I don't know what your
application is trying to do, so I don't know what your failure
criteria is....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
