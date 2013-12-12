Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 710DB7F54
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:14:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D3CFAC002
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 08:14:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5ilXeGnlYhUeZ98U for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 08:14:44 -0800 (PST)
Message-ID: <52A9E0EF.1000206@sandeen.net>
Date: Thu, 12 Dec 2013 10:14:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
References: <20131211172725.GA4606@redhat.com> <20131211230128.GM10988@dastard>
In-Reply-To: <20131211230128.GM10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>
Cc: xfs@oss.sgi.com

On 12/11/13, 5:01 PM, Dave Chinner wrote:
> On Wed, Dec 11, 2013 at 12:27:25PM -0500, Dave Jones wrote:
>> Powered up my desktop this morning and noticed I couldn't cd into ~/Mail
>> dmesg didn't look good.  "XFS: Internal error XFS_WANT_CORRUPTED_RETURN"
>> http://codemonkey.org.uk/junk/xfs-1.txt
> 
> They came from xfs_dir3_block_verify() on read IO completion, which
> indicates that the corruption was on disk and in the directory
> structure. Yeah, definitely a verifier error:
> 
> XFS (sda3): metadata I/O error: block 0x2e790 ("xfs_trans_read_buf_map") error 117 numblks 8
> 
> Are you running a CRC enabled filesystem? (i.e. mkfs.xfs -m crc=1)
> 
> Is there any evidence that this verifier has fired in the past on
> write? If not, then it's a good chance that it's a media error
> causing this, because the same verifier runs when the metadata is
> written to ensure we are not writing bas stuff to disk.

Dave C, have you given any thought to how to make the verifier errors more
actionable?  If davej throws up his hands, the rest of the world is obviously
in trouble.  ;)

To the inexperienced this looks like a "crash" thanks to the backtrace.
I do understand that it's necessary for bug reports, but I wonder if we
could preface it with something informative or instructive.

We also don't get a block number or inode number, although you or I can
dig the inode number out of the hexdump, in this case.

We also don't get any details of what the values in the failed check were;
not from the check macro itself or from the hexdump, necessarily, since
it only prints the first handful of bytes.

Any ideas here?

-Eric

>> I rebooted into single user mode, and ran xfs_repair on /dev/sda3 (/home).
>> It fixed up a bunch of stuff, but ended up eating ~/.procmailrc entirely
>> (no sign of it in lost & found), and a bunch of filenames got garbled
>> 'december' became 'decemcer' for eg.  Looks like a couple kernel trees ended
>> up in lost & found.
> 
> Single bit errors in directory names? That really does point towards
> media errors, not a filesystem error being the cause.
> 
>> After rebooting back into multi-user mode, I looked in dmesg again to be sure
>> and this time sda2 was complaining..
>>
>> http://codemonkey.org.uk/junk/xfs-2.txt
> 
> Exaclty the same - directory blocks failing read verification.
> 
>> Same drill, reboot, xfs_repair. Looks like a bunch of man pages ended up in lost & found.
>>
>> Thoughts ? Could sda be dying ? (It is a fairly old crappy ssd)
> 
> I'd seriously be considering replacing the SSD as the first step.
> If you then see failures on a known good drive, we'll need to dig
> further.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
