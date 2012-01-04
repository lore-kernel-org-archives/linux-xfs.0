Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04H1qLm159613 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 11:01:52 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ufrZSjQhKaF6Uhgu for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 09:01:51 -0800 (PST)
Message-ID: <4F0485FE.8000405@sandeen.net>
Date: Wed, 04 Jan 2012 11:01:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: new check 278 to ensure btrfs backref
	integrity
References: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net>
	<20120104163946.GA8153@infradead.org>
In-Reply-To: <20120104163946.GA8153@infradead.org>
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
Cc: linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs@oss.sgi.com

On 1/4/12 10:39 AM, Christoph Hellwig wrote:
> On Thu, Dec 22, 2011 at 12:08:58PM +0100, Jan Schmidt wrote:
>> This is a btrfs specific scratch test checking the backref walker. It
>> creates a file system with compressed and uncompressed data extents, picks
>> files randomly and uses filefrag to get their extents. It then asks the
>> btrfs utility (inspect-internal) to do the backref resolving from fs-logical
>> address (the one filefrag calls "physical") back to the inode number and
>> file-logical offset, verifying the result.
> 
> I was about to apply this, but for some reason it fails for me when
> running xfstest on xfs:
> 
> 276	 [failed, exit status 1] - output mismatch (see 276.out.bad)
> --- 276.out	2012-01-04 16:14:36.000000000 +0000
> +++ 276.out.bad	2012-01-04 16:32:26.000000000 +0000
> @@ -1,4 +1,5 @@
> QA output created by 276
> -*** test backref walking
> -*** done
> +common.rc: Error: $TEST_DEV (/dev/vdb1) is not a MOUNTED btrfs
> filesystem
> +Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> +/dev/vdb1      xfs    39042944     32928  39010016   1% /mnt/test
>  *** unmount
> 
> which is a bit confusing
> 

276 got merged on Dec 28 before my requests for fixup, I guess?  And it
explicitly sets FSTYP=btrfs which is why it fails.

the 278 patch v2 in this thread works ok for me.

so munging the 278 patch here into the existing 276 should be the
right approach.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
