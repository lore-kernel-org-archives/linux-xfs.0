Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9F07Erg221862 for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 19:07:15 -0500
Received: from tac.ki.iif.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C22661227EE8
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 17:08:43 -0700 (PDT)
Received: from tac.ki.iif.hu (tac.ki.iif.hu [193.6.222.43]) by cuda.sgi.com
	with ESMTP id 4szgQFOz6sz1xxCC for <xfs@oss.sgi.com>;
	Wed, 14 Oct 2009 17:08:43 -0700 (PDT)
From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: mmap vs mtime in 2.6.26 and up
References: <20090518114305.GA6303@infradead.org>
	<87vdj742dt.fsf@tac.ki.iif.hu> <20090926131043.GA25204@infradead.org>
Date: Thu, 15 Oct 2009 02:08:22 +0200
In-Reply-To: <20090926131043.GA25204@infradead.org> (Christoph Hellwig's
	message of "Sat, 26 Sep 2009 09:10:43 -0400")
Message-ID: <87oco94iyx.fsf@tac.ki.iif.hu>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Staubach <staubach@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Sep 25, 2009 at 02:47:42PM +0200, Ferenc Wagner wrote:
>
>> I added some fresh test results to
>> http://bugzilla.kernel.org/show_bug.cgi?id=2645.  In short, under
>> 2.6.30-rc8 the test program reports full failure on XFS and RAMFS,
>> full success on EXT3, VFAT and ReiserFS, and mixed results on TMPFS:
>
> There's a patch queued up for inclusion in 2.6.32 to work around this
> issue in XFS.  The lack of a proper callout from the VFS still makes
> this a much less than ideal solution.

Great, anyway!  Somehow I managed to gloss over this mail until now,
but happened to test 2.6.32-rc4 and found the issue fixed.  At least
for XFS, as my latest addition to the bug report details it.  Thank
you very much for taking care of this issue!
-- 
Regards,
Feri.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
