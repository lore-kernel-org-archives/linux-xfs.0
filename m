Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B5AA7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 16:41:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44D3330407B
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 14:41:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fng5e715Y3JM6WbS for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 14:41:22 -0800 (PST)
Message-ID: <5317A7F7.4060404@redhat.com>
Date: Wed, 05 Mar 2014 16:40:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix use after free in inode_item_done()
References: <5314E912.9080708@redhat.com>
	<20140305170256.GB11667@infradead.org>
	<53175C97.2050408@sandeen.net>
	<20140305223612.GA25639@infradead.org>
In-Reply-To: <20140305223612.GA25639@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/5/14, 4:36 PM, Christoph Hellwig wrote:
> On Wed, Mar 05, 2014 at 11:19:19AM -0600, Eric Sandeen wrote:
>> Yeah, that does seem better!   Thanks for spotting that.
>>
>> The difference when calling inode_item_unlock is a bit more zeroing-out:
>>
>>         ip->i_transp = NULL;
>>
>>         iip->ili_flags = 0;
>>
>> I'm not sure of the implications of that offhand, TBH.
>>
>> Dave, hold off on my commit I guess ;)
> 
> i_itransp nulling is obviously harmless as we are freeing the inode
> right after.

Not in all cases, right?

static void
inode_item_unlock(
        xfs_inode_log_item_t    *iip)
{
        xfs_inode_t             *ip = iip->ili_inode;

        /* Clear the transaction pointer in the inode. */
        ip->i_transp = NULL;

        iip->ili_flags = 0;
        if (!iip->ili_lock_flags)
                libxfs_iput(ip, 0);
        else
                iip->ili_lock_flags = 0;  // <-- not here.
}



> ili_flags is always 0 in libxfs and we might as well just remove it.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
