Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA1927F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 10:39:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68CC4AC001
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 08:39:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Pv6bgjS5Vt7NyVWn for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 08:39:18 -0800 (PST)
Message-ID: <51225935.5030409@sandeen.net>
Date: Mon, 18 Feb 2013 10:39:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: inode64 and 64bit kernel with 32bit userspace
References: <20130218094320.GA24644@citd.de> <512244CE.5030008@sandeen.net>
	<20130218162032.GA16259@citd.de>
In-Reply-To: <20130218162032.GA16259@citd.de>
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

On 2/18/13 10:20 AM, Matthias Schniedermeyer wrote:
> On 18.02.2013 09:12, Eric Sandeen wrote:
>> On 2/18/13 3:43 AM, Matthias Schniedermeyer wrote:
>>> Hi
>>>
>>>
>>> The more or less simple question is:
>>> Is the requirement for 32bit programs to support 64bit inodes the same 
>>> as LFS(Large File Support)?
>>>
>>> IOW if a programs was compiled with FILE_OFFSET_BITS=64 (if i remember 
>>> that name correctly) should it work?
>>
>> I think so (I don't know where the formal documentation is, 
>> http://users.suse.com/~aj/linux_lfs.html is an old but still good
>> over view I think).  From open(2):
>>
>>        EOVERFLOW
>>               (stat())  path refers to a file whose size cannot be represented
>>               in the type       off_t.  This can  occur  when  an  application
>>               compiled  on  a  32-bit  platform without -D_FILE_OFFSET_BITS=64
>>               calls stat() on a file whose size exceeds (2<<31)-1 bits.
>>
>> EOVERFLOW can happen if the inode nubmer doesn't fit in a (32-bit)
>> stat struct as well.
> 
> I've looked into /usr/include/sys/stat.h
> 
> And i see this:
> # ifndef __ino_t_defined
> #  ifndef __USE_FILE_OFFSET64
> typedef __ino_t ino_t;
> #  else
> typedef __ino64_t ino_t;
> #  endif
> #  define __ino_t_defined
> # endif
> 
> So ino_t really is __ino64_t when compiled with the LFS option, which 
> answers my original question. :-)
> 
> Besides i don't have that many programs that (should) care about inodes. 
> Of the top of my head i care about rsync/perl/find/ln/ls, which 
> apparently work correctly.

find cares, ls cares . . . but I would assume that they get it right :)

I'm getting a box set up w/ 32-bit F18, I want to re-run my test over it
and see if things have improved at all in 5 years.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
