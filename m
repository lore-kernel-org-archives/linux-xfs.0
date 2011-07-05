Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p651Hfba206627 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 20:17:41 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD4A923D5D
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 18:17:40 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id dnKnaib0FIlITlNR
	for <xfs@oss.sgi.com>; Mon, 04 Jul 2011 18:17:40 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: [RFC] remove filestreams support?
In-Reply-To: <20110704153443.GA21501@infradead.org>
References: <20110704153443.GA21501@infradead.org>
Date: Tue, 05 Jul 2011 11:17:46 +1000
Message-ID: <87sjqlbk5h.fsf@flamingspork.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, 4 Jul 2011 11:34:43 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> I'd like to know if there are any people actively using the filestreams
> support in XFS (-o filestreams).  It's pretty much a fringe feature, and
> I've not seen any user reports for it, while it never passes all its
> XFSQA tests reliably.  It was added specificly for CXFS media streaming
> operations on one particular array model that hasn't been sold for a
> long time.  The feature purely is an in-memory one so unlike for example
> the realtime device there are no issue about beeing able to read old
> filesystems.  The filestreams specific files are around 1500 lines of
> code, not even counting the hooks in the core XFS codebase.

I used it a bit on MythTV box to help circumvent the stupid behaviour of
it fsync()ing every second[1] leading to poor file layout on disk. I
found that filestreams worked a bit better than just setting allocsize
mount option... but I wouldn't be screaming too much if it went away....


[1] which was to work around ext3 taking locks for so long that you'd
then miss part of your TV program

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
