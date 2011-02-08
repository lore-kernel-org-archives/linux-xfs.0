Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p185brmP095727 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 23:37:53 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 188201D3B913
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 21:40:25 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id Y6z6B8M7HwYwq14n for
	<xfs@oss.sgi.com>; Mon, 07 Feb 2011 21:40:25 -0800 (PST)
Message-ID: <4D50D748.1090406@sandeen.net>
Date: Mon, 07 Feb 2011 23:40:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: segmentation fault during mount
References: <02b401cbc6b6$5b7ac0b0$12704210$@samsung.com>
	<4D50CA45.8070807@sandeen.net>
	<030701cbc74e$b7f25680$27d70380$@samsung.com>
In-Reply-To: <030701cbc74e$b7f25680$27d70380$@samsung.com>
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
To: Ryan Roh <unisist.roh@samsung.com>
Cc: xfs@oss.sgi.com

On 2/7/11 11:12 PM, Ryan Roh wrote:
> Dear Eric,
> 
> I don't know how I can make correct form to answer for this thread because
> I'm newbie here. Sorry.
> 
> Anyway, this issue was happened from returned HDD from customer which was
> used our PVR STB. And our STB has toggle power switch so I think user turned
> off the power during recording something.

Ok, so you're not sure what happened to the hard drive before this, then.

Other Samsung folks have reported problems after intentionally testing the filesystem under harsh conditions such as poweroff or USB unplugs, so I just wondered...

It seems plausible to me that this could be corruption from lack of proper barrier support, and a poweroff or usb unplug (without barrier support) could cause that.

Mounting a corrupted filesystem should never oops the kernel though, so that is a bug.  If you can provide an xfs_metadump image of the filesystem, someone might be able to investigate further.

Does the mount failure persist after an xfs_repair (without using -n?)

If you wish to keep the original filesystem intact, you can make an xfs_metadump image of the filesystem, run xfs_mdrestore to create a new metadata image from that dump, run xfs_repair against that, and try to mount the result.

Does samsung run with CONFIG_XFS_DEBUG enabled?  Otherwise, this:

    /*
     * If we went off the root then we are seriously confused.
     */

    ASSERT(lev < cur->bc_nlevels);

would be a no-op:

#ifndef DEBUG
#define ASSERT(expr)    ((void)0)
...

(As a side note, running with CONFIG_XFS_DEBUG in production is not recommended.)

However, I'm not quite sure that's what you are hitting, if you tripped an ASSERT you should have seen "Assertion failed" in the messages.  This appears to be a null pointer dereference in xfs_free_ag_extent().

-Eric


> Thanks,
> Ryan.
>   
> 
> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@sandeen.net] 
> Sent: Tuesday, February 08, 2011 1:45 PM
> To: Ryan Roh
> Cc: xfs@oss.sgi.com
> Subject: Re: segmentation fault during mount
> 
> On 2/7/11 5:01 AM, Ryan Roh wrote:
>> Dear Members,
>>
>> I'm using XFS based on STMicro SH4 based chip (STi7105).
>>
>> and I have some issue on xfs log mounting.
>>
> 
> Were the errors after any sort of harsh testing of the filesystem, such as
> usb disconnects or power off?
> 
> Or was this after a clean unmount?
> 
> -Eric
> 
>>
>> 1. chip : sh4 STi7105
>>
>> 2. HDD : 320GB USB HDD USB 2.0 port.
>>
>> 3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.
>>
>> 4. XFSProgs version : 3.1.1
>>
>>  
>>
>> mounting and repairing log in the below. This segmentation fault is 
>> caused by
>>
>> the assert in xfs_alloc_increment function of xfs_alloc_btree.c file. 
>> The btree
>>
>> level is equal to root level in the below code.
>>
>>  
>>
>>     /*
>>
>>      * If we went off the root then we are seriously confused.
>>
>>      */
>>
>>     ASSERT(lev < cur->bc_nlevels);
>>
>>  
> 
> ...
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
