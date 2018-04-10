Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59259 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751630AbeDJJUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 05:20:04 -0400
Date: Tue, 10 Apr 2018 19:20:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Question] Behaviour of directory listing in XFS with concurrent
 deletes
Message-ID: <20180410092001.GW23861@dastard>
References: <BLUPR0601MB0929603CF85A26259FA94D32F1BB0@BLUPR0601MB0929.namprd06.prod.outlook.com>
 <20180406011808.GQ23861@dastard>
 <BLUPR0601MB0929F6CB22C71DE3E6E65F28F1BF0@BLUPR0601MB0929.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BLUPR0601MB0929F6CB22C71DE3E6E65F28F1BF0@BLUPR0601MB0929.namprd06.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Vairavanathan, Emalayan" <Emalayan.Vairavanathan@netapp.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

[ Please word wrap your emails at 72 columns! ]

On Tue, Apr 10, 2018 at 12:24:55AM +0000, Vairavanathan, Emalayan
wrote:
> Hi Dave,
> 
> Thank you for getting back to me. Please see my response inline.
> 
> >> What's does "false-negative" mean?  I don't know what your
> >> application is trying to do, so I don't know what your failure
> >> criteria is...
> 
> Assume the following :
> 
> 1) No failures (application crash OR disk / sector errors OR any
> form of disk or memory corruption)
> 2) xfs file-system is mounted with dirsync option.
> 3) A directory in XFS with 1.2 million files. fsync() was called
> on each file after creation.

Directory Size, dirsync, fsync, and failures are irrelevant to
readdir vs concurrent unlink behaviour.

> 4) An application with two threads (Thread-A and Thread-B) that
> uses this directory. Thread-A iterates through the directory and
> lists the names of all the files in the directory using readdir
> calls. The Thread-B  concurrently deletes some files from the
> directory.
> 5) Files can be only deleted from the directory. No new files will
> be created once the directory listing is started and we have a
> coordination layer to ensure this. 

> Given this context:
> - False-positive means a file that was deleted by Thread-B is seen
> by Thread-A. 
> - False-negative means a file that is already in the directory is
> not seen by Thread-A (due to concurrent deletes of some other
> files in the directory).
> 
> Does this make sense ?

Yes.

> I know that false-positives are possible in this context.

Right, POSIX explicitly states that behaviour of readdir() w.r.t.
files added/deleted after opendir()/rewinddir() is unspecified.

> Is it possible to see false negatives in this
> context? 

No.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
