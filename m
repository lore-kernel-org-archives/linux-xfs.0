Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F53C7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 17:01:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FD6D304067
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 15:01:35 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	f9FxXGvTr5Jek5gD for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 15:01:33 -0800 (PST)
Date: Thu, 12 Dec 2013 10:01:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
Message-ID: <20131211230128.GM10988@dastard>
References: <20131211172725.GA4606@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211172725.GA4606@redhat.com>
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
To: Dave Jones <davej@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 11, 2013 at 12:27:25PM -0500, Dave Jones wrote:
> Powered up my desktop this morning and noticed I couldn't cd into ~/Mail
> dmesg didn't look good.  "XFS: Internal error XFS_WANT_CORRUPTED_RETURN"
> http://codemonkey.org.uk/junk/xfs-1.txt

They came from xfs_dir3_block_verify() on read IO completion, which
indicates that the corruption was on disk and in the directory
structure. Yeah, definitely a verifier error:

XFS (sda3): metadata I/O error: block 0x2e790 ("xfs_trans_read_buf_map") error 117 numblks 8

Are you running a CRC enabled filesystem? (i.e. mkfs.xfs -m crc=1)

Is there any evidence that this verifier has fired in the past on
write? If not, then it's a good chance that it's a media error
causing this, because the same verifier runs when the metadata is
written to ensure we are not writing bas stuff to disk.

> I rebooted into single user mode, and ran xfs_repair on /dev/sda3 (/home).
> It fixed up a bunch of stuff, but ended up eating ~/.procmailrc entirely
> (no sign of it in lost & found), and a bunch of filenames got garbled
> 'december' became 'decemcer' for eg.  Looks like a couple kernel trees ended
> up in lost & found.

Single bit errors in directory names? That really does point towards
media errors, not a filesystem error being the cause.

> After rebooting back into multi-user mode, I looked in dmesg again to be sure
> and this time sda2 was complaining..
> 
> http://codemonkey.org.uk/junk/xfs-2.txt

Exaclty the same - directory blocks failing read verification.

> Same drill, reboot, xfs_repair. Looks like a bunch of man pages ended up in lost & found.
> 
> Thoughts ? Could sda be dying ? (It is a fairly old crappy ssd)

I'd seriously be considering replacing the SSD as the first step.
If you then see failures on a known good drive, we'll need to dig
further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
