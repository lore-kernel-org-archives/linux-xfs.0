Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RC3HuG086132 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 07:03:33 -0500
Date: Thu, 27 Aug 2009 08:03:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH] xfs: implement .dirty_inode to fix timestamp handling
Message-ID: <20090827120349.GA13901@infradead.org>
References: <20090827031242.GB6147@infradead.org>
	<DD638BCE-CCAA-4540-9187-C0ACED984731@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DD638BCE-CCAA-4540-9187-C0ACED984731@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Aug 27, 2009 at 01:40:08AM -0500, Felix Blyakher wrote:
>
> On Aug 26, 2009, at 10:12 PM, Christoph Hellwig wrote:
>
>> [Note: this patch needs the O_SYNC patch applies first]
>
> I assume O_SYNC is not a prerequisite to this patch, it's just
> needed to apply the current patch cleanly.

indeed.  it just removes setting an i_update_size close to an
i_update_core we touch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
