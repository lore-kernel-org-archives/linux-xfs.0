Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 19:16:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9U2G4rK016920
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 19:16:05 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A3FC55CA88
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 19:16:03 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id 8HQ4Rfx8WRBjeI6a for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 19:16:03 -0700 (PDT)
Date: Thu, 30 Oct 2008 03:16:01 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081030021601.GF18041@wotan.suse.de>
References: <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029091203.GA32545@infradead.org> <20081029092143.GA5953@wotan.suse.de> <20081029094417.GA21824@infradead.org> <20081029103029.GC5953@wotan.suse.de> <20081029122234.GE846@shareable.org> <490865E3.8070102@gmail.com> <1225292196.6448.263.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225292196.6448.263.camel@think.oraclecorp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Mason <chris.mason@oracle.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Jamie Lokier <jamie@shareable.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Oct 29, 2008 at 10:56:36AM -0400, Chris Mason wrote:
> On Wed, 2008-10-29 at 09:32 -0400, Ric Wheeler wrote:
> > Jamie Lokier wrote:
> 
> > >> Is there anything that particularly makes it a file operation
> > >> as opposed to an inode operation?
> > >>     
> > >
> > > In principle, is fsync() required to flush all dirty data written
> > > through any file descriptor ever, or just dirty data written through
> > > the file descriptor used for fsync()?
> > >
> > > -- Jamie
> > > --
> > >   
> > http://www.opengroup.org/onlinepubs/009695399/functions/fsync.html
> > 
> > Is a pointer to what seems to be the official posix spec for this - it 
> > is definitely per file descriptor, not per file system, etc...
> > 
> 
> Maybe I'm reading Jamie's question wrong, but I think he's saying:
> 
> /* open exactly the same file twice */
> fd = open("file");
> fd2 = open("file");
> 
> write(fd, "stuff")
> write(fd2, "more stuff")
> fsync(fd);
> 
> Does the fsync promise "more stuff" will be on disk?  I think the answer
> should be yes.

I think so. And this is in the context of making ->fsync an inode
operation and avoid the NFS NULL-file problem... I don't think there
is any fd specific metadata that fsync has to deal with? Any other
reasons it has to be a file operation?
