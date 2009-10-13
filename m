Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DMFHU9156601 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:15:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5715FC25F83
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:16:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uHKlFUxGYsuXL7u2 for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:16:47 -0700 (PDT)
Date: Tue, 13 Oct 2009 18:16:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/14] repair: kill B_IS_META flag
Message-ID: <20091013221646.GA31385@infradead.org>
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175840.224768080@bombadil.infradead.org>
	<4AD38744.3010702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AD38744.3010702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 12, 2009 at 02:45:08PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
>
>> B_IS_META is the inverse flag of B_IS_INODE which is not really obvious
>> from it's use.  So just use !B_IS_INODE to make it more clear.
>>
>
> Logic-wise it's fine, but is this change really helpful?   The comment says:
>
> /*
> * Test if bit 0 or 2 is set in the "priority tag" of the buffer to see if
> * the buffer is for an inode or other metadata.
> */
>
> so basically it distinguishes inodes from other metadata right.

Yes, with the key on other.  In my books inodes are meta-data.

> B_IS_INODE is clear; B_IS_META is pretty clear, "!B_IS_INODE" seems muddy; so
> very many things are "not inodes" :)

In a buffercache (and in fact a whole application) that only deals with
metadata at all !B_IS_INODE meaning other metadata seems a lot more
clear to me than B_IS_META.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
