Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 08:30:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4DFUHUO017329
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 08:30:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26D9B16A8378
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 08:31:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BVPwtbVeNCAHzZAW for <xfs@oss.sgi.com>; Tue, 13 May 2008 08:31:04 -0700 (PDT)
Message-ID: <4829B435.10200@sandeen.net>
Date: Tue, 13 May 2008 10:31:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org> <20080513090311.GZ155679365@sgi.com> <20080513092156.GA26736@infradead.org> <20080513092851.GA19879@infradead.org>
In-Reply-To: <20080513092851.GA19879@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Georgi Chorbadzhiyski <gf@unixsol.org>, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net, Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, May 13, 2008 at 05:21:56AM -0400, Christoph Hellwig wrote:
>> Well, we could refcount the number of active xfs instances and
>> start/stop the global threads based on that.  Not really worth my
>> time IHMO, but if someone comes up with a clean enough patch it should
>> go in.
> 
> Actually doing it in the VFS might be even better.  Add ->init and
> ->exit methods to struct file_system_type and then the filesystems can
> move most of module_init/exit into the new methods.

Hmm I like that idea! :)

-Eric
