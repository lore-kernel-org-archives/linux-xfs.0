Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D1077F3F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 20:45:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 738D38F8094
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 18:45:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gA1oaiUrysTBa705 for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 18:45:47 -0700 (PDT)
Message-ID: <5258A9C9.1040208@sandeen.net>
Date: Fri, 11 Oct 2013 20:45:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: remove newlines from 3 xfs_alert_tag error
	strings
References: <52584C8A.1060808@redhat.com> <52584D04.3020907@sandeen.net>
	<525874AA.9020300@sgi.com>
In-Reply-To: <525874AA.9020300@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/11/13 4:59 PM, Mark Tinguely wrote:
> On 10/11/13 14:09, Eric Sandeen wrote:
>> xfs_alert_tag passes the format string to __xfs_printk,
>> which adds its own "\n".  Having it in the original string
>> leads to unintentional blank lines from these messages.
>>
>> Most format strings have no newline, but these 3 do, leading to
>> i.e.:
>>
>> [ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
>> [ 7347.119911]
>> [ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
>> [ 7347.119919]
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> Reviewed-by: Carlos Maiolino<cmaiolino@redhat.com>
>> ---
> 
> Is this true of xfs_alert() too? ie the newline in xfs_alert in xfs_dir2_leafn_rebalance(). The newline in xfs_alert() in xlog_unpack_data_crc() looks intentional.

All of these:

define_xfs_printk_level(xfs_emerg, KERN_EMERG);
define_xfs_printk_level(xfs_alert, KERN_ALERT);
define_xfs_printk_level(xfs_crit, KERN_CRIT);
define_xfs_printk_level(xfs_err, KERN_ERR);
define_xfs_printk_level(xfs_warn, KERN_WARNING);
define_xfs_printk_level(xfs_notice, KERN_NOTICE);
define_xfs_printk_level(xfs_info, KERN_INFO);
#ifdef DEBUG
define_xfs_printk_level(xfs_debug, KERN_DEBUG);
#endif

go through __xfs_printk(), which adds a newline...

seems like more fixes are in order, yeah.

-Eric
> --Mark.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
