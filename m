Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE7D57F54
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:20:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88B4A8F8040
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 08:20:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TNqpxkKns5idPHG2 for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 08:20:48 -0800 (PST)
Date: Thu, 12 Dec 2013 11:20:36 -0500
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
Message-ID: <20131212162036.GA9057@redhat.com>
References: <20131211172725.GA4606@redhat.com> <20131211230128.GM10988@dastard>
	<52A9E0EF.1000206@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A9E0EF.1000206@sandeen.net>
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

On Thu, Dec 12, 2013 at 10:14:39AM -0600, Eric Sandeen wrote:
 > On 12/11/13, 5:01 PM, Dave Chinner wrote:
 > > On Wed, Dec 11, 2013 at 12:27:25PM -0500, Dave Jones wrote:
 > >> Powered up my desktop this morning and noticed I couldn't cd into ~/Mail
 > >> dmesg didn't look good.  "XFS: Internal error XFS_WANT_CORRUPTED_RETURN"
 > >> http://codemonkey.org.uk/junk/xfs-1.txt
 > > 
 > > They came from xfs_dir3_block_verify() on read IO completion, which
 > > indicates that the corruption was on disk and in the directory
 > > structure. Yeah, definitely a verifier error:
 > > 
 > > XFS (sda3): metadata I/O error: block 0x2e790 ("xfs_trans_read_buf_map") error 117 numblks 8
 > > 
 > > Are you running a CRC enabled filesystem? (i.e. mkfs.xfs -m crc=1)
 > > 
 > > Is there any evidence that this verifier has fired in the past on
 > > write? If not, then it's a good chance that it's a media error
 > > causing this, because the same verifier runs when the metadata is
 > > written to ensure we are not writing bas stuff to disk.
 > 
 > Dave C, have you given any thought to how to make the verifier errors more
 > actionable?  If davej throws up his hands, the rest of the world is obviously
 > in trouble.  ;)
 > 
 > To the inexperienced this looks like a "crash" thanks to the backtrace.
 > I do understand that it's necessary for bug reports, but I wonder if we
 > could preface it with something informative or instructive.
 > 
 > We also don't get a block number or inode number, although you or I can
 > dig the inode number out of the hexdump, in this case.
 > 
 > We also don't get any details of what the values in the failed check were;
 > not from the check macro itself or from the hexdump, necessarily, since
 > it only prints the first handful of bytes.

This morning, same ssd spewed a bunch of other errors when find ran over a kernel tree..

http://paste.fedoraproject.org/61189/38686344

in that case I did get a block number (the irony of the failing block # is not lost on me)

As soon as the new one arrives, I'll try some destructive tests on the failing one.

I'm just happy it's stayed alive long enough for me to get the data off it.
When my Intel SSD failed earlier this year it was just a brick.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
