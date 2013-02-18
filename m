Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD6AF7F4E
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 09:12:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC6D0304032
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 07:12:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HOf7EKDf2DDo7WQX for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 07:12:16 -0800 (PST)
Message-ID: <512244CE.5030008@sandeen.net>
Date: Mon, 18 Feb 2013 09:12:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: inode64 and 64bit kernel with 32bit userspace
References: <20130218094320.GA24644@citd.de>
In-Reply-To: <20130218094320.GA24644@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On 2/18/13 3:43 AM, Matthias Schniedermeyer wrote:
> Hi
> 
> 
> The more or less simple question is:
> Is the requirement for 32bit programs to support 64bit inodes the same 
> as LFS(Large File Support)?
> 
> IOW if a programs was compiled with FILE_OFFSET_BITS=64 (if i remember 
> that name correctly) should it work?

I think so (I don't know where the formal documentation is, 
http://users.suse.com/~aj/linux_lfs.html is an old but still good
over view I think).  From open(2):

       EOVERFLOW
              (stat())  path refers to a file whose size cannot be represented
              in the type       off_t.  This can  occur  when  an  application
              compiled  on  a  32-bit  platform without -D_FILE_OFFSET_BITS=64
              calls stat() on a file whose size exceeds (2<<31)-1 bits.

EOVERFLOW can happen if the inode nubmer doesn't fit in a (32-bit)
stat struct as well.

> So that all programs compiled in the last several years in a halfway 
> recent distribution should be able to cope with 64bit inodes?

The syscalls it makes should be able to, at least.  What it does after
that is up to the program.

(i.e. you might do a nice stat64 and then try to stuff the size or the
inode number into a 32-bit variable; the -D_FILE_OFFSET_BITS won't help
in that case.)

I did a test long ago at :

http://sandeen.net/wordpress/computers/the-world-wants-32-bit-inodes/

and the results weren't too encouraging; I should try it again on a
more recent distro, and see how things look.

-Eric

> The program i care about most is rsync and it appears to work correctly 
> when i tested it with 2 hard-linked files (with an inode >2^32) and the 
> option to preserve hard links. And "find" and "stat" also worked, 
> otherwise i couldn't have found the file to test it with. ;-)
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
