Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 07:57:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TEvUIU021605
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 07:57:31 -0700
Received: from rgminet13.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D03014A8B54
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 07:57:30 -0700 (PDT)
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125]) by cuda.sgi.com with ESMTP id iYH9YmmR6YjgKUTv for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 07:57:30 -0700 (PDT)
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
From: Chris Mason <chris.mason@oracle.com>
In-Reply-To: <490865E3.8070102@gmail.com>
References: <20081028144715.683011000@suse.de>
	 <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed>
	 <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed>
	 <20081029091203.GA32545@infradead.org>
	 <20081029092143.GA5953@wotan.suse.de>
	 <20081029094417.GA21824@infradead.org>
	 <20081029103029.GC5953@wotan.suse.de> <20081029122234.GE846@shareable.org>
	 <490865E3.8070102@gmail.com>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 10:56:36 -0400
Message-Id: <1225292196.6448.263.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, 2008-10-29 at 09:32 -0400, Ric Wheeler wrote:
> Jamie Lokier wrote:

> >> Is there anything that particularly makes it a file operation
> >> as opposed to an inode operation?
> >>     
> >
> > In principle, is fsync() required to flush all dirty data written
> > through any file descriptor ever, or just dirty data written through
> > the file descriptor used for fsync()?
> >
> > -- Jamie
> > --
> >   
> http://www.opengroup.org/onlinepubs/009695399/functions/fsync.html
> 
> Is a pointer to what seems to be the official posix spec for this - it 
> is definitely per file descriptor, not per file system, etc...
> 

Maybe I'm reading Jamie's question wrong, but I think he's saying:

/* open exactly the same file twice */
fd = open("file");
fd2 = open("file");

write(fd, "stuff")
write(fd2, "more stuff")
fsync(fd);

Does the fsync promise "more stuff" will be on disk?  I think the answer
should be yes.

-chris
