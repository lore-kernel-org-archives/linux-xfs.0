Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44B857F80
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 11:20:48 -0500 (CDT)
Date: Wed, 1 May 2013 11:20:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Cleancache support in XFS
Message-ID: <20130501162044.GN29359@sgi.com>
References: <51810CED.4080003@zynstra.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51810CED.4080003@zynstra.com>
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
To: James Dingwall <james.dingwall@zynstra.com>
Cc: xfs@oss.sgi.com

Hi James, 

On Wed, May 01, 2013 at 01:39:09PM +0100, James Dingwall wrote:
> In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html
> 
> $ grep -r cleancache fs/xfs
> on the 3.9 kernel source suggests that no patch was submitted to
> enable cleancache for the XFS filesystem.  Since it was suggested
> that this could be a one liner I've had a go and my first effort is
> inline below.  While this seems to compile OK I have no experience
> in filesystems so I would appreciate it if anyone can point out that
> it is obviously wrong and likely to eat my data before I try booting
> the kernel.
> 
> If it seems a reasonable attempt what would be the best way to check
> that it isn't doing nasty things?

Hrm.. Looks like there is a doc in Documentation/vm/cleancache.txt which
includes a list of attributes the filesystem needs to have to work properly
with cleancache.  I'd suggest going over that list and the code by inspection
first, followed by some xfstests runs, and then wait for it to make a release
before trusting any data to it.  For a test machine that I'm willing to crater,
no worries.  But I wouldn't run this on my main workstation without doing the
above first.  We can probably explore this for 3.11.  Thanks for the patch.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
