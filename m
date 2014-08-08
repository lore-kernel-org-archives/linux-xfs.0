Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B1797F8D
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 03:54:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CF26AC002
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 01:54:21 -0700 (PDT)
Received: from mail-pd0-f169.google.com (mail-pd0-f169.google.com
	[209.85.192.169]) by cuda.sgi.com with ESMTP id
	R0dzCux9Qqk7TfiK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 01:54:19 -0700 (PDT)
Received: by mail-pd0-f169.google.com with SMTP id y10so6718668pdj.14
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 01:54:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53E39117.4090200@sandeen.net>
References: <CACyNnZNAZUSf1Veybw24hU0snaTyp+Yg+wXS1_Kv-rynQjzjuw@mail.gmail.com>
	<53E39117.4090200@sandeen.net>
Date: Fri, 8 Aug 2014 10:54:18 +0200
Message-ID: <CACyNnZMAGQecaX-xkobXy3JaRZbrHSn+b+3OD+9KT5ykeV-yLw@mail.gmail.com>
Subject: Re: Recovery of deleted files/directories
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 7, 2014 at 4:45 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Do you have a link to the project you're working on?  Is it an open
> source tool?

At the moment its only local in my computer, I'm first trying to get
it to work and afterwards think about what to do with it...

> There's another tool out there already called "xfs_irecover" which
> looks for any inode anywhere on disk, and tries to copy back out any
> data that it points to, deleted or not.  It could use some love.

Nice! So indeed it's possible =) From what I could understand it looks
like that it recovers only file, not really directories, and it seams
to suppose that the files have format extent, so I suppose that it
won't work with very small files (with local data in the inode) and
neither will work in files with format btree.

Still, it should be able to recover most files I guess that local and
btree formats are less commonly found.

-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
