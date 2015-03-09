Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A758A7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:18:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C66DAC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:18:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sBuYAYhnwc3mTuvV for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 11:18:22 -0700 (PDT)
Message-ID: <54FDE3EB.6050904@sandeen.net>
Date: Mon, 09 Mar 2015 14:18:19 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfault
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>	<54FDC6FC.1070303@sandeen.net>	<572429630.410924.1425918276266.JavaMail.zimbra@rvx.is>	<54FDD995.5080307@sandeen.net>
	<514254492.412601.1425923432820.JavaMail.zimbra@rvx.is>
In-Reply-To: <514254492.412601.1425923432820.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

On 3/9/15 1:50 PM, Rui Gomes wrote:
> Hi,
> 
> Yeah I feel the same way what could possible happen here, since no "funky" business happen in this server.
> 
> In case this help the underline hardware is:
> Raid Controller: MegaRAID SAS 2108 [Liberator] (rev 05)
> With 16 7.2k SAS 2TB harddrives in raid6
> 
> The output from the command:
> [root@icess8a ~]# xfs_db -c "inode 260256256" -c "p" /dev/sdb1 

<snip>

Ok, that's enough to create an image which sees the same failure:

# repair/xfs_repair -n namelen.img 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
local inode 131 attr too small (size = 0, min size = 4)
bad attribute fork in inode 131, would clear attr fork
bad nblocks 7 for inode 131, would reset to 0
bad nextents 1 for inode 131, would reset to 0
entry "aaaaaaaaaaaaaaaaaaaaaaaa" in shortform directory 131 references invalid inode 28428972647780227
would have junked entry "aaaaaaaaaaaaaaaaaaaaaaaa" in directory inode 131
entry "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" in shortform directory 131 references invalid inode 0
size of last entry overflows space left in in shortform dir 131, would reset to -1
entry contains offset out of order in shortform dir 131
Segmentation fault

I'll see what we need to do in repair to handle this type of corruption.

(However, I don't think that it will suffice to get much of your filesystem
back ...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
