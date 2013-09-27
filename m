Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE7637F50
	for <linux-xfs@oss.sgi.com>; Fri, 27 Sep 2013 03:18:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 820688F8071
	for <linux-xfs@oss.sgi.com>; Fri, 27 Sep 2013 01:18:47 -0700 (PDT)
Received: from wombat.san-francisco.ca.us (wombat.san-francisco.ca.us
	[75.101.60.140]) by cuda.sgi.com with ESMTP id hnfVVNN9QbFzfdvc
	for <linux-xfs@oss.sgi.com>; Fri, 27 Sep 2013 01:18:46 -0700 (PDT)
Date: Fri, 27 Sep 2013 01:18:44 -0700
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: free inodes remaining in 1tb
Message-ID: <20130927081844.GA14996@wombat.san-francisco.ca.us>
References: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
	<20130927010847.GW26872@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130927010847.GW26872@dastard>
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
To: linux-xfs@oss.sgi.com

Thank you both Dave and Carlos for your replies.  My response inline.

On Fri, Sep 27, 2013 at 11:08:47AM +1000, Dave Chinner wrote:
> On Thu, Sep 26, 2013 at 03:47:00PM -0700, Keith Keller wrote:
> 
> > so that I can plan for a migration to
> > inode64 (if it's very few, I would make it a high priority; if not, it
> > can be done in a few weeks instead, for example).  Is there an easy
> > way (or even a hard way) to query the filesystem for this information?
> 
> Only a hard way - using xfs_db to look at on-disk structures and
> inferring the state from there...

That's what I was afraid of.  :)

> So if you have an old kernel (older than 2.6.35), you won't be able
> to access 64 bit inodes at all if you mount with inode32. Anything
> more recent than that will work just fine.

I am currently using a stock CentOS kernel, 2.6.32-358.14.1.el6.x86_64.
I'd have to check the changelogs to see if that kernel has the patch
in question, which I will do tomorrow.  I have another machine on
kernel-ml which I'm trying out now, and may simply move the original
machine to it as well.

> The inode number is an encoding of the physical location of the inod
> inthe filesystem. Hence the kernel code can always find the inode
> location - it just may not be able to do anything with it because
> the caches on old kernels can't index them...

Great, thanks, that's really helpful.

On 2013-09-26, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> bear in mind though that are some applications that can't read 64bit
> inodes.

I know that NFS has some issues (documented in the XFS FAQ).  Do you
know offhand of any other examples?

--keith


-- 
kkeller@wombat.san-francisco.ca.us

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
