Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 881ED7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:24:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 700F48F8073
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:24:27 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id WLSEb22TJ1cKp5aj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 11:24:25 -0700 (PDT)
Date: Mon, 9 Mar 2015 18:24:24 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <755575062.413014.1425925464217.JavaMail.zimbra@rvx.is>
In-Reply-To: <54FDE3EB.6050904@sandeen.net>
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
	<54FDC6FC.1070303@sandeen.net>
	<572429630.410924.1425918276266.JavaMail.zimbra@rvx.is>
	<54FDD995.5080307@sandeen.net>
	<514254492.412601.1425923432820.JavaMail.zimbra@rvx.is>
	<54FDE3EB.6050904@sandeen.net>
Subject: Re: xfs_repair segfault
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

Hello Eric, 

Thank you very much for looking in to this.
Just as a curiosity, I can mount the filesystem and access a lot of the files, but some files/folders will just hang the kernel, so I need to be careful almost file by file tries.

If I could get the xfs_repair to at least clean the filesystem and allow me to browse the remain files without hanging the kernel it will be a bonus!

Once again thank for looking in to this.

Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Eric Sandeen" <sandeen@sandeen.net>
To: "Rui Gomes" <rgomes@rvx.is>
Cc: "omar" <omar@rvx.is>, "xfs" <xfs@oss.sgi.com>
Sent: Monday, 9 March, 2015 18:18:19
Subject: Re: xfs_repair segfault

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
