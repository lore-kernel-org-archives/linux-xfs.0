Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47E3F29DFA
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 09:41:52 -0500 (CDT)
Message-ID: <51681D2C.8040401@sgi.com>
Date: Fri, 12 Apr 2013 09:41:48 -0500
From: Troy McCorkell <tdm@sgi.com>
MIME-Version: 1.0
Subject: Re: Deprecating xfs_check
References: <1365716708.3762.32154.camel@chandra-dt.ibm.com>	<20130411221754.GI22182@sgi.com>
	<516740B8.4030704@sgi.com> <20130412010407.GE31207@dastard>
In-Reply-To: <20130412010407.GE31207@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 04/11/2013 08:04 PM, Dave Chinner wrote:
> [compendium reply]
>
> On Thu, Apr 11, 2013 at 06:01:12PM -0500, Troy McCorkell wrote:
>    
>> On 04/11/2013 05:17 PM, Ben Myers wrote:
>>      
>>> Hey Chandra,
>>>
>>> On Thu, Apr 11, 2013 at 04:45:08PM -0500, Chandra Seetharaman wrote:
>>>        
>>>> Hello All,
>>>>
>>>> Alex Elder mentioned about deprecating xfs_check, and he suggested is to
>>>> replace xfs_check command with a script, that says xfs_check is
>>>> deprecated, use "xfs_repair -n".
>>>>
>>>> Sounds ok ?
>>>>          
> Yes. I'd suggest that you also put a removal date in the output,
> such as:
>
> "xfs_check is deprecated and scheduled for removal in June 2014.
>   Please use xfs_repair -n<dev>  instead."
>
> The same information needs to go into the xfs_check man page.
>
> xfstests also still needs to run xfs_check. That means we also need
> either an override flag an make $XFS_CHECK_PROG have it set
> appropriately or add an internal xfs_db wrapper that runs the
> xfs_check functionality appropriately. The second is probably the
> better option...
>
>    
>>>> Let me know if it is not the right approach.
>>>>          
>>> That sounds ok to me.  You might also consider making xfs_check a hardlink to
>>> xfs_repair and varying the behavior based on program name.  Then xfs_check ==
>>> xfs_repair -n.
>>>        
> xfs_check is a shell script wrapper around xfs_db, so modifying the
> shell script is the right thing to do at this point in time.
>
>    
>> Does "xfs_repair -n" need to provide all of the functionality that xfs_check
>> provides before it is replaced?
>>      
> It already does.
>
>    
>> xfs_check can be run on a filesystem mounted read-only.  xfs_repair
>> -n can not.
>>      
>         -d     Repair  dangerously.  Allow  xfs_repair  to  repair an XFS filesystem mounted read only. This is typically done on a root fileystem from single user
>                mode, immediately followed by a reboot.
>
>
> $ sudo mount -o remount,ro /mnt/scratch
> $ grep scratch /proc/mounts
> /dev/vdc /mnt/scratch xfs ro,relatime,attr2,nobarrier,inode64,logbsize=256k,noquota 0 0
> $ sudo xfs_repair -dn /dev/vdc
> Phase 1 - find and verify superblock...
> Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!
> Use of these features is at your own risk!
> Not enough RAM available for repair to enable prefetching.
> This will be _slow_.
> You need at least 16061MB RAM to run with prefetching enabled.
> Phase 2 - using internal log
>          - scan filesystem freespace and inode maps...
> ....
>          - agno = 98
>          - agno = 99
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>          - traversing filesystem ...
>          - traversal finished ...
>          - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> $
>
> So it works just fine on read-only filesystems...
>
> (Oh, yeah, that's a 100TB metadata crc enabled filesystem with 50
> million inodes in it ;)
>
>    
>> xfs_check has two options:
>>      -i ino   Specifies  verbose  behavior  for  the specified inode ino.
>>      -b bno   Specifies  verbose behavior for the specific filesystem
>> block at bno.
>> which are not available with xfs_repair.
>>      
> I've never used either of them in 10 years. If they are needed, you
> can still use xfs_db to get that information directly:
>
> # xfs_db -F -i -p xfs_check -c "check -i ino"<dev>
>
> So, really, we are not losing any xfs_check functionality at all -
> all we are doing is deprecating the user facing interface to it.
>
> Cheers,
>
> Dave.
>    

Dave,

Thanks for the thorough explanation!   I agree, time to deprecate xfs_check.

Thanks,
Troy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
