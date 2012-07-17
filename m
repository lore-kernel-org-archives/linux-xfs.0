Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HD2iG2078462 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 08:02:44 -0500
Message-ID: <50056244.5060404@oracle.com>
Date: Tue, 17 Jul 2012 21:01:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: Add pquotaino to on-disk super block
References: <4FFFDDF8.10401@oracle.com> <20120717073811.GC24395@infradead.org>
In-Reply-To: <20120717073811.GC24395@infradead.org>
Reply-To: jeff.liu@oracle.com
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
Cc: Ben Myers <bpm@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 07/17/2012 03:38 PM, Christoph Hellwig wrote:

> On Fri, Jul 13, 2012 at 04:36:08PM +0800, Jeff Liu wrote:
>> Add pquotaino to on-disk super block. Add a new field to
>> the super block to add support for separate pquota with
>> a specific version.
> 
> Call me stupid, but I can't find where it actually adds the field.

Sorry! looks I have made a mistake when producing this patch set, just
looked through the code on my working tree, the code change in
xfs_readsb() also does not reflect here.

I'll correct this in next post.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
