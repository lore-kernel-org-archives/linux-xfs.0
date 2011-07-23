Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6NKR328176727 for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 15:27:03 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32D141D8CE97
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 13:27:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S7FYVjQNjHxhhjx3 for
	<xfs@oss.sgi.com>; Sat, 23 Jul 2011 13:27:02 -0700 (PDT)
Message-ID: <4E2B2E88.8080006@redhat.com>
Date: Sat, 23 Jul 2011 16:26:48 -0400
From: Josef Bacik <josef@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
	->fsync() handlers
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	<20110723180942.GA1616@x4.trippels.de>
In-Reply-To: <20110723180942.GA1616@x4.trippels.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org

On 07/23/2011 02:09 PM, Markus Trippelsdorf wrote:
> On 2011.06.29 at 14:05 -0400, Josef Bacik wrote:
>> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
>> in fsync to make it less of a painful operation, so push down taking i_mutex and
>> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
>> file systems can drop taking the i_mutex altogether it seems, like ext3 and
>> ocfs2.  For correctness sake I just pushed everything down in all cases to make
>> sure that we keep the current behavior the same for everybody, and then each
>> individual fs maintainer can make up their mind about what to do from there.
>
> At least the xfs part of this patch is broken.
> Running the latest git-kernel bogofilter doesn't work anymore on my xfs
> partition. When I run "bogoutil -d wordlist.db" to dump the contents of
> the database, it produces no output at all.
>

Already fixed and sent a patch out earlier this week.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
