Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 01:19:39 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5A8JZde021178
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 01:19:37 -0700
Received: from noire.bucharest.roedu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA91617A50D9
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 01:20:30 -0700 (PDT)
Received: from noire.bucharest.roedu.net (noire.Bucharest.roedu.net [141.85.128.18]) by cuda.sgi.com with ESMTP id lpOH5nNvvsteBNn7 for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 01:20:30 -0700 (PDT)
Received: from ahriman.bucharest.roedu.net (noire.bucharest.roedu.net [141.85.128.18])
	(authenticated bits=0)
	by noire.bucharest.roedu.net (8.12.10/8.12.10) with ESMTP id m5A7KVke027013
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:20:32 +0300
From: dizzy <dizzy@roedu.net>
Subject: Re: readdir() ordering guarantees on XFS
Date: Tue, 10 Jun 2008 11:20:27 +0300
References: <200806061634.13990.dizzy@roedu.net> <20080610035547.GZ10720@disturbed>
In-Reply-To: <20080610035547.GZ10720@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101120.27473.dizzy@roedu.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tuesday 10 June 2008 06:55:47 Dave Chinner wrote:
> On Fri, Jun 06, 2008 at 04:34:13PM +0300, dizzy wrote:
> > Hello
> >
> > POSIX leaves unspecified the order of getting the entries with readdir().
> > This is normal since different filesystems may implement their own
> > techniques to organize entries in a directory (linear, hash, various
> > search trees, etc).
> >
> > But if I can makes sure that several Linux machines will have the same FS
> > (ie XFS), mount options and same kernels can assume that traversing the
> > same file hierarchy structure (that is a file structure with the exact
> > same directories and files as names, structure, attributes, except maybe
> > "ctime" which we can't really control in Linux) can I expect that
> > traversing using readdir() will give me the entries in the exact same
> > order?
>
> No. For speed I suggest sorting the inode stat() calls in ascending
> inode number order before issuing them. 

But this does not solve the main requirement, that is the files traversed on 
the multiple Linux machines have to be sent in the same order (not sure if I 
have specified this in the original mesage, sorry if not). For now I'm 
sorting them lexicographically which is pretty slow. Sorting them by inode 
would not give them in the same order.

> Also, perhaps you should 
> look at:
>
> http://oss.oracle.com/~mason/acp/
>
> To see if you can use similar techniques to speed directory
> traversal.

Funny that you mention acp. We have benchmarked simple "tar" reading and "acp" 
reading of directory structures and on XFS "tar" reading is faster (but not 
on ext3), here are some results (reading a linux kernel tree after a flush of 
the cache by "tar"-ing a huge ammount of data, double the memory size):
- xfs: acp: 1m32s, tar: 1m12s
- ext3: acp: 0m1.5s, tar: 0m2.8s

Although in the test ext3 seems to be much faster than XFS overall in reading, 
it isn't so in writing so we will stick with XFS as it's fast enough for 
reading and fast for writing. Anyway that is another topic.

We still have that ordering issues tho from the original message :)

-- 
Mihai RUSU					Email: dizzy@roedu.net
			"Linux is obsolete" -- AST
