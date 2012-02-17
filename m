Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HCXo1K081575 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 06:33:50 -0600
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 7hNAKCCAskiG2wN1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 04:33:48 -0800 (PST)
Date: Fri, 17 Feb 2012 13:33:35 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Problems with filesizes on different Kernels
Message-ID: <20120217123335.GA9671@citd.de>
References: <4F3E3F5A.9000202@innogames.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3E3F5A.9000202@innogames.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bernhard Schrader <bernhard.schrader@innogames.de>
Cc: xfs@oss.sgi.com

On 17.02.2012 12:51, Bernhard Schrader wrote:
> Hi all,
> 
> we just discovered a problem, which I think is related to XFS. Well,
> I will try to explain.
> 
> The environment i am working with are around 300 Postgres databases
> in separated VM's. All are running with XFS. Differences are just in
> kernel versions.
> - 2.6.18
> - 2.6.39
> - 3.1.4
> 
> Some days ago i discovered that the file nodes of my postgresql
> tables have strange sizes. They are located in
> /var/lib/postgresql/9.0/main/base/[databaseid]/
> If I execute the following commands i get results like this:
> 
> Command: du -sh | tr "\n" " "; du --apparent-size -h
> Result: 6.6G	. 5.7G	.

Since a few kernel-version XFS does speculative preallocations, which is 
primarily a measure to prevent fragmentation.

The preallocations should go away when you drop the caches.

sync
echo 3 > /proc/sys/vm/drop_caches

XFS can be prevented to do that with the mount-option "allocsize". 
Personally i use "allocsize=64k", since i first encountered that 
behaviour, my workload primarily consists of single-thread writing which 
doesn't benefit from this preallocation.
Your workload OTOH may benefit as it should prevent/lower the 
fragmentation of the database files.






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
