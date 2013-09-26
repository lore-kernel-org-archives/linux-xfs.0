Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1965D7F3F
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 18:03:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 076D98F8033
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:03:52 -0700 (PDT)
Date: Thu, 26 Sep 2013 20:03:45 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: free inodes remaining in 1tb
Message-ID: <20130926230345.GA18765@andromeda.usersys.redhat.com>
References: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
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
To: xfs@oss.sgi.com, linux-xfs@oss.sgi.com

On Thu, Sep 26, 2013 at 03:47:00PM -0700, Keith Keller wrote:
> Hi all,
> 
> I "recently" (a few months ago) came across the inode64 entries in the
> XFS FAQ.  Unfortunately, I have a filesystem not mounted with inode64,
> and I would like to know how many more inodes I can create in the
> first 1TB before I run out, 

The maximum amount of the filesystem that can be used by inodes (by default)
are:

25% for filesystems  under  1TB,  5% for  filesystems  under 50TB and 1% for
filesystems over 50TB.

>so that I can plan for a migration to
> inode64 (if it's very few, I would make it a high priority; if not, it
> can be done in a few weeks instead, for example).  Is there an easy
> way (or even a hard way) to query the filesystem for this information?
> 

inode64 is a remountable option now (if you're using a relatively recent
kernel), so you don't need to umount and remount it.

> I also wanted to ask about the FAQ that says you can switch back from
> inode64 to inode32.  How does that work if an inode is created past the
> 1TB mark?  How would the kernel know how to find an inode64 inode that
> was created beyond the 1TB mark if the filesystem is subsequentely
> mounted without inode64?
> 
inode32 option only dictates where the filesystem will create next inodes, not
where it will search for already created inodes.

bear in mind though that are some applications that can't read 64bit inodes.

> Thanks,
> 
> --keith
> 
> -- 
> kkeller@wombat.san-francisco.ca.us
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
