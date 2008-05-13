Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 23:23:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D6NSdt026318
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 23:23:30 -0700
Message-ID: <4829340B.4090708@sgi.com>
Date: Tue, 13 May 2008 16:24:11 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] xfsqa 008 takes too long on UML...
References: <20080512110134.GH155679365@sgi.com>
In-Reply-To: <20080512110134.GH155679365@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Sounds reasonable to me.
Might be nice to have the description as a comment in the test
so it is easy to see the thought behind the calculations
in the future.

--Tim

David Chinner wrote:
> With the recent change for reliability with 64k page size
> made to test 008,the file sizes got much larger. It appears
> that randholes actually reads the entire file, so this has
> slowed the test down by a factor of ten (all file sizes
> were increased by 10x). This means the test is now taking
> about 18 minutes to run on a UML session, and all the time
> is spent reading the files.
> 
> Instead, scale the file size based on the page size. We know
> how many holes we are trying to produce and the I/O size
> being used to produce them, so the size of the files can be
> finely tuned. Assuming a decent random distribution, if the
> number of blocks in the file is 4x the page size and the
> I/O size is page sized, this means that every I/O should
> generate a new hole and we'll only get a small amount of
> adjacent extents. This has passed over 10 times on ia64
> w/ 64k page and another 15 times on UML with 4k page.
> 
> UML runtime is down from ~1000s to 5s, ia64 runtime is down from
> ~30s to 7s.
> 
> Cheers,
> 
> Dave.
