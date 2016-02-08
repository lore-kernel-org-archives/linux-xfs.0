Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B1AE7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:24:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0B87AC003
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:24:00 -0800 (PST)
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	8mb44bIsBi7Zzqpl (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 11:23:58 -0800 (PST)
Received: by mail-yw0-f181.google.com with SMTP id h129so110048181ywb.1
	for <xfs@oss.sgi.com>; Mon, 08 Feb 2016 11:23:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160208183112.GF2343@linux.intel.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-3-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jT=yAb2_yLfMGqV1SdbQwoWQj7joroeJGAJAcjsMY_oQ@mail.gmail.com>
	<20160208183112.GF2343@linux.intel.com>
Date: Mon, 8 Feb 2016 11:23:56 -0800
Message-ID: <CAPcyv4gdej=BfP-MDWbgTy7JTciiU_6F3zaAyzUJ2Ofgh0gapg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dax: move writeback calls into the filesystems
From: Dan Williams <dan.j.williams@intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, jmoyer <jmoyer@redhat.com>

On Mon, Feb 8, 2016 at 10:31 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Sun, Feb 07, 2016 at 11:13:51AM -0800, Dan Williams wrote:
>> The proposal: make applications explicitly request DAX semantics with
>> a new MAP_DAX flag and fail if DAX is unavailable.  Document that a
>> successful MAP_DAX request mandates that the application assumes
>> responsibility for cpu cache management.
>
>> Require that all applications that mmap the file agree on MAP_DAX.
>
> I think this proposal could run into issues with aliasing.  For example, say
> you have two threads accessing the same region, and one wants to use DAX and
> the other wants to use the page cache.  What happens?
>
> If we satisfy both requests, we end up with one user reading and writing to
> the page cache, while the other is reading and writing directly to the media.
> They can't see each other's changes, and you get data corruption.
>
> If we satisfy the request of whoever asked first, sort of lock the inode into
> that mode, and then return an error to the second thread because they are
> asking for the other mode, we have now introduced a new weird failure case
> where mmaps can randomly fail based on the behavior of other applications.
> I think this is where you were going with the last line quoted above, but I
> don't understand how it would work in an acceptable way.
>
> It seems like we have to have the decision about whether or not to use DAX
> made in the same way for all users of the inode so that we don't run into
> these types of conflicts.

We haven't solved the conflict problem by pushing it out to the inode,
see the recent revert of blkdev_daxset().  We're heading in a
direction where an application can't develop it's own policies about
DAX usage, it's always an administrative decision.  However, maybe
that is ok.  Dave is right that if an application is using an existing
filesystem it should get all the existing semantics.

If the existing semantics (or overhead of maintaining the existing
semantics) turn out not to fit a given pmem-aware application then we
may just need new interfaces (separate from fs/dax.c) to persistent
memory.  I admit we're a ways off from knowing if that is needed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
