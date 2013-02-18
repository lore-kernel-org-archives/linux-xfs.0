Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7A697F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 10:20:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5F7B304043
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 08:20:43 -0800 (PST)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id dBHk74xoY1NcKQt9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 08:20:42 -0800 (PST)
Date: Mon, 18 Feb 2013 17:20:32 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: inode64 and 64bit kernel with 32bit userspace
Message-ID: <20130218162032.GA16259@citd.de>
References: <20130218094320.GA24644@citd.de>
 <512244CE.5030008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512244CE.5030008@sandeen.net>
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

On 18.02.2013 09:12, Eric Sandeen wrote:
> On 2/18/13 3:43 AM, Matthias Schniedermeyer wrote:
> > Hi
> > 
> > 
> > The more or less simple question is:
> > Is the requirement for 32bit programs to support 64bit inodes the same 
> > as LFS(Large File Support)?
> > 
> > IOW if a programs was compiled with FILE_OFFSET_BITS=64 (if i remember 
> > that name correctly) should it work?
> 
> I think so (I don't know where the formal documentation is, 
> http://users.suse.com/~aj/linux_lfs.html is an old but still good
> over view I think).  From open(2):
> 
>        EOVERFLOW
>               (stat())  path refers to a file whose size cannot be represented
>               in the type       off_t.  This can  occur  when  an  application
>               compiled  on  a  32-bit  platform without -D_FILE_OFFSET_BITS=64
>               calls stat() on a file whose size exceeds (2<<31)-1 bits.
> 
> EOVERFLOW can happen if the inode nubmer doesn't fit in a (32-bit)
> stat struct as well.

I've looked into /usr/include/sys/stat.h

And i see this:
# ifndef __ino_t_defined
#  ifndef __USE_FILE_OFFSET64
typedef __ino_t ino_t;
#  else
typedef __ino64_t ino_t;
#  endif
#  define __ino_t_defined
# endif

So ino_t really is __ino64_t when compiled with the LFS option, which 
answers my original question. :-)

Besides i don't have that many programs that (should) care about inodes. 
Of the top of my head i care about rsync/perl/find/ln/ls, which 
apparently work correctly.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
