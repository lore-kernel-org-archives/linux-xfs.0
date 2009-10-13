Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DNbJsE160550 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:37:19 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 03/14] repair: kill B_IS_META flag
Date: Tue, 13 Oct 2009 18:38:01 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADA6@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4AD4FCDD.1060602@sandeen.net>
From: "Alex Elder" <aelder@sgi.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On , Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Mon, Oct 12, 2009 at 02:45:08PM -0500, Eric Sandeen wrote:
>>> Christoph Hellwig wrote:
>>> 
>>>> B_IS_META is the inverse flag of B_IS_INODE which is not really obvious
>>>> from it's use.  So just use !B_IS_INODE to make it more clear.
>>>> 
>>> Logic-wise it's fine, but is this change really helpful?   The comment says:
>>> 
>>> /*
>>> * Test if bit 0 or 2 is set in the "priority tag" of the buffer to see if
>>> * the buffer is for an inode or other metadata.
>>> */
>>> 
>>> so basically it distinguishes inodes from other metadata right.
>> 
>> Yes, with the key on other.  In my books inodes are meta-data.
>> 
>>> B_IS_INODE is clear; B_IS_META is pretty clear, "!B_IS_INODE" seems muddy; so
>>> very many things are "not inodes" :)
>> 
>> In a buffercache (and in fact a whole application) that only deals with
>> metadata at all !B_IS_INODE meaning other metadata seems a lot more clear to me than B_IS_META.
>> 
> 
> Ok, I'm fine with that I suppose.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
