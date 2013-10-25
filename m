Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E5657F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:33:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EED0A8F8066
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 02:33:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id pGr3yPsVRaF6fALj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 02:33:35 -0700 (PDT)
Date: Fri, 25 Oct 2013 02:33:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests 317
Message-ID: <20131025093333.GB24583@infradead.org>
References: <20131024161235.GA29381@infradead.org>
	<20131024162557.6dd72435@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024162557.6dd72435@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 04:25:57PM -0400, Dwight Engen wrote:
> On Thu, 24 Oct 2013 09:12:35 -0700
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > This one also seems to be guranteed to fail for me with the following
> > output:
> > 
> > 
> > --- tests/generic/317.out	2013-09-09 14:41:08.000000000 +0000
> > +++ /root/xfstests/results//generic/317.out.bad	2013-10-24
> > 16:12:00.000000000 +0000 @@ -4,9 +4,7 @@
> >    Size: 0            Filetype: Regular File
> >    Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
> >  From user_ns
> > -  File: "$SCRATCH_MNT/file1"
> > -  Size: 0            Filetype: Regular File
> > -  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
> > +execvp: Permission denied
> 
> Hi Christoph,
> 
> Hmm, this looks to me like src/lstat64 cannot be exec()ed by qa_user on
> your system. Is there some other id I can/should use?

That doesn't seem to be the issue from the main system for me:

root@vm:~/xfstests# sudo -u fsgqa ./src/lstat64
Usage: lstat64 [-t] filename ...

Do you have a one liner to try what happens in a namespace?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
