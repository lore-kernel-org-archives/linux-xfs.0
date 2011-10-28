Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SDWYZ0154949 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 08:32:34 -0500
Message-ID: <4EAAAEEE.5030600@sgi.com>
Date: Fri, 28 Oct 2011 08:32:30 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: incremental dump directory selection
References: <1319214933-16276-1-git-send-email-wkendall@sgi.com>
	<20111028093752.GB23069@infradead.org>
In-Reply-To: <20111028093752.GB23069@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Oct 21, 2011 at 11:35:33AM -0500, Bill Kendall wrote:
>> When doing incremental backups, xfsdump does a recursive scan through
>> the filesystems to determine the proper set of unchanged directories
>> to include in the dump in order to make the dump self-contained
>> (allowing files to be restored from this dump without applying the
>> base dumps first).
>>
>> For high-inode count filesystems, the recursive scan may consume a
>> significant portion of the backup time. This patch adds a -D option
>> which causes xfsdump to skip the recursive scan. Unchanged directories
>> will not be dumped, so the base dump(s) will have to be loaded prior
>> to restoring files from the dump. When restoring files from such a
>> dump, a message is issued to alert the user that files may end up in
>> the orphanage if the base dump(s) has not been applied.
> 
> Any chance you could submit some xfstests coverage for this feature?

Sure, will do.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
