Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R4pfim189556 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 22:51:41 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B355D1A3610D
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 20:54:05 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	uEwJaOuEOcOr5VCA for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 20:54:05 -0800 (PST)
Message-ID: <4D40FA69.2040608@teksavvy.com>
Date: Wed, 26 Jan 2011 23:54:01 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <4D40CDCF.4010301@teksavvy.com>
	<20110127034314.GI21311@dastard> <4D40EC2D.5020507@teksavvy.com>
In-Reply-To: <4D40EC2D.5020507@teksavvy.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

On 11-01-26 10:53 PM, Mark Lord wrote:
> On 11-01-26 10:43 PM, Dave Chinner wrote:
>> On Wed, Jan 26, 2011 at 08:43:43PM -0500, Mark Lord wrote:
>>> On 11-01-26 08:22 PM, Mark Lord wrote:
> ..
>>> Thinking about it some more:  the first problem very much appears as if
>>> it is due to a filesystem check happening on the already-mounted filesystem,
>>> if that makes any kind of sense (?).
>>
>> Not to me.  You can check this simply by looking at the output of
>> top while the problem is occurring...
> 
> Top doesn't show anything interesting, since disk I/O uses practically zero CPU.
> 
>>> running xfs_check on the umounted drive takes about the same 30-60 seconds,
>>> with the disk activity light fully "on".
>>
>> Well, yeah - XFS check reads all the metadata in the filesystem, so
>> of course it's going to thrash your disk when it is run. The fact it
>> takes the same length of time as whatever problem you are having is
>> likely to be coincidental.
> 
> I find it interesting that the mount takes zero-time,
> as if it never actually reads much from the filesystem.
> Something has to eventually read the metadata etc.
> 
>>> The other thought that came to mind:  this behaviour has only been
>>> noticed recently, probably because I have recently added about
>>> 1000 new files (hundreds of MB each) to the videos/ directory on
>>> that filesystem.  Whereas before, it had fewer than 500 (multi-GB)
>>> files in total.
>>>
>>> So if it really is doing some kind of internal filesystem check,
>>> then the time required has only recently become 3X larger than
>>> before.. so the behaviour may not be new/recent, but now is very
>>> noticeable.
>>
>> Where does that 3x figure come from?
> 
> Well, it used to have about 500 files/subdirs on it,
> and now it has somewhat over 1500 files/subdirs.
> That's a ballpark estimate of 3X the amount of meta data.
> 
> All of these files are at least large (hundreds of MB),
> and a lot are huge (many GB) in size.

I've rebuilt the kernel with the various config options to enable blktrace
and XFS_DEBUG, but in the meanwhile we have also watched and deleted
a few GB of recordings.

The result is that the mysterious first-write delay has vanished, for now,
so there's nothing to trace.

I think I'll pick up an extra 2TB drive, so that next time
it surfaces I can simply bit-clone the filesystem or something,
to preserve the buggered state for further examination.

The second issue is probably still there, and I'll blktrace that instead.
But it will have to wait a spell -- I've run out of time here right now.

Cheers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
