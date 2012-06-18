Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5ILGENU241734 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 16:16:14 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id tbn0bork8fLY6utP for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 14:16:13 -0700 (PDT)
Message-ID: <4FDF9A9C.6060408@sandeen.net>
Date: Mon, 18 Jun 2012 16:16:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS status update for May 2012
References: <20120618120853.GA15480@infradead.org>
	<AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
	<4FDF9998.6020205@sandeen.net>
In-Reply-To: <4FDF9998.6020205@sandeen.net>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On 6/18/12 4:11 PM, Eric Sandeen wrote:
> On 6/18/12 1:25 PM, Andreas Dilger wrote:
>> On 2012-06-18, at 6:08 AM, Christoph Hellwig wrote:
>>> May saw the release of Linux 3.4, including a decent sized XFS update.
>>> Remarkable XFS features in Linux 3.4 include moving over all metadata
>>> updates to use transactions, the addition of a work queue for the
>>> low-level allocator code to avoid stack overflows due to extreme stack
>>> use in the Linux VM/VFS call chain,
>>
>> This is essentially a workaround for too-small stacks in the kernel,
>> which we've had to do at times as well, by doing work in a separate
>> thread (with a new stack) and waiting for the results?  This is a
>> generic problem that any reasonably-complex filesystem will have when
>> running under memory pressure on a complex storage stack (e.g. LVM +
>> iSCSI), but causes unnecessary context switching.
>>
>> Any thoughts on a better way to handle this, or will there continue
>> to be a 4kB stack limit and hack around this with repeated kmalloc
> 
> well, 8k on x86_64 (not 4k) right?   But still...
> 
> Maybe it's still a partial hack but it's more generic - should we have
> IRQ stacks like x86 has?  (I think I'm right that that only exists
> on x86 / 32-bit) - is there any downside to that?

Maybe I'm wrong about that, and we already have IRQ stacks on x86_64 -
at least based on the kernel documentation?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
