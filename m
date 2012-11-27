Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARMAmDL097004 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:10:48 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OZWyDoBUeevsU5Ud for
	<xfs@oss.sgi.com>; Tue, 27 Nov 2012 14:13:05 -0800 (PST)
Message-ID: <50B53AEA.3080102@redhat.com>
Date: Tue, 27 Nov 2012 16:12:58 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test EROFS vs. EEXIST when creating on an RO
	filesystem
References: <50B52DB7.3030506@redhat.com>
	<20121127221111.GA13753@infradead.org>
In-Reply-To: <20121127221111.GA13753@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/27/12 4:11 PM, Christoph Hellwig wrote:
> On Tue, Nov 27, 2012 at 03:16:39PM -0600, Eric Sandeen wrote:
>> TBH, I don't know if this is posix-specified, but I found out the
>> hard way that when trying to re-create existing files on a readonly 
>> filesystem, some apps expect/handle EEXIST, but fail on EROFS.
>>
>> This will test mkdir, mknod, and symlinks for that behavior.
> 
> Just curious, which filesystem would fail this currently or did in the
> past?

No single filesystem, really - 

I temporarily broke the VFS in a rhel backport.  ;)  But it seems like
the kind of thing that could be missed in the future, so figured it was
worth a quick test.

(basically this was from moving mnt_want_write outside i_mutex for freeze
work, and returning an error directly from mnt_want_write() would
give us EROFS instead of maybe EEXIST)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
